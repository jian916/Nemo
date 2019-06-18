function ChangeMaxPartyValue() {
	
	var code = " 68 9F 0C 00 00";
	var offset = exe.findCode(code, PTYPE_HEX, false);
	if (offset === -1)
		return "Failed in Step 1";
	
	code = " 6A 0C E8";
	offset = exe.find(code, PTYPE_HEX, false, "\xAB", offset, offset + 0x60);
	if (offset === -1)
		return "Failed in Step 2";
	
	var value = exe.getUserInput("$value", XTYPE_BYTE, "Max Party", "Set Max Party Value: (Max:127, Default:12)", "12", 1, 127);
	
	exe.replace(offset + 1, value.packToHex(1), PTYPE_HEX);
	
	
}