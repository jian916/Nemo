//
// Copyright (C) 2018  Andrei Karas (4144)
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

function Global_clear()
{
    delete D2S;
    delete D2D;
    delete EspAlloc;
    delete StrAlloc;
    delete AllocType;
    delete LuaState;
    delete LuaFnCaller;
    delete Import_Info;
    delete PEncInsert;
    delete PEncActive;

    dllFile = false;
}
