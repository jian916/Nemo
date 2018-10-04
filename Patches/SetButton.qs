//===================================================//
// Patch Functions wrapping over SetButton function  //
//===================================================//

function SetButtonBooking() {
	if(Use18Icons()) {
		return "Failed in Patch - 2018 was disabled";
	}
	else if(Use17Icons()) {
		if(ReplaceHex(" C7 45 B0 63 01 00 00", "F0 01", 3)) return true;
		return Hide17Button("equip", "booking");
	}
	else if(Use14Icons() || FindOldRes("booking")) {
		return ReplaceString(
			["basic_interface\\booking", "RO_menu_icon\\booking"],
			["\x00", "\x00"]
		);
	}
	return "Failed in Patch - NO resource found";
}

function SetButtonBg() {
	if(Use18Icons()) {
		return Hide17Button("equip", "battle");
	}
	else if(Use17Icons()) {
		if(ReplaceHex(" C7 45 BC 60 01 00 00", "F0 01", 3)) return true;
		if(ReplaceHex(" C7 45 B8 61 01 00 00", "06 02", 3)) return true;
		return Hide17Button("equip", "battle");
	}
	else if(Use14Icons() || FindOldRes("btn_battle_field")) {
		return ReplaceString(
			["basic_interface\\btn_battle_field", "RO_menu_icon\\battle"],
			["\x00", "\x00"]
		);
	}
	return "Failed in Patch - NO resource found";
}

function SetButtonQuest() {
	if(Use18Icons()) {
		return Hide17Button("equip", "quest");
	}
	else if(Use17Icons()) {
		if(ReplaceHex(" C7 45 C0 51 01 00 00", "F0 01", 3)) return true;
		if(ReplaceHex(" C7 45 BC 52 01 00 00", "06 02", 3)) return true;
		return Hide17Button("equip", "quest");
	}
	else if(Use14Icons()) {
		if(ReplaceString("RO_menu_icon\\quest","\x00")) return true;
		return Hide17Button("info", "quest");
	}
	else if(FindOldRes("quest_%d.bmp")) {
		return ReplaceString("basic_interface\\quest_%d.bmp","\x00"); // not effect
	}
	return "Failed in Patch - NO resource found";
}

function SetButtonMap() {
	if(Use18Icons()) {
		return Hide17Button("equip", "map");
	}
	else if(Use17Icons()) {
		return Hide17Button("equip", "map");
	}
	else if(Use14Icons() || (exe.findString("map", RAW) !== -1)) {
		return ReplaceString("map","\x00"); // not effect
	}
	return "Failed in Patch - NO resource found";
}

function SetButtonNav() {
	if(Use18Icons()) {
		return Hide18Button("0x197", exe.getUserInput("$navi", XTYPE_BYTE, "Set Button", "設定按鈕: 隱藏(0) 或 顯示(1)", 0, 0, 1));
	}
	else if(Use17Icons()) {
		if(ReplaceHex(" C7 45 C8 96 01 00 00", "F0 01", 3)) return true;
		if(ReplaceHex(" C7 45 C4 97 01 00 00", "06 02", 3)) return true;
		return Hide17Button("equip", "navigation");
	}
	else if(Use14Icons() || (exe.findString("navigation_interface\\btn_Navigation", RAW, false) !== -1)) {
		return ReplaceString(
			["navigation_interface\\btn_Navigation", "RO_menu_icon\\navigation"],
			["\x00", "\x00"]
		);
	}
	return "Failed in Patch - NO resource found";
}

function SetButtonBank() {
	if(Use18Icons()) {
		return Hide18Button("0x1B6", exe.getUserInput("$bank", XTYPE_BYTE, "Set Button", "設定按鈕: 隱藏(0) 或 顯示(1)", 0, 0, 1));
	}
	else if(Use17Icons()) {
		if(ReplaceHex(" C7 45 D0 B5 01 00 00", "F0 01", 3)) return true;
		if(ReplaceHex(" C7 45 CC B6 01 00 00", "06 02", 3)) return true;
		return Hide17Button("equip", "bank");
	}
	else if(Use14Icons() || FindOldRes("btn_bank")) {
		return ReplaceString(
			["basic_interface\\btn_bank", "RO_menu_icon\\bank"],
			["\x00", "\x00"]
		);
	}
	return "Failed in Patch - NO resource found";
}

function SetButtonRec() {
	if(Use18Icons()) {
		return Hide18Button("0x178", exe.getUserInput("$replay", XTYPE_BYTE, "Set Button", "設定按鈕: 隱藏(0) 或 顯示(1)", 0, 0, 1));
	}
	else if(Use17Icons()) {
		if(ReplaceHex(" C7 45 D4 77 01 00 00", "F0 01", 3)) return true;
		if(ReplaceHex(" C7 45 D0 78 01 00 00", "06 02", 3)) return true;
		return Hide17Button("equip", "rec");
	}
	else if(Use14Icons() || (exe.findString("replay_interface\\rec", RAW, false) !== -1)) {
		return ReplaceString(
			["replay_interface\\rec", "RO_menu_icon\\rec"],
			["\x00", "\x00"]
		);
	}
	return "Failed in Patch - NO resource found";
}

