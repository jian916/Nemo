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

function hooks_addPostEndHook(patchAddr, text, vars)
{
    consoleLog("hooks.addPostEndHook: match function end");

    var matchObj = hooks_matchFunctionEnd(patchAddr);

    consoleLog("hooks.addPostEndHook: insert own hook code");
    var text = asm.combine(
        asm.hexToAsm(matchObj.stolenCode1),
        text,
        "_ret:",
        asm.hexToAsm(matchObj.retCode));

    var data = exe.insertAsmText(text, vars);
    var free = data[0]

    consoleLog("hooks.addPostEndHook: add jump to own code");
    exe.setJmpRaw(patchAddr, free);

    var obj = new Object();
    obj.text = text;
    obj.free = free;
    obj.vars = data[1];
    obj.stolenCode = matchObj.stolenCode;
    obj.stolenCode1 = matchObj.stolenCode1;
    obj.retCode = matchObj.retCode;
    return obj;
}

function hooks_initHook(patchAddr, matchFunc, searchAddrFunc)
{
    consoleLog("hooks.initHook start");
    if (typeof(searchAddrFunc) !== "undefined")
    {
        patchAddr = searchAddrFunc(patchAddr);
    }

    if (patchAddr in storage.hooks)
    {
        consoleLog("hooks.initHook found existing hook");
        var obj = storage.hooks[patchAddr];
        if (obj.matchFunc !== matchFunc)
            throw "Other type of hook registered for address: 0x" + pe.rawToVa(patchAddr).toString(16);
        return obj;
    }
    else
    {
        consoleLog("hooks.initHook match new hook");
        var obj = matchFunc(patchAddr);
    }

    if (obj.endHook !== true)
        throw "Not supported endHook value: " + obj.endHook;

    function createEntry(text, vars)
    {
        var obj = new Object();
        obj.text = text;
        obj.vars = vars;
        obj.patch = patch.getName();
        return obj;
    }

    obj.matchFunc = matchFunc;
    obj.preEntries = [];
    obj.postEntries = [];
    obj.stolenEntry = createEntry(asm.hexToAsm(obj.stolenCode1), {});
    if (obj.retCode != "")
    {
        obj.finalEntry = createEntry(asm.hexToAsm(obj.retCode), {});
        obj.finalEntry.isFinal = true;
    }
    else
    {
        obj.finalEntry = false;
    }

    obj.addEntry = function(text, vars, entries)
    {
        if (typeof(vars) === "undefined")
            vars = {};
        var asmObj = exe.insertAsmTextObj(text, vars, 5);
        asmObj.patch = patch.getName();
        entries.push(asmObj);
        storage.multiHooks[asmObj.patch] = true;
    }
    obj.addPre = function(text, vars)
    {
        this.addEntry(text, vars, this.preEntries);
    }
    obj.addPost = function(text, vars)
    {
        this.addEntry(text, vars, this.postEntries);
    }
    obj.addFilePre = function(fileName, vars)
    {
        var text = asm.load(fileName);
        this.addEntry(text, vars, this.preEntries);
    }
    obj.addFilePost = function(fileName, vars)
    {
        var text = asm.load(fileName);
        this.addEntry(text, vars, this.postEntries);
    }
    obj.applyFinal = function()
    {
        hooks_applyFinal(this);
    }
    obj.validate = function()
    {
        hooks_applyFinal(this, true);
    }
    storage.hooks[patchAddr] = obj;
    return obj;
}

function hooks_initEndHook(patchAddr)
{
    return hooks_initHook(patchAddr, hooks_matchFunctionEnd);
}

function hooks_initTableEndHook(varId)
{
    return hooks_initHook(varId, hooks_matchFunctionEnd, table.getRawValidated);
}

function hooks_applyFinal(obj, dryRun)
{
    consoleLog("hooks.applyFinal start");
    if (obj.endHook !== true)
        throw "Not supported endHook value: " + obj.endHook;

    if (typeof(dryRun) === "undefined")
        dryRun = false;

    var szPre = obj.preEntries.length;
    var szPost = obj.postEntries.length;
    if (obj.alwaysHook !== true && szPre + szPost === 0)
        return;

    function entryToAsm(obj)
    {
        if (typeof(obj.code) === "undefined")
            return exe.insertAsmTextObj(obj.text, obj.vars, 5, dryRun);
        else
            return obj;
    }

    function convertArray(entries)
    {
        var sz = entries.length;
        for (var i = 0; i < sz; i ++)
        {
            obj.allEntries.push(entryToAsm(entries[i]));
        }
    }

    obj.allEntries = [];

    consoleLog("hooks.applyFinal add pre entries");
    convertArray(obj.preEntries);

    consoleLog("hooks.applyFinal add stolen entry");
    obj.allEntries.push(entryToAsm(obj.stolenEntry));

    consoleLog("hooks.applyFinal add post entries");
    convertArray(obj.postEntries);

    consoleLog("hooks.applyFinal add final entry");
    if (obj.finalEntry !== false)
    {
        var entry = entryToAsm(obj.finalEntry);
        entry.isFinal = obj.finalEntry.isFinal;
        obj.allEntries.push(entry);
    }

    var sz = obj.allEntries.length;
    if (sz == 0)
        throw "No entried in hook object";

    consoleLog("hooks.applyFinal initial jmp");
    if (dryRun !== true)
        exe.setJmpRaw(obj.patchAddr, obj.allEntries[0].free);

    consoleLog("hooks.applyFinal loop jumps");
    for (var i = 0; i < sz - 1; i ++)
    {
        var entry = obj.allEntries[i];
        var nextEntry = obj.allEntries[i + 1];
        if (entry.isFinal === true)
            continue;
        if (dryRun !== true)
            exe.setJmpRaw(entry.free + entry.bytes.length, nextEntry.free);
    }
    var lastEntry = obj.allEntries[sz - 1];
    if (lastEntry.isFinal === false)
    {
        throw "Not supported non final last entry";
    }
}

function hooks_applyAllFinal()
{
    storage.zero = exe.findZeros(0x1000);
    for (var patchAddr in storage.hooks)
    {
        hooks_applyFinal(storage.hooks[patchAddr]);
    }
}

function hooks_removePatchHooks()
{
    consoleLog("hooks.removePatchHooks start");
    var name = patch.getName();

    if (!(name in storage.multiHooks))
        return;

    function filterArray(obj)
    {
        return obj.patch != name;
    }

    consoleLog("hooks.removePatchHooks filter patches");

    for (var patchAddr in storage.hooks)
    {
        var obj = storage.hooks[patchAddr];
        obj.preEntries = obj.preEntries.filter(filterArray);
        obj.postEntries = obj.postEntries.filter(filterArray);
    }
    consoleLog("hooks.removePatchHooks end");
}

function registerHooks()
{
    hooks = new Object();
    hooks.matchFunctionStart = hooks_matchFunctionStart;
    hooks.matchFunctionEnd = hooks_matchFunctionEnd;
    hooks.addPostEndHook = hooks_addPostEndHook;
    hooks.initHook = hooks_initHook;
    hooks.initEndHook = hooks_initEndHook;
    hooks.initTableEndHook = hooks_initTableEndHook;
    hooks.applyFinal = hooks_applyFinal;
    hooks.applyAllFinal = hooks_applyAllFinal;
    hooks.removePatchHooks = hooks_removePatchHooks;
}
