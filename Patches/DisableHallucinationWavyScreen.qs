//#################################################################
//# Purpose: Change the JE after comparison of g_useEffect with 0 #
//#          to JMP in Hallucination Effect maker function        #
//#################################################################

function DisableHallucinationWavyScreen()
{ //Missing Comparison in pre-2010 clients

  //Step 1a - Find offset of 'xmas_fild01.rsw'
  var offset = exe.findString("xmas_fild01.rsw", RVA);
  if (offset === -1)
    return "Failed in Step 1 - xmas_fild01 not found";

  //Step 1b - Find its references. Preceding the one inside CGone of them is an assignment to g_useEffect
  var code = "B8" + offset.packToHex(4); //MOV EAX, OFFSET addr; ASCII "xmas_fild01.rsw"
  var offsets = pe.findCodes(code);

  if (offsets.length === 0)
    return "Failed in Step 1 - xmas_fild01 references missing";

  //Step 1c - Look for the correct location inside CGameMode::Initialize in offsets[]
  code = " 89 ?? ?? ?? ?? 00"; //MOV DWORD PTR DS:[g_useEffect], reg32_A

  for (var i = 0; i < offsets.length; i++)
  {
    offset = pe.find(code, offsets[i] - 8, offsets[i]);
    if (offset !== -1 && (exe.fetchUByte(offset + 1) & 0xC7) === 0x5) break;
    offset = -1;
  }

  if (offset === -1)
    return "Failed in Step 1 - no references matched";

  //Step 1d - Extract g_useEffect
  var gUseEffect = exe.fetchHex(offset + 2, 4);

  //Step 2a - Find the Comparison we need
  code =
    " 8B ??"                      //MOV ECX, reg32
  + " E8 ?? ?? ?? ??"             //CALL addr1
  + " 83 3D" + gUseEffect + " 00" //CMP DWORD PTR DS:[g_useEffect], 0
  + " 0F 84"                      //JE LONG addr2
  ;
  offset = pe.findCode(code);

  if (offset === -1)
  {
    code = code.replace("83 3D" + gUseEffect + " 00", "A1" + gUseEffect + " 85 C0");//Change CMP with MOV EAX, DS:[g_useEffect] followed by TEST EAX, EAX
    offset = pe.findCode(code);
  }

  if (offset === -1)
    return "Failed in Step 2";

  //Step 2b - Replace the JE with NOP + JMP
  exe.replace(offset + code.hexlength() - 2, "90 E9", PTYPE_HEX);

  return true;
}

//==============================//
// Disable for Unsupported date //
//==============================//
function DisableHallucinationWavyScreen_()
{
  return (exe.getClientDate() <= 20120516);//New client uses Inverted Screen effect. Havent figured out where it is
}
