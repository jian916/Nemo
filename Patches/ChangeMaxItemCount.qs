//=============================================================//
// Patch Functions wrapping over ChangeMaxItemCount function   //
//=============================================================//

function SetMaxItemCount() {
	return ChangeMaxItemCount(exe.getUserInput("$MaxItemCount", XTYPE_STRING, "輸入數字", "輸入道具持有種類數顯示上限 (0-999)", 100, 0, 3));
}

//####################################################################################
//# Purpose: Find the max item count display and replace it with the value specified #
//####################################################################################

function ChangeMaxItemCount(value) {
	//Step 1a - Prep String
	var newString = "/" + value;

	//Step 1b - Allocate space for New Format String.
	var free = exe.findZeros(newString.length);
	if (free === -1)
		return "Failed in Step 1 - Not enough free space";

	//Step 1c - Insert the new format string
	exe.insert(free, newString.length, newString, PTYPE_STRING);

	//Step 2 - Find the max item count.
	var code =
	  " 6A 64"          //PUSH 64h
	+ " 8D 45 AB"       //LEA EAX, [EBP+Z]
	+ " 68 AB AB AB 00" //PUSH offset "/%d"
	;
	var offsets = exe.findAll(code, PTYPE_HEX, true, "\xAB");
	if (offsets.length === 0)
		return "Failed in Step 2 - function missing";

	//Step 3 - Replace with new one's address
	for (var i = 0; i < offsets.length; i++){
		var offset2 = offsets[i] + code.hexlength();
		exe.replace(offset2 - 4, exe.Raw2Rva(free).packToHex(4), PTYPE_HEX);
	}

	return true;
}

//=======================================================================//
// Disable for Unsupported Clients - Check for string "icon_num.bmp"     //
//=======================================================================//

function SetMaxItemCount_() {
	return (exe.findString("icon_num.bmp", RAW, false) !== -1);
}
