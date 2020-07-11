//
// Copyright (C) 2019  Andrei Karas (4144)
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
//# Purpose: Allow spam skill by hotkey                       #
//#############################################################
// search in CGameMode_virt24 near useskilltoid packet

function AllowSpamSkills()
{
    consoleLog("step 1");
    var code =
        "A1 AB AB AB AB " +           // 0 mov eax, g_session.virtual_key_code
        "81 FB F4 07 00 00 " +        // 5 cmp ebx, 7F4h
        "0F 44 05 AB AB AB AB " +     // 11 cmovz eax, g_session.field_5ADC
        "A3 ";                        // 18 mov g_session.virtual_key_code, eax
    var patchOffset = 5;
    var key1Offset1 = 1;
    var key1Offset2 = 19;
    var key2Offset = 14;
    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    if (offset === -1)
        return "Failed in step 1 - pattern not found";

    var key1 = exe.fetchDWord(offset + key1Offset1);
    if (key1 !== exe.fetchDWord(offset + key1Offset2))
    {
        return "Failed in step 1 - found different virtual key offsets";
    }
    var key2 = exe.fetchDWord(offset + key2Offset);
    if (key1 + 4 !== key2)
    {
        return "Failed in step 1 - found wrong virtual key offset";
    }

    consoleLog("step 2");
    code =
        "3B DB" +  // cmp ebx, ebx
        "90 " +    // nop
        "90 " +    // nop
        "90 " +    // nop
        "90 ";     // nop

    exe.replace(offset + patchOffset, code, PTYPE_HEX);
    return true;
}
