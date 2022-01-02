//##################################################################
//# Purpose: Modify the switch inside CLoginMode::OnChangeState to #
//#          skip transfering to License Screen creation code      #
//##################################################################

function SkipLicenseScreen()
{

  //Step 1a - Find offset of "btn_disagree"
  var offset = pe.stringVa("btn_disagree");
  if (offset === -1)
    return "Failed in Step 1 - Unable to find btn_disagree";

  //Step 1b - Find it's reference . Interestingly it is only PUSHed once
  offset = pe.findCode(" 68" + offset.packToHex(4));
  if (offset === -1)
    return "Failed in Step 1 - Unable to find reference to btn_disagree";

  //Step 2a - Find the Switch Case JMPer within 0x200 bytes before the PUSH
  offset = pe.find(" FF 24 85 ?? ?? ?? 00", offset - 0x200, offset);//JMP DWORD PTR DS:[EAX*4 + refaddr]
  if (offset === -1)
    return "Failed in Step 2 - Unable to find the switch";

  //Step 2b - Extract the refaddr
  var refaddr = pe.vaToRaw(pe.fetchDWord(offset + 3));//We need the raw address

  //Step 2c - Extract the 3rd Entry in the jumptable => Case 2. Case 0 and Case 1 are related to License Screen
  var third = pe.fetchHex(refaddr + 8, 4);

  //Step 3 - Replace the 1st and 2nd entries with the third. i.e. Case 0 and 1 will now use Case 2
  pe.replaceHex(refaddr, third);
  pe.replaceHex(refaddr + 4, third);

  return true;
}