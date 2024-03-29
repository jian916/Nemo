//##################################################################
//# Purpose: Inject code inside UIBasicInfoWnd::OnDraw function to #
//#          make it also display the exp values like other info   #
//#          inside the "Basic Info" window when not minimized     #
//##################################################################

function ShowExpNumbers()
{ //To Do - Make color and coords configurable

  //Step 1a - Find the address of the Alt String
  var offset = pe.halfStringVa("Alt+V, Ctrl+V");
  if (offset === -1)
    return "Failed in Step 1 - String missing";

  //Step 1b - Find its reference inside UIBasicInfoWnd::OnCreate function
  var code =
    " 68" + offset.packToHex(4) //PUSH addr; ASCII "Alt+V, Ctrl+V"
  + " 8B"                       //MOV ECX, reg32_A
  ;

  offset = pe.findCode(code);
  if (offset === -1)
    return "Failed in Step 1 - String reference missing";

  offset += code.hexlength() + 6;//1 from the MOV and 5 from the CALL after it

  //Step 2a - Look for a double PUSH pattern (addresses of Total and Current Exp values are being sent as args to be filled)
  code =
    " 8B ?? ?? 00 00 00" //MOV ECX, DWORD PTR DS:[reg32_B + const]
  + " 68 ?? ?? ?? ??"    //PUSH totExp
  + " 68 ?? ?? ?? ??"    //PUSH curExp
  + " E8"                //CALL loaderFunc
  ;

  var offset2 = pe.find(code, offset, offset + 0x300);
  if (offset2 === -1)
  {  //new clients
    code =
      " 8B ?? ?? 00 00 00" //MOV ECX, DWORD PTR DS:[reg32_B + const]
    + " FF 35 ?? ?? ?? ??"    //PUSH totExp
    + " FF 35 ?? ?? ?? ??"    //PUSH curExp.sign bit
    + " FF 35 ?? ?? ?? ??"    //PUSH curExp
    + " E8"                //CALL loaderFunc
    ;
    offset2 = pe.find(code, offset, offset + 0x300);
    var newclient = 1;
  }

  if (offset2 === -1)
    return "Failed in Step 2 - Base Exp addrs missing";

  offset2 += code.hexlength() + 4;


  //Step 2b - Extract the PUSHed addresses (For Base Exp)
  if (newclient !== 1)
  {
  var curExpBase = pe.fetchDWord(offset2 - 9);
  var totExpBase = pe.fetchDWord(offset2 - 14);
  }
  else
  {
  var curExpBase = pe.fetchDWord(offset2 - 9);
  var totExpBase = pe.fetchDWord(offset2 - 21);
  }
  //Step 2c - Look for the double PUSH pattern again after the first one.
  offset2 = pe.find(code, offset2, offset + 0x300);
  if (offset2 === -1)
    return "Failed in Step 2 - Job Exp addrs missing";

  offset2 += code.hexlength() + 4;

  //Step 2d - Extract the PUSHed addresses (For Job Exp)
  if (newclient !== 1)
  {
  var curExpJob = pe.fetchDWord(offset2 - 9);
  var totExpJob = pe.fetchDWord(offset2 - 14);
  }
  else
  {
  var curExpJob = pe.fetchDWord(offset2 - 9);
  var totExpJob = pe.fetchDWord(offset2 - 21);
  }

  //Step 3a - Find address of "SP"
  offset = pe.stringVa("SP");

  //Step 3b - Find the pattern using the string inside OnDraw function  after which we need to inject
  code =
    " 68" + offset.packToHex(4) //PUSH addr; ASCII "SP"
  + " 6A 41" //PUSH 41
  + " 6A 11" //PUSH 11
  ;

  offset = pe.findCode(code);
  if (offset === -1)
    return "Failed in Step 3 - Args missing";

  offset += code.hexlength();

  //Step 3c - If the UIWindow::TextOutA function call comes immediately after the pattern, ECX is loaded from ESI
  //          else extract reg code from the MOV ECX, reg32 and update offset
  var rcode = " CE";//for MOV ECX, ESI

  if (pe.fetchUByte(offset) !== 0xE8)
  { //MOV ECX, reg32 comes in between
    rcode = pe.fetchHex(offset + 1, 1);
    offset += 2;
  }

  if (pe.fetchUByte(offset) !== 0xE8)
    return "Failed in Step 3 - Call missing";

  //Step 3d - Extract UIWindow::TextOutA address and address where the CALL is made
  var uiTextOut = pe.rawToVa(offset+5) + pe.fetchDWord(offset+1);
  var injectAddr = offset;

  //Step 3e - Check if Extra PUSH 0 is there (only for clients > 20140116)
  var extraPush = "";
  if (exe.getClientDate() > 20140116)
    extraPush = " 6A 00";
  //Step 3f - Check if Extra PUSH 0 is there (only for 2020 clients 20200325)
  var extraPush2 = "";
  code =
    " E8 ?? ?? ?? ??" //CALL UIWindow::TextOutA
  + " 6A 00"          //PUSH 0  ; Arg9 = Only for new clients (2020+)
  + " 6A 00"          //PUSH 0  ; Arg8 = Only for new clients
  + " 6A 00"          //PUSH 0  ; Arg7 = Color
  + " 6A 0E"          //PUSH 0E ; Arg6 = Font Height
  ;
  offset = pe.find(code, injectAddr - 0x20, injectAddr);
  if (offset !== -1)
    extraPush2 = " 6A 00";

  //Step 4a - Prep the template code that we use for both type of exp
  var template =
    " A1" + GenVarHex(1)   //MOV EAX, DWORD PTR DS:[totExp*]
  + " 8B 0D" + GenVarHex(2)//MOV ECX, DWORD PTR DS:[curExp*]
  + " 09 C1"               //OR ECX, EAX
  + " 74 JJ"               //JE SHORT addr
  + " 50"                  //PUSH EAX
  + " A1" + GenVarHex(3)   //MOV EAX, DWORD PTR DS:[curExp*]
  + " 50"                  //PUSH EAX
  + " 68" + GenVarHex(4)   //PUSH addr; ASCII "%d / %d"
  + " 8D 44 24 0C"         //LEA EAX, [ESP + 0C]
  + " 50"                  //PUSH EAX
  + " FF 15" + GenVarHex(5)//CALL DWORD PTR DS:[<&MSVCR#.sprintf>]
  + " 83 C4 10"            //ADD ESP, 10
  + " 89 E0"               //MOV EAX, ESP
  + extraPush2             //PUSH 0   ; Arg9 = Only for new clients (2020+)
  + extraPush              //PUSH 0   ; Arg8 = Only for new clients
  + " 6A 00"               //PUSH 0   ; Arg7 = Color
  + " 6A 0D"               //PUSH 0D  ; Arg6 = Font Height
  + " 6A 01"               //PUSH 1   ; Arg5 = Font Index
  + " 6A 00"               //PUSH 0   ; Arg4 = Char count (0 => calculate string size)
  + " 50"                  //PUSH addr; Arg3 = String i.e. output from sprintf above
  + " 6A YC"               //PUSH y   ; Arg2 = y Coord
  + " 6A XC"               //PUSH x   ; Arg1 = x Coord
  + " 8B" + rcode          //MOV ECX, reg32_A
  + " E8" + GenVarHex(6)   //CALL UIWindow::TextOutA ; stdcall => No Stack restore required
  ;

  //Step 4b - Fill in common values
  var printFunc = imports.ptr("sprintf");

  if (printFunc === -1)
    printFunc = imports.ptr("wsprintfA");

  if (printFunc === -1)
    return "Failed in Step 4 - No print functions found";

  template = ReplaceVarHex(template, 4, pe.halfStringVa("%d / %d"));
  template = ReplaceVarHex(template, 5, printFunc);
  template = template.replace(" XC", " 56");//Common X Coordinate
  template = template.replace(" JJ", (template.hexlength() - 15).packToHex(1));

  //Step 4c - Prep code we are going to insert
  code =
    " E8" + GenVarHex(0)   //CALL UIWindow::TextOutA
  + " 50"                  //PUSH EAX
  + " 83 EC 20"            //SUB ESP, 20
  + template               //for Base Exp
  + template               //for Job Exp
  + " 83 C4 20"            //ADD ESP, 20
  + " 58"                  //POP EAX
  + " E9" + GenVarHex(7)   //JMP retAddr = injectAddr + 5
  ;

  //Step 4d - Allocate space for it
  var size = code.hexlength();
  var free = exe.findZeros(size);
  if (free === -1)
    return "Failed in Step 4 - Not enough free space";

  var freeRva = pe.rawToVa(free);

  //Step 4e - Fill in the remaining blanks
  code = ReplaceVarHex(code, [1, 2, 3], [totExpBase, curExpBase, curExpBase]);
  code = ReplaceVarHex(code, 6, uiTextOut - (freeRva + 9 + template.hexlength()));//5 for call, 1 for PUSH EAX and 3 for SUB ESP
  code = code.replace("YC", "4E");

  code = ReplaceVarHex(code, [1, 2, 3], [totExpJob,  curExpJob,  curExpJob]);
  code = ReplaceVarHex(code, 6, uiTextOut - (freeRva + 9 + template.hexlength() * 2));//5 for call, 1 for PUSH EAX and 3 for SUB ESP
  code = code.replace("YC", "68");

  code = ReplaceVarHex(code, 0, uiTextOut - (freeRva + 5));
  code = ReplaceVarHex(code, 7, pe.rawToVa(injectAddr + 5) - (freeRva + size));

  //Step 5a - Insert the new code into the allocated area
  exe.insert(free, size, code, PTYPE_HEX);

  //Step 5b - Replace the CALL at injectAddr with a JMP to our new code.
  pe.replaceHex(injectAddr, "E9" + (freeRva - pe.rawToVa(injectAddr + 5)).packToHex(4));

  return true;
}
