//
// Copyright (C) 2018-2019  Andrei Karas (4144)
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
//####################################################
//# Purpose: Extend hard-coded hair style table and  #
//#          change limit to hair styles             #
//####################################################

function IncreaseHairSprites()
{
    var maxHairs = 100;
    var bytesPerString = 4;
    var bufSize = maxHairs * bytesPerString;

    consoleLog("step 1a search for spr/act string");
    var code = "\\\xB8\xD3\xB8\xAE\xC5\xEB\\%s\\%s_%s.%s"; // "\머리통\%s\%s_%s.%s"
    var offset = exe.findString(code, RAW);

    if (offset === -1)
        return "Failed in step 1 - string not found";

    consoleLog("step 1b - search string reference");
    offset = exe.findCode("68" + exe.Raw2Rva(offset).packToHex(4), PTYPE_HEX, false);
    if (offset === -1)
        return "Failed in step 1 - string reference missing";

    consoleLog("step 2 - search normal jobs hair limit");
    // offset bit after hair checks
    var refOffset = offset;

    code = 
        "85 C0" +             // 0 test eax, eax
        "78 05" +             // 2 js short A
        "83 F8 AB" +          // 4 cmp eax, 1Dh
        "7E 06" +             // 7 jle short B
        "C7 06 AB 00 00 00";  // 9 mov dword ptr [esi], 0Dh
    var assignOffset = 9;
    var valueOffset = 6;

    offset = exe.find(code, PTYPE_HEX, true, "\xAB", refOffset - 0x200, refOffset);
    if (offset === -1)
        return "Failed in step 2 - hair limit missing";

    var currentLimit = exe.fetchUByte(offset + valueOffset) + 1;  // current max hair limit
    exe.replace(offset + assignOffset, "90 90 90 90 90 90", PTYPE_HEX);  // removing hair style limit assign

    consoleLog("step 3 - search doram jobs hair limit");
    code =
        "8B 06 " +                    // 0 mov eax, [esi]
        "75 AB " +                    // 2 jnz short loc_8D08A9
        "83 F8 01 " +                 // 4 cmp eax, 1
        "7C 05 " +                    // 7 jl short loc_8D0840
        "83 F8 AB " +                 // 9 cmp eax, 7
        "7C 06 " +                    // 12 jl short loc_8D0846
        "C7 06 AB 00 00 00 ";         // 14 mov dword ptr [esi], 6
    var assignOffset = 14;
    var valueOffset = 11;

    offset = exe.find(code, PTYPE_HEX, true, "\xAB", refOffset - 0x200, refOffset);
    if (offset === -1)
        return "Failed in step 3 - doram hair limit missing";

    var currentLimit = exe.fetchUByte(offset + valueOffset) + 1;  // current max hair limit
    exe.replace(offset + assignOffset, "90 90 90 90 90 90", PTYPE_HEX);  // removing hair style limit assign

    consoleLog("step 4 - search string \"2\" \"3\" \"4\"");
    code = 
        "32 00" + // "2"
        "00 00" + //
        "33 00" + // "3"
        "00 00" + //
        "34 00" + // "4"
        "00 00";  //
    offset = exe.find(code, PTYPE_HEX, false);
    if (offset === -1)
        return "Failed in step 4 - string '2' missing";

    var str2Offset = exe.Raw2Rva(offset);
    currentLimit = currentLimit.packToHex(1);

    consoleLog("step 5 - search male hair table allocations in CSession::InitPcNameTable");
    code = 
        "50 " +                                        // 0 push eax
        "6A AB " +                                     // 1 push 1Eh
        "C7 45 F0 " + str2Offset.packToHex(4) + " " +  // 3 mov dword ptr [ebp+A], offset "2"
        "E8 AB AB AB AB " +                            // 10 call vector__alloc_mem_and_set_pointer
        "8B 06 " +                                     // 15 mov eax, [esi]
        "C7 00 " + str2Offset.packToHex(4);            // 17 mov dword ptr [eax], offset "2"
    var patchOffset = 0;  // from this offset code will be patched
    var callOffset = 11;  // in this offset relative call address
    var fetchOffset = 3;  // copy into own code from this address
    var fetchSize = 7;    // copy this N bytes into own code

    var offsets = exe.findCodes(code, PTYPE_HEX, true, "\xAB");

    if (offsets.length === 0)
        return "Failed in step 5 - hair table not found";
    if (offsets.length !== 1)
        return "Failed in step 5 - found wrong number of hair tables: " + offsets.length;

    var tableCodeOffset = offsets[0];
    var vectorCallAddr = exe.fetchDWord(tableCodeOffset + callOffset) + tableCodeOffset + callOffset + 4;
    var varCode = exe.fetchHex(tableCodeOffset + fetchOffset, fetchSize);
    patchOffset = tableCodeOffset + patchOffset;

    consoleLog("step 6 - allocate strings with hair id");
    var free = exe.findZeros(bufSize);
    if (free === -1)
        return "Failed in step 6 - not enough free space";
    var data = "";
    for(var i = 0; i < maxHairs; i++)
    {
        data = data + str2Hex(i, bytesPerString);
    }
    if (data.hexlength() !== bufSize)
        return "Failed in step 6 - wrong allocated buffer";

    exe.insert(free, bufSize, data, PTYPE_HEX);
    var tableStrings = exe.Raw2Rva(free);  // index = id * bytesPerString

    consoleLog("step 7 - search female hair table and location for jump");
    code =
        "8B 06" +                 // 0 mov eax, [esi]
        "8D B7 AB AB 00 00" +     // 2 lea esi, [edi+CSession.normal_job_hair_sprite_array_F]
        "C7 40 AB AB AB AB AB" +  // 8 mov dword ptr [eax+74h], offset a29
        "8D 45 AB" +              // 15 lea eax, [ebp+var_10]
        "50" +                    // 18 push eax
        "6A AB " +                // 19 push 1Eh
        "8B CE " +                // 21 mov ecx, esi
        "E8 AB AB AB AB ";        // 23 call vector__alloc_mem_and_set_pointer
    var patchOffset2 = 18;   // from this offset code will be patched
    var callOffset2 = 24;    // in this offset relative call address

    offset = exe.find(code, PTYPE_HEX, true, "\xAB", tableCodeOffset, tableCodeOffset + 0x150);
    if (offset === -1)
        return "Failed in step 7 - jump location not found";

    var tableCodeOffset2 = offset;
    var vectorCallAddr2 = exe.fetchDWord(tableCodeOffset2 + callOffset2) + tableCodeOffset2 + callOffset2 + 4;
    patchOffset2 = tableCodeOffset2 + patchOffset2;

    if (vectorCallAddr !== vectorCallAddr2)
        return "Failed in step 7 - vector call functions different";

    var jmpAddr = exe.Raw2Rva(offset);
    var vectorCallOffset = vectorCallAddr - (patchOffset + 1 + 5 + varCode.hexlength() + 5);  // calc offset to call vector function (offsets from next code block)

    consoleLog("normal job male hair style table loader patch");
    code =
        "50 " +                              // push eax
        "68 " + maxHairs.packToHex(4) +      // push maxHairs
        varCode +                            // mov dword ptr [ebp+A], offset "2"
        "E8 " + vectorCallOffset.packToHex(4) +  // call vector__alloc_mem_and_set_pointer

        "56 " +                              // push esi
        "57 " +                              // push edi
        "53 " +                              // push ebx
        "51 " +                              // push ecx
        "B9 " + maxHairs.packToHex(4) +      // mov ecx, maxHairs
        "8B 06 " +                           // mov eax, [esi]         eax now is pointer to destination buffer
        "BF " + tableStrings.packToHex(4) +  // mov edi, tableStrings  edi now is pointer to strings buffer
        "89 38" +                            // mov [eax], edi         save one pointer into table
        "83 C0 04" +                         // add eax, 4
        "83 C7 04" +                         // add edi, 4
        "49" +                               // dec ecx
        "75 F5" +                            // je -11                 mov to mov [eax], edi
        "59 " +                              // pop ecx
        "5B " +                              // pop ebx
        "5F " +                              // pop edi
        "5E " +                              // pop esi
        "E9 ";                               // jmp jmpAddr

    jmpAddr = jmpAddr - (exe.Raw2Rva(patchOffset) + code.hexlength() + 4);
    code = code + jmpAddr.packToHex(4);

    exe.replace(patchOffset, code, PTYPE_HEX);  // add patch with fill male hair table

    consoleLog("step 8 - search location for jump");
    code =
        "8B 06" +                 // 0 mov eax, [esi]
        "8D B7 AB AB 00 00" +     // 2 lea esi, [edi+CSession.doram_sex1_hair_sprite_array]
        "C7 40 AB AB AB AB AB" +  // 8 mov dword ptr [eax+74h], offset a29
        "8D 45 F0" +              // 15 lea eax, [ebp+var_10]
        "50" +                    // 18 push eax
        "6A AB" +                 // 19 push 7  - doram hair limit
        "8B CE" +                 // 21 mov ecx, esi
        "E8 AB AB AB AB";         // 23 call vector__alloc_mem_and_set_pointer

    offset = exe.find(code, PTYPE_HEX, true, "\xAB", tableCodeOffset2 + 5, tableCodeOffset2 + 0x150);
    if (offset === -1)
        return "Failed in step 8 - jump location not found";

    jmpAddr = exe.Raw2Rva(offset);
    var vectorCallOffset2 = vectorCallAddr2 - (patchOffset2 + 1 + 5 + 2 + 5);  // calc offset to call vector function (offsets from next code block)

    consoleLog("normal job female hair style table loader patch");
    code =
        "50 " +                              // push eax
        "68 " + maxHairs.packToHex(4) +      // push maxHairs
        "8B CE " +                           // mov ecx, esi
        "E8 " + vectorCallOffset2.packToHex(4) +  // call vector__alloc_mem_and_set_pointer

        "56 " +                              // push esi
        "57 " +                              // push edi
        "53 " +                              // push ebx
        "51 " +                              // push ecx
        "B9 " + maxHairs.packToHex(4) +      // mov ecx, maxHairs
        "8B 06 " +                           // mov eax, [esi]         eax now is pointer to destination buffer
        "BF " + tableStrings.packToHex(4) +  // mov edi, tableStrings  edi now is pointer to strings buffer
        "89 38" +                            // mov [eax], edi         save one pointer into table
        "83 C0 04" +                         // add eax, 4
        "83 C7 04" +                         // add edi, 4
        "49" +                               // dec ecx
        "75 F5" +                            // je -11                 mov to mov [eax], edi
        "59 " +                              // pop ecx
        "5B " +                              // pop ebx
        "5F " +                              // pop edi
        "5E " +                              // pop esi
        "E9 ";                               // jmp jmpAddr

    jmpAddr = jmpAddr - (exe.Raw2Rva(patchOffset2) + code.hexlength() + 4);
    code = code + jmpAddr.packToHex(4);

    exe.replace(patchOffset2, code, PTYPE_HEX);  // add patch with fill female hair table

    consoleLog("step 9 - search male doram hair table allocations in CSession::InitPcNameTable");
    code =
        "C7 40 AB AB AB AB AB " +     // 0 mov dword ptr [eax+78h], offset a30
        "8B 06 " +                    // 7 mov eax, [esi]
        "8D B7 AB AB AB AB " +        // 9 lea esi, [edi+CSession.doram_job_hair_sprite_array_M]
        "C7 40 AB AB AB AB AB " +     // 15 mov dword ptr [eax+7Ch], offset a31
        "8D 45 AB " +                 // 22 lea eax, [ebp+a3]
        "50 " +                       // 25 push eax
        "6A 07 " +                    // 26 push 7
        "8B CE " +                    // 28 mov ecx, esi
        "E8 AB AB AB AB " +           // 30 call std_vector_char_ptr_resize
        "8B 06 " +                    // 35 mov eax, [esi]
        "C7 45 ";                     // 37 mov [ebp+a3], offset a1_1
    var str1Offset = 40;
    var patchOffset = 25;  // from this offset code will be patched
    var callOffset = 31;  // in this offset relative call address
    // no fetch code

    var offsets = exe.findCodes(code, PTYPE_HEX, true, "\xAB");

    if (offsets.length === 0)
        return "Failed in step 9 - doram hair table not found";
    if (offsets.length !== 1)
        return "Failed in step 9 - found wrong number of doram hair tables: " + offsets.length;

    var str1Addr = exe.Rva2Raw(exe.fetchDWord(offsets[0] + str1Offset));
    if (exe.fetchUByte(str1Addr) != 0x31 || exe.fetchUByte(str1Addr + 1) != 0)
        return "Failed in step 9 - wrong constant 1 found";

    var tableCodeOffset = offsets[0];
    var vectorCallAddr = exe.fetchDWord(tableCodeOffset + callOffset) + tableCodeOffset + callOffset + 4;
    // no varCode
    var varCode = "";
    patchOffset = tableCodeOffset + patchOffset;

    consoleLog("step 10 - search female doram hair table and location for jump");
    code =
        "C7 40 14 AB AB AB AB " +     // 0 mov dword ptr [eax+14h], offset a5
        "8B 06 " +                    // 7 mov eax, [esi]
        "8D B7 AB AB 00 00 " +        // 9 lea esi, [edi+CSession.doram_job_hair_sprite_array_F]
        "C7 40 AB AB AB AB AB " +     // 15 mov dword ptr [eax+18h], offset a6
        "8D 45 AB " +                 // 22 lea eax, [ebp+a3]
        "50 " +                       // 25 push eax
        "6A 07 " +                    // 26 push 7
        "8B CE " +                    // 28 mov ecx, esi
        "E8 AB AB AB AB " +           // 30 call std_vector_char_ptr_resize
        "8B 06 " +                    // 35 mov eax, [esi]
        "C7 40 ";                     // 37 mov dword ptr [eax+4], offset a1_1
    var str1Offset = 40;
    var patchOffset2 = 25;   // from this offset code will be patched
    var callOffset2 = 31;    // in this offset relative call address

    offset = exe.find(code, PTYPE_HEX, true, "\xAB", tableCodeOffset, tableCodeOffset + 0x150);
    if (offset === -1)
        return "Failed in step 10 - jump location not found";

    var tableCodeOffset2 = offset;
    var vectorCallAddr2 = exe.fetchDWord(tableCodeOffset2 + callOffset2) + tableCodeOffset2 + callOffset2 + 4;
    patchOffset2 = tableCodeOffset2 + patchOffset2;

    if (vectorCallAddr !== vectorCallAddr2)
        return "Failed in step 10 - vector call functions different";

    var jmpAddr = exe.Raw2Rva(offset);
    var vectorCallOffset = vectorCallAddr - (patchOffset + 1 + 5 + 2 + 5);  // calc offset to call vector function (offsets from next code block)

    consoleLog("doram job male hair style table loader patch");

    code =
        "50 " +                              // push eax
        "68 " + maxHairs.packToHex(4) +      // push maxHairs
        "8B CE " +                           // mov ecx, esi
        "E8 " + vectorCallOffset.packToHex(4) +  // call vector__alloc_mem_and_set_pointer

        "56 " +                              // push esi
        "57 " +                              // push edi
        "53 " +                              // push ebx
        "51 " +                              // push ecx
        "B9 " + maxHairs.packToHex(4) +      // mov ecx, maxHairs
        "8B 06 " +                           // mov eax, [esi]         eax now is pointer to destination buffer
        "BF " + tableStrings.packToHex(4) +  // mov edi, tableStrings  edi now is pointer to strings buffer
        "89 38" +                            // mov [eax], edi         save one pointer into table
        "83 C0 04" +                         // add eax, 4
        "83 C7 04" +                         // add edi, 4
        "49" +                               // dec ecx
        "75 F5" +                            // je -11                 mov to mov [eax], edi
        "59 " +                              // pop ecx
        "5B " +                              // pop ebx
        "5F " +                              // pop edi
        "5E " +                              // pop esi
        "E9 ";                               // jmp jmpAddr

    jmpAddr = jmpAddr - (exe.Raw2Rva(patchOffset) + code.hexlength() + 4);
    code = code + jmpAddr.packToHex(4);

    exe.replace(patchOffset, code, PTYPE_HEX);  // add patch with fill male hair table


    // ex 8
    consoleLog("step 11 - search location for jump");
    var code =
        "8B 06 " +                    // 0 mov eax, [esi]
        "8D 8F AB AB 00 00 " +        // 2 lea ecx, [edi+CSession.field_4B84]
        "C7 40 08 " + str2Offset.packToHex(4) + " " + // 8 mov dword ptr [eax+8], offset a2
        "8B 06 " +                    // 15 mov eax, [esi]
        "C7 45 AB AB AB AB AB " +     // 17 mov [ebp+a3], offset a_O
        "C7 40 0C AB AB AB AB " +     // 24 mov dword ptr [eax+0Ch], offset a3
        "8B 06 " +                    // 31 mov eax, [esi]
        "C7 40 10 AB AB AB AB " +     // 33 mov dword ptr [eax+10h], offset a4
        "8B 06 " +                    // 40 mov eax, [esi]
        "C7 40 14 AB AB AB AB " +     // 42 mov dword ptr [eax+14h], offset a5
        "8B 06 " +                    // 49 mov eax, [esi]
        "C7 40 18 AB AB AB AB " +     // 51 mov dword ptr [eax+18h], offset a6
        "8D 45 AB " +                 // 58 lea eax, [ebp+a3]
        "50 " +                       // 61 push eax
        "68 AB AB 00 00 " +           // 62 push 7D0h
        "E8 ";                        // 67 call std_vector_char_ptr_resize
    var fetchOffset1 = 2;   // copy into own code from this address
    var fetchSize1 = 6;     // copy this N bytes into own code
    var fetchOffset2 = 17;  // copy into own code from this address
    var fetchSize2 = 7;     // copy this N bytes into own code
    var jumpOffset = 58;    // jump offset

    offset = exe.find(code, PTYPE_HEX, true, "\xAB", tableCodeOffset2 + 5, tableCodeOffset2 + 0x150);
    if (offset === -1)
        return "Failed in step 8 - jump location not found";

    var varCode = exe.fetchHex(offset + fetchOffset1, fetchSize1) + exe.fetchHex(offset + fetchOffset2, fetchSize2);
    jmpAddr = exe.Raw2Rva(offset + jumpOffset);
    var vectorCallOffset2 = vectorCallAddr2 - (patchOffset2 + 1 + 5 + 2 + 5);  // calc offset to call vector function (offsets from next code block)

    consoleLog("doram job female hair style table loader patch");
    code =
        "50 " +                              // push eax
        "68 " + maxHairs.packToHex(4) +      // push maxHairs
        "8B CE " +                           // mov ecx, esi
        "E8 " + vectorCallOffset2.packToHex(4) +  // call vector__alloc_mem_and_set_pointer

        "56 " +                              // push esi
        "57 " +                              // push edi
        "53 " +                              // push ebx
        "51 " +                              // push ecx
        "B9 " + maxHairs.packToHex(4) +      // mov ecx, maxHairs
        "8B 06 " +                           // mov eax, [esi]         eax now is pointer to destination buffer
        "BF " + tableStrings.packToHex(4) +  // mov edi, tableStrings  edi now is pointer to strings buffer
        "89 38" +                            // mov [eax], edi         save one pointer into table
        "83 C0 04" +                         // add eax, 4
        "83 C7 04" +                         // add edi, 4
        "49" +                               // dec ecx
        "75 F5" +                            // je -11                 mov to mov [eax], edi
        "59 " +                              // pop ecx
        "5B " +                              // pop ebx
        "5F " +                              // pop edi
        "5E " +                              // pop esi
        varCode +                            // lea ecx, [edi+CSession.field_4B84]
                                             // mov [ebp+a3], offset a_O
        "E9 ";                               // jmp jmpAddr

    jmpAddr = jmpAddr - (exe.Raw2Rva(patchOffset2) + code.hexlength() + 4);
    code = code + jmpAddr.packToHex(4);

    exe.replace(patchOffset2, code, PTYPE_HEX);  // add patch with fill female hair table

    return true;
}

function str2Hex(val, sz)
{
    var str = val.toString();
    var hex = "";
    for(var i = 0; i < str.length; i++)
    {
        hex = hex + (parseInt(str[i]) + 0x30).packToHex(1);
    }
    while (hex.length < sz * 3)
        hex = hex + " 00";
    return hex;
}
