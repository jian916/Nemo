//
// Copyright (C) 2021  Andrei Karas (4144)
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

function UINewMakeCharWndCreation_match()
{
    var renderHex = table.getHex4(table.g_renderer);
    var widthHex = table.getHex1(table.g_renderer_m_width);
    var heightHex = table.getHex1(table.g_renderer_m_height);

    var code = [
        [
            "E8 ?? ?? ?? ?? " +           // 0 call UIWindowMgr_AddWindow
            "68 A6 01 00 00 " +           // 5 push 1A6h
            "68 1A 03 00 00 " +           // 10 push 31Ah
            "8B ?? " +                    // 15 mov ecx, ebx
            "E8 ?? ?? ?? ?? " +           // 17 call UIWindow_Create
            "8B 0D " + renderHex +        // 22 mov ecx, g_renderer
            "?? ?? " +                    // 28 mov esi, [ebx]
            "8B 41 " + heightHex +        // 30 mov eax, [ecx+CRenderer.m_height]
            "2D A6 01 00 00 " +           // 33 sub eax, 1A6h
            "99 " +                       // 38 cd cdq
            "2B C2 " +                    // 39 sub eax, edx
            "D1 F8 " +                    // 41 sar eax, 1
            "83 E8 ?? " +                 // 43 sub eax, 46h
            "50 " +                       // 46 push eax
            "8B 41 " + widthHex +         // 47 mov eax, [ecx+CRenderer.m_width]
            "2D 1A 03 00 00 " +           // 50 sub eax, 31Ah
            "99 " +                       // 55 cd cdq
            "2B C2 " +                    // 56 sub eax, edx
            "D1 F8 " +                    // 58 sar eax, 1
            "E9 ",                        // 60 jmp loc_704E8C
            {
                "windowYOffset": [45, 1],
                "addWindowOffset": 1,
                "windowCreateOffset": 18,
                "vtblMoveOffset": 0,
                "widthOffsets": [[11, 4], [51, 4]],
                "heightOffsets": [[6, 4], [34, 4]]
            }
        ],
        [
            "E8 ?? ?? ?? ?? " +           // 0 call UIWindowMgr_AddWindow
            "68 A6 01 00 00 " +           // 5 push 1A6h
            "68 1A 03 00 00 " +           // 10 push 31Ah
            "8B ?? " +                    // 15 mov ecx, ebx
            "E8 ?? ?? ?? ?? " +           // 17 call UIWindow_Create
            "8B 0D " + renderHex +        // 22 mov ecx, ds:g_renderer
            "?? ?? " +                    // 28 mov esi, [ebx]
            "8B 41 " + heightHex +        // 30 mov eax, [ecx+CRenderer.m_height]
            "2D A6 01 00 00 " +           // 33 sub eax, 1A6h
            "99 " +                       // 38 cd cdq
            "2B C2 " +                    // 39 sub eax, edx
            "D1 F8 " +                    // 41 sar eax, 1
            "83 E8 ?? " +                 // 43 sub eax, 46h
            "50 " +                       // 46 push eax
            "8B 41 " + widthHex +         // 47 mov eax, [ecx+CRenderer.m_width]
            "2D 1A 03 00 00 " +           // 50 sub eax, 31Ah
            "99 " +                       // 55 cd cdq
            "2B C2 " +                    // 56 sub eax, edx
            "D1 F8 " +                    // 58 sar eax, 1
            "50 " +                       // 60 push eax
            "8B ?? ?? " +                 // 61 mov eax, [esi+UINewMakeCharWnd_vtable.UINewMakeCharWnd_Move]
            "E9 ",                        // 64 jmp loc_62B789
            {
                "windowYOffset": [45, 1],
                "addWindowOffset": 1,
                "windowCreateOffset": 18,
                "vtblMoveOffset": [63, 1],
                "widthOffsets": [[11, 4], [51, 4]],
                "heightOffsets": [[6, 4], [34, 4]]
            }
        ],
        [
            "E8 ?? ?? ?? ?? " +           // 0 call UIWindowMgr_AddWindow
            "68 A6 01 00 00 " +           // 5 push 1A6h
            "68 1A 03 00 00 " +           // 10 push 31Ah
            "8B ?? " +                    // 15 mov ecx, ebx
            "E8 ?? ?? ?? ?? " +           // 17 call UIWindow_Create
            "8B 0D " + renderHex +        // 22 mov ecx, g_renderer
            "?? ?? " +                    // 28 mov esi, [ebx]
            "8B 41 " + heightHex +        // 30 mov eax, [ecx+CRenderer.m_height]
            "2D A6 01 00 00 " +           // 33 sub eax, 1A6h
            "99 " +                       // 38 cd cdq
            "2B C2 " +                    // 39 sub eax, edx
            "D1 F8 " +                    // 41 sar eax, 1
            "83 E8 ?? " +                 // 43 sub eax, 46h
            "50 " +                       // 46 push eax
            "8B 41 " + widthHex +         // 47 mov eax, [ecx+CRenderer.m_width]
            "8B CB " +                    // 50 mov ecx, ebx
            "2D 1A 03 00 00 " +           // 52 sub eax, 31Ah
            "99 " +                       // 57 cd cdq
            "2B C2 " +                    // 58 sub eax, edx
            "D1 F8 " +                    // 60 sar eax, 1
            "50 " +                       // 62 push eax
            "8B ?? ?? " +                 // 63 mov eax, [esi+UIWindow_vtable.UIWindow_Move]
            "FF D0 " +                    // 66 call eax
            "E9 ",                        // 68 jmp loc_71DBDF
            {
                "windowYOffset": [45, 1],
                "addWindowOffset": 1,
                "windowCreateOffset": 18,
                "vtblMoveOffset": [65, 1],
                "widthOffsets": [[11, 4], [53, 4]],
                "heightOffsets": [[6, 4], [34, 4]]
            }
        ]
    ];

    var offsetObj = pe.findAnyCode(code);

    if (offsetObj === -1)
        throw "Pattern not found";

    var obj = hooks.createHookObj();
//    obj.patchAddr = offsetObj.offset;
    obj.stolenCode = "";
    obj.stolenCode1 = "";
    obj.retCode = "";
    obj.endHook = false;

    obj.offset = offsetObj.offset;
    obj.windowYOffset = offsetObj.windowYOffset;
    obj.addWindowOffset = offsetObj.addWindowOffset;
    obj.windowCreateOffset = offsetObj.windowCreateOffset;
    obj.vtblMoveOffset = offsetObj.vtblMoveOffset;
    obj.widthOffsets = offsetObj.widthOffsets;
    obj.heightOffsets = offsetObj.heightOffsets;

    var offset = obj.offset;
    logRawFunc("UIWindowMgr_AddWindow", offset, obj.addWindowOffset);
    logRawFunc("UIWindow_Create", offset, obj.windowCreateOffset);
    if (obj.vtblMoveOffset != 0)
    {
        logField("UIWindow_vtable_Move", offset, obj.vtblMoveOffset)
    }

    return obj;
}


function FixNewCharCreationPos()
{
    var obj = UINewMakeCharWndCreation_match();

    var yOffset = exe.getUserInput("$UINewMakeCharWndYOffset", XTYPE_BYTE,
        _("Y offset for new char creation window"),
        _("Enter y offset for new char creation window (wrong default: 70)"),
        0, -127, 127);

    pe.setValue(obj.offset, obj.windowYOffset, yOffset);
    return true;
}

function FixNewCharCreationPos_()
{
    return (pe.stringRaw(".?AVUIRPImageWnd@@") !== -1);
}
