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

function hooks_initEndHook(patchAddr)
{
    return hooks_initHook(patchAddr, hooks_matchFunctionEnd);
}

function hooks_initTableEndHook(varId)
{
    return hooks_initHook(varId, hooks_matchFunctionEnd, table.varToHook);
}

function hooks_initImportCallHooks(funcName, dllName, ordinal)
{
    return hooks_initHooks([funcName, dllName, ordinal],
        hooks.matchImportCallUsage,
        hooks.searchImportCallUsage);
}

function hooks_initImportJmpHooks(funcName, dllName, ordinal)
{
    return hooks_initHooks([funcName, dllName, ordinal],
        hooks.matchImportJmpUsage,
        hooks.searchImportJmpUsage);
}

function hooks_initImportMovHooks(funcName, dllName, ordinal)
{
    return hooks_initHooks([funcName, dllName, ordinal],
        hooks.matchImportMovUsage,
        hooks.searchImportMovUsage);
}
