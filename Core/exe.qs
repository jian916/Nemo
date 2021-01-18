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

function exe_setJmpVa(patchAddr, jmpAddrVa)
{
    var vars = {
        "offset": jmpAddrVa,
    };
    var code = asm.textToHexRaw(patchAddr, "jmp offset", vars);
    if (code === false)
        throw "Jmp code error";

    exe.replace(patchAddr, code, PTYPE_HEX);
}

function exe_setJmpRaw(patchAddr, jmpAddrRaw)
{
    exe_setJmpVa(patchAddr, exe.Raw2Rva(jmpAddrRaw));
}

function registerExe()
{
    exe.setJmpVa = exe_setJmpVa;
    exe.setJmpRaw = exe_setJmpRaw;
}
