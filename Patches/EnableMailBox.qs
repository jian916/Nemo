//########################################################################
//# Purpose: Fixup all the Langtype comparison Jumps in Mailbox function #
//########################################################################

function EnableMailBox()
{

  //Step 1a - Prep codes for finding short jumps
  var code  =
    " 74 ??"    //JE SHORT addr1 (prev statement is either TEST EAX, EAX or CMP EAX, r32 => both instructions use 2 bytes)
  + " 83 F8 08" //CMP EAX,08
  + " 74 ??"    //JE SHORT addr1
  + " 83 F8 09" //CMP EAX,09
  + " 74 ??"    //JE SHORT addr1
  ;

  var pat1 = " 8B 8E ?? 00 00 00"; //MOV ECX, DWORD PTR DS:[ESI+const]
  var pat2 = " BB 01 00 00 00"; //MOV EBX,1

  //Step 1b - Find all occurences of 1st LangType comparisons in the mailbox function
  var offsets = pe.findCodes(code + pat1);
  if (offsets.length !== 3)
    return "Failed in Step 1 - First pattern not found";

  //Step 1c - Change the first JE to JMP
  for (var i = 0; i < 3; i++)
  {
    pe.replaceHex(offsets[i] - 2, " EB 0C");
  }

  //Step 1d - Find occurence of 2nd LangType comparison in the mailbox function
  var offset = pe.findCode(code + pat2);
  if (offset === -1)
    return "Failed in Step 1 - Second pattern not found";

  //Step 1e - Change the first JE to JMP
  pe.replaceHex(offset-2, " EB 0C");

  //Step 2a - Prep codes for finding Long jumps
  var LANGTYPE = GetLangType();//Langtype value overrides Service settings hence they use the same variable - g_serviceType
  if (LANGTYPE.length === 1)
    return "Failed in Step 2 - " + LANGTYPE[0];

  code =
    " 0F 84 ?? ?? 00 00" //JE addr1 (prev statement is either TEST EAX, EAX or CMP EAX, r32 => both instructions use 2 bytes)
  + " 83 F8 08"          //CMP EAX,08
  + " 0F 84 ?? ?? 00 00" //JE addr1
  + " 83 F8 09"          //CMP EAX,09
  + " 0F 84 ?? ?? 00 00" //JE addr1
  ;

  pat1 = " A1" + LANGTYPE + " ?? ??" ; //MOV EAX, DS:[g_serviceType];

  //Step 2b - Find all occurences of the pattern - 3 or 4 would be there
  offsets = pe.findCodes(pat1 + code);

  if (offsets.length < 3 || offsets.length > 4)
    return "Failed in Step 2 - LangType comparisons missing";

  for (var i = 0; i < offsets.length; i++)
  {
    pe.replaceHex(offsets[i] + 5, " EB 18");
  }

  //Step 3 - If the count is 3 then there is an additional JE we missed
  if (offsets.length === 3)
  {
    var pat2 = " 6A 23"; //PUSH 23

    var offset = pe.findCode(code + pat2);
    if (offset === -1)
      return "Failed in Step 3";

    pe.replaceHex(offset - 2, " EB 18");
  }

  return true;
}

//================================================//
// Disable Patch for Unsupported/Unneeded clients //
//================================================//
function EnableMailBox_()
{
  return (exe.getClientDate() >= 20130320 || exe.getClientDate() <= 20140800);
}
