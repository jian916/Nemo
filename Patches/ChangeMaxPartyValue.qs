//
// Copyright (C) 2019  CH.C
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

// search in UIMessengerGroupWnd_virt68

function ChangeMaxPartyValue()
{
    consoleLog("step 1");
    var code =
        "68 9F 0C 00 00 ";            // 0 push 0C9Fh
    var offset = exe.findCode(code, PTYPE_HEX, false);
    if (offset === -1)
        return "Failed in Step 1";

    consoleLog("step 2");
    var code =
        "B9 AB AB AB AB " +           // 0 mov ecx, offset g_session
        "6A 0C " +                    // 5 push 0Ch
        "E8";                         // 7 call CSession_GetNumParty
    var patchOffset = 6;
    offset = exe.find(code, PTYPE_HEX, true, "\xAB", offset, offset + 0x60);
    if (offset === -1)
        return "Failed in Step 2";

    var value = exe.getUserInput("$max_party_value", XTYPE_BYTE, _("Max Party"), _("Set Max Party Value: (Max:127, Default:12)"), "12", 1, 127);

    consoleLog("step 3");
    exe.replace(offset + patchOffset, value.packToHex(1), PTYPE_HEX);

    return true;
}