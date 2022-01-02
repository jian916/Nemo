//
// Copyright (C) 2018  CH.C
// Copyright (C) 2021  Andrei Karas (4144)
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
//================================================================//
// Patch Functions wrapping over ChangeAutoFollowDelay function   //
//================================================================//

function SetAutoFollowDelay()
{
    var value = exe.getUserInput("$followDelay", XTYPE_DWORD, _("Number Input"), _("Enter the new autofollow move delay in ms."), 1000, 0, 0x7fffffff);
    if (value === 1000)
        return "New delay is same with old value";

    var oldFollowTime = table.getHex4(table.m_oldFollowTime);

    consoleLog("Find the delay comparison");
    var code =
        "FF ?? " +                    // 0 call edi ; timeGetTime
        "2B 05 " + oldFollowTime +    // 2 sub eax, m_oldFollowTime
        "3D E8 03 00 00 ";            // 8 cmp eax, 3E8h
    var delayOffset = [9, 4];
    var offsets = pe.findCodes(code);

    if (offsets.length === 0)
        return "Auto follow delay code not found.";

    if (offsets.length > 2)
        return "Found too much auto follow delay code.";

    consoleLog("Replace the value");
    for (var i = 0; i < offsets.length; i++)
    {
        pe.setValue(offsets[i], delayOffset, value);
    }

    return true;
}
