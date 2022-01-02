//############################################
//# Purpose: Replace guild chat color inside #
//#          CGameMode::Zc_guild_chat        #
//############################################

function ChatColorGuild()
{

  //Step 1 - Find the area where color is pushed
  var code =
    " 6A 04"          //PUSH 4
  + " 68 B4 FF B4 00" //PUSH B4,FF,B4 (Light Green)
  ;
  var offset = pe.findCode(code);

  if (offset === -1)
{
    code = code.replace(" 6A 04", " 6A 04 8D ?? ?? ?? FF FF");  // insert LEA reg32_A, [EBP-x] after PUSH 4
    offset = pe.findCode(code);
  }

  if (offset === -1)
    return "Failed in Step 1";

  //Step 2a - Get new color from user
  var color = exe.getUserInput("$guildChatColor", XTYPE_COLOR, _("Color input"), _("Select the new Guild Chat Color"), 0x00B4FFB4);
  if (color === 0x00B4FFB4)
    return "Patch Cancelled - New Color is same as old";

  //Step 2b - Replace with new color
  pe.replaceDWord(offset + code.hexlength() - 4, color);

  return true;
}

//###################################################
//# Purpose: Replace all the colors assigned for GM #
//#          inside CGameMode::Zc_Notify_Chat       #
//###################################################

function ChatColorGM()
{

  //Step 1a - Find the unique color FF, 8D, 1D (Orange) PUSH for langtype 11
  var offset1 = pe.findCode("68 FF 8D 1D 00");
  if (offset1 === -1)
    return "Failed in Step 1 - Orange color not found";

  //Step 1b - Find FF, FF, 00 (Cyan) PUSH in the vicinity of Orange
  var offset2 = pe.find("68 FF FF 00 00", offset1 - 0x30, offset1 + 0x30);
  if (offset2 === -1)
    return "Failed in Step 1 - Cyan not found";

  //Step 1c - Find 00, FF, FF (Yellow) PUSH in the vicinity of Orange
  var offset3 = pe.find("68 00 FF FF 00", offset1 - 0x30, offset1 + 0x30);
  if (offset3 === -1)
    return "Failed in Step 1 - Yellow not found";

  //Step 2a - Get the new color from user
  var color = exe.getUserInput("$gmChatColor", XTYPE_COLOR, _("Color input"), _("Select the new GM Chat Color"), 0x0000FFFF);
  if (color === 0x0000FFFF)
    return "Patch Cancelled - New Color is same as old";

  //Step 2b - Replace all the colors with new color
  pe.replaceDWord(offset1 + 1, color);
  pe.replaceDWord(offset2 + 1, color);
  pe.replaceDWord(offset3 + 1, color);

  return true;
}

//###################################################
//# Purpose: Replace Chat color assigned for Player #
//#          inside CGameMode::Zc_Notify_PlayerChat #
//###################################################

function ChatColorPlayerSelf()
{ //N.B. - Check if it holds good for old client. Till 2010 no issue is there.

  //Step 1a - Find PUSH 00,78,00 (Dark Green) offsets (the required Green color PUSH is within the vicinity of one of these)
  var offsets = pe.findCodes(" 68 00 78 00 00");
  if (offsets.length === 0)
    return "Failed in Step 1 - Dark Green missing";

  //Step 1b - Find the Green color push.
  for (var i = 0; i < offsets.length; i++)
  {
    var offset = pe.find(" 68 00 FF 00 00", offsets[i] + 5, offsets[i] + 40);
    if (offset !== -1) break;
  }

  if (offset === -1)
    return "Failed in Step 1 - Green not found";

  //Step 2a - Get the new color from user
  var color = exe.getUserInput("$yourChatColor", XTYPE_COLOR, _("Color input"), _("Select the new Self Chat Color"), 0x0000FF00);
  if (color === 0x0000FF00)
    return "Patch Cancelled - New Color is same as old";

  //Step 2b - Replace with new color
  pe.replaceDWord(offset + 1, color);

  return true;
}

//############################################################
//# Purpose: Replace Chat color assigned for Player inside   #
//#          CGameMode::Zc_Notify_Chat for received messages #
//############################################################

function ChatColorPlayerOther()
{

  //Step 1 - Find the area where color is pushed.
  var code =
    " 6A 01"           //PUSH 1
  + " 68 FF FF FF 00"  //PUSH FF,FF,FF (White)
  ;
  var offset = pe.findCode(code);
  if (offset === -1)
    return "Failed in Step 1";

  //Step 2a - Get the new color from user
  var color = exe.getUserInput("$otherChatColor", XTYPE_COLOR, _("Color input"), _("Select the new Other Player Chat Color"), 0x00FFFFFF);
  if (color === 0x00FFFFFF)
    return "Patch Cancelled - New Color is same as old";

  //Step 2b - Replace with new color
  pe.replaceDWord(offset + code.hexlength() - 4, color);

  return true;
}

