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
//##################################################################
//# Purpose: Change http url for MerchantStore save and load       #
//##################################################################

function ChangeMerchantStoreUrl()
{
  //Step 1 - Find url strings
    var url1 = exe.findString("http://112.175.128.140:3000/MerchantStore/save", RVA, false);
    if (url1 === -1)
        return "Failed in Step 1a - String missing";

    var url2 = exe.findString("http://112.175.128.140:3000/MerchantStore/load", RVA, false);
    if (url2 === -1)
        return "Failed in Step 1b - String missing";

    //Step 2a - Find strings reference for servertype = primary
    var code =
        " 6A 2E"                  //0 push 2E
      + " 68" + url1.packToHex(4) //2 push offset url1
      + " E8 AB AB AB AB"         //7 call memcopy
      + " 6A 2E"                  //12 push 2E
      + " 68" + url2.packToHex(4) //14 push offset url2
      + " 8D 4F 24"               //19 lea ecx,[edi+24h]
      + " E8"                     //22 call memcopy
      ;

    var urlLen1 = 1;
    var urlLen2 = 13;
    var url1Ref = 3;
    var url2Ref = 15;

    //Step 2b - Find strings reference for servertype = sakray
    var offset1 = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    if (offset1 === -1)
        return "Failed in Step 2a";

    code =
        " BF" + url2.packToHex(4) //0 mov edi, offset url2
      + " BE 2E 00 00 00"         //5 mov esi, 2E
      + " B8" + url1.packToHex(4) //10 mov eax, offset url1
    ;

    var urlLen3 = 6;
    var url1aRef = 11;
    var url2aRef = 1;

    var offset2 = exe.findCodes(code, PTYPE_HEX, true, "\xAB");
    if (offset2.length !== 2)
        return "Failed in Step 2b";

    //Get user input
    var saveUrl = exe.getUserInput("$save", XTYPE_STRING, _("String input - maximum 255 characters"), _("Enter the new URL for MerchantStore save"), "http://", 9, 255);

    var loadUrl = exe.getUserInput("$load", XTYPE_STRING, _("String input - maximum 255 characters"), _("Enter the new URL for MerchantStore load"), "http://", 9, 255);

    var ins = saveUrl.toHex() + " 00" + loadUrl.toHex() + " 00";
    ins = ins + " 90".repeat(8);

    //Step 3 - find free space
    var size = ins.hexlength();
    var free = exe.findZeros(size);
    if (free === -1)
        return "Failed in Step 3 - Not enough free space";

    var freeRva = exe.Raw2Rva(free);

    //Step 4 - Insert and replace everything
    exe.insert(free, size, ins, PTYPE_HEX);

    exe.replace(offset1 + urlLen1, saveUrl.length.packToHex(1), PTYPE_HEX);
    exe.replace(offset1 + urlLen2, loadUrl.length.packToHex(1), PTYPE_HEX);
    exe.replace(offset1 + url1Ref, freeRva.packToHex(4), PTYPE_HEX);
    exe.replace(offset1 + url2Ref, (freeRva + saveUrl.length + 1).packToHex(4), PTYPE_HEX);

    exe.replace(offset2[1] + urlLen3, saveUrl.length.packToHex(4), PTYPE_HEX);
    exe.replace(offset2[1] + url1aRef, freeRva.packToHex(4), PTYPE_HEX);
    exe.replace(offset2[1] + url2aRef, (freeRva + saveUrl.length + 1).packToHex(4), PTYPE_HEX);

    //Step 5 -Remove all official ip address
    var ipaddr = "http://112.175.128.140:3000";
    var offsets = exe.findAll(ipaddr.toHex(), PTYPE_HEX, false);

    for (var i =0; i < offsets.length; i ++)
    {
        exe.replace(offsets[i], "http://0.0.0.0/\x00", PTYPE_STRING);
    }

    return true;
}

//Hide patch for unsupported clients
function ChangeMerchantStoreUrl_()
{
    return (exe.findString(":3000/MerchantStore/load", RAW, false) !== -1);
}
