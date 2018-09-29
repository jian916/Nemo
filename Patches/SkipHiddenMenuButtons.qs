//
// Copyright (C) 2018  Andrei Karas (4144)
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
//#############################################################
//# Purpose: Allow skip hidden menu buttons in                #
//# UIMenuIconWnd_virt56                                      #
//#############################################################

function SkipHiddenMenuButtons()
{
    // step 1 - search string status_doram
    var strHex = exe.findString("status_doram", RVA).packToHex(4);

    // step 2 - search start for do/while block in adding buttons
    var code =
        "8D B5 AB AB AB AB" +  // lea esi, [ebp+names]
        "89 8D AB AB AB AB" +  // mov [ebp+cnt2], ecx
        "8B 18" +              // mov ebx, [eax]
        "81 FB AB AB 00 00" +  // cmp ebx, 0A9h    <-- stole code here
        "75 AB" +              // jnz short loc_577BA6
        "FF 35 AB AB AB AB" +  // push g_session.jobId
        "B9 AB AB AB AB" +     // mov ecx, offset g_session
        "E8 AB AB AB AB" +     // call is_doram_job
        "3C 01" +              // cmp al, 1
        "75 0E" +              // jnz short loc_577BA0
        "6A 0C" +              // push 0Ch
        "68 " + strHex +       // push offset "status_doram"
        "8B CE" +              // mov ecx, esi
        "E8"                   // call std_string_from_chars_size
    // in esi pointer to current name
    var nonA9Offset = 21;
    var a9Offset = 22;
    var stoleOffset = 14;
    var stoleSize = 6;

    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    if (offset === -1)
        return "Failed in step 2 - pattern not found";
    offset1 = offset;

    var nonA9JmpAddr = exe.Raw2Rva(exe.fetchByte(offset + nonA9Offset) + offset + nonA9Offset + 1).packToHex(4);
    var a9JmpAddr = exe.Raw2Rva(offset + a9Offset).packToHex(4);
    var patchAddr = offset + stoleOffset;

    // step 3 - search switch block and non default jmp in switch (using first one jump)
    code =
        "8D 83 AB AB AB AB" +     // lea eax, [ebx-164h]
        "3D AB AB 00 00" +        // cmp eax, 0A6h
        "77 0E" +                 // ja short loc_577BC1
        "0F B6 80 AB AB AB AB" +  // movzx eax, switch1[eax]
        "FF 24 85 AB AB AB AB";   // jmp switch2[eax*4]

    var switch1Offset = 16;
    var switch2Offset = 23;

    offset = exe.find(code, PTYPE_HEX, true, "\xAB", offset1, offset1 + 0x50);
    if (offset === -1)
        return "Failed in Step 3 - switch not found";

    // get switch jmp address for value 0
    var addr1 = exe.Rva2Raw(exe.fetchDWord(offset + switch1Offset));
    var addr2 = exe.Rva2Raw(exe.fetchDWord(offset + switch2Offset));
    var offset1 = exe.fetchUByte(addr1);
    var continueAddr = exe.fetchDWord(addr2 + 4 * offset1);

    // step 4 - patch code

    // add own extra checks
    code =
        "8B 46 00" +           // mov eax, [esi + 0]  (strlen)
        "3C 00" +              // cmp eax, 0
        "75 06 " +             // jnz +6
        "68 " + continueAddr.packToHex(4) + // push continueAddr
        "C3 " +                // retn
        exe.fetchHex(patchAddr, stoleSize) + // cmp ebx, 0A9
        "75 06 " +             // jnz +6
        "68 " + a9JmpAddr +    // push a9JmpAddr
        "C3 " +                // retn
        "68 " + nonA9JmpAddr + // push nonA9JmpAddr
        "C3 ";                 // retn

    var free = exe.findZeros(code.hexlength());
    if (free === -1)
        return "Failed in Step 2 - Not enough free space";

    exe.insert(free, code.length, code, PTYPE_HEX);

    // add jump to own code
    code =
        "68" + exe.Raw2Rva(free).packToHex(4) + // push addr1
        "C3"                                    // retn
    exe.replace(patchAddr, code, PTYPE_HEX); // add jump to own code

    return true;
}

function SkipHiddenMenuButtons_()
{
    return (exe.findString("status_doram", RAW) !== -1);
}
