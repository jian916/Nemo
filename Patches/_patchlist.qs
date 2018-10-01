//===============================================================================================================//
// Register all your Patches and Patch groups in this file. Always register group before using its id in a patch //
//===============================================================================================================//

//###################################################################################################
//#                                                                                                 #
//# FORMAT for registering group : registerGroup(group id, group Name, mutualexclude [true/false]); #
//#                                                                                                 #
//# If you wish that only 1 patch can be active at a time (default) put mutualexclude as true       #
//#                                                                                                 #
//###################################################################################################

registerGroup( 0, "通用", false);

registerGroup( 1, "聊天限制", true);

registerGroup( 2, "修正視角角度", true);

registerGroup( 3, "擴增視角距離", true);

registerGroup( 4, "使用圖示", true);

registerGroup( 5, "GRF管理", true);

registerGroup( 6, "共用染色", true)

registerGroup( 7, "共用染色", true);

registerGroup( 8, "登入背景", true);

registerGroup( 9, "封包混淆", false);

registerGroup(10, "登入模式", true);

registerGroup(11, "點數商城", true);

registerGroup(12, "隱藏按鈕", false);

registerGroup(14, "授權介面", true);

registerGroup(15, "復活相關", true);

registerGroup(16, "移動延遲", true);

registerGroup(17, "起源版", false);

registerGroup(18, "自訂技能", false);

registerGroup(19, "路徑", false);

//#########################################################################################################################################################
//#                                                                                                                                                       #
//# FORMAT for registering patch : registerPatch(patch id, functionName, patch Name, category, group id, author, description, recommended [true/false] ); #
//#                                                                                                                                                       #
//#  functionName is the function called when a patch is enabled. All your logic goes inside it.                                                          #
//#  You can define your function in any .qs file in the patches folder.                                                                                  #
//#  Remember the functionName needs to be in quotes (single or double) here but no quotes should be used while defining it.                              #
//#                                                                                                                                                       #
//#########################################################################################################################################################

//==========================================================================================================================//
// Note:                                                                                                                    //
// Currently some of the ids are not used in between (probably some patches were removed/disabled due to errors/deprecated) //
// It would be safer to not use those IDs for your own Patches to avoid any future conflict.                                //
//==========================================================================================================================//

//0 Unused - to be filled
registerPatch(  1, "UseTildeForMatk", "Use Tilde for Matk", "UI", 0, "Neo", "Make the client use tilde (~) symbol for Matk in Stats Window instead of Plus (+)", false);

registerPatch(  2, "AllowChatFlood", "發話洗頻次數限制設定", "UI", 1, "Shinryo", "設定發話洗頻的限制，預設是只能發3次一樣內容", false);

registerPatch(  3, "RemoveChatLimit", "發話洗頻限制關閉", "UI", 1, "Neo", "取消發話洗頻的限制(設定次數限制的選項會取消)", false);

registerPatch(  4, "CustomAuraLimits", "Use Custom Aura Limits", "UI", 0, "Neo", "Allows the client to display standard auras within user specified limits for Classes and Levels", false);

registerPatch(  5, "EnableProxySupport", "Enable Proxy Support", "Fix", 0, "Ai4rei/AN", "Ignores server-provided IP addresses when changing servers", false);

registerPatch(  6, "ForceSendClientHash", "Force Send Client Hash Packet", "Packet", 0, "GreenBox, Neo", "Forces the client to send a packet with it's MD5 hash for all LangTypes. Only use if you have enabled it in your server", false);

//registerPatch(  7, "ChangeGravityErrorHandler", "Change Gravity Error Handler", "Fix", 0, " ", "It changes the Gravity Error Handler Mesage for a Custom One Pre-Defined by Diff Team", false);

registerPatch(  8, "CustomWindowTitle", "修改登入器標題", "UI", 0, "Shinryo", "修改登入器的標題(不支援中文，中文要用16進制自行修改)，預設為 'Ragnarok'", false);

registerPatch(  9, "Disable1rag1Params", "不用1rag1直接啟動遊戲", "Fix", 0, "Shinryo", "不用 1rag1 參數就可以直接啟動遊戲", true);

registerPatch( 10, "Disable4LetterCharnameLimit", "取消角色名最少4個字限制", "Fix", 0, "Shinryo", "取消角色名稱最少4個字的限制(伺服端還是有限制)", false);

registerPatch( 11, "Disable4LetterUsernameLimit", "取消帳號最少4個字限制", "Fix", 0, "Shinryo", "取消帳號最少4個字的限制(伺服端還是有限制)", false);

registerPatch( 12, "Disable4LetterPasswordLimit", "取消密碼最少4個字限制", "Fix", 0, "Shinryo", "取消密碼最少4個字的限制(伺服端還是有限制)", false);

registerPatch( 13, "DisableFilenameCheck", "Disable Ragexe Filename Check", "Fix", 0, "Shinryo", "Disables the check that forces the client to quit if not called an official name like ragexe.exe for all LangTypes", true);

