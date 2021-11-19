//#####################################################################
//# Purpose: Modify the comparisons in C3dGrannyBoneRes::GetAnimation #
//#       to always use gr2 from 3dmob_bone folder                    #
//#####################################################################

function EnableCustom3DBones()
{

  //Step 1a - Find location of the sprintf control string for 3d mob bones
  var offset = pe.stringVa("model\\3dmob_bone\\%d_%s.gr2");
  if (offset === -1)
    return "Failed in Step 1 - String not found";

  //Step 1b - Find its reference which is inside C3dGrannyBoneRes::GetAnimation
  var offset2 = pe.findCode("68" + offset.packToHex(4));
  if (offset2 === -1)
    return "Failed in Step 1 - String reference missing";

  //Step 2a - Find Limiting CMP instruction within this function before the reference (should be within 0x80 bytes)
  var code =
    " C6 05 ?? ?? ?? 00 00" //MOV BYTE PTR DS:[addr], 0
  + " 83 FE 09"             //CMP ESI, 9
  ;
  offset = pe.find(code, offset2 - 0x80, offset2);

  if (offset === -1)
  {
    code = code.replace("09", "0A"); //Change the 09h to 0Ah for VC6 clients
    offset = pe.find(code, offset2 - 0x80, offset2);
  }

  if (offset === -1)
    return "Failed in Step 2 - Comparison missing";

  offset += code.hexlength();

  //Step 2b - Find the Index test after ID Comparison (should be within 0x20 bytes)
  code =
    " 85 FF" //TEST EDI, EDI
  + " 75 27" //JNE SHORT addr
  ;
  offset2 = pe.find(code, offset, offset + 0x20);

  if (offset2 === -1)
  {
    code = code.replace("27", "28"); //VC10 and older has 28 instead of 27
    offset2 = pe.find(code, offset, offset + 0x20);
  }

  if (offset2 === -1)
    return "Failed in Step 2 - Index Test missing";

  //Step 3a - NOP out the TEST & Modify the short JNE to JMP at offset2
  exe.replace(offset2, " 90 90 EB", PTYPE_HEX);

  //Step 3b - Modify the JA/JGE instruction at offset to just skip the Jump.
  switch(pe.fetchUByte(offset))
  {
    case 0x77:
    case 0x7D: {// Short JA/JGE
      exe.replace(offset, " 90 90", PTYPE_HEX);
      break;
    }
    case 0x0F: {// Long JA/JGE
      exe.replace(offset, " EB 04", PTYPE_HEX);
      break;
    }
    default: {
      return "Failed in Step 3";
    }
  }

  //Step 4a - Find the annoying warning - 'too many vertex granny model!'
  offset = pe.stringVa("too many vertex granny model!");

  //Step 4b - Find its reference + the function call after
  if (offset !== -1)
    offset = pe.findCode(" 68" + offset.packToHex(4) + " E8");

  //Step 4c - NOP out the call
  if (offset !== -1)
    exe.replace(offset + 5, " 90 90 90 90 90", PTYPE_HEX);

  return true;
}
