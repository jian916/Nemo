//
// Copyright (C) 2020  CH.C
//
// Hercules is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
//####################################################
//# Purpose: Use correct charset for Official Custom #
//#          Fonts on all LangType                   #
//####################################################

function FixCharsetForFonts() {
	//Find the code inside DrawDC::SetFont function
	var code = 
	  " 85 FF"             //TEST EDI,EDI
	+ " 75 0A"             //JNE 0A
	+ " A1 AB AB AB AB"    //MOV EAX,g_fontCharSet
	+ " 83 FA 14"          //CMP EDX,14
	+ " 7D 07"             //JNL 07
	;
	
	var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
	
	if (offset === -1) //Old Clients
	{
		code =
		  " 85 FF"               //TEST EDI,EDI
		+ " 0F 85 AB 00 00 00"   //JNZ short
		+ " 83 FA 14"            //CMP EDX,14
		+ " 0F 8C AB 00 00 00"   //JL short
		+ " 89 56 AB"            //MOV [ESI+x],EDX
		+ " 89 4E AB"            //MOV [ESI+y],ECX
		;
		
		offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
		if (offset === -1)
			return "Failed in Step 1";
		
		var oldclient = true;
	}
	else {
		var oldclient = false;
	}
	
	//fetch address of g_fontCharSet
	if(oldclient)
	{
		offset += code.hexlength();
		var cTable = exe.fetchHex(offset+1,4);
		
	}
	else{
		
		var cTable = exe.fetchHex(offset+5,4);
		
	}
	//Find the patch point, should be MOV EAX,[EDX*4+g_fontCharSet]
	offset = exe.findCode(" 8B 04 95" + cTable, PTYPE_HEX, false);
		
	if (offset === -1)
		return "Failed in Step 1b";
		
	var retAdd = offset+ 7;
	
	//Get ServiceType (LangType)
	var LANGTYPE = GetLangType();
	if (LANGTYPE.length === 1)
		return "Failed in Step 2 - " + LANGTYPE[0];
	
	//Prepare newCharSetTable for each serviceType
	var ins = " 81 00 80 86 88 DE 00 00 00 00 00 00 00 00 CC A3 00 00 00 B2 00";
	
	//Prepare code to inject
	code =
	  " 83 FA 14"                               //CMP EDX,14
	+ " 7C 0F"                                  //JL short
	+ " 8B 3D" + LANGTYPE                       //MOV edi,g_serviceType
	+ " 0F B6 87" + GenVarHex(1)                //MOVZX EAX,BYTE PTR [EDI + newCharSetTable]
	+ " EB 07"                                  //JMP short
	+ " 8B 04 95" + cTable                      //MOV EAX,[EDX*4+cTable]
	+ " 68" + exe.Raw2Rva(retAdd).packToHex(4)  //PUSH retAdd
	+ " C3"                                     //RET
	;
	
	ins += code;
	
	
	//Allocate space for newCharSetTable and codes
	var size = ins.hexlength();
	var free = exe.findZeros(size + 4);
	if (free === -1)
		return "Failed in Step 3 - No enough free space";
	
	var freeRva = exe.Raw2Rva(free);
	
	ins = ReplaceVarHex(ins, 1, freeRva);
	
	var jump = exe.Raw2Rva(free + 21) - exe.Raw2Rva(offset + 5);
	
	code = " E9" + jump.packToHex(4) + " 90 90";
	
	
	exe.insert(free, size + 4, ins, PTYPE_HEX);
	exe.replace(offset, code, PTYPE_HEX);
	
	
	
	return true;
}
