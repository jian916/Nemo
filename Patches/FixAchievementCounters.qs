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
//#############################################################
//# Purpose: Fix achievement counters in ahievement window in #
//#          UIAchSummaryWnd_virt68                           #
//#############################################################

function FixAchievementCounters()
{
    // step 1
    var countersStr = pe.stringVa("%d/%d");

    if (countersStr === -1)
        return "Failed in Step 1 - '%d/%d' string missing";

    // step 2
    // search global counter
    var code =
        "8B 57 ?? " +                 // 0 mov edx, [edi+68h]
        "8B 42 04 " +                 // 3 mov eax, [edx+4]    <-- type1
        "8B 48 ?? " +                 // 6 mov ecx, [eax+68h]
        "8B 02 " +                    // 9 mov eax, [edx]
        "51 " +                       // 11 push ecx
        "FF 70 ?? " +                 // 12 push dword ptr [eax+64h]
        "8D 45 ?? " +                 // 15 lea eax, [ebp+dstStr]
        "68 " + countersStr.packToHex(4) + // 18 push offset "%d/%d"
        "50 " +                       // 23 push eax
        "E8 ";                        // 24 call std_string_sprintf
    var type1Offset = 5;
    var offset = pe.findCode(code);

    if (offset === -1)
    {
        if (exe.getClientDate() < 20170000)
            return "Failed in step 2 - pattern not found";
        else
            var addr1 = false;  // can skip 2017 clients, because no this bug
    }
    else
    {
        var addr1 = offset + type1Offset;
    }

    // step 3
    // search categories except general
    var code =
        "8B 57 ?? " +  // mov edx, [edi+78h]
        "8B 42 04 " +  // mov eax, [edx+4]    <-- type1
        "8B 48 ?? " +  // mov ecx, [eax+78h]
        "8B 42 ?? " +  // mov eax, [edx+8]    <-- type2
        "51 " +        // push ecx
        "FF 70 ?? " +  // push dword ptr [eax+74h]
        "8D 45 ?? " +  // lea eax, [ebp+dstStr]
        "68 " + countersStr.packToHex(4) +  // push offset "%d/%d"
        "50 " +        // push eax
        "E8 ";         // call std_string_sprintf

    var type1Offset = 5;
    var type2Offset = 11;
    var offsets = pe.findCodes(code);

    if (offsets.length === 0)
        return "Failed in step 3 - pattern not found";
    if (offsets.length !== 5)
        return "Failed in step 3 - found wrong number of patterns: " + offsets.length;

    if (addr1 !== false)
    {
        if (addr1 > offsets[0] || addr1 + 0x200 < offsets[0])
            return "Failed in step 3 - found wrong offsets";
    }

    // step 4
    var msgOffsets = [];
    var msgIds = [];
    var type1Offsets = [];
    var type2Offsets = [];

    var msgOffset = 1;

    for (var i = 0; i < offsets.length; i++)
    {
        code =
            "68 ?? ?? 00 00 " +        // push msgId
            "C7 45 ?? 0F 00 00 00 " +  // mov [ebp+dstStr.m_allocated_len], 0Fh
            "C7 45 ?? 00 00 00 00 " +  // mov [ebp+dstStr.m_len], 0
            "C6 45 ?? 00 " +           // mov byte ptr [ebp+dstStr.m_cstr], 0
            "E8 ?? ?? ?? ?? " +        // call MsgStr
            "83 C4 04 " +              // add esp, 4
            "8B CF " +                 // mov ecx, edi
            "50 ";                     // push eax
        var offset = pe.find(code, offsets[i] - 0x40, offsets[i]);
        if (offset === -1)
            return "Failed in step 4: pattern not found, offset " + i;
        msgOffsets[i] = offset;
        msgIds[i] = pe.fetchDWord(msgOffsets[i] + msgOffset);
        type1Offsets[i] = pe.fetchUByte(offsets[i] + type1Offset);
        type2Offsets[i] = pe.fetchUByte(offsets[i] + type2Offset);
    }

    // step 5
    var data = 0;

    // global counter
    if (addr1 !== false)
    {
        pe.replaceByte(addr1, 0);     // change wrong offset to correct one
    }

    // 0
    // 52, 9d  - Adventure -> Battle
    pe.replaceHex(offsets[0] + type1Offset, type2Offsets[1].packToHex(1));  // change wrong offset to correct one
    pe.replaceHex(offsets[0] + type2Offset, type2Offsets[1].packToHex(1));  // change wrong offset to correct one
    pe.replaceHex(msgOffsets[0] + msgOffset, msgIds[1].packToHex(4));     // change wrong message id

    // 1
    // 52, cf  - Battle    -> Memorial
    pe.replaceHex(offsets[1] + type1Offset, type2Offsets[3].packToHex(1));  // change wrong offset to correct one
    pe.replaceHex(offsets[1] + type2Offset, type2Offsets[3].packToHex(1));  // change wrong offset to correct one
    pe.replaceHex(msgOffsets[1] + msgOffset, msgIds[3].packToHex(4));     // change wrong message id

    // 2
    // 180, 6b - Quest     -> Adventure
    pe.replaceHex(offsets[2] + type1Offset, type2Offsets[0].packToHex(1));  // change wrong offset to correct one
    pe.replaceHex(offsets[2] + type2Offset, type2Offsets[0].packToHex(1));  // change wrong offset to correct one
    pe.replaceHex(msgOffsets[2] + msgOffset, msgIds[0].packToHex(4));     // change wrong message id

    // 3
    // 180, 9d - Memorial  -> Quest
    pe.replaceHex(offsets[3] + type1Offset, type2Offsets[2].packToHex(1));  // change wrong offset to correct one
    pe.replaceHex(offsets[3] + type2Offset, type2Offsets[2].packToHex(1));  // change wrong offset to correct one
    pe.replaceHex(msgOffsets[3] + msgOffset, msgIds[2].packToHex(4));     // change wrong message id

    // 4
    // 180, cf - Feat
    pe.replaceHex(offsets[4] + type1Offset, type2Offsets[4].packToHex(1));  // change wrong offset to correct one

    return true;
}
