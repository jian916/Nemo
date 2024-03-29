//
// Copyright (C) 2018  CH.C
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
//#####################################################
//# Purpose: Create a function calling ShellExecuteA  #
//#          right after URL parsed, and skip calling #
//#          ROWebBrowser                             #
//#####################################################

function UseDefaultBrowser()
{
    //Step 1a - Find the location where client parsing <URL>
    var code =
        " 50"        //PUSH EAX
      + " FF D6"    //CALL ESI (atoi)
      + " 83 C4 04"    //ADD ESP,04
      + " 8B D8"    //MOV EBX,EAX
      ;

    var foffset = pe.findCode(code);
    if (foffset === -1)
        return "Failed in Step 1a - Function not found.";

    //Step 1b - Find offset where client start parsing first argument of <URL>
    code =
        " 6A 00"            //PUSH 00
      + " 8D 45 ??"            //LEA EAX,[EBP-z]
      + " 50"                //PUSH EAX
      + " 8B CF"            //MOV ECX,EDI
      +  "E8 ?? ?? ?? ??"    //CALL offset
      ;

    var offset = pe.find(code, foffset - 0x80, foffset);
    if (offset === -1)
        return "Failed in Step 1b - Function not found.";

    //Step 1c - Move offset to next instruction after reference where going place CALL later
    var coffset = offset + code.hexlength();    //and check instruction
    if (pe.fetchUByte(coffset) !== 0xC7 )    //Should be a MOV [EBP-z],y
        return "Failed in Step 1c - Unknown instruction after reference.";

    //Step 1d - Save original instruction for later use
    var store1 = pe.fetchHex(coffset, 7);

    //Step 2a - Get SHELL32.ShellExecuteA address
    var seoffset = imports.ptrHexValidated("ShellExecuteA", "SHELL32.dll");

    //Step 2b - Get address of string "open" for lpOperation
    var opoffset = pe.stringHex4("open");

    //Step 2c - Prep the code for CALL ShellExecuteA
    code =
        " 50"                //PUSH EAX
      + " 8B 00"            //MOV EAX,[EAX]
      + " 6A 0A"            //PUSH 0A        nShowCmd
      + " 6A 00"            //PUSH 00        lpDirectory
      + " 6A 00"            //PUSH 00        lpParameters
      + " 50"                //PUSH EAX         lpFile -> URL
      + " 68" + opoffset    //PUSH offset    lpOperation -> open
      + " 6A 00"            //PUSH 00         hwnd
      + " FF 15" + seoffset    //CALL ShellExecuteA
      + " 58"                //POP EAX
      + store1                //MOV [EBP-z],y
      + " C3"                //RET
      ;

    //Step 2d - Find free space to inject our code
    var size = code.hexlength();
    var free = exe.findZeros(size + 4);
    if (free === -1)
        return "Failed in Step 2d - Not enough free space.";

    //Step 2e - Prep CALL instruction and insert everything
    var freeRva = pe.rawToVa(free);
    var joffset = (freeRva - pe.rawToVa(coffset + 5)).packToHex(4);
    var call =
        " E8" + joffset    //CALL our code
      + " 90 90"        //NOPS
      ;

    pe.replaceHex(coffset, call);
    exe.insert(free, size+4, code, PTYPE_HEX);

    //Step 3a - Find offset where calling ROWebBrowser
    code =
        " 53"                    //PUSG EBX
      + " FF B5 ?? ?? FF FF"    //PUSH [EBP-x]
      ;

    var roffset = pe.find(code, foffset, foffset + 0x50);
    if (roffset === -1)
        return "Failed in Step 3a - Pattern missing.";

    //Step 3b - Find the destination when create ROWebBrowser failed
    code =
        " 8B F0"    //MOV ESI,EAX
      + " 85 F6"    //TEST ESI,ESI
      + " 74 ??"    //JE offset
      ;

    var doffset = pe.find(code, roffset, roffset + 0x20);
    if (doffset === -1)
        return "Failed in Step 3b - Pattern missing.";

    //Step 3c - Calculate distance for jump
    doffset = doffset + 4;
    var dist = pe.fetchByte(doffset + 1);
    dist = (dist + doffset - roffset).packToHex(1);

    //Step 3d - Place the JMP to skip ROWebBrowser
    code =
        " EB" + dist        //JMP offset
      + " 90 90 90 90 90"    //NOPS
      ;

    pe.replaceHex(roffset, code);


    return true;
}