registerPatch( 14, "DisableHallucinationWavyScreen", "Disable Hallucination Wavy Screen", "Fix", 0, "Shinryo", "Disables the Hallucination effect (screen becomes wavy and lags the client), used by baphomet, horongs, and such", true);

registerPatch( 15, "DisableHShield", "關閉駭客保護程式", "Fix", 0, "Ai4rei/AN, Neo", "關閉駭客保護程式，要 Diff 就一定要關閉(它會吃 aossdk.dll v3hunt.dll)", true);

registerPatch( 16, "DisableSwearFilter", "Disable Swear Filter", "UI", 0, "Shinryo", "The content of manner.txt has no impact on ability to send text", false);

registerPatch( 17, "EnableOfficialCustomFonts", "Enable Official Custom Fonts", "UI", 0, "Shinryo", "This option forces Official Custom Fonts (eot files int data folder) on all LangType", false);

registerPatch( 18, "SkipServiceSelect", "Skip Service Selection Screen", "UI", 0, "Shinryo", "Jumps directly to the login interface without asking to select a service", false);

registerPatch( 19, "EnableTitleBarMenu", "Enable Title Bar Menu", "UI", 0, "Shinryo", "Enable Title Bar Menu (Reduce, Maximize, Close button) and the window icon", false);

registerPatch( 20, "ExtendChatBox", "Extend Chat Box", "UI", 0, "Shinryo", "Extend the Main/Battle chat box max input chars from 70 to 234", false);

registerPatch( 21, "ExtendChatRoomBox", "Extend Chat Room Box", "UI", 0, "Shinryo", "Extend the chat room box max input chars from 70 to 234", false);

registerPatch( 22, "ExtendPMBox", "Extend PM Box", "UI", 0, "Shinryo", "Extend the PM chat box max input chars from 70 to 221", false);

registerPatch( 23, "EnableWhoCommand", "Enable /who command", "UI", 0, "Neo", "Enable /w and /who command for all LangTypes", true);

registerPatch( 24, "FixCameraAnglesRecomm", "Fix Camera Angles", "UI", 2, "Shinryo", "Unlocks the possible camera angles to give more freedom of placement. Gives a medium range of around 60 degrees", true);

registerPatch( 25, "FixCameraAnglesLess", "Fix Camera Angles (LESS)", "UI", 2, "Shinryo", "Unlocks the possible camera angles to give more freedom of placement. This enables an 30deg angle", false);

registerPatch( 26, "FixCameraAnglesFull", "Fix Camera Angles (FULL)", "UI", 2, "Shinryo", "Unlocks the possible camera angles to give more freedom of placement. This enables an almost ground-level camera", false);

registerPatch( 27, "HKLMtoHKCU", "HKLM To HKCU", "Fix", 0, "Shinryo", "This makes the client use HK_CURRENT_USER registry entries instead of HK_LOCAL_MACHINE. Necessary for users who have no admin privileges on their computer", false);

registerPatch( 28, "IncreaseViewID", "Increase Headgear ViewID", "Data", 0, "Shinryo", "Increases the limit for the headgear ViewIDs from 2000 to User Defined value (max 32000)", false);

registerPatch( 29, "DisableGameGuard", "Disable Game Guard", "Fix", 0, "Neo", "Disables Game Guard from new clients", true);

registerPatch( 30, "IncreaseZoomOut50Per", "Increase Zoom Out 50%", "UI", 3, "Shinryo", "Increases the zoom-out range by 50 percent", false);

registerPatch( 31, "IncreaseZoomOut75Per", "Increase Zoom Out 75%", "UI", 3, "Shinryo", "Increases the zoom-out range by 75 percent", false);

registerPatch( 32, "IncreaseZoomOutMax", "Increase Zoom Out Max", "UI", 3, "Shinryo", "Maximizes the zoom-out range", false);

registerPatch( 33, "KoreaServiceTypeXMLFix", "Always Call SelectKoreaClientInfo()", "Fix", 0, "Shinryo", "Calls SelectKoreaClientInfo() always before SelectClientInfo() allowing you to use features that would be only visible on Korean Service Type", true);

registerPatch( 34, "EnableShowName", "Enable /showname", "Fix", 0, "Neo", "Enables use of /showname command on all LangTypes", true);

registerPatch( 35, "ReadDataFolderFirst", "Read Data Folder First", "Data", 0, "Shinryo", "Gives the data directory contents priority over the data/sdata.grf contents", false);

registerPatch( 36, "ReadMsgstringtabledottxt", "Read msgstringtable.txt", "Data", 0, "Shinryo", "This option will force the client to read all the user interface messages from msgstringtable.txt instead of displaying the Korean messages", true);

registerPatch( 37, "ReadQuestid2displaydottxt", "Read questid2display.txt", "Data", 0, "Shinryo", "Makes the client to load questid2display.txt on all LangTypes (instead of only 0)", true);

