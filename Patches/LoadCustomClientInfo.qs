//################################################
//# Purpose: Change the clientinfo.xml reference #
//#          to custom file specified by user    #
//################################################

function LoadCustomClientInfo() {
	//Step 1a - Check if the client is Sakray (clientinfo file name is "sclientinfo.xml" for some Sakray clients)
	var ciName = "sclientinfo.xml";
	var offset = exe.findString(ciName, RVA);

	if (offset === -1) { // if sclientinfo.xml does not exist then it is a main server exe
		ciName = "clientinfo.xml";
		offset = exe.findString(ciName, RVA);
	}
	if (offset === -1)
		return "Failed in Step 1a - (s)clientinfo file name not found";

	//Step 1b - Find its reference
	var offset1 = exe.findCode(" F3 0F AB AB" + offset.packToHex(4),  PTYPE_HEX, true, "\xAB"); // MOVQ XMM0, clientinfo_xml
	if (offset1 === -1)
		return "Failed in Step 1b - clientinfo reference not found";

	if (ciName == "sclientinfo.xml") {
		var offset2 = exe.find(" F3 0F AB AB" + (offset + 8).packToHex(4),  PTYPE_HEX, true, "\xAB", offset1, offset1 + 0x20);
		if (offset2 === -1)
			return "Failed in Step 1c - clientinfo reference 2 not found";
	}
	else {
		var offset2 = exe.find(" A1" + (offset + 8).packToHex(4),  PTYPE_HEX, true, "\xAB", offset1 - 10, offset1);
		if (offset2 === -1)
			return "Failed in Step 1c - clientinfo reference 2 not found";

		var offset3 = exe.find(" 66 A1" + (offset + 0xC).packToHex(4),  PTYPE_HEX, true, "\xAB", offset1, offset1 + 0x10);
		if (offset3 === -1)
			return "Failed in Step 1c - clientinfo reference 3 not found";

		var offset4 = exe.find(" A0" + (offset + 0xE).packToHex(4),  PTYPE_HEX, true, "\xAB", offset1, offset1 + 0x20);
		if (offset4 === -1)
			return "Failed in Step 1c - clientinfo reference 4 not found";
	}

	//Step 2a - Get the new filename from user
	var myfile = exe.getUserInput("$newclientinfo", XTYPE_STRING, _("String input - maximum 14 characters"), _("Enter the new clientinfo path"), ciName, 9, 14);
	if (myfile === ciName)
		return "Patch Cancelled - New value is same as old";
	if (myfile.length > 14 || myfile.length < 9)
		return "Patch Cancelled - File name length should between 9 to 14 char";

	//Step 2b - Allocate space for the new name
	var free = exe.findZeros(myfile.length);
	if (free === -1)
		return "Failed in Step 2b - Not enough free space";

	//Step 3 - Insert the new name and replace the clientinfo reference
	exe.insert(free, myfile.length, "$newclientinfo", PTYPE_STRING);
	exe.replace(offset1+4, exe.Raw2Rva(free).packToHex(4), PTYPE_HEX);
	if (ciName == "sclientinfo.xml") {
		exe.replace(offset2+4, exe.Raw2Rva(free+8).packToHex(4), PTYPE_HEX);
	}
	else {
		exe.replace(offset2+1, exe.Raw2Rva(free+8).packToHex(4), PTYPE_HEX);
		exe.replace(offset3+2, exe.Raw2Rva(free+0xC).packToHex(4), PTYPE_HEX);
		exe.replace(offset4+1, exe.Raw2Rva(free+0xE).packToHex(4), PTYPE_HEX);
	}

	return true;
}

//=================================//
// Disable for Unsupported clients //
//=================================//
function LoadCustomClientInfo_() {
	return (exe.findString("sclientinfo.xml", RAW) !== -1 || exe.findString("clientinfo.xml", RAW) !== -1);
}
