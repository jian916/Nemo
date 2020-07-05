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
        "85 C9" +              // 0 test ecx, ecx
        "78 05" +              // 2 js short A
        "83 F9 AB" +           // 4 cmp eax, 21h
        "AB AB" +              // 7 jle short B
        "C7 00 AB 00 00 00 " + // 9 mov dword ptr [esi], 21h
		"B9 AB 00 00 00";      // 15 mov ecx, 21h
    var assignOffset = 9;
    var valueOffset = 6;

    offset = exe.find(code, PTYPE_HEX, true, "\xAB", refOffset - 0x200, refOffset);
    if (offset === -1)
        return "Failed in step 2 - hair limit missing";

    var currentLimit = exe.fetchUByte(offset + valueOffset) + 1;  // current max hair limit
    exe.replace(offset + assignOffset, "90 90 90 90 90 90 90 90 90 90 90", PTYPE_HEX);  // removing hair style limit assign

    consoleLog("step 3 - search doram jobs hair limit");
    code =
        "8B 08 " +                    // 0 mov ecx, [eax]
        "75 AB " +                    // 2 jnz short loc_8D08A9
        "83 F9 01 " +                 // 4 cmp ecx, 1
        "7C 05 " +                    // 7 jl short loc_8D0840
        "83 F9 AB " +                 // 9 cmp ecx, 0Bh
        "7C AB " +                    // 12 jl short loc_8D0846
        "C7 00 AB 00 00 00 " +        // 14 mov dword ptr [esi], 0A
		"B9 AB 00 00 00";             // 20 mov ecx, 0Ah
    var assignOffset = 14;
    var valueOffset = 11;

    offset = exe.find(code, PTYPE_HEX, true, "\xAB", refOffset - 0x200, refOffset);
    if (offset === -1)
        return "Failed in step 3 - doram hair limit missing";

    var currentLimit = exe.fetchUByte(offset + valueOffset) + 1;  // current max hair limit
    exe.replace(offset + assignOffset, "90 90 90 90 90 90 90 90 90 90 90", PTYPE_HEX);  // removing hair style limit assign

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
		"56 " +                                        // 1 push esi
        "6A AB " +                                     // 2 push 21h
		"8B CE " +                                     // 4 mov ecx,esi
        "E8 AB AB AB AB " +                            // 6 call vector__alloc_mem_and_set_pointer
        "8B 06 " +                                     // 11 mov eax, [esi]
        "C7 45 F0 " + str2Offset.packToHex(4) + " " +  // 13 mov dword ptr [ebp+A], offset "2"
        "C7 00 " + str2Offset.packToHex(4);            // 20 mov dword ptr [eax], offset "2"
    var patchOffset = 0;  // from this offset code will be patched
    var callOffset = 7;  // in this offset relative call address
    var fetchOffset = 13;  // copy into own code from this address
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
        "8B 06" +                          // 0 mov eax, [esi]
        "8D B7 AB AB 00 00" +              // 2 lea esi, [edi+CSession.normal_job_hair_sprite_array_F]
        "8B CE " +                         // 8 mov ecx, esi
        "C7 80 AB AB AB AB AB AB AB AB" +  // 10 mov dword ptr [eax+80h], offset a32
        "8D 45 AB" +                       // 20 lea eax, [ebp+var_10]
        "50" +                             // 23 push eax
		"56 " +                            // 24 push esi
        "6A AB " +                         // 25 push 1Eh
        "E8 AB AB AB AB ";                 // 27 call vector__alloc_mem_and_set_pointer
    var patchOffset2 = 23;   // from this offset code will be patched
    var callOffset2 = 28;    // in this offset relative call address

    offset = exe.find(code, PTYPE_HEX, true, "\xAB", tableCodeOffset, tableCodeOffset + 0x150);
	
	if (offset === -1) //newer clients
	{
		code = code.replace(" C7 80 AB AB AB AB AB AB AB AB", " C7 40 AB AB AB AB AB");   //mov dword ptr [eax+7Ch], offset a31
		offset = exe.find(code, PTYPE_HEX, true, "\xAB", tableCodeOffset, tableCodeOffset + 0x150);
		patchOffset2 -= 3;
		callOffset2 -= 3; 
	}
    if (offset === -1)
        return "Failed in step 7 - jump location not found";

    var tableCodeOffset2 = offset;
    var vectorCallAddr2 = exe.fetchDWord(tableCodeOffset2 + callOffset2) + tableCodeOffset2 + callOffset2 + 4;
    patchOffset2 = tableCodeOffset2 + patchOffset2;

    if (vectorCallAddr !== vectorCallAddr2)
        return "Failed in step 7 - vector call functions different";

    var jmpAddr = exe.Raw2Rva(offset);
    var vectorCallOffset = vectorCallAddr - (patchOffset + 1 + 1 + 5 + varCode.hexlength() + 2 + 5);  // calc offset to call vector function (offsets from next code block)

    consoleLog("normal job male hair style table loader patch");
    code =
        "50 " +                              // push eax
		"56 " +                              // push esi
        "68 " + maxHairs.packToHex(4) +      // push maxHairs
        varCode +                            // mov dword ptr [ebp+A], offset "2"
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

    consoleLog("step 8 - search male doram hair table allocations in CSession::InitPcNameTable");
    code =
        "8B 06 " +                             // 0 mov eax, [esi]
        "8D B7 AB AB AB AB " +                 // 2 lea esi, [edi+CSession.doram_job_hair_sprite_array_M]
        "8B CE " +                             // 8 mov ecx, esi
        "C7 80 AB AB AB AB AB AB AB AB " +     // 10 mov dword ptr [eax+80h], offset a31
        "8D 45 AB " +                          // 20 lea eax, [ebp+a3]
        "50 " +                                // 23 push eax
		"56 " +                                // 24 push esi
        "6A AB " +                             // 25 push 7
        "E8 AB AB AB AB " +                    // 27 call std_vector_char_ptr_resize
        "8B 06 " +                             // 32 mov eax, [esi]
        "C7 40 ";                              // 34 mov dword ptr [eax+4], offset a1
    var str1Offset = 37;
    var patchOffset = 23;  // from this offset code will be patched
    var callOffset = 28;  // in this offset relative call address
    // no fetch code

    var offsets = exe.findCodes(code, PTYPE_HEX, true, "\xAB");

    if (offsets.length === 0)
	{
		code = code.replace(" C7 80 AB AB AB AB AB AB AB AB", " C7 40 AB AB AB AB AB");   //mov dword ptr [eax+7Ch], offset a31
		offsets = exe.findCodes(code, PTYPE_HEX, true, "\xAB");
		str1Offset -= 3;
		patchOffset -= 3; 
		callOffset -= 3;
	}
		
	if (offsets.length === 0)
        return "Failed in step 8 - doram hair table not found";
    if (offsets.length !== 1)
        return "Failed in step 8 - found wrong number of doram hair tables: " + offsets.length;

    var str1Addr = exe.Rva2Raw(exe.fetchDWord(offsets[0] + str1Offset));
    if (exe.fetchUByte(str1Addr) != 0x31 || exe.fetchUByte(str1Addr + 1) != 0)
        return "Failed in step 8 - wrong constant 1 found";

    var tableCodeOffset = offsets[0];
    var vectorCallAddr = exe.fetchDWord(tableCodeOffset + callOffset) + tableCodeOffset + callOffset + 4;
    // no varCode
    var varCode = "";
    patchOffset = tableCodeOffset + patchOffset;
	
	offset = offsets[0];
	jmpAddr = exe.Raw2Rva(offset);
    var vectorCallOffset2 = vectorCallAddr2 - (patchOffset2 + 1 + 1 + 5 + 2 + 5);  // calc offset to call vector function (offsets from next code block)

    consoleLog("normal job female hair style table loader patch");
    code =
        "50 " +                              // push eax
		"56 " +                              // push esi
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


    consoleLog("step 9 - search female doram hair table and location for jump");
    code =
        "8B 06 " +                    // 0 mov eax, [esi]
        "8D B7 AB AB 00 00 " +        // 2 lea esi, [edi+CSession.doram_job_hair_sprite_array_F]
        "8B CE " +                    // 8 mov ecx, esi
        "C7 40 AB AB AB AB AB " +     // 10 mov dword ptr [eax+18h], offset a6
        "8D 45 AB " +                 // 17 lea eax, [ebp+a3]
        "50 " +                       // 20 push eax
		"56 " +                       // 21 push esi
        "6A AB " +                    // 22 push 7
        "E8 AB AB AB AB " +           // 24 call std_vector_char_ptr_resize
        "8B 06 " +                    // 29 mov eax, [esi]
        "8D 9F AB AB AB AB " +        // 31 lea ebx, [edi+CSession.ViewID_sprite_array]
		"8B CB " +                    // 37 mov ecx,ebx
		"C7 45 AB AB AB AB AB" +      // 39 mov [ebp+var_10], offset "_병아리모자"
		"C7 40 ";                     // 46 mov dword ptr [eax+4], offset a1
		
    var str1Offset = 49;
    var patchOffset2 = 20;   // from this offset code will be patched
    var callOffset2 = 25;    // in this offset relative call address
	var fetchOffset = 31;  // copy into own code from this address
    var fetchSize = 15;    // copy this N bytes into own code

    offset = exe.find(code, PTYPE_HEX, true, "\xAB", tableCodeOffset, tableCodeOffset + 0x150);
    if (offset === -1)
        return "Failed in step 9 - jump location not found";

    var tableCodeOffset2 = offset;
    var vectorCallAddr2 = exe.fetchDWord(tableCodeOffset2 + callOffset2) + tableCodeOffset2 + callOffset2 + 4;
    patchOffset2 = tableCodeOffset2 + patchOffset2;
	var varCode = exe.fetchHex(tableCodeOffset2 + fetchOffset, fetchSize);

    if (vectorCallAddr !== vectorCallAddr2)
        return "Failed in step 9 - vector call functions different";

    var jmpAddr = exe.Raw2Rva(offset);
    var vectorCallOffset = vectorCallAddr - (patchOffset + 1 + 1 + 5 + 2 + 5);  // calc offset to call vector function (offsets from next code block)

    consoleLog("doram job male hair style table loader patch");

    code =
        "50 " +                              // push eax
		"56 " +                              // push esi
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
    consoleLog("step 10 - search location for jump");

	if (exe.getClientDate() > 20200325)
		var viewID = 3000;
	else
		var viewID = 2000;
	
    var code =
        "8B 06 " +                           // 0 mov eax, [esi]
        "C7 40 AB AB AB AB AB " +            // 2 mov dword ptr [eax+28h], offset a10
        "8D 45 AB " +                        // 9 lea eax, [ebp+var_10]
        "50 " +                              // 12 push eax
		"53 " +                              // 13 push ebx
        "68 " + viewID.packToHex(4) + " " +  // 14 push viewID
        "E8 ";                               // 19 call std_vector_char_ptr_resize
    var jumpOffset = 9;    // jump offset

    offset = exe.find(code, PTYPE_HEX, true, "\xAB", tableCodeOffset2 + 5, tableCodeOffset2 + 0x150);
    if (offset === -1)
        return "Failed in step 10 - jump location not found";

    jmpAddr = exe.Raw2Rva(offset + jumpOffset);
    var vectorCallOffset2 = vectorCallAddr2 - (patchOffset2 + 1 + 1 + 5 + 2 + 5);  // calc offset to call vector function (offsets from next code block)

    consoleLog("doram job female hair style table loader patch");
    code =
        "50 " +                              // push eax
		"53 " +                              // push esi
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
        varCode +                            // lea ebx, [edi+CSession.ViewID_sprite_array]
                                             // mov ecx,ebx
											 // mov [ebp+var_10], offset "_병아리모자"
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
