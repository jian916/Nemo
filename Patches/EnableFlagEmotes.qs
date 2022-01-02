//#################################################################
//# Purpose: Change the Flag Emote callers for Ctrl+1 - Ctrl+9 in #
//#          function called from UIWindowMgr::ProcessPushButton  #
//#################################################################

function EnableFlagEmotes()
{ //The function is not present in pre-2010 clients

  //Step 1a - Find the switch case selector for all the flag Emote callers
  var code =
    " 05 2E FF FF FF"    //ADD EAX,-D2
  + " 83 F8 08"          //CMP EAX, 08
  + " 0F 87 ?? ?? 00 00" //JA addr -> skip showing emotes
  + " FF 24 85"          //JMP DWORD PTR DS:[EAX*4+refAddr]
  ;
  var offset = pe.findCode(code);

  if (offset === -1)
  {
    code = code.replace(" 05 2E FF FF FF", " 83 C0 ??");//change ADD EAX, -D2 with ADD EAX, -54
    offset = pe.findCode(code);
  }

  if (offset === -1)
    return "Failed in Step 1 - switch not found";

  //Step 1b - Extract the refAddr
  var refAddr = pe.vaToRaw(pe.fetchDWord(offset + code.hexlength()));

  //Step 2a - Get Input file containing the list of Flag Emotes per key
  var f = new TextFile();
  if (!GetInputFile(f, "$inpFlag", _("File Input - Enable Flag Emoticons"), _("Enter the Flags list file"), APP_PATH + "/Input/flags.txt"))
  {
    return "Patch Cancelled";
  }

  //Step 2b - Read all the entries into an array
  var consts = [];
  while (!f.eof())
  {
    var str = f.readline().trim();
    if (str.charAt(1) === "=")
    {
      var key = parseInt(str.charAt(0));
      if (!isNaN(key))
      {
        var value = parseInt(str.substr(2));//full length is retrieved.
        if (!isNaN(value)) consts[key] = value;
      }
    }
  }
  f.close();

  //Step 3a - Prep code that is part of each case (common portions that we need)
  var LANGTYPE = GetLangType();//Langtype value overrides Service settings hence they use the same variable - g_serviceType
  if (LANGTYPE.length === 1)
    return "Failed in Step 3 - " + LANGTYPE[0];

  code =
    " A1" + LANGTYPE //MOV EAX, DS:[g_servicetype]
  + " 85 C0"         //TEST EAX, EAX
  ;                  //JZ SHORT addr or JZ addr

  var code2 =
    " 6A 00" //PUSH 0
  + " 6A 00" //PUSH 0
  + " 6A ??" //PUSH emoteConstant
  + " 6A 1F" //PUSH 1F
  + " FF"    //CALL EDX or CALL DWORD PTR DS:[EAX+const]
  ;

  var oldOffsets = [];
  for (var i = 1; i < 10; i++)
  {
    //Step 3b - Get the starting address of the case
    var offset = pe.vaToRaw(pe.fetchDWord(refAddr + (i - 1)*4));

    //Step 3c - Find the first code. Ideally it would be at offset itself unless something changed
    offset = pe.find(code, offset);
    if (offset === -1)
      return "Failed in Step 3 - First part missing : " + i;

    offset += code.hexlength();

    //Step 3d - Change the JZ to JMP & Get the JMPed address
    if (pe.fetchByte(offset) === 0x0F)
    {//Long
      pe.replaceHex(offset, " 90 E9");
      offset += pe.fetchDWord(offset + 2) + 6;
    }
    else
    { //Short
      pe.replaceByte(offset, 0xEB);
      offset += pe.fetchByte(offset + 1) + 2;
    }

    if (consts[i])
    {
      //Step 3e - Find the second code.
      offset = pe.find(code2, offset);
      if (offset === -1)
        return "Failed in Step 3 - Second part missing : " + i;

      if (oldOffsets.indexOf(offset) !== -1)
        return "Found two same offset";
      oldOffsets.push(offset);

      //Step 3d - Replace the emoteConstant with the one we read from input file.
      pe.replaceHex(offset + code2.hexlength() - 4, consts[i].toString(16));
    }
  }

  return true;
}
