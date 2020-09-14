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
//##################################################################
//# Purpose: Override job id in creation dialog / packet           #
//##################################################################

function FixedCharJobCreate()
{
    //Step 1 - find sending packet 0xA39
    // 2018-05-30
    var code =
        "B8 39 0A 00 00" +        // mov     eax, 0A39h
        "66 89 85 AB AB AB AB" +  // mov     [ebp+a39.packet_id], ax
        "0F B7 05 AB AB AB AB" +  // movzx   eax, word_FC7C44
        "66 89 85 AB AB AB AB" +  // mov     [ebp+a39.hair_color], ax
        "0F B7 05 AB AB AB AB" +  // movzx   eax, word_FC7C32
        "66 89 85 AB AB AB AB" +  // mov     [ebp+a39.hair_style], ax
        "A0 AB AB AB AB" +        // mov     al, byte_FC7C66
        "88 85 AB AB AB AB" +     // mov     [ebp+a39.slot], al
        "0F BF 05 AB AB AB AB" +  // movsx   eax, word_FC7C30  <-- patch here
        "89 85 AB AB AB AB"       // mov     dword ptr [ebp+a39.starting_job_id], eax
    var patchOffset = 51;
    var offsets = exe.findCodes(code, PTYPE_HEX, true, "\xAB");
    if (offsets.length === 0)
        return "Search packet 0xA39 error";
    if (offsets.length != 1)
        return "Found too many 0xA39 packets";
    var offset = offsets[0]
    var newJob = exe.getUserInput("$newJobVal", XTYPE_DWORD, _("Number Input"), _("Enter fixe job id"), 1);
    exe.replace(offset + patchOffset, "B8 " + newJob.packToHex(4) + " 90 90" , PTYPE_HEX);
    return true;
}
