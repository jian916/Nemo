//
// Copyright (C) 2018  CH.C
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
//===================================================//
// Patch Functions wrapping over Set Button function //
//===================================================//

function NavigationButton()
{
    return ButtonNew(0x197 + 5, exe.getUserInput("$navi", XTYPE_BYTE, _("Set Button"), _("Set Button Hide(0) or Show(1)"), 0, 0, 1));
}

function BankButton()
{
    return ButtonNew(0x1B6 + 5, exe.getUserInput("$bank", XTYPE_BYTE, _("Set Button"), _("Set Button Hide(0) or Show(1)"), 0, 0, 1));
}

function ReplayButton()
{
    return ButtonNew(0x178 + 5, exe.getUserInput("$replay", XTYPE_BYTE, _("Set Button"), _("Set Button Hide(0) or Show(1)"), 0, 0, 1));
}

function MailButton()
{
    return ButtonNew(0x1C5 + 5, exe.getUserInput("$mail", XTYPE_BYTE, _("Set Button"), _("Set Button Hide(0) or Show(1)"), 0, 0, 1));
}

function AchievementButton()
{
    return ButtonNew(0x1C2 + 5, exe.getUserInput("$achievement", XTYPE_BYTE, _("Set Button"), _("Set Button Hide(0) or Show(1)"), 0, 0, 1));
}

function TipButton()
{
    return ButtonNew(0x1E8 + 5, exe.getUserInput("$tip", XTYPE_BYTE, _("Set Button"), _("Set Button Hide(0) or Show(1)"), 0, 0, 1));
}

function ShopButton()
{
    return ButtonNew(0x1E9 + 5, exe.getUserInput("$shop", XTYPE_BYTE, _("Set Button"), _("Set Button Hide(0) or Show(1)"), 0, 0, 1));
}

function SNSButton()
{
    return ButtonNew(0x1EF + 5, exe.getUserInput("$sns", XTYPE_BYTE, _("Set Button"), _("Set Button Hide(0) or Show(1)"), 0, 0, 1));
}

function AttendanceButton()
{
    return ButtonNew(0x205 + 5, exe.getUserInput("$attendance", XTYPE_BYTE, _("Set Button"), _("Set Button Hide(0) or Show(1)"), 0, 0, 1));
}

function BookingButton()
{
    return ButtonNew(0x169, exe.getUserInput("$booking", XTYPE_BYTE, _("Set Button"), _("Set Button Hide(0) or Show(1)"), 0, 0, 1));
}

function AdventurerAgencyButton()
{
    return ButtonNew(0x20E, exe.getUserInput("$adventurerAgency", XTYPE_BYTE, _("Set Button"), _("Set Button Hide(0) or Show(1)"), 0, 0, 1));
}


//##########################################################
//# Purpose: Find the button display table and set bool    #
//#          value for each button                         #
//##########################################################

function ButtonNew(buttonId, value)
{
    consoleLog("Step 1 - Find address of reference string");
    var offset = exe.findString("adventurerAgency", RAW);
    if (offset === -1)
        throw "Failed in Step 1 - String not found";

    consoleLog("Step 2 - Find the string reference");
    offset = exe.findCode("68" + exe.Raw2Rva(offset).packToHex(4), PTYPE_HEX, false);
    if (offset === -1)
        throw "Failed in Step 2 - String reference missing";

    consoleLog("Step 3 - Find and extract address of button display table");
    var code =
        "0F B6 80 AB AB AB AB " +     // 0 movzx eax, ds:byte_592124[eax]
        "FF 24 85 ";                  // 7 jmp ds:off_59211C[eax*4]
    var switchTblOffset = 3;
    offset = exe.find(code, PTYPE_HEX, true, "\xAB", offset, offset + 0xA0);

    if (offset === -1)
        throw "Failed in Step 3 - Button display table not found";

    var switchTbl = exe.Rva2Raw(exe.fetchDWord(offset + switchTblOffset));

    consoleLog("Step 4 - Set bool value for button");
    var valueOffset = switchTbl + buttonId - 0x169;

    var oldValue = exe.fetchByte(valueOffset);
    if (valueOffset < switchTbl)
    {
        throw "Failed in Step 4 - button switch pointer before switch table start";
    }
    if (oldValue !== 0 && oldValue !== 1)
    {
        throw "Failed in Step 4 - default button show value: " + oldValue;
    }

    // 0x169 is id for booking. should be set to switchTbl offset
    exe.replaceByte(valueOffset, value);

    return true;
}

//=======================================================================//
// Disable for Unsupported Clients - Check for string "adventurerAgency" //
//=======================================================================//

function NavigationButton_()
{
    return (exe.findString("adventurerAgency") !== -1);
}

function BankButton_()
{
    return (exe.findString("adventurerAgency") !== -1);
}

function ReplayButton_()
{
    return (exe.findString("adventurerAgency") !== -1);
}

function MailButton_()
{
    return (exe.findString("adventurerAgency") !== -1);
}

function AchievementButton_()
{
    return (exe.findString("adventurerAgency") !== -1);
}

function TipButton_()
{
    return (exe.findString("adventurerAgency") !== -1);
}

function ShopButton_()
{
    return (exe.findString("adventurerAgency") !== -1);
}

function SNSButton_()
{
    return (exe.findString("adventurerAgency") !== -1);
}

function AttendanceButton_()
{
    return (exe.findString("adventurerAgency") !== -1);
}

function BookingButton_()
{
    return (exe.findString("adventurerAgency") !== -1);
}

function AdventurerAgencyButton_()
{
    return (exe.findString("adventurerAgency") !== -1);
}
