//
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

function UITransBalloonTextDecoration(addrId, name)
{
    var fieldId = table.UITransBalloonText_m_drawTextDecoration;
    var paramStr = "$" + name + "TextDecoration";

    var value = exe.getUserInput(paramStr, XTYPE_DWORD, _("Number Input"), _("Enable text decoration for @@").replace("@@", name), 0, 0, 1);
    if (value === 0)
        throw "New decoration type is same";

    if (table.get(addrId) === 0)
        throw name + "::" + name + " ret not set";
    var addrRaw = table.getRaw(addrId);

    var field = table.get(fieldId);
    if (field === 0)
        throw "UITransBalloonText::m_drawTextDecoration not set";

    var text = "mov dword ptr [eax + m_drawTextDecoration], drawTextDecoration";
    var vars = {
        "m_drawTextDecoration": field,
        "drawTextDecoration": value
    };

    var hook = hooks.initEndHook(addrRaw);
    hook.addPost(text, vars);
    hook.validate();
}

function ChangeUITransBalloonTextDecoration()
{
    UITransBalloonTextDecoration(table.UITransBalloonTextConstructor_ret, "UITransBalloonText");
    return true;
}
