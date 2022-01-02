/**
 * Infinite intravision patch
 * Author: Secret <secret@rathena.org>
 * version: 2017-12-31
 **/
function Intravision()
{
    var code =
        " 0F 84 ?? ?? ?? ??"    // JZ a
    +   " 83 C0 ??"             // ADD EAX, offset  ; Vary, 14 in 2017 clients
    +   " 3B C1"                // CMP EAX, ECX
    +   " 75"                   // JNZ loop_start
    ;

    var offset = pe.findCode(code);

    if (offset === -1)
        return "Failed in Step 1";

    pe.replaceHex(offset, " 90 E9");

    return true;
}
