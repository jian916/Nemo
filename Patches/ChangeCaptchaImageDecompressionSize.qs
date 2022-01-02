//
// Copyright (C) 2018-2021  Andrei Karas (4144)
// Copyright (C) 2021 Asheraf
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
//###########################################################
//# Purpose: Change the zlib decompression size             #
//#          for downloaded captcha images                  #
//###########################################################

function ChangeCaptchaImageDecompressionSize()
{
    var code =
        "68 ?? ?? ?? ?? " +           // 0 push offset new2_flag
        "68 B0 9A 00 00 " +           // 5 push 9AB0h
        "C7 45 ?? B0 9A 00 00 " +     // 10 mov [ebp+size], 9AB0h
        "E8 ";                        // 17 call new2

    var new2FlagOffset = [1, 4];
    var sizeOffset1 = [6, 4];
    var sizeOffset2 = [13, 4];
    var new2Offset = 18;

    consoleLog("Find the image decompression allocations.");
    var offsets = pe.findCodes(code);
    if (offsets.length === 0)
        return "Failed in Step 1 - CaptchaDecompressSize not found";

    var capthaNewsize = exe.getUserInput("$capthaNewsize", XTYPE_DWORD,
        _("max decompession size (default: 39600)"),
        _("Enter new captcha max decompession size"),
        59454, 1, 100000);
    if (capthaNewsize === 39600)
        return "New size value is same as old value";

    consoleLog("Replace the values");
    for (var i = 0; i < offsets.length; i++)
    {
        var offset = offsets[i];
        pe.setValue(offset, sizeOffset1, capthaNewsize);
        pe.setValue(offset, sizeOffset2, capthaNewsize);

        logVaVar("new2_flag", offset, new2FlagOffset);
        logVal("max captch image decompression size", offset, sizeOffset1);
        logVal("max captch image decompression size", offset, sizeOffset2);
        logRawFunc("new2", offset, new2Offset);
    }

    return true;
}

//============================//
// Disable Unsupported client //
//============================//
function ChangeCaptchaImageDecompressionSize_()
{
    return (pe.stringRaw("/macro_preview") !== -1);
}
