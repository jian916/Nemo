//
// Copyright (C) 2020  Andrei Karas (4144)
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

function ValidateClient()
{
    var xmas1 = table.get(table.var1);
    var xmas2 = exe.findString("xmas.rsw", RVA);

    if (xmas1 === 0)
        return "Loaded file is not ragnarok client. Error 1.";
    if (xmas2 === -1)
        return "Loaded file is not ragnarok client. Error 2.";
    if (xmas1 !== xmas2)
        return "Loaded file is wrong ragnarok client. Error 3.";

    return true;
}
