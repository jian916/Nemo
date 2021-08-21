//
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

function imports_load()
{
    if (imports.init === true)
        return;

    var descriptor = pe.getImportTable();
    var vaOffset = pe.rawToVa(descriptor.offset);
    if (vaOffset <= 0)
    {
        consoleLog("Import table corrupted");
        imports.init = true;
        return;
    }
    consoleLog("Import table 0x" + vaOffset.toString(16) + " size: 0x" +  descriptor.size.toString(16));
    for (var i = 0; i < descriptor.size; i += 4*5)
    {
        var data = imports.loadDescriptor(descriptor.offset + i);
        if (data === false)
            break;
        imports.parseDescriptor(data);
    }
    imports.init = true;
    return;
}

function imports_add(dllName, funcName, funcPtr)
{
    dllName = dllName.toLowerCase();
    imports.allImports.push(dllName, funcName, funcPtr);

    var value = {
        "dll": dllName,
        "name": funcName,
        "ptr": funcPtr
    }

    function addEntry(key, value)
    {
        if (!(key in imports.nameToPtr))
        {
            imports.nameToPtr[key] = [];
        }
        imports.nameToPtr[key].push(value);
    }

    addEntry([undefined, funcName], value);
    addEntry([dllName, funcName], value);
}

function imports_parseDescriptor(descriptor)
{
    var nameOffset = descriptor.names;
    var funcOffset = descriptor.funcs;
    var dllName = descriptor.dll;
    while (true)
    {
        var offset = pe.fetchUDWord(nameOffset);
        if (offset == 0)
            return;

        if ((offset & 0x80000000) != 0)
        {
            var ordinal = (offset & 0x7fffffff);
            var funcPtr = pe.rawToVa(funcOffset);
            consoleLog("Found import ordinal: " + dllName + ", " + ordinal + ", " + funcPtr.toString(16));
            imports.add(dllName, ordinal, funcPtr);
        }
        else
        {
            offset = pe.rvaToRaw(offset);
            if (offset < 0)
            {
                consoleLog("Possible import table corruption");
                return;
            }
            var funcName = pe.fetchString(offset + 2);
            var funcPtr = pe.rawToVa(funcOffset);
            consoleLog("Found import name: " + dllName + ", " + funcName + ", " + funcPtr.toString(16));
            imports.add(dllName, funcName, funcPtr);
        }
        nameOffset += 4;
        funcOffset += 4;
    }
}

function imports_loadDescriptor(offset)
{
    consoleLog("Import table descriptor 0x" + pe.rawToVa(offset).toString(16));
    var nameList = pe.fetchUDWord(offset);
    if (nameList === 0)
    {
        consoleLog("Import descriptor name list zero");
        return false;
    }
    nameList = pe.rvaToRaw(nameList);
    var forwarded = pe.fetchUDWord(offset + 8);
    if (forwarded != 0)
        throw "Unsupported import table flag";
    var dllName = pe.fetchUDWord(offset + 12);
    if (dllName === 0)
    {
        consoleLog("Import descriptor dll name zero");
        return false;
    }
    dllName = pe.fetchString(pe.rvaToRaw(dllName));
    if (dllName.length < 4 || dllName.toLowerCase().indexOf(".dll") < 1)
    {
        consoleLog("Import descriptor wrong dll name");
        return false;
    }
    var funcList = pe.fetchUDWord(offset + 16);
    if (funcList === 0)
    {
        consoleLog("Import descriptor functions list zero");
        return false;
    }
    funcList = pe.rvaToRaw(funcList);
    return {
        "names": nameList,
        "dll": dllName,
        "funcs": funcList
    }
}

function imports_importByName(funcName, dllName)
{
    imports.load();
    var key = [dllName.toLowerCase(), funcName];
    if (key in imports.nameToPtr)
    {
        var arr = imports.nameToPtr[key];
        return arr[0];
    }
    else
    {
        return false;
    }
}

function imports_ptr(funcName, dllName, ordinal)
{
    var entry = imports.importByName(funcName, dllName);
    if (entry === false && typeof(ordinal) !== "undefined")
        entry = imports.importByName(ordinal, dllName);
    if (entry === false)
        return -1;
    return entry.ptr;
}

function imports_ptrValidated(funcName, dllName, ordinal)
{
    var entry = imports_ptr(funcName, dllName, ordinal)
    if (entry === false)
        throw "Import function " + dllName + ":" + funcName + " not found";
    return entry;
}

function registerImports()
{
    imports = new Object();
    imports.init = false;
    imports.allImports = [];
    imports.nameToPtr = {};

    imports.load = imports_load;
    imports.loadDescriptor = imports_loadDescriptor;
    imports.parseDescriptor = imports_parseDescriptor;
    imports.add = imports_add;
    imports.importByName = imports_importByName;
    imports.ptr = imports_ptr;
    imports.ptrValidated = imports_ptrValidated;
}