//###################################################
//# Purpose: Replace Chat color assigned for Player #
//#          inside CGameMode::Zc_Notify_Chat_Party #
//###################################################

function ChatColorPartySelf()
{

  //Step 1 - Find the area where color is pushed
  var code =
    " 6A 03"          //PUSH 3
  + " 68 FF C8 00 00" //PUSH FF,C8,00 (Yellowish Brown)
  ;
  var offset = pe.findCode(code);

  if (offset === -1)
  {
    code = code.replace(" 6A 03", " 6A 03 8D ?? ?? ?? FF FF"); //insert LEA reg32_A, [EBP-x] after PUSH 3
    offset = pe.findCode(code);
  }

  if (offset === -1)
    return "Failed in Step 1";

  //Step 2a - Get the new color from user
  var color = exe.getUserInput("$yourpartyChatColor", XTYPE_COLOR, _("Color input"), _("Select the new Self Party Chat Color"), 0x0000C8FF);
  if (color === 0x0000C8FF)
    return "Patch Cancelled - New Color is same as old";

  //Step 2b - Replace with new color
  pe.replaceDWord(offset + code.hexlength() - 4, color);

  return true;
}

//################################################################
//# Purpose: Replace Chat color assigned for Player inside       #
//#          CGameMode::Zc_Notify_Chat_Party for Member messages #
//################################################################

function ChatColorPartyOther()
{

  //Step 1a - Find the area where color is pushed
  var code =
    " 6A 03"          //PUSH 3 ; old clients have an extra instruction after this one
  + " 68 FF C8 C8 00" //PUSH FF,C8,C8 (Light Pink)
  ;
  var offset = pe.findCode(code);

  if (offset === -1)
  {
    code = code.replace(" 6A 03", " 6A 03 8D ?? ?? ?? FF FF"); //insert LEA reg32_A, [EBP-x] after PUSH 3
    offset = pe.findCode(code);
  }

  if (offset === -1)
    return "Failed in Step 1";

  //Step 2a - Get the new color from user
  var color = exe.getUserInput("$otherpartyChatColor", XTYPE_COLOR, _("Color input"), _("Select the new Others Party Chat Color"), 0x00C8C8FF);
  if (color === 0x00C8C8FF)
    return "Patch Cancelled - New Color is same as old";

  //Step 2b - Replace with new color
  pe.replaceDWord(offset + code.hexlength() - 4, color);

  return true;
}

//ChatColorMain - is included in ChatColorGM so it makes it pointless


function HighlightSkillSlotColor()
{
    consoleLog("Step 1 - Find the area where color is pushed.");
    var code =
        "0F B6 0D ?? ?? ?? ?? " +  // 00 movzx ecx, g_session.m_shortcutSlotCnt
        "6B ?? 1D " +              // 07 imul edx, 1Dh
        "68 B4 FF B4 00 " +        // 10 push 0B4FFB4h
        "8B ?? " +                 // 15 mov eax, ecx
        "6A 18 " +                 // 17 push 18h
        "83 C1 05 ";               // 19 add ecx, 5
    var shortcutSlotCntOffset = [3, 4];
    var slotCx2Offset = [9, 1];
    var colorOffset = [11, 4];
    var slotCyOffset = [18, 1];
    var yOffsetOffset = [21, 1];
    var offset = pe.findCode(code);

    if (offset === -1)
    {
        code =
            "0F B6 0D ?? ?? ?? ?? " +  // 00 movzx ecx, g_session.m_shortcutSlotCnt
            "6B ?? 1D " +              // 07 imul edx, 1Dh
            "8B ?? " +                 // 10 mov eax, ecx
            "68 B4 FF B4 00 " +        // 12 push 0B4FFB4h
            "6A 18 " +                 // 17 push 18h
            "83 C1 05 ";               // 19 add ecx, 5
        shortcutSlotCntOffset = [3, 4];
        slotCx2Offset = [9, 1];
        colorOffset = [13, 4];
        slotCyOffset = [18, 1];
        yOffsetOffset = [21, 1];
        offset = pe.findCode(code);
    }

    if (offset === -1)
        return "Failed in Step 1 - Pattern not found";

    logFieldAbs("CSession::m_shortcutSlotCnt", offset, shortcutSlotCntOffset);
    logVal("UIShortCutWnd slot2 cx", offset, slotCx2Offset);
    logVal("UIShortCutWnd slot cy", offset, slotCyOffset);
    logVal("UIShortCutWnd slot color", offset, colorOffset);
    logVal("UIShortCutWnd slot y offset", offset, yOffsetOffset);

    consoleLog("Step 2a - Get the new color from user");
    var color = exe.getUserInput("$HSkillSColor", XTYPE_COLOR, _("Color input"), _("Select new Highlight Skillslot Color"), 0x00B4FFB4);
    if (color === 0x00B4FFB4)
        return "Patch Cancelled - New Color is same as old";

    consoleLog("Step 2b - Replace with new color");
    pe.replaceDWord(offset + colorOffset[0], color);

    return true;
}
