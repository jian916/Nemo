//
// Copyright (C) 2018-2021  Andrei Karas (4144)
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
//# Purpose: Change height for UIEditCtrl2 in        #
//#          UINewMakeCharWnd_virt56                 #
//####################################################

function ChangeNewCharName_match()
{
    var addr1 = table.getRawValidated(table.UINewMakeCharWnd_OnCreate);
    var addr2 = table.getRawValidated(table.UINewMakeCharWnd_OnCreate_ret);

    var code = [
        [
            "C7 45 ?? FF FF FF FF" +  // 0 mov [ebp+var], 0FFFFFFFFh
            "6A 0D" +                 // 7 push 0Dh
            "68 82 00 00 00" +        // 9 push 82h
            "8B C8" +                 // 14 mov ecx, eax
            "89 83 ?? ?? 00 00" +     // 16 mov  [ebx+28Ch], eax
            "E8 ?? ?? ?? ??" +        // 22 call UIWindow_Create
            "8B 8B ?? ?? 00 00",      // 27 mov ecx, [ebx+28Ch]
            {
                "heightOffset": [8, 1],
                "charNameOffsets": [[18, 4], [29, 4]],
                "createOffset": 23,
            }
        ],
        [
            "C7 45 ?? FF FF FF FF" +  // 0 mov [ebp+var], 0FFFFFFFFh
            "8B C8" +                 // 7 mov ecx, eax
            "6A 0D" +                 // 9 push 0Dh
            "68 82 00 00 00" +        // 11 push 82h
            "89 83 ?? ?? 00 00" +     // 16 mov  [ebx+28Ch], eax
            "E8 ?? ?? ?? ??" +        // 22 call UIWindow_Create
            "8B 8B ?? ?? 00 00",      // 27 mov ecx, [ebx+28Ch]
            {
                "heightOffset": [10, 1],
                "charNameOffsets": [[18, 4], [29, 4]],
                "createOffset": 23,
            }
        ],
        [
            "C7 45 ?? FF FF FF FF " +     // 0 mov [ebp+var_4], 0FFFFFFFFh
            "8B C8 " +                    // 7 mov ecx, eax
            "6A 14 " +                    // 9 push 14h
            "68 82 00 00 00 " +           // 11 push 82h
            "89 83 ?? ?? 00 00 " +        // 16 mov [ebx+UINewMakeCharWnd.m_charName], eax
            "E8 ?? ?? ?? ?? " +           // 22 call UIWindow_Create
            "8B 8B ?? ?? 00 00",          // 27 mov ecx, [ebx+UINewMakeCharWnd.m_charName]
            {
                "heightOffset": [10, 1],
                "charNameOffsets": [[18, 4], [29, 4]],
                "createOffset": 23,
            }
        ],
        [
            "C7 45 ?? FF FF FF FF " +     // 0 mov [ebp+var_4], 0FFFFFFFFh
            "6A 10 " +                    // 7 push 10h
            "6A 6E " +                    // 9 push 6Eh
            "8B C8 " +                    // 11 mov ecx, eax
            "89 86 ?? ?? 00 00 " +        // 13 mov [esi+UINewMakeCharWnd.m_charName], eax
            "E8 ?? ?? ?? ?? " +           // 19 call UIWindow_Create
            "8B 8E ?? ?? 00 00",          // 24 mov ecx, [esi+UINewMakeCharWnd.m_charName]
            {
                "heightOffset": [8, 1],
                "charNameOffsets": [[15, 4], [26, 4]],
                "createOffset": 20,
            }
        ],
        [
            "C7 45 ?? FF FF FF FF " +     // 0 mov [ebp+var_4], 0FFFFFFFFh
            "6A 14 " +                    // 7 push 14h
            "68 82 00 00 00 " +           // 9 push 82h
            "8B C8 " +                    // 14 mov ecx, eax
            "89 83 ?? ?? 00 00 " +        // 16 mov [ebx+28Ch], eax
            "E8 ?? ?? ?? ?? " +           // 22 call UIWindow_Create
            "8B 8B ?? ?? 00 00",          // 27 mov ecx, [ebx+28Ch]
            {
                "heightOffset": [8, 1],
                "charNameOffsets": [[18, 4], [29, 4]],
                "createOffset": 23,
            }
        ],
    ];

    var offsetObj = pe.findAny(code, addr1, addr2);

    if (offsetObj === -1)
        throw "Failed in step 1 - pattern not found";

    var offset = offsetObj.offset;
    for (var i = 0; i < offsetObj.charNameOffsets.length; i ++)
    {
        logField("UINewMakeCharWnd::m_charName", offset, offsetObj.charNameOffsets[i]);
    }
    logRawFunc("UIWindow_Create", offset, offsetObj.createOffset);

    var obj = hooks.createHookObj();
//    obj.patchAddr = offset;
    obj.stolenCode = "";
    obj.stolenCode1 = "";
    obj.retCode = "";
    obj.endHook = false;

    obj.offset = offset;
    obj.heightOffset = offsetObj.heightOffset;
    return obj;
}

function ChangeNewCharNameHeight()
{
    var obj = ChangeNewCharName_match();

    var height = exe.getUserInput("$newCharNameHeight",
        XTYPE_BYTE,
        _("Number Input"),
        _("Enter new char name height (0-255, default is 13):"),
        13,
        0, 255);
    if (height === 13)
    {
        return "Patch Cancelled - New value is same as old";
    }

    pe.setValue(obj.offset, obj.heightOffset, height);

    return true;
}

function ChangeNewCharNameHeight_()
{
    return (pe.stringRaw(".?AVUINewMakeCharWnd@@") !== -1);
}