registerPatch( 38, "RemoveGravityAds", "Remove Gravity Ads", "UI", 0, "Shinryo", "Removes Gravity ads on the login background", true);

registerPatch( 39, "RemoveGravityLogo", "Remove Gravity Logo", "UI", 0, "Shinryo", "Removes Gravity Logo on the login background", true);

registerPatch( 40, "RestoreLoginWindow", "Restore Login Window", "Fix", 10, "Shinryo, Neo", "Circumvents Gravity's new token-based login system and restores the normal login window", true);

registerPatch( 41, "DisableNagleAlgorithm", "關閉Nagle演算法", "Packet", 0, "Shinryo", "取消Nagle演算法，Nagle簡單講是緩衝演算法(資料到達一定的量才會一並傳輸)，使用此演算法可以減少網路傳輸量，但會增加延遲，以目前網路頻寬來講沒有差這一點，所以會勾選", true);

registerPatch( 42, "SkipResurrectionButton", "Skip Resurrection Button", "UI", 15, "Shinryo", "Skip showing resurrection button when you die with Token of Ziegfried in inventory", false);

registerPatch( 43, "DeleteCharWithEmail", "刪除角色使用信箱當密碼", "Fix", 0, "Neo", "刪除角色時，使用信箱來當密碼，強制所有(langtype)都使用", false);

registerPatch( 44, "TranslateClient", "Translate Client", "UI", 0, "Ai4rei/AN, Neo", "This will translate some of the Hard-coded Korean phrases with strings stored in TranslateClient.txt. It also fixes the Korean Job name issue with LangType", true);

registerPatch( 45, "UseCustomAuraSprites", "Use Custom Aura Sprites", "Data", 0, "Shinryo", "This option will make it so your warp portals will not be affected by your aura sprites. For this you will have to make aurafloat.tga and auraring.bmp and place them in your 'data\\texture\\effect' folder", false);

registerPatch( 46, "UseNormalGuildBrackets", "Use Normal Guild Brackets", "UI", 0, "Shinryo", "On LangType 0, instead of square-brackets, japanese style brackets are used, this option reverts that behaviour to the normal square brackets '[' and ']'", true);

registerPatch( 47, "UseRagnarokIcon", "Use Ragnarok Icon", "UI", 4, "Shinryo, Neo", "Makes the hexed client use the RO program icon instead of the generic Win32 app icon", false);

registerPatch( 48, "UsePlainTextDescriptions", "Use Plain Text Descriptions", "Data", 0, "Shinryo", "Signals that the contents of text files are text files, not encoded", true);

registerPatch( 49, "EnableMultipleGRFs", "Enable Multiple GRFs", "UI", 5, "Shinryo", "Enables the use of multiple grf files by putting them in a data.ini file in your client folder.You can only load up to 10 total grf files with this option ( -9)", true);

registerPatch( 50, "SkipLicenseScreen", "Skip License Screen", "UI", 14, "Shinryo, MS", "Skip the warning screen and goes directly to the main window with the Service Select", false);

registerPatch( 51, "ShowLicenseScreen", "啟動時顯示授權條款", "UI", 14, "Neo", "登入時顯示授權條款，強制所有(langtype)都顯示", false);

registerPatch( 52, "UseCustomFont", "Use Custom Font", "UI", 0, "Ai4rei/AN", "Allows the use of user-defined font for all LangTypes. The LangType-specific charset is still being enforced, so if the selected font does not support it, the system falls back to a font that does", false);

registerPatch( 53, "UseAsciiOnAllLangTypes", "Use Ascii on All LangTypes", "UI", 0, "Ai4rei/AN", "Makes the Client Enable ASCII irrespective of Font or LangTypes", true);

registerPatch( 54, "ChatColorGM", "修改GM訊息文字顏色", "Color", 0, "Ai4rei/AN, Shakto", "改變 GM 聊天視窗文字的顏色，預設值為 FFFF00 (黃色)", false);

registerPatch( 55, "ChatColorPlayerOther", "修改一般訊息文字顏色", "Color", 0, "Ai4rei/AN, Shakto", "改變 一般對話 聊天視窗文字的顏色，預設值為 FFFFFF (白色)" );

//Disabled since GM Chat Color also patches the Main color - to be removed
//registerPatch( 56, "ChatColorMain", "Chat Color - Main", "Color", 0, "Ai4rei/AN, Shakto", "Changes the Main Chat color and sets it to the specified value", false);

registerPatch( 57, "ChatColorGuild", "修改公會訊息文字顏色", "Color", 0, "Ai4rei/AN, Shakto", "改變 公會 聊天視窗文字的顏色，預設值為 B4FFB4 (亮綠色)", false);

registerPatch( 58, "ChatColorPartyOther", "修改組隊其他人訊息文字顏色", "Color", 0, "Ai4rei/AN, Shakto", "改變 組隊其他人 聊天視窗文字的顏色，預設值為 FFC8C8 (粉紅色)", false);

