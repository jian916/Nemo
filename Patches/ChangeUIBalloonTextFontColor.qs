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

function UIBalloonTextFontColor(addrId, name)
{
    var fieldId = table.UIBalloonText_m_fontColor;
    var colorStr = "$" + name + "FontColor";

    var value = exe.getUserInput(colorStr, XTYPE_COLOR, _("Color input"), _("Select new default font color in @@").replace("@@", name), 0xFFFFFF).reverseRGB();
    if (value === 0xFFFFFF)
        throw "New font color is same";

    if (table.get(addrId) === 0)
        throw name + "::" + name + " ret not set";
    var addrRaw = table.getRaw(addrId);

    var field = table.get(fieldId);
    if (field === 0)
        throw "UIBalloonText::m_fontColor not set";

    var text = "mov dword ptr [eax + m_fontColor], fontColor";
    var vars = {
        "m_fontColor": field,
        "fontColor": value
    };

    var hook = hooks.initEndHook(addrRaw);
    hook.addPost(text, vars);
}

function ChangeUIBalloonTextFontColor()
{
    UIBalloonTextFontColor(table.UIBalloonTextConstructor_ret, "UIBalloonText");
    return true;
}

function ChangeUINameBalloonTextFontColor()
{
    UIBalloonTextFontColor(table.UINameBalloonTextConstructor_ret, "UINameBalloonText");
    return true;
}

function ChangeUITransBalloonTextFontColor()
{
    UIBalloonTextFontColor(table.UITransBalloonTextConstructor_ret, "UITransBalloonText");
    return true;
}

function ChangeUIAchBalloonTextFontColor()
{
    UIBalloonTextFontColor(table.UIAchBalloonTextConstructor_ret, "UIAchBalloonText");
    return true;
}

function ChangeUICharInfoBalloonTextFontColor()
{
    UIBalloonTextFontColor(table.UICharInfoBalloonTextConstructor_ret, "UICharInfoBalloonText");
    return true;
}

function ChangeUIVerticalNameBalloonTextFontColor()
{
    UIBalloonTextFontColor(table.UIVerticalNameBalloonTextConstructor_ret, "UIVerticalNameBalloonText");
    return true;
}
