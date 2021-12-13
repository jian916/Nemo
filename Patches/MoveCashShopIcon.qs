//##########################################################################
//# Purpose: Modify the coordinates send as argument to UIWindow::UIWindow #
//#          for Cash Shop Button to the user specified ones               #
//##########################################################################

function MoveCashShopIcon()
{
    if (table.get(table.UIWindowMgr_MakeWindow) === 0)
        return "UIWindowMgr::MakeWindow not set";

    var makeWindow = table.getRaw(table.UIWindowMgr_MakeWindow);
    if (table.get(table.UIWindowMgr_MakeWindow_ret1) == 0)
        return "UIWindowMgr::MakeWindow ret not set";
    var endOffset = table.getRaw(table.UIWindowMgr_MakeWindow_ret1);
    var endOffset2 = table.getRaw(table.UIWindowMgr_MakeWindow_ret2);
    if (endOffset2 > endOffset)
        endOffset = endOffset2;

    consoleLog("Step 1a - Find the XCoord calculation pattern");
    var code =
        " 81 EA BB 00 00 00" +  // 0 SUB EDX, 0BB
        " 52";                  // 6 PUSH EDX
    var patchOffset = 0;
    var pushReg = "edx";
    var stolenCodeOffset = 0;
    var skipByte = true;
    var offset = pe.find(code, makeWindow, endOffset);

    if (offset === -1)
    {
        var code =
            " 2D BB 00 00 00" +  // 0 SUB EAX, 0BB
            " 50";               // 5 PUSH EAX
        patchOffset = 0;
        pushReg = "eax";
        stolenCodeOffset = 0;
        skipByte = false;
        offset = pe.find(code, makeWindow, endOffset);
    }

    if (offset === -1)
    {
        var code =
            " 2D BB 00 00 00" +  // 0 SUB EAX, 0BB
            " 6A 10" +           // 5 PUSH 10h
            " 50";               // 7 PUSH EAX
        patchOffset = 0;
        pushReg = "eax";
        stolenCodeOffset = [5, 2];
        skipByte = false;
        offset = pe.find(code, makeWindow, endOffset);
    }

    if (offset === -1)
        return "Failed in Step 1 - Coord calculation missing";

    if (stolenCodeOffset)
    {
        var stolenCode = pe.fetchHexBytes(offset, stolenCodeOffset);
    }
    else
    {
        var stolenCode = "";
    }

    consoleLog("Step 1b - Accomodate for extra bytes by NOPing those");

    var g_renderer = table.get(table.g_renderer);
    if (g_renderer === 0)
        return "g_renderer not set";
    var g_renderer_width = table.get(table.g_renderer_m_width);
    var g_renderer_height = table.get(table.g_renderer_m_height);

    //Step 2a - Get User Coords
    var xCoord = exe.getUserInput("$cashShopX", XTYPE_WORD, _("Number Input"), _("Enter new X coordinate:"), -0xBB, -0xFFFF, 0xFFFF);
    var yCoord = exe.getUserInput("$cashShopY", XTYPE_WORD, _("Number Input"), _("Enter new Y coordinate:"), 0x10, -0xFFFF, 0xFFFF);

    if (xCoord === -0xBB && yCoord === 0x10)
        return "Patch Cancelled - New coordinate is same as old";

    consoleLog("Step 2b - Prep code to insert based on the sign of each coordinate (negative values are relative to width and height respectively)");
    var text = "";
    if (yCoord < 0)
    {
        yCoord = -yCoord;
        text = asm.combine(
            "push ecx",
            "mov ecx, dword ptr [g_renderer]",
            "mov ecx, dword ptr [ecx + g_renderer_height]",
            "sub ecx, yCoord",
            "mov dword ptr [esp + 8], ecx"
        );
    }
    else
    {
        text = asm.combine(
            "push ecx",
            "mov ecx, yCoord",
            "mov dword ptr [esp + 8], ecx"
        );
    }

    if (xCoord < 0)
    {
        xCoord = -xCoord;
        text = asm.combine(
            text,
            "mov ecx, dword ptr [g_renderer]",
            "mov ecx, dword ptr [ecx + g_renderer_width]",
            "sub ecx, xCoord",
            "mov " + pushReg + ", ecx",
            "pop ecx",
            "ret"
        );
    }
    else
    {
        text = asm.combine(
            text,
            "mov ecx, xCoord",
            "mov " + pushReg + ", ecx",
            "pop ecx",
            "ret"
        );
    }

    consoleLog("Step 3a - Insert the code");
    var vars = {
        "g_renderer": g_renderer,
        "g_renderer_width": g_renderer_width,
        "g_renderer_height": g_renderer_height,
        "xCoord": xCoord,
        "yCoord": yCoord
    };

    var obj = exe.insertAsmTextObj(text, vars);
    var free = obj.free;

    consoleLog("Step 3b - Change the 0xBB subtraction with a call to our code");

    if (skipByte)
    {
        text = asm.combine(
            asm.hexToAsm(stolenCode),
            "nop",
            "call free"
        );
    }
    else
    {
        text = asm.combine(
            asm.hexToAsm(stolenCode),
            "call free"
        );
    }

    var vars = {
        "free": pe.rawToVa(free)
    };

    exe.replaceAsmText(offset + patchOffset, text, vars);

    return true;
}

//=====================================================//
// Only Enable for Clients that actually have the icon //
//=====================================================//
function MoveCashShopIcon_()
{
    return (pe.stringRaw("NC_CashShop") !== -1);
}
