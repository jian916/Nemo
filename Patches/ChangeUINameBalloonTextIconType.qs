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

function UINameBalloonTextIconType(addrId, name)
{
    var fieldId = table.UINameBalloonText_m_iconType;
    var paramStr = "$" + name + "IconType";

    var value = exe.getUserInput(paramStr, XTYPE_DWORD, _("Number Input"), _("Enter default icon type for @@").replace("@@", name), 0, 0, 2);
    if (value === 0)
        throw "New icon type is same";

    if (table.get(addrId) === 0)
        throw name + "::" + name + " ret not set";
    var addrRaw = table.getRaw(addrId);

    var field = table.get(fieldId);
    if (field === 0)
        throw "UIBalloonText::m_fontSize not set";

    var text = "mov dword ptr [eax + m_iconType], iconType";
    var vars = {
        "m_iconType": field,
        "iconType": value
    };

    var hook = hooks.initEndHook(addrRaw);
    hook.addPost(text, vars);
    hook.validate();
}

function ChangeUINameBalloonTextIconType()
{
    UINameBalloonTextIconType(table.UINameBalloonTextConstructor_ret, "UINameBalloonText");
    return true;
}
