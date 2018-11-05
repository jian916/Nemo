function AlwaysReadKrExtSettings()
{
    // Step 1a - Find ExternalSettings_kr path string
    var offset = exe.findString("Lua Files\\service_korea\\ExternalSettings_kr", RVA);
    if (offset === -1)
    {
        return "Failed in step 1a - Cannot find ExternalSettings_kr path string.";
    }

    // Step 1b - Find its reference
    var korea_ref_offset = exe.findCode("68" + offset.packToHex(4), PTYPE_HEX, false);
    if (korea_ref_offset === -1)
    {
        return "Failed in step 1b - String reference is missing.";
    }

    // Step 2a - Find server_korea reading code
    var LANGTYPE = GetLangType();

    var code =
        " 8B F9"         // MOV EDI, ECX
    +   " A1" + LANGTYPE // MOV EAX, g_serviceType
    +   " 83 F8 12"      // CMP EAX, 12
    ;

    offset = exe.find(code, PTYPE_HEX, true, "\xAB", korea_ref_offset - 0x50, korea_ref_offset);
    if (offset !== -1)
    {  // old way for old clients
        // offset now points to the JA instruction after CMP EAX, 12
        offset += code.hexlength();

        // Step 3a - Force the client to read Lua Files\service_korea\ExternalSettings_kr.lub
        var diff = korea_ref_offset - offset - 2; // -2 for EB xx
        exe.replace(offset, " EB" + diff.packToHex(1), PTYPE_HEX);

        return true;
    }

    // new way for new clients here first way failed
    code =
        "8B F9 " +                // mov edi, ecx
        "A1 " + LANGTYPE +        // mov eax, g_serviceType
        "83 F8 AB " +             // cmp eax, 12h
        "0F 87 AB AB AB AB " +    // ja default
        "0F B6 80 AB AB AB AB " + // movzx eax, switch1_byte_AA28EC[eax]
        "FF 24 85 ";              // jmp switch2_off_AA28C0[eax*4]
    var patchOffset = 2;
    var switch1Offset = 19;
    var switch2Offset = 26;

    offset = exe.find(code, PTYPE_HEX, true, "\xAB", korea_ref_offset - 0x100, korea_ref_offset);
    if (offset === -1)
        return "Failed in Step 2a - g_serviceType comparison not found";

    // get switch jmp address for value 0
    var addr1 = exe.Rva2Raw(exe.fetchDWord(offset + switch1Offset));
    var addr2 = exe.Rva2Raw(exe.fetchDWord(offset + switch2Offset));
    var offset1 = exe.fetchUByte(addr1);
    var jmpAddr = exe.fetchDWord(addr2 + 4 * offset1);
    code =
        "B8 " + jmpAddr.packToHex(4) + // mov eax, addr
        "FF E0";                       // jmp eax
    exe.replace(offset + patchOffset, code, PTYPE_HEX);  // add jump to korean settings
    return true;
}

//=================================//
// Disable for Unsupported clients //
//=================================//
function AlwaysReadKrExtSettings_()
{
    return (exe.findString("Lua Files\\service_korea\\ExternalSettings_kr",RAW) !== -1);
}
