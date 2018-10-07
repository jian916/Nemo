//##############################################################################
//# Purpose: Switch "Ragnarok" reference with address of User specified Window #
//#          Title                                                             #
//##############################################################################

function CustomWindowTitle() {
	if(getActivePatches().indexOf(306) !== -1)
		return "�ɤB���� - �ק� HEX�� �����D�A�N����A�ϥ� �^�媩 ���D";

	//Step 1a - Find offset of 'Ragnarok'
	var code = " C7 05 AB AB AB 00" + exe.findString("Ragnarok", RVA).packToHex(4);//MOV DWORD PTR DS:[g_title], OFFSET addr; ASCII "Ragnarok"

	//Step 1b - Find its reference
	var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
	if( offset === -1)
		return "Failed in Step 1";

	//Step 2 - Get the new Title from User
	var title = exe.getUserInput("$customWindowTitle", XTYPE_STRING, "��J��r - �̦h�i��J 100 �Ӧr��", "��J�s���������D (Window Title)", "Ragnarok", 1, 100).trim();
	if (title === "Ragnarok")
		return "�ɤB���� - �s���]�w���ª��]�w�ۦP";

	var free = exe.findZeros(title.length);
	if (free === -1)
		return "Failed in Step 2 - Not enough free space";

	exe.insert(free, title.length, "$customWindowTitle", PTYPE_STRING);
	exe.replace(offset + code.hexlength() - 4, exe.Raw2Rva(free).packToHex(4), PTYPE_HEX);

	return true;
}

function CustomWindowTitleHex() {
	if(getActivePatches().indexOf(8) !== -1)
		return "�ɤB���� - �ק� �^�媩 �����D�A�N����A�ϥ� HEX�� ���D";

	//Step 1a - Find offset of 'Ragnarok'
	var code = " C7 05 AB AB AB 00" + exe.findString("Ragnarok", RVA).packToHex(4);//MOV DWORD PTR DS:[g_title], OFFSET addr; ASCII "Ragnarok"

	//Step 1b - Find its reference
	var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
	if( offset === -1)
		return "Failed in Step 1";

	//Step 1b - Get the new Title from User
	var title = exe.getUserInput("$customWindowTitleHex", XTYPE_STRING, "��J��r - �̦h�i��J 100 �Ӧr��", "��J�s���������D (Window Title) Hex �s�X�A�w�]��: 52 61 67 6E 61 72 6F 6B (Ragnarok)", "52 61 67 6E 61 72 6F 6B", 1, 300);
	if (title.trim() === "52 61 67 6E 61 72 6F 6B")
		return "�ɤB���� - �s���]�w���ª��]�w�ۦP";

	var free = exe.findZeros(title.hexlength() + 1);
	if (free === -1)
		return "Failed in Step 2 - Not enough free space";

	exe.insert(free, title.hexlength() + 1, title + " 00", PTYPE_HEX);
	exe.replace(offset + code.hexlength() - 4, exe.Raw2Rva(free).packToHex(4), PTYPE_HEX);

	return true;
}
