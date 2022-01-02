//##############################################################################
//# Purpose: Switch "Ragnarok" reference with address of User specified Window #
//#          Title which will be that of unused URL string that is overwritten #
//##############################################################################

function CustomWindowTitle()
{
	if(getActivePatches().indexOf(500) !== -1)
		return "補丁取消 - 修改 HEX版 的標題，就不能再使用 英文版 標題";

    consoleLog("Search old title");
    if (IsZero())
    {
        var oldTitle = "Ragnarok : Zero";
        var titleOffset = pe.stringVa(oldTitle);
        if (titleOffset === -1)
        {
            oldTitle = "Ragnarok";
            titleOffset = pe.stringVa(oldTitle);
        }
    }
    else
    {
        var oldTitle = "Ragnarok";
        var titleOffset = pe.stringVa(oldTitle);
    }
    if (titleOffset === -1)
        return "Old title not found";

    consoleLog("Request new title");
    var title = exe.getUserInput("$customWindowTitle", XTYPE_STRING, _("String Input - maximum 200 characters"), _("Enter the new window Title"), oldTitle, 1, 200);
    if (title.trim() === oldTitle)
        return "Patch Cancelled - New Title is same as old";

    consoleLog("Store new title");
    var newTitle = exe.findZeros(title.length);
    if (newTitle === -1)
        return "Not enough free space";

    exe.insert(newTitle, title.length, title, PTYPE_STRING);

    consoleLog("Search title usage");
    var code = " C7 05 ?? ?? ?? 00" + titleOffset.packToHex(4); //MOV DWORD PTR DS:[g_title], OFFSET addr; ASCII "Ragnarok"
    var offset = pe.findCode(code);
    if (offset === -1)
        return "Failed in Step 2";

    consoleLog("Update title address");
    pe.replaceDWord(offset + code.hexlength() - 4, pe.rawToVa(newTitle));

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
