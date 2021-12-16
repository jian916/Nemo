//
// Copyright (C) 2021 Neo-Mind
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

function RemoveNewCharCreationBluredBackground()
{
    var offset = pe.stringRaw("\xC0\xAF\xC0\xFA\xC0\xCE\xC5\xCD\xC6\xE4\xC0\xCC\xBD\xBA\x5C\x6D" +
                              "\x61\x6B\x65\x5F\x63\x68\x61\x72\x61\x63\x74\x65\x72\x5F\x76\x65" +
                              "\x72\x32\x5C\x62\x67\x5F\x62\x61\x63\x6B\x32\x2E\x74\x67\x61");
    if (offset === -1)
        return "Error: background image not found";

    pe.replaceByte(offset, 0);
    return true;
}

function RemoveNewCharCreationBluredBackground_()
{
    return (pe.stringRaw(".?AVUIRPImageWnd@@") !== -1);
}
