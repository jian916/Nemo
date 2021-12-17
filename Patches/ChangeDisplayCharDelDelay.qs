//########################################################
//# Purpose: Change the type of time displaying by which #
//#          the character deletion is delayed.          #
//#                                                      #
//# before: it shows the date and time when the player   #
//#         will be able to delete character             #
//#                                                      #
//# after: it shows the remaining time when the player   #
//#         will be able to delete character             #
//########################################################

function ChangeDisplayCharDelDelay()
{

  // Step 1 - Find the code which prepare character deletion time data

  var code =
    " 83 EC 24"          //SUB ESP, 24
  + " 33 C0"             //XOR EAX, EAX
  + " 56"                //PUSH ESI
  + " 8B 75 08"          //MOV ESI,DWORD PTR SS:[EBP+8]
  + " 0F 57 C0"          //XORPS XMM0, XMM0
  + " 66 89 06"          //MOV WORD PTR DS:[ESI], AX
  + " 66 0F D6 46 02"    //MOVQ QWORD PTR DS:[ESI+2], XMM0
  + " 89 46 0A"          //MOV DWORD PTR DS:[ESI+A], EAX
  ;

  var offset = pe.findCode(code);

  if (offset === -1) //2019+ clients
  {
    code =
      " 83 EC 24"          //SUB ESP, 24
    + " 0F 57 C0"          //XORPS XMM0, XMM0
    + " 83 39 00"          //CMP DWORD PTR [ECX], 0
    + " 56"                //PUSH ESI
    + " 8B 75 08"          //MOV ESI,DWORD PTR SS:[EBP+8]
    + " 0F 11 06"          //MOVUPS XMMWORD PTR [ESI], XMM0
    + " 7D 06"             //JGE SHORT
    + " C7 01 00 00 00 00" //MOV DWORD PTR [ECX], 0
    ;

    offset = pe.findCode(code);
  }

  if (offset === -1)
    return "Failed in Step 1";


  // Step 2 - Get "MSVCR110._time32" address

  var time32Func = imports.ptr("_time32", "MSVCR110.dll");

  if (time32Func === -1) //2019+ clients
  {
    time32Func = imports.ptr("_time32", "api-ms-win-crt-time-l1-1-0.dll");
  }

  if (time32Func === -1)
    return "Failed in Step 2 - No \"_time32\" function found";


  // Step 3 - Replace the code which prepare character deletion time data

  code =
    " 53"                     //PUSH EBX
  + " 56"                     //PUSH ESI
  + " 51"                     //PUSH ECX
  + " 8B 75 08"               //MOV ESI,DWORD PTR SS:[EBP+8]
  + " 33 D2"                  //XOR EDX, EDX
  + " 89 56 06"               //MOV DWORD PTR DS:[ESI+6],EDX
  + " 89 56 0A"               //MOV DWORD PTR DS:[ESI+A],EDX
  + " 6A 00"                  //PUSH 0
  + " FF 15" + GenVarHex(1)   //CALL DWORD PTR DS:[<&MSVCR110._time32>]
  + " 83 C4 04"               //ADD ESP, 4
  + " 59"                     //POP ECX
  + " 8B 09"                  //MOV ECX, DWORD PTR DS:[ECX]
  + " 3B C1"                  //CMP EAX, ECX
  + " 73 22"                  //JNB SHORT to POP ESI
  + " 2B C8"                  //SUB ECX, EAX
  + " 33 D2"                  //XOR EDX, EDX
  + " 8B C1"                  //MOV EAX, ECX
  + " BB 3C 00 00 00"         //MOV EBX, 0x3C
  + " F7 F3"                  //DIV EBX
  + " 66 89 56 0A"            //MOV WORD PTR DS:[ESI+A], DX
  + " 33 D2"                  //XOR EDX, EDX
  + " BB 3C 00 00 00"         //MOV EBX, 0x3C
  + " F7 F3"                  //DIV EBX
  + " 66 89 46 06"            //MOV WORD PTR DS:[ESI+6], AX
  + " 66 89 56 08"            //MOV WORD PTR DS:[ESI+8], DX
  + " 5E"                     //POP ESI
  + " 5B"                     //POP EBX
  + " 8B E5"                  //MOV ESP, EBP
  + " 5D"                     //POP EBP
  + " C2 04 00"               //RETN 4
  ;

  code = ReplaceVarHex(code, 1, time32Func);

  pe.replaceHex(offset, code);


  // Step 4 - Remove displaying the text "X month X day" by changing coords

  offset = pe.findCode("52 6A 28 6A 00 6A 0B 6A 00 8D 75");

  if (offset === -1) //2019+ clients
  {
    offset = pe.findCode("57 6A 28 6A 00 6A 0B 6A 00 6A 00");
  }

  if (offset === -1) //2019+ clients
  {
    offset = pe.findCode("52 6A 28 6A 00 6A 00 6A 0B 6A 00 6A 00");
  }

  if (offset === -1)
    return "Failed in Step 4";

  pe.replaceByte(offset + 2, 0x90);

  return true;
}

function ChangeDisplayCharDelDelay_()
{
  return ((pe.findCode("52 6A 28 6A 00 6A 0B 6A 00 8D 75") & pe.findCode("52 6A 28 6A 00 6A 00 6A 0B 6A 00 6A 00") & pe.findCode("57 6A 28 6A 00 6A 0B 6A 00 6A 00")) !== -1);
}
