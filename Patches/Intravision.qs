/**
 * Infinite intravision patch
 * Author: Secret <secret@rathena.org>
 * version: 2017-12-31
 **/
function Intravision()
{
    var code =
        " 0F 84 AB AB AB AB"    // JZ a
    +   " 83 C0 AB"             // ADD EAX, offset  ; Vary, 14 in 2017 clients
    +   " 3B C1"                // CMP EAX, ECX
    +   " 75"                   // JNZ loop_start
    ;

    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");

    if (offset === -1)
        return "Failed in Step 1";

    exe.replace(offset, " 90 E9", PTYPE_HEX);

    return true;
}