registerPatch( 59, "ChatColorPartySelf", "修改組隊自己發言文字顏色", "Color", 0, "Ai4rei/AN, Shakto", "改變 組隊自己發言 的顏色，預設值為 FFC800 (橘色)", false);

registerPatch( 60, "ChatColorPlayerSelf", "修改自己發言文字顏色", "Color", 0, "Ai4rei/AN, Shakto", "改變 自己發言 的聊天視窗文字顏色，預設值為 00FF00 (綠色)", false);

registerPatch( 61, "DisablePacketEncryption", "關閉封包混淆", "UI", 0, "Ai4rei/AN", "取消封包混淆，此功能並不是加密，而是讓每個封包有一個隨機流水號，只要跟伺服端沒有對應就無法連線", false);

registerPatch( 62, "DisableLoginEncryption", "Disable Login Encryption", "Fix", 0, "Neo", "Disable Encryption in Login Packet 0x2b0", true);

registerPatch( 63, "UseOfficialClothPalette", "Use Official Cloth Palettes", "UI", 0, "Neo", "Use Official Cloth Palette on all LangTypes. Do not use this if you are using the 'Enable Custom Jobs' patch", false);

registerPatch( 64, "FixChatAt", "修復 @ 符號 Bug", "UI", 0, "Shinryo", "修復聊天視窗不能輸入 @ 的限制", true);

registerPatch( 65, "ChangeItemInfo", "Load Custom lua file instead of iteminfo*.lub", "自訂", 19, "Neo", "Makes the client load your own lua file instead of iteminfo*.lub . If you directly use itemInfo*.lub for your translated items, it may become lost during the next kRO update", true);

registerPatch( 66, "LoadItemInfoPerServer", "Load iteminfo with char server", "Data", 0, "Neo", "Load ItemInfo file and call main function with selected char server name as argument", false);

registerPatch( 67, "DisableQuakeEffect", "取消技能震動效果", "UI", 0, "Ai4rei/AN", "取消技能震動效果、地裂、爆氣等等", false);

registerPatch( 68, "Enable64kHairstyle", "Enable 64k Hairstyle", "UI", 0, "Ai4rei/AN", "Increases Max Hairstyle limit to 64k from default 27", false);

registerPatch( 69, "ExtendNpcBox", "Extend Npc Dialog Box", "UI", 0, "Ai4rei/AN", "Increases Max input chars of NPC Dialog boxes from 2052 to 4096", false);

registerPatch( 70, "CustomExpBarLimits", "Use Custom Exp Bar Limits", "UI", 0, "Neo", "Allows client to use user specified limits for Exp Bars", false);

registerPatch( 71, "IgnoreResourceErrors", "Ignore Resource Errors", "Fix", 0, "Shinryo", "Prevents the client from displaying a variety of Error messages (but not all of them) including missing files. This does not guarantee the client will work in-spite of missing files", false);

registerPatch( 72, "IgnoreMissingPaletteError", "Ignore Missing Palette Error", "Fix", 0, "Shinryo", "Prevents the client from displaying error messages about missing palettes. It does not guarantee client will not crash if files are missing", false);

registerPatch( 73, "RemoveHourlyAnnounce", "Remove Hourly Announce", "UI", 0, "Ai4rei/AN", "Remove hourly game grade and hourly play time minder announcements", true);

registerPatch( 74, "IncreaseScreenshotQuality", "Increase Screenshot Quality", "UI", 0, "Ai4rei/AN", "Allows changing the JPEG quality parameter for screenshots", false);

registerPatch( 75, "EnableFlagEmotes", "Enable Flag Emoticons", "UI", 0, "Neo", "Enable Selected Flag Emoticons for all LangTypes. You need to specify a txt file as input with the flag constants assigned to 1-9", false);

registerPatch( 76, "EnforceOfficialLoginBackground", "Enforce Official Login Background", "UI", 0, "Shinryo", "Enforce Official Login Background for all LangType", false);

registerPatch( 77, "EnableCustom3DBones", "Enable Custom 3D Bones", "Data", 0, "Ai4rei/AN", "Enables the use of custom 3D monsters (Granny) by lifting Hard-coded ID limit", false);

registerPatch( 78, "MoveCashShopIcon", "Move Cash Shop Icon", "UI",  11, "Neo", "Move the Cash Shop icon to user specified co-ordinates. Positive values are relative to left and top, Negative values are relative to right and bottom", false);

registerPatch( 79, "SharedBodyPalettesV2", "Shared Body Palettes Type2", "UI", 6, "Ai4rei/AN, Neo", "Makes the client use a single cloth palette set (body_%d.pal) for all job classes both genders", false);

registerPatch( 80, "SharedBodyPalettesV1", "Shared Body Palettes Type1", "UI", 6, "Ai4rei/AN, Neo", "Makes the client use a single cloth palette set (body_%s_%d.pal) for all job classes but separate for both genders", false);

