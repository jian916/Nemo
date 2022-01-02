function floatToHex(value)
{
    return floatToDWord(value).packToHex(4);
}

function enablePatchAndCheck(name)
{
    if (isPatchActive(name) !== true)
    {
        enablePatch(name);
        if (isPatchActive(name) !== true)
            throw "Patch '" + name + "' must be enabled";
    }
}

function isOneOfPatchesActive()
{
    var args = Array.prototype.slice.call(arguments);

    for (var idx = 0; idx < args.length; idx ++)
    {
        if (isPatchActive(args[idx]) === true)
            return true;
    }
    return false;
}

function enableOneOfPatchAndCheck()
{
    if (isOneOfPatchesActive(arguments) === true)
        return;
    var args = Array.prototype.slice.call(arguments);
    var str = "";
    for (var idx = 0; idx < args.length; idx ++)
    {
        var name = args[idx];
        enablePatch(name);
        if (isPatchActive(name) === true)
            return;
        str = str + " " + name;
    }
    throw "One of patches '" + str + "' must be enabled";
}

function partialCheckRetNeg(func, num)
{
    if (typeof(num) === "undefined")
        num = 0;
    var proxyFunc = function check1()
    {
        var args = Array.prototype.slice.call(arguments);
        var res = func.apply(func, args);
        if (res < 0)
            throw "Error: " + args[num] + " not found";
        return res;
    }
    return proxyFunc;
}
