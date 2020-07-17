//============================================================//
// Patch Functions wrapping over Disable4LetterLimit function //
//============================================================//

function Disable4LetterCharnameLimit()
{
  return Disable4LetterLimit(0);
}

function Disable4LetterPasswordLimit()
{
  return Disable4LetterLimit(1);
}

function Disable4LetterUsernameLimit()
{
  return Disable4LetterLimit(2);
}

//###########################################################################
//# Purpose: Find the Comparisons of UserName/Password/CharName size with 4 #
//#          and replace it with 0 so any non-empty string is valid         #
//###########################################################################

function Disable4LetterLimit(index)
{ //Some old clients dont have the ID Check

  if (!IsZero() && exe.getClientDate() < 20181113)
  { //Old clients

    //Step 1a - Find all Text Size comparisons with 4 chars.
    var code =
      " E8 AB AB AB FF" //CALL UIEditCtrl::GetTextSize
    + " 83 F8 04"       //CMP EAX, 4
    + " 7C"             //JL SHORT addr
    ;

    var offsets = exe.findCodes(code, PTYPE_HEX, true, "\xAB");

    code = code.replaceAt(-3, " 0F 8C AB AB 00 00"); //JL addr
    offsets = offsets.concat(exe.findCodes(code, PTYPE_HEX, true, "\xAB"));

    if (offsets.length < 3)
      return "Failed in Step 1 - Not enough matches found";


    //Step 1b - Find which of the offsets belong to Password & ID Check
    code =
      " E8 AB AB AB FF"  //CALL UIEditCtrl::GetTextSize
    + " 83 F8 04"        //CMP EAX, 4
    ;

    var csize = code.hexlength();

    for (var idp = 0; idp < offsets.length; idp++)
    {
      var offset2 = exe.find(code, PTYPE_HEX, true, "\xAB", offsets[idp] + csize, offsets[idp] + csize + 30 + csize);
      if (offset2 !== -1) break;
    }

    if (offset2 === -1)
      return "Failed in Step 1 - ID+Pass check not found";

    //Step 2 - Replace 4 with 0 in CMP EAX,4 in appropriate offsets
    switch(index)
    {
      case 0: {
        //Step 2a - For Index 0 i.e. Char Name, all offsets other than offset2 and offsets[idp] will get the replace
        for (var i = 0; i < offsets.length; i++)
        {
          if (i === idp || offsets[i] === offset2) continue;
          exe.replace(offsets[i] + csize - 1, " 00", PTYPE_HEX);
        }
        break;
      }
      case 1: {
        //Step 2b - For Index 1 i.e. Password, offsets[idp] get the replace
        exe.replace(offsets[idp] + csize - 1, " 00", PTYPE_HEX);
        break;
      }
      case 2: {
        //Step 2c - For Index 2, i.e. ID, offset2 get the replace
        exe.replace(offset2 + csize - 1, " 00", PTYPE_HEX);
        break;
      }
    }

  }
  else
  { //New Clients with new login interface

    //Step 1a - Find all Text Size comparisons with 4 chars.
    var code =
      " E8 AB AB AB FF"    //CALL UIEditCtrl::GetTextSize
    + " 83 F8 04"          //CMP EAX, 4
    + " 0F 8C AB AB 00 00" //JL addr
    ;

    switch(index)
    {
      case 0:
      { //Find the Charname check inside UIChangeNameWnd
        var ref = exe.findCode(" 68 06 0D 00 00", PTYPE_HEX, false); //ref string: Please enter one line without line breaks.
        if (ref === -1)
          return "Failed in Step 1 - UIChangeNameWnd::SendMsg not found";

        var offset = exe.find(code, PTYPE_HEX, true, "\xAB", ref, ref + 0xFF);
        if (offset === -1)
          return "Failed in Step 1 - UIChangeNameWnd::SendMsg:CharNameCheck not found";

        //Find the Charname check inside UINewMakeCharWnd
        ref = exe.findCode(" 68 C7 00 00 00 E8", PTYPE_HEX, false); //ref string: You cannot put a space at the beginning or end of a name.
        if (ref === -1)
          return "Failed in Step 1 - UINewMakeCharWnd::SendMsg not found";

        code = code.replace(" 0F 8C AB AB 00 00", " 7D AB");//JL SHORT addr
        var offset2 = exe.find(code, PTYPE_HEX, true, "\xAB", ref - 0X400, ref);
        if (offset === -1)
          return "Failed in Step 1 - UINewMakeCharWnd::SendMsg:CharNameCheck not found";

        //Replace 4 with 0 in CMP EAX,4 in appropriate offsets
        exe.replace(offset + 7, " 00", PTYPE_HEX);
        exe.replace(offset2 + 7, " 00", PTYPE_HEX);
        break;
      }
      case 1:
      { //New login interface compare Pass text size with 6 chars
        code = code.replace(" 04", " 06");
        var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
        if (offset === -1)
          return "Failed in Step 1 - Pass check not found.";

        //Replace 4 with 0 in CMP EAX,4 in appropriate offsets
        exe.replace(offset + 7, " 00", PTYPE_HEX);
        break;
      }
      case 2:
      { //ID check just below Pass check
        var passCode = code.replace(" 04", " 06");
        var offset = exe.findCode(passCode, PTYPE_HEX, true, "\xAB");
        if (offset === -1)
          return "Failed in Step 1 - Pass check not found.";

        var offset2 = exe.find(code, PTYPE_HEX, true, "\xAB", offset, offset + 0xFF);
        if (offset2 === -1)
          return "Failed in Step 1 - ID check not found.";

        code = code.replace(" 0F 8C AB AB 00 00", " 7D AB");//JL SHORT addr
        var offset3 = exe.find(code, PTYPE_HEX, true, "\xAB", offset, offset + 0xFF);
        if (offset3 === -1)
          return "Failed in Step 1 - ID check not found.";

        //Replace 4 with 0 in CMP EAX,4 in appropriate offsets
        exe.replace(offset2 + 7, " 00", PTYPE_HEX);
        exe.replace(offset3 + 7, " 00", PTYPE_HEX);
        break;
      }
    }
  }
  return true;
}
