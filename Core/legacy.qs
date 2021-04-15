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

function reportLegacy(text)
{
    if (typeof(enableLegacy) !== "undefined")
        return;

    if (typeof(console2) !== "undefined")
        console2.logLegacy(text);
    throw text;
}

function registerExeLegacy()
{
    if (typeof(enableLegacy) !== "undefined")
        return;
    exe.findCode = function()
    {
        reportLegacy("Please replace exe.findCode to pe.findCode");
    }
}
