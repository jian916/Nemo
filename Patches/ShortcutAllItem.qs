//##########################################################
//# Purpose: Allow Shortcut place any item                 #
//##########################################################

function ShortcutAllItem() {
	//Step 1 - Find the item type table fetchers
	var code =
	    " 0F B6 80 AB AB AB 00"	//MOVZX EAX,BYTE PTR [EAX+offsetA]
	  + " FF 24 85 AB AB AB 00"	//JMP DWORD PTR [EAX*4+offsetB]
	  + " 83 BD AB AB AB AB 00"	//CMP DWORD PTR [EBP-x],00
	  ;

	var offsets = exe.findCodes(code, PTYPE_HEX, true, "\xAB");
	if (offsets.length === 0)
		return "Failed in Step 1 - Codes not found";

	//Step 2 - Remove the EAX*4 from JMP instruction
	var offset = 0;
	for (var i = 0; i < offsets.length; i++) {
		offset = offsets[i] + 7;
		code = "90 FF 25"		//NOP
								//JMP DWORD PTR [offsetB]

		exe.replace(offset, code, PTYPE_HEX);
	}

	return true;
}
