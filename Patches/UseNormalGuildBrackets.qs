//#############################################
//# Purpose: Change the 『 』 brackets to ( ) #
//#############################################

function UseNormalGuildBrackets()
{

  //Step 1 - Find the format string used for displaying Guild names
  var offset = pe.stringRaw("%s\xA1\xBA%s\xA1\xBB");
  if (offset === -1)
    return "Failed in Step 1";

  //Step 2 - Change the brackets to regular parentheses + blanks
  //         (since we are converting from UNICODE to ASCII 1 extra byte would be there for each korean character)
  pe.replace(offset, "%s (%s) ");

  return true;
}