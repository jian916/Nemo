
function MvpItemIdenfifyName() {
	
	var code = 
	    " 6A 00"
	  + " 6A 00"
	  + " 6A 00"
	  + " 6A 00"
	  + " 6A 03"
	  + " B9 AB AB AB 00"
	  + " C7 85 AB FF FF FF 00 00 00 00"
	  + " C6 85 AB FF FF FF 00"
	  ;
	
	var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
	if (offset === -1)
		return "Failed in Step 1";
	
	offset += code.hexlength();
	
	exe.replace(offset - 1, "01", PTYPE_HEX);
	
	return true;
}