registerPatch( 81, "RenameLicenseTxt", "Rename License File", "Data", 0, "Neo", "Rename the filename used for EULA from '..\\licence.txt' to user specified name (Path is relative to Data folder)", false);

registerPatch( 82, "SharedHeadPalettesV1", "Shared Head Palettes Type1", "UI", 7, "Ai4rei/AN, Neo", "Makes the client use a single hair palette set (head_%s_%d.pal) for all job classes but separate for both genders", false);

registerPatch( 83, "SharedHeadPalettesV2", "Shared Head Palettes Type2", "UI", 7, "Ai4rei/AN, Neo", "Makes the client use a single hair palette set (head_%d.pal) for all job classes both genders", false);

registerPatch( 84, "RemoveSerialDisplay", "Remove Serial Display", "UI", 0, "Shinryo", "Removes the display of the client serial number in the login window (bottom right corner)", true);

registerPatch( 85, "ShowCancelToServiceSelect","Show Cancel To Service Select", "UI", 0, "Neo", "Restores the Cancel button in Login Window for switching back to Service Select Window. The button will be placed in between Login and Exit buttons", false);

registerPatch( 86, "OnlyFirstLoginBackground", "Only First Login Background", "UI", 8, "Shinryo", "Displays always the first login background", false);

registerPatch( 87, "OnlySecondLoginBackground", "Only Second Login Background", "UI", 8, "Shinryo", "Displays always the second login background", false);

registerPatch( 88, "AllowSpaceInGuildName", "允許公會名稱內有空白", "UI", 0, "Shakto", "允許創公會時，公會名中使用空白 (/guild \"測 試\")", false);

registerPatch( 90, "EnableDNSSupport", "Enable DNS Support", "UI", 0, "Shinryo", "Enable DNS support for clientinfo.xml", true);

registerPatch( 91, "DCToLoginWindow", "Disconnect to Login Window", "UI", 0, "Neo", "Make the client return to Login Window upon disconnection", false);

registerPatch( 92, "PacketFirstKeyEncryption", "Packet First Key Encryption", "Packet", 9, "Shakto, Neo", "Change the 1st key for packet encryption. Dont select the patch Disable Packet Header Encryption if you are using this. Don't use it if you don't know what you are doing", false);

registerPatch( 93, "PacketSecondKeyEncryption", "Packet Second Key Encryption", "Packet", 9, "Shakto, Neo", "Change the 2nd key for packet encryption. Dont select the patch Disable Packet Header Encryption if you are using this. Don't use it if you don't know what you are doing", false);

registerPatch( 94, "PacketThirdKeyEncryption", "Packet Third Key Encryption", "Packet", 9, "Shakto, Neo", "Change the 3rd key for packet encryption. Dont select the patch Disable Packet Header Encryption if you are using this. Don't use it if you don't know what you are doing", false);

registerPatch( 95, "UseSSOLoginPacket", "Use SSO Login Packet", "Packet", 10, "Ai4rei/AN", "Enable using SSO packet on all LangType (to use login and pass with a launcher)", false);

registerPatch( 96, "RemoveGMSprite", "Remove GM Sprites", "UI", 0, "Neo", "Remove the GM sprites and keeping all the functionality like Yellow name and Admin right click menu", false);

registerPatch( 97, "CancelToLoginWindow", "取消返回登入介面", "Fix", 0, "Neo", "在選擇角色時，可以點取消返回登入介面，而不是結束遊戲", true);

registerPatch( 98, "DisableDCScream", "Disable dc_scream.txt", "UI", 0, "Neo", "Disable chat on file dc_scream", false);

registerPatch( 99, "DisableBAFrostJoke", "Disable ba_frostjoke.txt", "UI", 0, "Neo", "Disable chat on file ba_frostjoke", false);

registerPatch(100, "DisableMultipleWindows", "禁止登入器雙開", "UI", 0, "Shinryo, Ai4rei/AN", "禁止登入器雙開(這無法杜絕雙開)", false);

registerPatch(101, "SkipCheaterFriendCheck", "Skip Friend list Cheat Check", "UI", 0, "Ai4rei/AN", "Prevents warnings during PM's when the sender has similar name to one of your friends", false);

registerPatch(102, "SkipCheaterGuildCheck", "Skip Guild Member Cheat Check", "UI", 0, "Ai4rei/AN", "Prevents warnings during PM's when the sender has similar name to one of your guild members", false);

registerPatch(103, "DisableAutofollow", "關閉自動跟隨功能", "UI", 0, "Functor, Neo", "關閉自動跟隨的功能 Shift+右鍵", false);

registerPatch(104, "IncreaseHairLimits", "Increase creation Hair Style & Color Limits", "UI", 0, "Neo", "Modify the limits used in Make Character Window for Hair Style and Color to user specified values");

