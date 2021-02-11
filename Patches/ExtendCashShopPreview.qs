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
    var offset1 = table.getRaw(table.cashShopPreviewPatch1);
    if (offset1 === 0)
    {
        return "Cash shop address 1 not found";
    }
    var offset2 = table.getRaw(table.cashShopPreviewPatch2);
    if (offset2 === 0)
    {
        return "Cash shop address 2 not found";
    }
    var offset3 = table.getRaw(table.cashShopPreviewPatch3);

    var location = table.get(table.ITEM_INFO_location);
    if (location === 0)
    {
        return "ITEM_INFO::location not found";
    }

    var viewSprite = table.get(table.ITEM_INFO_view_sprite);
    if (viewSprite === 0)
    {
        return "ITEM_INFO::view_sprite not found";
    }

    var flag = table.get(table.cashShopPreviewFlag);

    consoleLog("search first pattern");

    var code =
        "8D 8D AB AB AB FF ";         // 0 lea ecx, [ebp+itemInfo]
    var itemInfoOffset = [2, 4];
    var stolenCodeSize = 6;

    var found = exe.match(code, true, offset1);
    if (found !== true)
    {
        return "Error: first pattern not found";
    }

    consoleLog("search second pattern");

    code =
        "83 C6 AB ";                  // 0 add esi, size struct_packet_8CA_next
    var blockSizeOffset = [2, 1];
    var register = "esi";
    var found = exe.match(code, true, offset2);

    if (found !== true)
    {
        code =
            "83 C7 AB ";                  // 0 add edi, size struct_packet_8CA_next
        var blockSizeOffset = [2, 1];
        var register = "edi";
        var found = exe.match(code, true, offset2);
    }

    if (found !== true)
    {
        code =
            "83 C1 AB ";                  // 0 add ecx, size struct_packet_8CA_next
        var blockSizeOffset = [2, 1];
        var register = "ecx";
        var found = exe.match(code, true, offset2);
    }

    if (found !== true)
    {
        return "Error: second pattern not found";
    }

    var blockSize = exe.fetchValue(offset2, blockSizeOffset);

    if (flag == 0)
    {
        consoleLog("search third pattern");

        code = "89 8D";         // 0 mov [ebp+next], ecx
        var nextOffset = [2, 4];
        var found = exe.match(code, true, offset3);

        if (found !== true)
        {
            return "Error: third pattern not found";
        }
        var next = exe.fetchValue(offset3, nextOffset);
    }
    else
    {
        next = 0;
    }

    consoleLog("add new code");

    var stolenCode = exe.fetchHex(offset1, stolenCodeSize);

    if (flag === 1)
    {
        var text = asm.combine(
            asm.hexToAsm(stolenCode),
            "push eax",
            "movzx eax, word ptr [" + register + "+block_size]",
            "mov [ebp + itemInfo + view_sprite], eax",
            "mov eax, [" + register + "+block_size+2]",
            "mov [ebp + itemInfo + location], eax",
            "pop eax",
            "jmp continueItemAddr"
        );
    }
    else
    {
        var text = asm.combine(
            asm.hexToAsm(stolenCode),
            "push eax",
            "push ecx",
            "mov ecx, dword ptr [ebp + next + 0]",
            "movzx eax, word ptr [ecx + block_size]",
            "mov [ebp + itemInfo + view_sprite], eax",
            "mov eax, dword ptr [ecx + block_size + 2]",
            "mov [ebp + itemInfo + location], eax",
            "pop ecx",
            "pop eax",
            "jmp continueItemAddr"
        );
    }
    var vars = {
        "continueItemAddr": exe.Raw2Rva(offset1 + stolenCodeSize),
        "location": location,
        "view_sprite": viewSprite,
        "itemInfo": exe.fetchValue(offset1, itemInfoOffset),
        "next": next,
        "block_size": blockSize
    };

    var data = exe.insertAsmText(text, vars);
    var free = data[0]

    consoleLog("add jump to own code");
    exe.setJmpRaw(offset1, free);

    consoleLog("update block size");
    exe.setValue(offset2, blockSizeOffset, blockSize + 4 + 2);

    return true;
}

function ExtendCashShopPreview_()
{
    return (exe.findString(".?AVUIPreviewEquipWnd@@", RAW) !== -1);
}
