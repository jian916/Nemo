//
// Copyright (C) 2017  Andrei Karas (4144)
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
//###########################################################################
//# Purpose: Remove hardcoded otp / login addreses and ports                #
//###########################################################################

// older than 2019-02-13
function RemoveHardcodedAddressOld(offset, overrideAddressOffset)
{
    // step 1b - replace call to nop
    var overrideAddr = offset + overrideAddressOffset + 4 + exe.fetchDWord(offset + overrideAddressOffset);  // rva to va

    // step 2a - find string "127.0.0.1"
    var offset = exe.find("31 32 37 2E 30 2E 30 2E 31 00", PTYPE_HEX);
    if (offset === -1)
        return "Failed in search 127.0.0.1 (old)";
    offset = exe.Raw2Rva(offset);

    // step 2b - find otp_addr
    var code = " " +
        offset.packToHex(4) + // offset 127.0.0.1
        " 26 1B 00 00"        // 6950
    var otpAddr = exe.find(code, PTYPE_HEX, true, "\xAB");
    if (otpAddr === -1)
        return "Failed in step 2b (old)";
    otpAddr = exe.Raw2Rva(otpAddr);
    var otpPort = otpAddr + 4
    var clientinfo_addr = otpPort + 4
    var clientinfo_port = clientinfo_addr + 4

    // step 3a - find otp_addr usage
    var code =
        " FF 35" + otpAddr.packToHex(4) + // push otp_addr
        " 8B AB AB AB AB 00" +            // mov esi, ds:_snprintf_s
        " 68 AB AB AB 00" +               // push offset "%s"
        " 6A FF" +                        // push 0FFFFFFFFh
        " 8D AB AB AB FF FF" +            // lea eax, [ebp+buf]
        " 6A 10"                          // push 10h
    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    if (offset === -1)
        return "Failed in step 3a (old)";

    // step 3b - replace otp_addr to clientinfo_addr
    exe.replace(offset + 2, clientinfo_addr.packToHex(4), PTYPE_HEX);

    // step 4a - find call to atoi
    var code =
        " 75 F4" +                                 // jnz addr1
        " FF 35" + clientinfo_port.packToHex(4) +  // push clientinfo_port
        " FF 15 AB AB AB 00" +                     // call ds:atoi
        " FF 35 AB AB AB 00"                       // push clientinfo_domain
    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    if (offset === -1)
        return "Failed in step 4a (old)";

    var callAtoi = exe.fetchHex(offset + 8, 6);

    // step 4b - change function override_address_port
    var newCode =
        "FF 35 " + clientinfo_port.packToHex(4) +  // push clientinfo_port
        callAtoi +                                 // call ds:atoi
        "A3" + otpPort.packToHex(4) +              // mov otp_port, eax
        "83 C4 04" +                               // add esp, 4
        "C3"                                       // retn
    exe.replace(overrideAddr, newCode, PTYPE_HEX);

    return true;
}

// 2019-02-13+
function RemoveHardcodedAddressNew(overrideAddr, retAddr)
{
    // step 2a - find string "127.0.0.1"
    var offset = exe.find("31 32 37 2E 30 2E 30 2E 31 00", PTYPE_HEX);
    if (offset === -1)
        return "Failed in search 127.0.0.1 (old)";
    offset = exe.Raw2Rva(offset);

    // step 2b - find otp_addr
    var code = " " +
        offset.packToHex(4) + // offset 127.0.0.1
        " 26 1B 00 00"        // 6950
    var otpAddr = exe.find(code, PTYPE_HEX, true, "\xAB");
    if (otpAddr === -1)
        return "Failed in step 2b (new)";
    otpAddr = exe.Raw2Rva(otpAddr);
    var otpPort = otpAddr + 4
    var clientinfo_addr = otpPort + 4
    var clientinfo_port = clientinfo_addr + 4

    // step 3a - find otp_addr usage
    var code =
        "FF 35" + otpAddr.packToHex(4) + // 0 push otp_addr
        "8D AB AB AB AB FF " +        // 6 lea eax, [ebp+Dst]
        "68 AB AB AB 00 " +           // 12 push offset aS
        "6A FF " +                    // 17 push 0FFFFFFFFh
        "6A 10 " +                    // 19 push 10h
        "50 ";                        // 21 push eax

    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    if (offset === -1)
        return "Failed in step 3a (new)";

    // step 3b - replace otp_addr to clientinfo_addr
    exe.replace(offset + 2, clientinfo_addr.packToHex(4), PTYPE_HEX);

    // step 4a - find call to atoi
    var code =
        " 75 F3" +                                 // jnz addr1
        " FF 35" + clientinfo_port.packToHex(4) +  // push clientinfo_port
        " FF 15 AB AB AB 00" +                     // call ds:atoi
        " FF 35 AB AB AB 00"                       // push clientinfo_domain
    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    if (offset === -1)
        return "Failed in step 4a (new)";

    var callAtoi = exe.fetchHex(offset + 8, 6);

    // step 4b - change function override_address_port
    var jmpOffset = 21;
    var continueAddr = retAddr - overrideAddr - jmpOffset - 4; // va to rva

    var newCode =
        "FF 35 " + clientinfo_port.packToHex(4) +  // 0 push clientinfo_port
        callAtoi +                                 // 6 call ds:atoi
        " A3" + otpPort.packToHex(4) +             // 12 mov otp_port, eax
        " 83 C4 04" +                              // 17 add esp, 4
        " E9" + continueAddr.packToHex(4)          // 20 jmp continue

    exe.replace(overrideAddr, newCode, PTYPE_HEX);

    return true;
}

function RemoveHardcodedAddress()
{
    // step 1a - Find the code where we will remove call
    var code =
        " 80 3D AB AB AB AB 00" + // cmp byte_addr1, 0
        " 75 AB" +                // jnz short addr2
        " E8 AB AB 00 00" +       // call override_address_port
        " E9 AB AB 00 00";        // jmp addr3
    var overrideAddressOffset = 10;

    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");

    if (offset !== -1)
        return RemoveHardcodedAddressOld(offset, overrideAddressOffset);

    // search for clients 2019-02-13+
    var g_serverType = GetServerType();

    // search "6900"
    var offset = exe.find("36 39 30 30 00", PTYPE_HEX);
    if (offset === -1)
        return "Failed in search '6900' (new)";
    var portStrHex = exe.Raw2Rva(offset).packToHex(4);

    var code =
        "80 3D AB AB AB AB 00 " +     // 0 cmp byte_F64F5B, 0
        "0F 85 AB AB AB 00 " +        // 7 jnz loc_716084
        "8B 15 " + g_serverType.packToHex(4) + // 13 mov edx, g_serverType
        "A1 AB AB AB AB " +           // 19 mov eax, _dword_F09838
        "8B 0D AB AB AB AB " +        // 24 mov ecx, _dword_F097F0
        "C7 05 AB AB AB AB " + portStrHex; // 30 mov _off_CCF968, offset a6900
    var overrideAddressOffset = 13;
    var retAddrOffset = 9;

    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    if (offset === -1)
        return "Failed in step 1 (new)";

    var retAddr = offset + retAddrOffset + 4 + exe.fetchDWord(offset + retAddrOffset);  // rva to va

    return RemoveHardcodedAddressNew(offset + overrideAddressOffset, retAddr);
}

//====================================================================//
// Disable for Unneeded Clients. Start from first zero client version //
//====================================================================//
function RemoveHardcodedAddress_() {
  return ((exe.getClientDate() > 20171019 && IsZero()) || exe.getClientDate() >= 20181113);
}
