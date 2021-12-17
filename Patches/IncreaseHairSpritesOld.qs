//
// Copyright (C) 2018-2021  Andrei Karas (4144)
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

function IncreaseHairSpritesOld()
{
    var maxHairs = 100;
    var bytesPerString = 4;
    var bufSize = maxHairs * bytesPerString;

    // step 1a search for spr/act string
    var code = "\\\xB8\xD3\xB8\xAE\xC5\xEB\\%s\\%s_%s.%s"; // "\머리통\%s\%s_%s.%s"
    var offset = pe.stringRaw(code);

    if (offset === -1)
        return "Failed in step 1 - string not found";

    // step 1b - search string reference
    offset = pe.findCode("68" + pe.rawToVa(offset).packToHex(4));
    if (offset === -1)
        return "Failed in step 1 - string reference missing";

    var refOffset = offset;

    code =
        "85 C0" +             // test eax, eax
        "78 05" +             // js short A
        "83 F8 ??" +          // cmp eax, 1Dh
        "7E 06" +             // jle short B
        "C7 06 ?? 00 00 00";  // mov dword ptr [esi], 0Dh
    var assignOffset = 9;
    var valueOffset = 6;

    // step 2 - search hair limit
    offset = pe.find(code, refOffset - 0x200, refOffset);
    if (offset === -1)
        return "Failed in step 2 - hair limit missing";

    var currentLimit = pe.fetchUByte(offset + valueOffset) + 1;  // current max hair limit
    pe.replaceHex(offset + assignOffset, "90 90 90 90 90 90");  // removing hair style limit assign

    // step 3 - search string "2" "3" "4"
    code =
        "32 00" + // "2"
        "00 00" + //
        "33 00" + // "3"
        "00 00" + //
        "34 00" + // "4"
        "00 00";  //
    offset = pe.find(code);
    if (offset === -1)
        return "Failed in step 3 - string '2' missing";

    var str2Offset = pe.rawToVa(offset);
    currentLimit = currentLimit.packToHex(1);

    // step 4 - search male hair table allocations in CSession::InitPcNameTable
    code =
        "50 " +                                        // push eax
        "6A ?? " +                                     // push 1Eh
        "C7 45 F0 " + str2Offset.packToHex(4) + " " +  // mov dword ptr [ebp+A], offset "2"
        "E8 ?? ?? ?? ?? " +                            // call vector__alloc_mem_and_set_pointer
        "8B 06 " +                                     // mov eax, [esi]
        "C7 00 " + str2Offset.packToHex(4);            // mov dword ptr [eax], offset "2"
    var patchOffset = 0;  // from this offset code will be patched
    var callOffset = 11;  // in this offset relative call address
    var fetchOffset = 3;  // copy into own code from this address
    var fetchSize = 7;    // copy this N bytes into own code

    var offsets = pe.findCodes(code);

    if (offsets.length === 0)
        return "Failed in step 4 - hair table not found";
    if (offsets.length !== 1)
        return "Failed in step 4 - found wrong number of hair tables: " + offsets.length;

    var tableCodeOffset = offsets[0];
    var vectorCallAddr = pe.fetchDWord(tableCodeOffset + callOffset) + tableCodeOffset + callOffset + 4;
    var varCode = pe.fetchHex(tableCodeOffset + fetchOffset, fetchSize);
    patchOffset = tableCodeOffset + patchOffset;

    // step 5 - allocate strings with hair id
    var free = exe.findZeros(bufSize);
    if (free === -1)
        return "Failed in step 5 - not enough free space";
    var data = "";
    for (var i = 0; i < maxHairs; i++)
    {
        data = data + str2Hex(i, bytesPerString);
    }
    if (data.hexlength() !== bufSize)
        return "Failed in step 5 - wrong allocated buffer";

    exe.insert(free, bufSize, data, PTYPE_HEX);
    var tableStrings = pe.rawToVa(free);  // index = id * bytesPerString

    // step 6 - search female hair table and location for jump
    code =
        "8B 06" +                 // mov eax, [esi]
        "8D B7 ?? ?? 00 00" +     // lea esi, [edi+CSession.normal_job_hair_sprite_array_F]
        "C7 40 ?? ?? ?? ?? ??" +  // mov dword ptr [eax+74h], offset a29
        "8D 45 ??" +              // lea eax, [ebp+var_10]
        "50" +                    // push eax
        "6A ?? " +                // push 1Eh
        "8B CE " +                // mov ecx, esi
        "E8 ?? ?? ?? ?? ";        // call vector__alloc_mem_and_set_pointer
    var patchOffset2 = 18;   // from this offset code will be patched
    var callOffset2 = 24;    // in this offset relative call address

    offset = pe.find(code, tableCodeOffset, tableCodeOffset + 0x150);
    if (offset === -1)
        return "Failed in step 6 - jump location not found";

    var tableCodeOffset2 = offset;
    var vectorCallAddr2 = pe.fetchDWord(tableCodeOffset2 + callOffset2) + tableCodeOffset2 + callOffset2 + 4;
    patchOffset2 = tableCodeOffset2 + patchOffset2;

    if (vectorCallAddr !== vectorCallAddr2)
        return "Failed in step 6 - vector call functions different";

    var jmpAddr = pe.rawToVa(offset);
    var vectorCallOffset = vectorCallAddr - (patchOffset + 1 + 5 + varCode.hexlength() + 5);  // calc offset to call vector function (offsets from next code block)

    // normal job male hair style table loader patch
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

    jmpAddr = jmpAddr - (pe.rawToVa(patchOffset) + code.hexlength() + 4);
    code = code + jmpAddr.packToHex(4);

    pe.replaceHex(patchOffset, code);  // add patch with fill male hair table

    // step 7 - search location for jump
    code =
        "8B 06" +                 // mov eax, [esi]
        "8D B7 ?? ?? 00 00" +     // lea esi, [edi+CSession.doram_sex1_hair_sprite_array]
        "C7 40 ?? ?? ?? ?? ??" +  // mov dword ptr [eax+74h], offset a29
        "8D 45 F0" +              // lea eax, [ebp+var_10]
        "50" +                    // push eax
        "6A ??" +                 // push 7  - doram hair limit
        "8B CE" +                 // mov ecx, esi
        "E8 ?? ?? ?? ??";         // call vector__alloc_mem_and_set_pointer

    offset = pe.find(code, tableCodeOffset2 + 5, tableCodeOffset2 + 0x150);
    if (offset === -1)
        return "Failed in step 7 - jump location not found";

    jmpAddr = pe.rawToVa(offset);
    var vectorCallOffset2 = vectorCallAddr2 - (patchOffset2 + 1 + 5 + 2 + 5);  // calc offset to call vector function (offsets from next code block)

    // normal job female hair style table loader patch
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

    jmpAddr = jmpAddr - (pe.rawToVa(patchOffset2) + code.hexlength() + 4);
    code = code + jmpAddr.packToHex(4);

    pe.replaceHex(patchOffset2, code);  // add patch with fill female hair table

    return true;
}

function str2Hex(val, sz)
{
    var str = val.toString();
    var hex = "";
    for (var i = 0; i < str.length; i++)
    {
        hex = hex + (parseInt(str[i]) + 0x30).packToHex(1);
    }
    while (hex.length < sz * 3)
        hex = hex + " 00";
    return hex;
}