function SetButtonMail() {
	if(Use18Icons()) {
		return Hide18Button("0x1C5", exe.getUserInput("$mail", XTYPE_BYTE, "Set Button", "設定按鈕: 隱藏(0) 或 顯示(1)", 0, 0, 1));
	}
	else if(Use17Icons()) {
		if(ReplaceHex(" C7 45 D8 C4 01 00 00", "F0 01", 3)) return true;
		if(ReplaceHex(" C7 45 D4 C5 01 00 00", "06 02", 3)) return true;
		return Hide17Button("equip", "mail");
	}
	else if(Use14Icons()) {
		return ReplaceString(
			"RO_menu_icon\\mail", "\x00"
		);
	}
	return "Failed in Patch - NO resource found";
}

function SetButtonAchieve() {
	if(Use18Icons()) {
		return Hide18Button("0x1C2", exe.getUserInput("$achievement", XTYPE_BYTE, "Set Button", "設定按鈕: 隱藏(0) 或 顯示(1)", 0, 0, 1));
	}
	else if(Use17Icons()) {
		if(ReplaceHex(" C7 45 DC C1 01 00 00", "F0 01", 3)) return true;
		if(ReplaceHex(" C7 45 D8 C2 01 00 00", "06 02", 3)) return true;
		return Hide17Button("equip", "achievement");
	}
	else if(Use14Icons()) {
		return ReplaceString(
			"RO_menu_icon\\achievement", "\x00"
		);
	}
	return "Failed in Patch - NO resource found";
}

function SetButtonTip() {
	if(Use18Icons()) {
		return Hide18Button("0x1E8", exe.getUserInput("$tip", XTYPE_BYTE, "Set Button", "設定按鈕: 隱藏(0) 或 顯示(1)", 0, 0, 1));
	}
	else if(Use17Icons()) {
		if(ReplaceHex(" C7 45 E0 E8 01 00 00", "F0 01", 3)) return true;
		if(ReplaceHex(" C7 45 DC E8 01 00 00", "06 02", 3)) return true;
		return Hide17Button("equip", "tip");
	}
	else if(Use14Icons()) {
		return "Failed in Patch - 2014 not had";
	}
	return "Failed in Patch - NO resource found";
}

function SetButtonAttend() {
	if(Use18Icons()) {
		return Hide18Button("0x205", exe.getUserInput("$attendance", XTYPE_BYTE, "Set Button", "設定按鈕: 隱藏(0) 或 顯示(1)", 0, 0, 1));
	}
	else if(Use17Icons()) {
		if(ReplaceHex(" C7 45 EC 05 02 00 00", "06 02", 3)) return true;
		return Hide17Button("equip", "attendance");
	}
	else if(Use14Icons()) {
		return "Failed in Patch - 2014 not had";
	}
	return "Failed in Patch - NO resource found";
}

function SetButtonSNS() {
	if(Use18Icons()) {
		return Hide18Button("0x1EF", exe.getUserInput("$sns", XTYPE_BYTE, "Set Button", "設定按鈕: 隱藏(0) 或 顯示(1)", 0, 0, 1));
	}
	else if(Use17Icons()) {
		if(ReplaceHex(" C7 45 EC EF 01 00 00", "F0 01", 3)) return true;
		if(ReplaceHex(" C7 45 E8 EF 01 00 00", "06 02", 3)) return true;
		return Hide17Button("equip", "sns");
	}
	else if(Use14Icons()) {
		return Hide17Button("info", "sns");
	}
	return "Failed in Patch - NO resource found";
}

function SetButtonCashShop() {
	if(Use18Icons()) {
		return Hide18Button("0x1E9", exe.getUserInput("$shop", XTYPE_BYTE, "Set Button", "設定按鈕: 隱藏(0) 或 顯示(1)", 1, 0, 1));
	}
	else if(Use17Icons()) {
		return Hide17Button("equip", "shop");
	}
	else if(Use14Icons()) {
		return "Failed in Patch - 2014 not had";
	}
	return "Failed in Patch - NO resource found";
}

//##########################################################
//# Purpose: Find the first match amongst the src prefixes #
//#          and replace it with corresponding tgt prefix  #
//##########################################################
function ReplaceString(src, tgt) {
	//Step 1a - Ensure both are lists/arrays
	if (typeof(src) === "string")
		src = [src];

	if (typeof(tgt) === "string")
		tgt = [tgt];

	//Step 1b - Loop through and find first match
	var offset = -1;
	for (var i = 0; i < src.length; i++) {
		offset = exe.findString(src[i], RAW, false);
		if (offset !== -1)
			break;
	}

	if (offset === -1)
		return false;

	//Step 2 - Replace with corresponding value in tgt
	exe.replace(offset, tgt[i], PTYPE_STRING);

	return true;
}

function ReplaceHex(src, tgt, rpc_offset) {
	var offset = exe.findCode(src, PTYPE_HEX, false);
	if (offset === -1)
		return false;

	exe.replace(offset + rpc_offset, tgt, PTYPE_HEX);

	return true;
}