registerPatch(105, "HideNavButton", "Hide Nav Button", "UI", 12, "Neo", "Hide Navigation Button", false);

registerPatch(106, "HideBgButton", "Hide BG Button", "UI", 12, "Neo", "Hide Battleground Button", false);

registerPatch(107, "HideBankButton", "Hide Bank Button", "UI", 12, "Neo", "Hide Bank Button", false);

registerPatch(108, "HideBooking", "Hide Booking Button", "UI", 12, "Neo", "Hide Booking Button", false);

registerPatch(109, "HideRodex", "Hide Rodex Button", "UI", 12, "Neo", "Hide Rodex Button", false);

registerPatch(110, "HideAchieve", "Hide Achievements Button", "UI", 12, "Neo", "Hide Achievements Button", false);

registerPatch(111, "HideRecButton", "Hide Rec Button", "UI", 12, "Neo", "Hide Rec Button", false);

registerPatch(112, "HideMapButton", "Hide Map Button", "UI", 12, "Neo", "Hide Map Button", false);

registerPatch(113, "HideQuest", "Hide Quest Button", "UI", 12, "Neo", "Hide Quest Button", false);

registerPatch(114, "ChangeVendingLimit", "修改收購商店金額限制[Experimental]", "Data", 0, "Neo", "修改收購商店最多100萬的限制", false);

registerPatch(115, "EnableEffectForAllMaps", "Enable Effect for all Maps [Experimental]", "Data", 0, "Neo", "Make the client load the corresponding file in EffectTool folder for all maps", false);

//registerPatch(151, "UseArialOnAllLangTypes", "Use Arial on All LangTypes", "UI", 0, "Ai4rei/AN, Shakto", "Makes Arial the default font on all LangTypes (it's enable ascii by default)", true);

//FixTetraVortex patch is removed since the black screen animation issue is fixed Server Side

//======================================//
// Special Patches by Neo and Curiosity //
//======================================//

registerPatch(200, "EnableMultipleGRFsV2", "Enable Multiple GRFs - Embedded", "自訂", 5, "Neo", "Enables the use of multiple grf files without needing INI file in client folder. Instead you specify the INI file as input to the patch", false);

registerPatch(201, "EnableCustomHomunculus", "Enable Custom Homunculus", "自訂", 0, "Neo", "Enables the addition of Custom Homunculus using Lua Files", false);

registerPatch(202, "EnableCustomJobs", "Enable Custom Jobs", "自訂", 0, "Neo", "Enables the use of Custom Jobs (using Lua Files similar to Xray)", false);

registerPatch(203, "EnableCustomShields", "Enable Custom Shields", "自訂", 0, "Neo", "Enables the use of Custom Shield Types (using Lua Files similar to Xray)", false);

registerPatch(204, "IncreaseAtkDisplay", "Increase Attack Display", "自訂", 0, "Neo", "Increases the limit of digits displayed while attacking from 6 to 10", false);

registerPatch(205, "EnableMonsterTables", "Enable Monster Tables", "自訂", 0, "Ind, Neo", "Enables Loading of MonsterTalkTable.xml, PetTalkTable.xml & MonsterSkillInfo.xml for all LangTypes", false);

registerPatch(206, "LoadCustomQuestLua", "Load Custom Quest Lua/Lub files", "自訂", 0, "Neo", "Enables loading of custom lua files used for quests. You need to specify a txt file containing list of files in the 'lua files\\quest' folder to load (one file per line)", false);

registerPatch(207, "ResizeFont", "Resize Font", "自訂", 0, "Yommy, Neo", "Resizes the height of the font used to the value specified", false);

registerPatch(208, "RestoreCashShop", "Restore Cash Shop Icon", "Special", 0, "Neo", "Restores the Cash Shop Icon in RE clients that can have them", false);

registerPatch(209, "EnableMailBox", "Enable Mail Box for All LangTypes", "自訂", 0, "Neo", "Enables the full use of Mail Boxes and @mail commands (write is disabled for few LangTypes by default in 2013 Clients)", false);

registerPatch(210, "UseCustomIcon", "Use Custom Icon", "自訂", 4, "Neo", "Makes the hexed client use the User specified icon. Icon file should have an 8bpp (256 color) 32x32 image", false);

registerPatch(211, "UseCustomDLL", "Use Custom DLL", "自訂", 0, "Neo", "Makes the hexed client load the specified DLL and functions", false);

registerPatch(212, "RestoreRoulette", "Restore Roulette", "自訂", 0, "Neo", "Brings back the Roulette Icon that was removed in new clients", false);

registerPatch(213, "DisableHelpMsg", "關閉遊戲提示", "自訂", 0, "Neo", "關閉登入遊戲顯示的提示", true);

registerPatch(214, "RestoreModelCulling", "Restore Model Culling", "自訂", 0, "Curiosity", "Culls models in front of player by turning them transparent", false);

