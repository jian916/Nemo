//##################################################################
//# Purpose: Change the JZ to JMP after the LangType comparison in #
//#          CLoginMode::OnUpdate function.                        #
//##################################################################

function EnforceOfficialLoginBackground()
{

  //Step 1 - Find the comparisons
  var code =
    " 74 ??"    //JZ SHORT addr -> prep for UIWindowMgr::RenderTitleGraphic
  + " 83 F8 04" //CMP EAX, 04
  + " 74 ??"    //JZ SHORT addr -> prep for UIWindowMgr::RenderTitleGraphic
  + " 83 F8 08" //CMP EAX, 08
  + " 74 ??"    //JZ SHORT addr -> prep for UIWindowMgr::RenderTitleGraphic
  + " 83 F8 09" //CMP EAX, 09
  + " 74 ??"    //JZ SHORT addr -> prep for UIWindowMgr::RenderTitleGraphic
  + " 83 F8 0E" //CMP EAX, 0E
  + " 74 ??"    //JZ SHORT addr -> prep for UIWindowMgr::RenderTitleGraphic
  + " 83 F8 03" //CMP EAX, 03
  + " 74 ??"    //JZ SHORT addr -> prep for UIWindowMgr::RenderTitleGraphic
  + " 83 F8 0A" //CMP EAX, 0A
  + " 74 ??"    //JZ SHORT addr -> prep for UIWindowMgr::RenderTitleGraphic
  + " 83 F8 01" //CMP EAX, 01
  + " 74 ??"    //JZ SHORT addr -> prep for UIWindowMgr::RenderTitleGraphic
  + " 83 F8 0B" //CMP EAX, 0B
  ;

  var offsets = pe.findCodes(code);
  if (offsets.length === 0) //newer clients
  {
    code = code.replace(" 83 F8 0E 74 ??", "");   //remove CMP EAX, 0E and JZ SHORT addr
    offsets = pe.findCodes(code);
  }
  if (offsets.length === 0)
    return "Failed in Step 1";

  //Step 2 - Replace first JZ to JMP for all the matches
  for (var i = 0; i < offsets.length; i++)
  {
    pe.replaceByte(offsets[i], 0xEB);
  }

  return true;
}