//#######################################################################
//# Purpose: Find the prefix assignment inside UIBasicWnd::OnCreate and #
//#          assign address of NULL after the prefix instead            #
//#######################################################################
function Hide17Button(reference, prefix) {
	//Step 1a - Find the address of the reference prefix "info" (needed since some prefixes are matching multiple areas)
	var refAddr = exe.findString(reference, RVA);
	if (refAddr === -1)
		return "Failed in Step 1 - info missing";

	//Step 1b - Find the address of the string
	var strAddr = exe.findString(prefix, RVA);
	if (strAddr === -1)
		return "Failed in Step 1 - Prefix missing";

	//Step 2a - Find assignment of "info" inside UIBasicWnd::OnCreate
	var suffix = " C7";
	var offset = exe.findCode(refAddr.packToHex(4) + suffix, PTYPE_HEX, false);

	if (offset === -1) {
		suffix = " 8D";
		offset = exe.findCode(refAddr.packToHex(4) + suffix, PTYPE_HEX, false);
	}

	if (offset === -1)
		return "Failed in Step 2 - info assignment missing";

	//Step 2b - Find the assignment of prefix after "info" assignment
	offset = exe.find(strAddr.packToHex(4) + suffix, PTYPE_HEX, false, "", offset + 5, offset + 0x500);
	if (offset === -1)
		return "Failed in Step 2 - Prefix assignment missing";

	//Step 2c - Update the address to point to NULL
	exe.replaceDWord(offset, strAddr + prefix.length);

	return true;
}

function Hide18Button(tbloffset, value) {
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

//#######################################################################
//# Purpose: Determine whether this client uses new menu icons          #
//#######################################################################

// 20141020 <= Use14Icons < 20170410
function Use14Icons() {
	return (exe.findString("\xC0\xAF\xC0\xFA\xC0\xCE\xC5\xCD\xC6\xE4\xC0\xCC\xBD\xBA\\RO_menu_icon\\btn_hide", RAW, false) !== -1);
}

// 20170410 <= Use17Icons < 20180416
function Use17Icons() {
	return (exe.findString("\xC0\xAF\xC0\xFA\xC0\xCE\xC5\xCD\xC6\xE4\xC0\xCC\xBD\xBA\\menu_icon\\bt_%s.bmp", RAW, false) !== -1);
}

// 20180416 <= Use18Icons < now
function Use18Icons() {
	return (exe.findString("adventurerAgency", RAW, false) !== -1 && Use17Icons());
}

function FindOldRes(name) {
	return (exe.findString("\xC0\xAF\xC0\xFA\xC0\xCE\xC5\xCD\xC6\xE4\xC0\xCC\xBD\xBA\\basic_interface\\"+name, RAW, false) !== -1);
}

function Find14Res(name) {
	return ((exe.findString("\xC0\xAF\xC0\xFA\xC0\xCE\xC5\xCD\xC6\xE4\xC0\xCC\xBD\xBA\\RO_menu_icon\\"+name, RAW, false) !== -1) /*|| (exe.findString(name, RAW) !== -1)*/);
}

function Find17Res(name) {
	return (Use17Icons() && (exe.findString(name, RAW) !== -1));
}

//========================================================//
// Disable for Unsupported Clients                        //
//========================================================//

function SetButtonBooking_() {
	return ((FindOldRes("booking") || Find14Res("booking") || Find17Res("booking")) && !Use18Icons()); // 17 disabled
}

function SetButtonBg_() {
	return (FindOldRes("btn_battle_field") || Find14Res("battle") || Find17Res("battle"));
}

function SetButtonQuest_() {
	return (FindOldRes("quest_%d.bmp") || Find14Res("quest") || Find17Res("quest"));
}

function SetButtonMap_() {
	return ((exe.findString("map", RAW) !== -1) || Find14Res("map") || Find17Res("map"));
}

function SetButtonNav_() {
	return ((exe.findString("navigation_interface\\btn_Navigation", RAW, false) !== -1) || Find14Res("navigation") || Find17Res("navigation"));
}

function SetButtonBank_() {
	return (FindOldRes("btn_bank") || Find14Res("bank") || Find17Res("bank"));
}

function SetButtonRec_() {
	return ((exe.findString("replay_interface\\rec", RAW, false) !== -1) || Find14Res("rec") || Find17Res("rec"));
}

function SetButtonMail_() {
	return (Find14Res("mail") || Find17Res("mail"));
}

function SetButtonAchieve_() {
	return (Find14Res("achievement") || Find17Res("achievement"));
}

function SetButtonTip_() {
	return (/*Find14Res("tip") || */Find17Res("tip")); // 17 only
}

function SetButtonAttend_() {
	return (/*Find14Res("attendance") || */Find17Res("attendance")); // 17 only
}

function SetButtonSNS_() {
	return (/*Find14Res("sns") || */Find17Res("sns")); // 17 only
}

function SetButtonCashShop_() {
	return (/*Find14Res("shop") || */Find17Res("shop")); // 17 only
}
