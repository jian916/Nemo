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

function UIBalloonTextFontSize(addrId, name)
{
    var fieldId = table.UIBalloonText_m_fontSize;
    var colorStr = "$" + name + "FontSize";

    var value = exe.getUserInput(colorStr, XTYPE_DWORD, _("Number Input"), _("Enter new default font size in @@").replace("@@", name), 12, 1, 1000);
    if (value === 12)
        throw "New font size is same";

    if (table.get(addrId) === 0)
        throw name + "::" + name + " ret not set";
    var addrRaw = table.getRaw(addrId);

    var field = table.get(fieldId);
    if (field === 0)
        throw "UIBalloonText::m_fontSize not set";

    var text = "mov dword ptr [eax + m_fontSize], fontSize";
    var vars = {
        "m_fontSize": field,
        "fontSize": value
    };

    var hook = hooks.initEndHook(addrRaw);
    hook.addPost(text, vars);
}

function ChangeUIBalloonTextFontSize()
{
    UIBalloonTextFontSize(table.UIBalloonTextConstructor_ret, "UIBalloonText");
    return true;
}

function ChangeUINameBalloonTextFontSize()
{
    UIBalloonTextFontSize(table.UINameBalloonTextConstructor_ret, "UINameBalloonText");
    return true;
}

function ChangeUITransBalloonTextFontSize()
{
    UIBalloonTextFontSize(table.UITransBalloonTextConstructor_ret, "UITransBalloonText");
    return true;
}

function ChangeUIAchBalloonTextFontSize()
{
    UIBalloonTextFontSize(table.UIAchBalloonTextConstructor_ret, "UIAchBalloonText");
    return true;
}

function ChangeUICharInfoBalloonTextFontSize()
{
    UIBalloonTextFontSize(table.UICharInfoBalloonTextConstructor_ret, "UICharInfoBalloonText");
    return true;
}

function ChangeUIVerticalNameBalloonTextFontSize()
{
    UIBalloonTextFontSize(table.UIVerticalNameBalloonTextConstructor_ret, "UIVerticalNameBalloonText");
    return true;
}