registerPatch(215, "IncreaseMapQuality", "Increase Map Quality", "自訂", 0, "Curiosity", "Makes client use 32 bit color maps for Map Textures", false);

registerPatch(216, "HideCashShop", "Hide Cash Shop", "自訂", 0, "Neo", "Hide Cash Shop Icon", false);

registerPatch(217, "HideRoulette", "Hide Roulette", "自訂", 0, "Neo", "Hide Roulette Icon", false);

registerPatch(218, "ShowExpNumbers", "Show Exp Numbers", "自訂", 0, "Neo", "Show Base and Job Exp numbers in Basic Info Window", false);

registerPatch(219, "ShowResurrectionButton", "顯示原地復活按鈕", "自訂", 15, "Neo", "角色死亡時強制顯示原地復活按鈕(不管mapflag都會顯示)", false);

registerPatch(220, "DisableMapInterface", "關閉世界地圖", "自訂", 0, "Neo", "關閉世界地圖功能", false);

registerPatch(221, "RemoveJobsFromBooking", "Remove Jobs from Booking", "自訂", 0, "Neo", "Removes user specified set of Job Names from Party Booking Window.", false);

registerPatch(222, "ShowReplayButton", "Show Replay Button", "自訂", 0, "Neo", "Makes the client show Replay button on Service Select screen that opens the Replay File List window", false);

registerPatch(223, "MoveItemCountUpwards", "Move Item Count Upwards [Experimental]", "自訂", 0, "Neo", "Move Item Count upwards in Shortcut Window so as to align with Skill Level display", false);

//registerPatch(224, "IncreaseNpcIDs", "Increase NPC Ids [Experimental]", "自訂", 0, "Neo", "Increase the Loaded NPC IDs to include 10K+ range IDs. Limits are configurable", false);

registerPatch(225, "ShowRegisterButton", "Show Register Button", "自訂", 0, "Neo", "Makes the client always show register button on Login Window for all Langtypes. Clicking the button will open <registrationweb> from clientinfo and closes the client.", false);

registerPatch(226, "DisableWalkToDelay", "Disable Walk To Delay.", "Fix", 16, "MegaByte", "Will have a quicker response to walking clicks. But client may likely send more/duplicated packets.", false);

registerPatch(227, "SetWalkToDelay", "Change Walk To Delay.", "Fix", 16, "MegaByte", "Can have a quicker response to walking clicks. But client may likely send more/duplicated packets.", false);

registerPatch(228, "DisableDoram", "Disable Doram Character Creation UI [Experimental]", "UI", 0, "Ai4Rei, Secret", "Disable Doram race in the character creation UI. Server-side disabling is also recommended", false);

registerPatch(229, "EnableEmblemForBG", "Enable Emblem hover for BG", "UI", 0, "Neo", "Makes the client show the Emblem on top of the character for Battleground mode as well along with GvG", false);

registerPatch(230, "AlwaysReadKrExtSettings", "Always load Korea ExternalSettings lua file", "Fix", 0, "Secret", "Makes the client load Korea server's ExternalSettings file for all langtypes.", false);

registerPatch(231, "RemoveHardcodedAddress", "Remove hardcoded address/port", "Fix", 17, "4144", "Remove hardcoded addresses and ports. For Zero client only.", false);

registerPatch(232, "RestoreOldLoginPacket", "Restore old login packet", "Fix", 17, "4144", "Make client send old 0x64 login packet. For Zero client only.", false);

registerPatch(233, "HideSNSButton", "Hide SNS Button", "UI", 12, "Secret", "Hide SNS (Twitter) button", false);

registerPatch(234, "IgnoreLuaErrors", "Ignore Lua Errors", "Fix", 0, "4144", "Prevents the client from displaying a error messages from lua code like 'attempt to call nil value'.", false);

registerPatch(235, "EnableGuildWhenInClan", "Enable guild while in clan", "自訂", 0, "Functor, Secret", "Remove restriction of guild functionality while being a member of a clan", false);

registerPatch(236, "EnablePlayerSkills", "Enable Custom Player Skills [Experimental]", "自訂", 18, "Neo", "Enables the use of custom skills castable on players (using Lua Files)", false);

registerPatch(237, "EnableHomunSkills", "Enable Custom Homunculus Skills [Experimental]", "自訂", 18, "Neo", "Enables the use of custom skills for Homunculus (using Lua Files)", false);

registerPatch(238, "EnableMerceSkills", "Enable Custom Mercenary Skills [Experimental]", "自訂", 18, "Neo", "Enables the use of custom skills for Mercenaries (using Lua Files)", false);

registerPatch(239, "IgnoreAccountArgument", "Ignore /account: command line argument", "Fix", 0, "Secret", "Makes the client ignore /account: command line argument to prevent custom clientinfo.xml from being used.", false);

registerPatch(240, "LoadCustomClientInfo", "Load custom ClientInfo file", "自訂", 0, "Secret", "Makes the client load your own clientinfo file instead of *clientinfo.xml", false);

