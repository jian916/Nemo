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
        "68 B0 9A 00 00 " +       // push 39600
        "C7 45 ?? B0 9A 00 00 " + // mov [ebp+Size], 39600
        "E8 ?? ?? ?? ?? ";        // call operator new

    var sizeOffset1 = [1, 4];
    var sizeOffset2 = [8, 4];

    consoleLog("Find the image decompression allocations.");
    var offsets = pe.findCodes(code);
    if (offsets.length === 0)
        return "Failed in Step 1 - CaptchaDecompressSize not found";

    var capthaNewsize = exe.getUserInput("$capthaNewsize", XTYPE_DWORD, _("decompession size (default: 39600)"), _("Enter new decompession size"), "59454", 1, 100000);
    if (capthaNewsize === 39600)
        return "New size value is same as old value";

    consoleLog("Replace the values");
    for (var i = 0; i < offsets.length; i++)
    {
        exe.setValue(offsets[i], sizeOffset1, capthaNewsize);
        logVaVar("CAPTCHA_IMAGE_DECOMPRESS_SIZE", offsets[i], sizeOffset1);

        exe.setValue(offsets[i], sizeOffset2, capthaNewsize);
        logVaVar("CAPTCHA_IMAGE_DECOMPRESS_SIZE", offsets[i], sizeOffset2);
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
