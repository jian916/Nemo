//########################################################################
//# Purpose: Hijack CreateFontA function calls to change the pushed Font #
//#          height before Jumping to actual CreateFontA                 #
//########################################################################

function ResizeFont()
{
    var newHeight = exe.getUserInput("$newFontHgt", XTYPE_BYTE,
        _("Number Input"),
        _("Enter the new Font Height(1-127) - snaps to closest valid value"),
        10, 1, 127);
    if (newHeight === 10)
        return "Patch Cancelled - New value is same as old";

    var vars = {
        "newHeight": newHeight
    }

    var hooksList = hooks.initImportCallHooks("CreateFontA", "GDI32.dll");
    if (hooksList.length === 0)
        throw "CreateFontA call usages not found";
    hooksList.addFilePre("", vars);
    hooksList.validate();

    hooksList = hooks.initImportJmpHooks("CreateFontA", "GDI32.dll");
    hooksList.addFilePre("", vars);
    hooksList.validate();

    return true;
}
