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

function UITransBalloonTextFillColor(addrId, name)
{
    var fieldId = table.UITransBalloonText_m_backFillColor;
    var colorStr = "$" + name + "BackFillColor";

    var value = exe.getUserInput(colorStr, XTYPE_COLOR, _("Color input"), _("Select default background color in @@").replace("@@", name), 0x5C5C5C).reverseRGB();
    if (value === 0x5C5C5C)
        throw "New background color is same";

    if (table.get(addrId) === 0)
        throw name + "::" + name + " ret not set";
    var addrRaw = table.getRaw(addrId);

    var field = table.get(fieldId);
    if (field === 0)
        throw "UITransBalloonText::m_backFillColor not set";

    var text = "mov dword ptr [eax + m_backFillColor], backFillColor";
    var vars = {
        "m_backFillColor": field,
        "backFillColor": value
    };

    var hook = hooks.initEndHook(addrRaw);
    hook.addPost(text, vars);
    hook.validate();
}

function ChangeUITransBalloonTextFillColor()
{
    UITransBalloonTextFillColor(table.UITransBalloonTextConstructor_ret, "UITransBalloonText");
    return true;
}
