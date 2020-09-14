//
// Copyright (C) 2020  CH.C
//
// Hercules is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
//##################################################################
//# Purpose: Use api StrStrIA instead of _mbsstr to enable         #
//#          case-insensitive search in storage.                   #
//##################################################################
function InsensitiveStorageSearch()
{
  var GetModuleHandleA = GetFunction("GetModuleHandleA", "KERNEL32.dll");
  if (GetModuleHandleA === -1)
    return "Failed in Step 1 - GetModuleHandleA not found.";
  var GetProcAddress = GetFunction("GetProcAddress", "KERNEL32.dll");
  if (GetProcAddress === -1)
    return "Failed in Step 1 - GetProcAddress not found.";

  //Find string compair for storage
  var code =
    " 51"                 //0 push ecx
  + " 50"                 //1 push eax
  + " FF 15 AB AB AB AB"  //2 call _mbsstr
  + " 83 C4 08"           //8 add esp,8
  + " 85 C0"              //11 test eax,eax
  + " 74 04"              //13 je short
  + " 8B 36"              //15 mov esi,[esi]
  + " EB"                 //17 jmp short
  ;
  var calloffset = 2;

  var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
  if (offset === -1)
  {//newer clients
    code = code.replace(" 51 50", " 51 0F 43 45 AB 50");//cmovnb eax,[ebp-x]
    offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    calloffset += 4;
  }
  if (offset === -1)
    return "Failed in Step 2 - String compair not found";

  //Fetch original code, just in case
  var varcode = exe.fetchHex(offset + calloffset, 9);
  var retAddr = exe.Raw2Rva(offset + calloffset + 9);

  //Prepare our code
  code =
    " 83 3D" + GenVarHex(1) + " 00"          //cmp dword ptr [StrStrIA],00
  + " 75 2F"                                 //jne short
  + " 68" + GenVarHex(4)                     //push "Shlwapi.dll"
  + " FF 15" + GetModuleHandleA.packToHex(4) //call GetModuleHandleA
  + " 68" + GenVarHex(5)                     //push "StrStrIA"
  + " 50"                                    //push eax
  + " FF 15" + GetProcAddress.packToHex(4)   //call GetProcAddress
  + " 85 C0"                                 //test eax,eax
  + " 75 0F"                                 //jne short
  + varcode                                  //call dword ptr [_mbsstr]
                                             //add esp,08
  + " 68" + retAddr.packToHex(4)             //push retAddr
  + " C3"                                    //ret
  + " A3" + GenVarHex(2)                     //mov [StrStrIA],eax
  + " FF 15" + GenVarHex(3)                  //call dword ptr [StrStrIA]
  + " 68" + retAddr.packToHex(4)             //push retAddr
  + " C3"                                    //ret
  ;

  //Prepare the strings we need
  var strings = ["Shlwapi.dll", "StrStrIA"];

  //Calculate size of free space that the code & strings will need
  var size = code.hexlength() + 4;
  size = size + strings[0].length + 1;
  size = size + strings[1].length + 1;

  //Find free space to inject our code
  var free = exe.findZeros(size + 8);
  if (free === -1)
    return "Failed in Step 3 - Not enough free space";

  var freeRva = exe.Raw2Rva(free);

  //Replace the variables used in code
  var memPosition = freeRva + code.hexlength();
  for (var i = 1; i < 4; i++)
  {
    code = ReplaceVarHex(code, i, memPosition);
  }

  memPosition = memPosition + 4;
  code = ReplaceVarHex(code, 4, memPosition);

  memPosition = memPosition + strings[0].length + 1;
  code = ReplaceVarHex(code, 5, memPosition);

  //Add mem and the strings into our code as well
  code = code + " 00 00 00 00"; //mem to hold StrStrIA address
  code = code + strings[0].toHex() + " 00";
  code = code + strings[1].toHex() + " 00";
  code = code + " 90 90 90 90"; //Separate strings from other patches

  //Insert everything
  exe.insert(free, code.hexlength(), code, PTYPE_HEX);

  //Prepare the code for jump
  code =
    " E9" + (freeRva - exe.Raw2Rva(offset + calloffset + 5)).packToHex(4)
  + " 90 90 90 90";

  //Insert jump to our code
  exe.replace(offset + calloffset, code, PTYPE_HEX);

  return true;
}
