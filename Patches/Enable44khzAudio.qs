function Enable44khzAudio ()
{
  //Step 1 - Find the code assign sampling frequency
  var code =
      " C7 86 AB AB 00 00 40 1F 00 00" //0 mov dword ptr [esi+x],1F40h  (8000)
    + " EB 16"                         //10 jmp short
    + " C7 86 AB AB 00 00 11 2B 00 00" //12 mov dword ptr [esi+x],2B11h (11025)
    + " EB 0A"                         //22 jmp short
    + " C7 86 AB AB 00 00 22 56 00 00" //24 mov dword ptr [esi+x],5622h (22050)
    ;

  var patchOffset = 30;
  var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
  if (offset === -1)
    return "Failed in Step 1";

  //Step 2 - Replace 22050 with 44100.
  exe.replace(offset + patchOffset, " 44 AC 00 00", PTYPE_HEX); //44100

  return true;
}
