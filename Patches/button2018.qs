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


function NavigationButton() {
		return ButtonNew("0x197", exe.getUserInput("$navi", XTYPE_BYTE, "Set Button", "Set Button Hide(0) or Show(1)", 0, 0, 1));
}

function BankButton() {
		return ButtonNew("0x1B6", exe.getUserInput("$bank", XTYPE_BYTE, "Set Button", "Set Button Hide(0) or Show(1)", 0, 0, 1));
}

function ReplayButton() {
		return ButtonNew("0x178", exe.getUserInput("$replay", XTYPE_BYTE, "Set Button", "Set Button Hide(0) or Show(1)", 0, 0, 1));
}

function MailButton() {
		return ButtonNew("0x1C5", exe.getUserInput("$mail", XTYPE_BYTE, "Set Button", "Set Button Hide(0) or Show(1)", 0, 0, 1));
}

function AchievementButton() {
		return ButtonNew("0x1C2", exe.getUserInput("$achievement", XTYPE_BYTE, "Set Button", "Set Button Hide(0) or Show(1)", 0, 0, 1));
}

function TipButton() {
		return ButtonNew("0x1E8", exe.getUserInput("$tip", XTYPE_BYTE, "Set Button", "Set Button Hide(0) or Show(1)", 0, 0, 1));
}

function ShopButton() {
		return ButtonNew("0x1E9", exe.getUserInput("$shop", XTYPE_BYTE, "Set Button", "Set Button Hide(0) or Show(1)", 0, 0, 1));
}

function SNSButton() {
		return ButtonNew("0x1EF", exe.getUserInput("$sns", XTYPE_BYTE, "Set Button", "Set Button Hide(0) or Show(1)", 0, 0, 1));
}

function AttendanceButton() {
		return ButtonNew("0x205", exe.getUserInput("$attendance", XTYPE_BYTE, "Set Button", "Set Button Hide(0) or Show(1)", 0, 0, 1));
}


//##########################################################
//# Purpose: Find the button display table and set bool    #
//#          value for each button                         #
//##########################################################

function ButtonNew(tbloffset, value) {
	//Step 1 - Find address of reference string
	var offset = exe.findString("adventurerAgency", RAW);
	if (offset === -1)
		return "Failed in Step 1 - String not found";
		
	//Step 2 - Find the string reference
	offset = exe.findCode("68" + exe.Raw2Rva(offset).packToHex(4), PTYPE_HEX, false);
	if (offset === -1)
		return "Failed in Step 2 - String reference missing";
	
	//Step 3 - Find and extract address of button display table
	var code = 
	    " 0F B6 80 AB AB AB AB"	//MOVZX EAX,BYTE PTR [EAX+offset]
	  + " FF 24 85 AB AB AB AB"	//JMP DWORD PTR [EAX*4+offset2]
	  ;
	
	offset = exe.find(code, PTYPE_HEX, true, "\xAB", offset, offset + 0xA0);
	if (offset === -1)
		return "Failed in Step 3 - Button display table not found";
	
	offset = offset + 3;
	var tbl = exe.fetchDWord(offset);
	tbl = exe.Rva2Raw(tbl);
	
	//Step 4 - Set bool value for button
	exe.replace((tbloffset - 0x164 + tbl), value, PTYPE_HEX);
	
	return true;
}

//=======================================================================//
// Disable for Unsupported Clients - Check for string "adventurerAgency" //
//=======================================================================//

function NavigationButton_() {
	return (exe.findString("adventurerAgency") !== -1);
}

function BankButton_() {
	return (exe.findString("adventurerAgency") !== -1);
}

function ReplayButton_() {
	return (exe.findString("adventurerAgency") !== -1);
}

function MailButton_() {
	return (exe.findString("adventurerAgency") !== -1);
}

function AchievementButton_() {
	return (exe.findString("adventurerAgency") !== -1);
}

function TipButton_() {
	return (exe.findString("adventurerAgency") !== -1);
}

function ShopButton_() {
	return (exe.findString("adventurerAgency") !== -1);
}

function SNSButton_() {
	return (exe.findString("adventurerAgency") !== -1);
}

function AttendanceButton_() {
	return (exe.findString("adventurerAgency") !== -1);
}
