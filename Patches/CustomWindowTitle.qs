//##############################################################################
//# Purpose: Switch "Ragnarok" reference with address of User specified Window #
//#          Title which will be that of unused URL string that is overwritten #
//##############################################################################

function CustomWindowTitle()
{
	if(getActivePatches().indexOf(400) !== -1)
		return "補丁取消 - 修改 HEX版 的標題，就不能再使用 英文版 標題";

    //Step 1a - Find the offset of the URL to overwrite
    var strOff = exe.findString("http://ro.hangame.com/login/loginstep.asp?prevURL=/NHNCommon/NHN/Memberjoin.asp", RAW);
    if (strOff === -1)
        return "Failed in Step 1";

    //Step 1b - Get the new Title of 'Ragnarok' or 'Ragnarok : Zero' from User
    var getUserInput = "Ragnarok";
        if (IsZero())
        getUserInput = "Ragnarok : Zero";

    var title = exe.getUserInput("$customWindowTitle", XTYPE_STRING, _("String Input - maximum 60 characters"), _("Enter the new window Title"), getUserInput, 1, 60);
    if (title.trim() === getUserInput)
        return "Patch Cancelled - New Title is same as old";

    //Step 1c - Overwrite URL with the new Title
    exe.replace(strOff, "$customWindowTitle", PTYPE_STRING);

    //Step 2a - Find offset of of 'Ragnarok' or 'Ragnarok : Zero'
    var code = " C7 05 AB AB AB 00" + exe.findString("Ragnarok", RVA).packToHex(4); //MOV DWORD PTR DS:[g_title], OFFSET addr; ASCII "Ragnarok"
    if (IsZero())
        code = " C7 05 AB AB AB 00" + exe.findString("Ragnarok : Zero", RVA).packToHex(4); //MOV DWORD PTR DS:[g_title], OFFSET addr; ASCII "Ragnarok : Zero"

    //Step 2b - Find its reference
    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    if ( offset === -1)
        return "Failed in Step 2";

    //Step 3 - Replace the original reference with the URL offset.
    exe.replaceDWord(offset + code.hexlength() - 4, exe.Raw2Rva(strOff));

    return true;
}

function CustomWindowTitleHex() {
	if(getActivePatches().indexOf(8) !== -1)
		return "補丁取消 - 修改 英文版 的標題，就不能再使用 HEX版 標題";

	//Step 1a - Find offset of 'Ragnarok'
	var code = " C7 05 AB AB AB 00" + exe.findString("Ragnarok", RVA).packToHex(4);//MOV DWORD PTR DS:[g_title], OFFSET addr; ASCII "Ragnarok"

	//Step 1b - Find its reference
	var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
	if( offset === -1)
		return "Failed in Step 1";

	//Step 1b - Get the new Title from User
	var title = exe.getUserInput("$customWindowTitleHex", XTYPE_STRING, "輸入文字 - 最多可輸入 100 個字元", "輸入新的視窗標題 (Window Title) Hex 編碼，預設為: 52 61 67 6E 61 72 6F 6B (Ragnarok)", "52 61 67 6E 61 72 6F 6B", 1, 300);
	if (title.trim() === "52 61 67 6E 61 72 6F 6B")
		return "補丁取消 - 新的設定跟舊的設定相同";

	var free = exe.findZeros(title.hexlength() + 1);
	if (free === -1)
		return "Failed in Step 2 - Not enough free space";

	exe.insert(free, title.hexlength() + 1, title + " 00", PTYPE_HEX);
	exe.replace(offset + code.hexlength() - 4, exe.Raw2Rva(free).packToHex(4), PTYPE_HEX);

	return true;
}
