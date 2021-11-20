//
// Copyright (C) 2018-2022  Andrei Karas (4144)
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
//#########################################################################
//# Purpose: Extend cash shop packet with location and view sprite fields #
//#########################################################################

function ExtendCashShopPreview()
{
    consoleLog("get patch addresses");
    var offset1 = table.getRawValidated(table.cashShopPreviewPatch1);
    var offset2 = table.getRawValidated(table.cashShopPreviewPatch2);
    var offset3 = table.getRaw(table.cashShopPreviewPatch3);

    var flag = table.get(table.cashShopPreviewFlag);

    consoleLog("search first pattern");

    var code =
        "8D 8D ?? ?? ?? FF ";         // 0 lea ecx, [ebp+itemInfo]
    var itemInfoOffset = [2, 4];
    var stolenCodeSize = 6;

    var found = pe.match(code, offset1);
    if (found !== true)
    {
        return "Error: first pattern not found";
    }

    consoleLog("search second pattern");

    code =
        "83 C6 ?? ";                  // 0 add esi, size struct_packet_8CA_next
    var blockSizeOffset = [2, 1];
    var register = "esi";
    var found = pe.match(code, offset2);

    if (found !== true)
    {
        code =
            "83 C7 ?? ";                  // 0 add edi, size struct_packet_8CA_next
        var blockSizeOffset = [2, 1];
        var register = "edi";
        var found = pe.match(code, offset2);
    }

    if (found !== true)
    {
        code =
            "83 C1 ?? ";                  // 0 add ecx, size struct_packet_8CA_next
        var blockSizeOffset = [2, 1];
        var register = "ecx";
        var found = pe.match(code, offset2);
    }

    if (found !== true)
    {
        return "Error: second pattern not found";
    }

    var blockSize = pe.fetchValue(offset2, blockSizeOffset);

    if (flag == 0)
    {
        consoleLog("search third pattern");

        code = "89 8D";         // 0 mov [ebp+next], ecx
        var nextOffset = [2, 4];
        var found = pe.match(code, offset3);

        if (found !== true)
        {
            return "Error: third pattern not found";
        }
        var next = pe.fetchValue(offset3, nextOffset);
    }
    else
    {
        var next = 0;
    }

    consoleLog("add new code");

    var stolenCode = exe.fetchHex(offset1, stolenCodeSize);

    if (flag === 1)
        var name = "1";
    else
        var name = "0";
    var vars = {
        "continueItemAddr": pe.rawToVa(offset1 + stolenCodeSize),
        "itemInfo": pe.fetchValue(offset1, itemInfoOffset),
        "next": next,
        "block_size": blockSize,
        "register": register,
        "stolenCode": stolenCode
    };

    var data = exe.insertAsmFile("ExtendCashShopPreview_" + name, vars);

    consoleLog("add jump to own code");
    exe.setJmpRaw(offset1, data.free);

    consoleLog("update block size");
    exe.setValue(offset2, blockSizeOffset, blockSize + 4 + 2);

    storage.ExtendCashShop = true;

    return true;
}

function ExtendCashShopPreview_cancel()
{
    storage.ExtendCashShop = false;
    return true;
}

function ExtendCashShopPreview_()
{
    return (pe.stringRaw(".?AVUIPreviewEquipWnd@@") !== -1);
}
