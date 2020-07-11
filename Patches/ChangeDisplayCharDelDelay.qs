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

  var offset = exe.findCode(code, PTYPE_HEX, false);

  if (offset === -1)
    return "Failed in Step 1";


  // Step 2 - Get "MSVCR110._time32" address

  var time32Func = GetFunction("_time32", "MSVCR110.dll");

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

  exe.replace(offset, code, PTYPE_HEX);


  // Step 4 - Remove displaying the text "X month X day" by changing coords

  offset = exe.findCode("52 6A 28 6A 00 6A 0B 6A 00 8D 75", PTYPE_HEX, false);

  if (offset === -1)
    return "Failed in Step 4";

  exe.replace(offset + 2, " 90", PTYPE_HEX);

  return true;
}

function ChangeDisplayCharDelDelay_()
{
  return (exe.findCode("52 6A 28 6A 00 6A 0B 6A 00 8D 75", PTYPE_HEX, false)  !== -1);
}
