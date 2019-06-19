
function ForceLubStateIcon() {
	var offset = exe.findString("GetEFSTImgFileName", RVA, true);
	if (offset === -1)
		return "Failed in Step 1 - Reference String Missing";

	offset = exe.findCode("68"+ offset.packToHex(4), PTYPE_HEX, false);
	if (offset === -1)
		return "Failed in Step 2";

	var code =
	    " 83 FB 04"					//CMP EBX, 04
	  + " 0F 87 AB AB AB AB"		//JA short
	  + " FF 24 9D AB AB AB AB"		//JMP DWORD PTR [EBX*4+addr]
	  ;

	offset = exe.find(code, PTYPE_HEX, true, "\xAB", offset, offset + 0x80);
	if (offset === -1)
		return "Failed in Step 3";

	exe.replace(offset+3, " 90 E9", PTYPE_HEX);
}
