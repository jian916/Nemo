//
// Copyright (C) 2020-2021  Andrei Karas (4144)
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

function SimpleReplaceDemo()
{
    // hex bytes replacing
    // change string `btn_ok.bmp` to `btn_ko.bmp`
    simpleReplaceHex("62 74 6E 5F 6F 6B 2E 62 6D 70 00", "62 74 6E 5F 6B 6F 2E 62 6D 70 00");

    // strings with bytes replacing
    // change string `btn_ok.bmp` to `btn_ko.bmp`
    simpleReplaceStr("\x62\x74\x6E\x5F\x6F\x6B\x2E\x62\x6D\x70\x00", "\x62\x74\x6E\x5F\x6B\x6F\x2E\x62\x6D\x70\x00");

    // strings replacing
    // change string `btn_ok.bmp` to `btn_ko.bmp`
    simpleReplaceStr("btn_ok.bmp", "btn_ko.bmp");


    // hex bytes replacing
    // change string `btn_ok.bmp` to `btn_ko.bmp`
    simpleReplaceAllHex("62 74 6E 5F 6F 6B 2E 62 6D 70 00", "62 74 6E 5F 6B 6F 2E 62 6D 70 00");

    // strings with bytes replacing
    // change string `btn_ok.bmp` to `btn_ko.bmp`
    simpleReplaceStr("\x62\x74\x6E\x5F\x6F\x6B\x2E\x62\x6D\x70\x00", "\x62\x74\x6E\x5F\x6B\x6F\x2E\x62\x6D\x70\x00");

    // strings replacing
    // change string `btn_ok.bmp` to `btn_ko.bmp`
    simpleReplaceStr("btn_ok.bmp", "btn_ko.bmp");

    return true;
}
