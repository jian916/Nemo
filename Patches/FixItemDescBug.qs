//######################################################################
//#        Purpose: Fix Item Description '[' Bug                       #
//######################################################################

function FixItemDescBug()
{
  var code =
    " 80 3E 5B"  //0 cmp byte ptr [esi],5Bh
  + " 75 ??"     //3 jnz short
  + " 8B"        //5 mov reg[arg8]
  ;
  var patchLoc = 3;
  var offset = pe.findCode(code);
  if (offset === -1)
  {
    code =
      " 3C 5B"  //0 cmp al,5Bh
    + " 75 ??"  //2 jnz short
    + " 8B"     //4 mov reg,[ebp+x]
    ;
  patchLoc = 2;
  offset = pe.findCode(code);
  }
  if (offset === -1)
    return "Failed in Step 1 - '[' string compare missing";

  pe.replaceByte(offset + patchLoc, 0xEB);

  return true;
}