registerPatch(241, "AlwaysLoadClientPlugins", "Always Load Client Plugins [Experimental]", "Fix", 0, "Secret", "Makes the client load client plug-ins regardless of its sound settings", false);

registerPatch(242, "DisableKROSiteLaunch", "Disable kRO Site Launch", "Fix", 0, "mrjnumber1", "Disable ro.gnjoy.com launching after in-game settings change", false);

registerPatch(243, "ChangeQuickSwitchDelay", "Change Quick Switch Delay", "Fix", 0, "mrjnumber1", "Change quick item switch delay", false);

registerPatch(244, "DisableCDGuard", "Disable Cheat Defender Game Guard", "Fix", 0, "4144", "Disables Cheat Defender Game Guard from new clients", false);

registerPatch(245, "FixedCharJobCreate", "Set fixed job id in char create dialog", "自訂", 0, "4144", "Override selected job in char creation packet", false);

registerPatch(246, "IncreaseHairSprites", "Increase hair style limit in game", "自訂", 0, "4144", "Allow use more hair styles than default limit", false);

registerPatch(247, "ChangeNewCharNameHeight", "Change new char name field height", "自訂", 0, "4144", "Allow change height in input field in new char creation dialog", false);

registerPatch(248, "RemoveWrongCharFromCashShop", "Remove wrong chars from cash shop", "自訂", 0, "4144", "Hide wrong field with random values in cash shop", false);

registerPatch(249, "ChangeMinimalResolutionLimit", "Change minimal screen resolution limit", "自訂", 0, "4144", "Allow change minimal client resolution (default value is 1024x768", false);

registerPatch(250, "AllowLeavelPartyLeader", "Allow leader to leave party if no members on map", "自訂", 0, "4144", "Allow leader to leave party if not party members on same map", false);

registerPatch(251, "AllowCloseCutinByEsc", "Allow close cutin by pressing esc key", "自訂", 0, "4144", "Allow close cutin window by pressing esc key", false);

//registerPatch(252, "FixAchievementCounters", "Fix achievement counters for each type of achievement", "自訂", 0, "4144", "Fix achievement counters for each type of achievement for 2017 clients", false);

registerPatch(300, "FixItemDescBug", "修復物品說明亂碼Bug", "UI", 0, "Jchcc", "修復物品右鍵內容 '[' 造成的亂碼", false);

registerPatch(301, "SetMaxItemCount", "Change Max Items in inventory", "UI", 0, "Jchcc", "Change maximum items in player inventory.", false);

registerPatch(302, "SetAutoFollowDelay", "自訂自動更隨延遲", "自訂", 0, "Jchcc", "讓自動更隨更緊密,減少過圖跟丟的情況", false);

registerPatch(303, "DefaultBrowserInCashshop", "用預設瀏覽器開啟商城內連結", "自訂", 0, "Jchcc", "使用預設的瀏覽器開啟新版商城(2018)內的連結", false);

registerPatch(304, "UseDefaultBrowser", "用預設瀏覽器開啟<URL>連結", "自訂", 0, "Jchcc", "使用預設瀏覽器開啟<URL>的連結,不再使用RO內建的瀏覽器", false);

registerPatch(311, "NavigationButton", "設定 導航 按鈕", "自訂", 12, "Jchcc", "設定20180416之後登入器的左上角功能按鈕是否顯示", false);

registerPatch(312, "BankButton", "設定 銀行 按鈕", "自訂", 12, "Jchcc", "設定20180416之後登入器的左上角功能按鈕是否顯示", false);

registerPatch(313, "ReplayButton", "設定 重播 按鈕", "自訂", 12, "Jchcc", "設定20180416之後登入器的左上角功能按鈕是否顯示", false);

registerPatch(314, "MailButton", "設定 郵件 按鈕", "自訂", 12, "Jchcc", "設定20180416之後登入器的左上角功能按鈕是否顯示", false);

registerPatch(315, "AchievementButton", "設定 成就系統 按鈕", "自訂", 12, "Jchcc", "設定20180416之後登入器的左上角功能按鈕是否顯示", false);

registerPatch(316, "TipButton", "設定 提示框 按鈕", "自訂", 12, "Jchcc", "設定20180416之後登入器的左上角功能按鈕是否顯示", false);

registerPatch(317, "ShopButton", "設定 商城 按鈕", "自訂", 12, "Jchcc", "設定20180416之後登入器的左上角功能按鈕是否顯示", false);

registerPatch(318, "SNSButton", "設定 TWITTER 按鈕", "自訂", 12, "Jchcc", "設定20180416之後登入器的左上角功能按鈕是否顯示", false);

registerPatch(319, "AttendanceButton", "設定 簽到 按鈕", "自訂", 12, "Jchcc", "設定20180416之後登入器的左上角功能按鈕是否顯示", false);
