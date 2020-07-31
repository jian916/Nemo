//===============================================================================================================//
// Register all your Patches and Patch groups in this file. Always register group before using its id in a patch //
//===============================================================================================================//

GlobalInit();

//###################################################################################################
//#                                                                                                 #
//# FORMAT for registering group : registerGroup(group id, group Name, mutualexclude [true/false]); #
//#                                                                                                 #
//# If you wish that only 1 patch can be active at a time (default) put mutualexclude as true       #
//#                                                                                                 #
//###################################################################################################

//0 is already registered by default as Generic

registerGroup( 1, "ChatLimit", true);

registerGroup( 2, "FixCameraAngles", true);

registerGroup( 3, "IncreaseZoomOut", true);

registerGroup( 4, "UseIcon", true);

registerGroup( 5, "MultiGRFs", true);

registerGroup( 6, "SharedBodyPalettes", true)

registerGroup( 7, "SharedHeadPalettes", true);

registerGroup( 8, "OnlySelectedLoginBackground", true);

registerGroup( 9, "PacketEncryptionKeys", false);

registerGroup(10, "LoginMode", true);

registerGroup(11, "CashShop", true);

registerGroup(12, "HideButton", false);

registerGroup(14, "LicenseScreen", true);

registerGroup(15, "Resurrection", true);

registerGroup(16, "WalkToDelay", true);

registerGroup(17, "Zero", false);

registerGroup(18, "EnableSkills", false);

registerGroup(19, "Hairs", true);

registerGroup(20, "Path", false);

registerGroup(21, "Import", true);

globalVarTest = 123;

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

registerPatch(  2, "AllowChatFlood", "Chat Flood Allow", "UI", 1, "Shinryo", "Disable the clientside repeat limit of 3, and sets it to the specified value", false);

registerPatch(  3, "RemoveChatLimit", "Chat Flood Remove Limit", "UI", 1, "Neo", "Remove the clientside limitation which checks for maximum repeated lines", false);

registerPatch(  4, "CustomAuraLimits", "Use Custom Aura Limits", "UI", 0, "Neo", "Allows the client to display standard auras within user specified limits for Classes and Levels", false);

registerPatch(  5, "EnableProxySupport", "Enable Proxy Support", "Fix", 0, "Ai4rei/AN", "Ignores server-provided IP addresses when changing servers", false);

registerPatch(  6, "ForceSendClientHash", "Force Send Client Hash Packet", "Packet", 0, "GreenBox, Neo", "Forces the client to send a packet with it's MD5 hash for all LangTypes. Only use if you have enabled it in your server", false);

//registerPatch(  7, "ChangeGravityErrorHandler", "Change Gravity Error Handler", "Fix", 0, " ", "It changes the Gravity Error Handler Mesage for a Custom One Pre-Defined by Diff Team", false);

registerPatch(  8, "CustomWindowTitle", "Custom Window Title", "UI", 0, "Shinryo", "Changes window title. Normally, the window title is 'Ragnarok'", false);

registerPatch(  9, "Disable1rag1Params", "Disable 1rag1 type parameters", "Fix", 0, "Shinryo", "Enable this to launch the client directly without patching or any 1rag1, 1sak1 etc parameters", true);

registerPatch( 10, "Disable4LetterCharnameLimit", "Disable 4 Letter Character Name Limit", "Fix", 0, "Shinryo", "Will allow people to use character names shorter than 4 characters", false);

registerPatch( 11, "Disable4LetterUsernameLimit", "Disable 4 Letter User Name Limit", "Fix", 0, "Shinryo", "Will allow people to use account names shorter than 4 characters", false);

registerPatch( 12, "Disable4LetterPasswordLimit", "Disable 4 Letter Password Limit", "Fix", 0, "Shinryo", "Will allow people to use passwords shorter than 4 characters", false);

registerPatch( 13, "DisableFilenameCheck", "Disable Ragexe Filename Check", "Fix", 0, "Shinryo", "Disables the check that forces the client to quit if not called an official name like ragexe.exe for all LangTypes", true);

registerPatch( 14, "DisableHallucinationWavyScreen", "Disable Hallucination Wavy Screen", "Fix", 0, "Shinryo", "Disables the Hallucination effect (screen becomes wavy and lags the client), used by baphomet, horongs, and such", true);

registerPatch( 15, "DisableHShield", "Disable HShield", "Fix", 0, "Ai4rei/AN, Neo", "Disables HackShield", true);

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

registerPatch( 41, "DisableNagleAlgorithm", "Disable Nagle Algorithm", "Packet", 0, "Shinryo", "Disables the Nagle Algorithm. The Nagle Algorithm queues packets before they are sent in order to minimize protocol overhead. Disabling the algorithm will slightly increase network traffic, but it will decrease latency as well", true);

registerPatch( 42, "SkipResurrectionButton", "Skip Resurrection Button", "UI", 15, "Shinryo", "Skip showing resurrection button when you die with Token of Ziegfried in inventory", false);

registerPatch( 43, "DeleteCharWithEmail", "Always Use Email for Char Deletion", "Fix", 0, "Neo", "Makes the Client use Email as Deletion Password for all LangTypes", false);

registerPatch( 44, "TranslateClient", "Translate Client", "UI", 0, "Ai4rei/AN, Neo", "This will translate some of the Hard-coded Korean phrases with strings stored in TranslateClient.txt. It also fixes the Korean Job name issue with LangType", true);

registerPatch( 45, "UseCustomAuraSprites", "Use Custom Aura Sprites", "Data", 0, "Shinryo", "This option will make it so your warp portals will not be affected by your aura sprites. For this you will have to make aurafloat.tga and auraring.bmp and place them in your 'data\\texture\\effect' folder", false);

registerPatch( 46, "UseNormalGuildBrackets", "Use Normal Guild Brackets", "UI", 0, "Shinryo", "On LangType 0, instead of square-brackets, japanese style brackets are used, this option reverts that behaviour to the normal square brackets '[' and ']'", true);

registerPatch( 47, "UseRagnarokIcon", "Use Ragnarok Icon", "UI", 4, "Shinryo, Neo", "Makes the hexed client use the RO program icon instead of the generic Win32 app icon", false);

registerPatch( 48, "UsePlainTextDescriptions", "Use Plain Text Descriptions", "Data", 0, "Shinryo", "Signals that the contents of text files are text files, not encoded", true);

registerPatch( 49, "EnableMultipleGRFs", "Enable Multiple GRFs", "UI", 5, "Shinryo", "Enables the use of multiple grf files by putting them in a data.ini file in your client folder.You can only load up to 10 total grf files with this option ( -9)", true);

registerPatch( 50, "SkipLicenseScreen", "Skip License Screen", "UI", 14, "Shinryo, MS", "Skip the warning screen and goes directly to the main window with the Service Select", false);

registerPatch( 51, "ShowLicenseScreen", "Always Show License Screen", "UI", 14, "Neo", "Makes the client always show the License for all LangTypes", false);

registerPatch( 52, "UseCustomFont", "Use Custom Font", "UI", 0, "Ai4rei/AN", "Allows the use of user-defined font for all LangTypes. The LangType-specific charset is still being enforced, so if the selected font does not support it, the system falls back to a font that does", false);

registerPatch( 53, "UseAsciiOnAllLangTypes", "Use Ascii on All LangTypes", "UI", 0, "Ai4rei/AN", "Makes the Client Enable ASCII irrespective of Font or LangTypes", true);

registerPatch( 54, "ChatColorGM", "Chat Color - GM", "Color", 0, "Ai4rei/AN, Shakto", "Changes the GM Chat color and sets it to the specified value. Default value is ffff00 (Yellow)", false);

registerPatch( 55, "ChatColorPlayerOther", "Chat Color - Other Player", "Color", 0, "Ai4rei/AN, Shakto", "Changes other players Chat color and sets it to the specified value. Default value is ffffff (White)" );

//Disabled since GM Chat Color also patches the Main color - to be removed
//registerPatch( 56, "ChatColorMain", "Chat Color - Main", "Color", 0, "Ai4rei/AN, Shakto", "Changes the Main Chat color and sets it to the specified value", false);

registerPatch( 57, "ChatColorGuild", "Chat Color - Guild", "Color", 0, "Ai4rei/AN, Shakto", "Changes the Guild Chat color and sets it to the specified value. Default Value is b4ffb4 (Light Green)", false);

registerPatch( 58, "ChatColorPartyOther", "Chat Color - Other Party ", "Color", 0, "Ai4rei/AN, Shakto", "Changes the Other Party members Chat color and sets it to the specified value. Default value is ffc8c8 (Pinkish)", false);

registerPatch( 59, "ChatColorPartySelf", "Chat Color - Your Party", "Color", 0, "Ai4rei/AN, Shakto", "Changes Your Party Chat color and sets it to the specified value. Default value is ffc800 (Orange)", false);

registerPatch( 60, "ChatColorPlayerSelf", "Chat Color - Self", "Color", 0, "Ai4rei/AN, Shakto", "Changes your character's Chat color and sets it to the specified value. Default value is 00ff00 (Green)", false);

registerPatch( 61, "DisablePacketEncryption", "Disable Packet Encryption", "UI", 0, "Ai4rei/AN", "Disable kRO Packet ID Encryption. Also known as Skip Packet Obfuscation", false);

registerPatch( 62, "DisableLoginEncryption", "Disable Login Encryption", "Fix", 0, "Neo", "Disable Encryption in Login Packet 0x2b0", true);

registerPatch( 63, "UseOfficialClothPalette", "Use Official Cloth Palettes", "UI", 0, "Neo", "Use Official Cloth Palette on all LangTypes. Do not use this if you are using the 'Enable Custom Jobs' patch", false);

registerPatch( 64, "FixChatAt", "@ Bug Fix", "UI", 0, "Shinryo", "Correct the bug to write @ in chat", true);

registerPatch( 65, "ChangeItemInfo", "Load Custom lua file instead of iteminfo*.lub", "UI", 0, "Neo", "Makes the client load your own lua file instead of iteminfo*.lub . If you directly use itemInfo*.lub for your translated items, it may become lost during the next kRO update", true);

registerPatch( 66, "LoadItemInfoPerServer", "Load iteminfo with char server", "Data", 0, "Neo", "Load ItemInfo file and call main function with selected char server name as argument", false);

registerPatch( 67, "DisableQuakeEffect", "Disable Quake skill effect", "UI", 0, "Ai4rei/AN", " Disables the Earthquake skill effect", false);

registerPatch( 68, "Enable64kHairstyle", "Enable 64k Hairstyle", "UI", 19, "Ai4rei/AN", "Increases Max Hairstyle limit to 64k from default 27", false);

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

registerPatch( 88, "AllowSpaceInGuildName", "Allow space in guild name", "UI", 0, "Shakto", "Allow player to create a guild with space in the name (/guild \"Space Name\")", false);

registerPatch( 90, "EnableDNSSupport", "Enable DNS Support", "UI", 0, "Shinryo", "Enable DNS support for clientinfo.xml", true);

registerPatch( 91, "DCToLoginWindow", "Disconnect to Login Window", "UI", 0, "Neo", "Make the client return to Login Window upon disconnection", false, [40]);

registerPatch( 92, "PacketFirstKeyEncryption", "Packet First Key Encryption", "Packet", 9, "Shakto, Neo", "Change the 1st key for packet encryption. Dont select the patch Disable Packet Header Encryption if you are using this. Don't use it if you don't know what you are doing", false);

registerPatch( 93, "PacketSecondKeyEncryption", "Packet Second Key Encryption", "Packet", 9, "Shakto, Neo", "Change the 2nd key for packet encryption. Dont select the patch Disable Packet Header Encryption if you are using this. Don't use it if you don't know what you are doing", false);

registerPatch( 94, "PacketThirdKeyEncryption", "Packet Third Key Encryption", "Packet", 9, "Shakto, Neo", "Change the 3rd key for packet encryption. Dont select the patch Disable Packet Header Encryption if you are using this. Don't use it if you don't know what you are doing", false);

registerPatch( 95, "UseSSOLoginPacket", "Use SSO Login Packet", "Packet", 10, "Ai4rei/AN", "Enable using SSO packet on all LangType (to use login and pass with a launcher)", false);

registerPatch( 96, "RemoveGMSprite", "Remove GM Sprites", "UI", 0, "Neo", "Remove the GM sprites and keeping all the functionality like Yellow name and Admin right click menu", false);

registerPatch( 97, "CancelToLoginWindow", "Cancel to Login Window", "Fix", 0, "Neo", "Makes clicking the Cancel button in Character selection window return to login window instead of Quitting", true, [40]);

registerPatch( 98, "DisableDCScream", "Disable dc_scream.txt", "UI", 0, "Neo", "Disable chat on file dc_scream", false);

registerPatch( 99, "DisableBAFrostJoke", "Disable ba_frostjoke.txt", "UI", 0, "Neo", "Disable chat on file ba_frostjoke", false);

registerPatch(100, "DisableMultipleWindows", "Disable Multiple Windows", "UI", 0, "Shinryo, Ai4rei/AN", "Prevents the client from creating more than one instance on all LangTypes", false);

registerPatch(101, "SkipCheaterFriendCheck", "Skip Friend list Cheat Check", "UI", 0, "Ai4rei/AN", "Prevents warnings during PM's when the sender has similar name to one of your friends", false);

registerPatch(102, "SkipCheaterGuildCheck", "Skip Guild Member Cheat Check", "UI", 0, "Ai4rei/AN", "Prevents warnings during PM's when the sender has similar name to one of your guild members", false);

registerPatch(103, "DisableAutofollow", "Disable Auto follow", "UI", 0, "Functor, Neo", "Disables player auto-follow on Shift+Right click", false);

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

registerPatch(114, "ChangeVendingLimit", "Change Vending Limit [Experimental]", "Data", 0, "Neo", "Change the Vending Limit of 1 Billion zeny to user specified value", false);

registerPatch(115, "EnableEffectForAllMaps", "Enable Effect for all Maps [Experimental]", "Data", 0, "Neo", "Make the client load the corresponding file in EffectTool folder for all maps", false);

//registerPatch(151, "UseArialOnAllLangTypes", "Use Arial on All LangTypes", "UI", 0, "Ai4rei/AN, Shakto", "Makes Arial the default font on all LangTypes (it's enable ascii by default)", true);

//FixTetraVortex patch is removed since the black screen animation issue is fixed Server Side

//======================================//
// Special Patches by Neo and Curiosity //
//======================================//

registerPatch(200, "EnableMultipleGRFsV2", "Enable Multiple GRFs - Embedded", "Custom", 5, "Neo", "Enables the use of multiple grf files without needing INI file in client folder. Instead you specify the INI file as input to the patch", false);

registerPatch(201, "EnableCustomHomunculus", "Enable Custom Homunculus", "Custom", 0, "Neo", "Enables the addition of Custom Homunculus using Lua Files", false);

registerPatch(202, "EnableCustomJobs", "Enable Custom Jobs", "Custom", 0, "Neo", "Enables the use of Custom Jobs (using Lua Files similar to Xray)", false);

registerPatch(203, "EnableCustomShields", "Enable Custom Shields", "Custom", 0, "Neo", "Enables the use of Custom Shield Types (using Lua Files similar to Xray)", false);

registerPatch(204, "IncreaseAtkDisplay", "Increase Attack Display", "Custom", 0, "Neo", "Increases the limit of digits displayed while attacking from 6 to 10", false);

registerPatch(205, "EnableMonsterTables", "Enable Monster Tables", "Custom", 0, "Ind, Neo", "Enables Loading of MonsterTalkTable.xml, PetTalkTable.xml & MonsterSkillInfo.xml for all LangTypes", false);

registerPatch(206, "LoadCustomQuestLua", "Load Custom Quest Lua/Lub files", "Custom", 0, "Neo", "Enables loading of custom lua files used for quests. You need to specify a txt file containing list of files in the 'lua files\\quest' folder to load (one file per line)", false);

registerPatch(207, "ResizeFont", "Resize Font", "Custom", 0, "Yommy, Neo", "Resizes the height of the font used to the value specified", false);

registerPatch(208, "RestoreCashShop", "Restore Cash Shop Icon", "Special", 0, "Neo", "Restores the Cash Shop Icon in RE clients that can have them", false);

registerPatch(209, "EnableMailBox", "Enable Mail Box for All LangTypes", "Custom", 0, "Neo", "Enables the full use of Mail Boxes and @mail commands (write is disabled for few LangTypes by default in 2013 Clients)", false);

registerPatch(210, "UseCustomIcon", "Use Custom Icon", "Custom", 4, "Neo", "Makes the hexed client use the User specified icon. Icon file should have an 8bpp (256 color) 32x32 image", false);

registerPatch(211, "UseCustomDLL", "Use Custom DLL", "Custom", 21, "Neo", "Makes the hexed client load the specified DLL and functions", false);

registerPatch(212, "RestoreRoulette", "Restore Roulette", "Custom", 0, "Neo", "Brings back the Roulette Icon that was removed in new clients", false);

registerPatch(213, "DisableHelpMsg", "Disable Help Message on Login", "Custom", 0, "Neo", "Prevents the Help Message being shown on Login for all LangTypes", true);

registerPatch(214, "RestoreModelCulling", "Restore Model Culling", "Custom", 0, "Curiosity", "Culls models in front of player by turning them transparent", false);

registerPatch(215, "IncreaseMapQuality", "Increase Map Quality", "Custom", 0, "Curiosity", "Makes client use 32 bit color maps for Map Textures", false);

registerPatch(216, "HideCashShop", "Hide Cash Shop", "Custom", 0, "Neo", "Hide Cash Shop Icon", false);

registerPatch(217, "HideRoulette", "Hide Roulette", "Custom", 0, "Neo", "Hide Roulette Icon", false);

registerPatch(218, "ShowExpNumbers", "Show Exp Numbers", "Custom", 0, "Neo", "Show Base and Job Exp numbers in Basic Info Window", false);

registerPatch(219, "ShowResurrectionButton", "Always Show Resurrection Button", "Custom", 15, "Neo", "Make the client always show Resurrection button with Token of Ziegfried in inventory irrespective of map type", false);

registerPatch(220, "DisableMapInterface", "Disable Map Interface", "Custom", 0, "Neo", "Disable the World View (Full Map) Interface", false);

registerPatch(221, "RemoveJobsFromBooking", "Remove Jobs from Booking", "Custom", 0, "Neo", "Removes user specified set of Job Names from Party Booking Window.", false);

registerPatch(222, "ShowReplayButton", "Show Replay Button", "Custom", 0, "Neo", "Makes the client show Replay button on Service Select screen that opens the Replay File List window", false);

registerPatch(223, "MoveItemCountUpwards", "Move Item Count Upwards [Experimental]", "Custom", 0, "Neo", "Move Item Count upwards in Shortcut Window so as to align with Skill Level display", false);

//registerPatch(224, "IncreaseNpcIDs", "Increase NPC Ids [Experimental]", "Custom", 0, "Neo", "Increase the Loaded NPC IDs to include 10K+ range IDs. Limits are configurable", false);

registerPatch(225, "ShowRegisterButton", "Show Register Button", "Custom", 0, "Neo", "Makes the client always show register button on Login Window for all Langtypes. Clicking the button will open <registrationweb> from clientinfo and closes the client.", false);

registerPatch(226, "DisableWalkToDelay", "Disable Walk To Delay.", "Fix", 16, "MegaByte", "Will have a quicker response to walking clicks. But client may likely send more/duplicated packets.", false);

registerPatch(227, "SetWalkToDelay", "Change Walk To Delay.", "Fix", 16, "MegaByte", "Can have a quicker response to walking clicks. But client may likely send more/duplicated packets.", false);

registerPatch(228, "DisableDoram", "Disable Doram Character Creation UI [Experimental]", "UI", 0, "Ai4Rei, Secret", "Disable Doram race in the character creation UI. Server-side disabling is also recommended", false);

registerPatch(229, "EnableEmblemForBG", "Enable Emblem hover for BG", "UI", 0, "Neo", "Makes the client show the Emblem on top of the character for Battleground mode as well along with GvG", false);

registerPatch(230, "AlwaysReadKrExtSettings", "Always load Korea ExternalSettings lua file", "Fix", 0, "Secret, 4144", "Makes the client load Korea server's ExternalSettings file for all langtypes.", false);

registerPatch(231, "RemoveHardcodedAddress", "Remove hardcoded address/port", "Fix", 0, "4144", "Remove hardcoded connection addresses and ports.", true);

registerPatch(232, "RestoreOldLoginPacket", "Restore old login packet", "Fix", 17, "4144", "Make client send old 0x64 login packet.", true);

registerPatch(233, "HideSNSButton", "Hide SNS Button", "UI", 12, "Secret, 4144", "Hide SNS (Twitter) button", false);

registerPatch(234, "IgnoreLuaErrors", "Ignore Lua Errors", "Fix", 0, "4144", "Prevents the client from displaying a error messages from lua code like 'attempt to call nil value'.", false);

registerPatch(235, "EnableGuildWhenInClan", "Enable guild while in clan", "Custom", 0, "Functor, Secret", "Remove restriction of guild functionality while being a member of a clan", false);

registerPatch(236, "EnablePlayerSkills", "Enable Custom Player Skills [Experimental]", "Custom", 18, "Neo", "Enables the use of custom skills castable on players (using Lua Files)", false);

registerPatch(237, "EnableHomunSkills", "Enable Custom Homunculus Skills [Experimental]", "Custom", 18, "Neo", "Enables the use of custom skills for Homunculus (using Lua Files)", false);

registerPatch(238, "EnableMerceSkills", "Enable Custom Mercenary Skills [Experimental]", "Custom", 18, "Neo", "Enables the use of custom skills for Mercenaries (using Lua Files)", false);

registerPatch(239, "IgnoreAccountArgument", "Ignore /account: command line argument", "Fix", 0, "Secret", "Makes the client ignore /account: command line argument to prevent custom clientinfo.xml from being used.", false);

registerPatch(240, "LoadCustomClientInfo", "Load custom ClientInfo file", "Custom", 0, "Secret", "Makes the client load your own clientinfo file instead of *clientinfo.xml", false);

registerPatch(241, "AlwaysLoadClientPlugins", "Always Load Client Plugins [Experimental]", "Fix", 0, "Secret", "Makes the client load client plug-ins regardless of its sound settings", false);

registerPatch(242, "DisableKROSiteLaunch", "Disable kRO Site Launch", "Fix", 0, "mrjnumber1", "Disable ro.gnjoy.com launching after in-game settings change", false);

registerPatch(243, "ChangeQuickSwitchDelay", "Change Quick Switch Delay", "Fix", 0, "mrjnumber1", "Change quick item switch delay", false);

registerPatch(244, "DisableCDGuard", "Disable Cheat Defender Game Guard", "Fix", 0, "4144", "Disables Cheat Defender Game Guard from new clients", true);

registerPatch(245, "FixedCharJobCreate", "Set fixed job id in char create dialog", "Custom", 0, "4144", "Override selected job in char creation packet", false);

registerPatch(246, "IncreaseHairSprites", "Increase hair style limit in game", "Custom", 19, "4144", "Allow use more hair styles than default limit", false);

registerPatch(247, "ChangeNewCharNameHeight", "Change new char name field height", "Custom", 0, "4144", "Allow change height in input field in new char creation dialog", false);

registerPatch(248, "RemoveWrongCharFromCashShop", "Remove wrong chars from cash shop", "Custom", 0, "4144", "Hide wrong field with random values in cash shop", false);

registerPatch(249, "ChangeMinimalResolutionLimit", "Change minimal screen resolution limit", "Custom", 0, "4144", "Allow change minimal client resolution (default value is 1024x768", false);

registerPatch(250, "AllowLeavelPartyLeader", "Allow leader to leave party if no members on map", "Custom", 0, "4144", "Allow leader to leave party if not party members on same map", false);

registerPatch(251, "AllowCloseCutinByEsc", "Allow close cutin by pressing esc key", "Custom", 0, "4144", "Allow close cutin window by pressing esc key", false);

registerPatch(252, "FixAchievementCounters", "Fix achievement counters for each type of achievement", "Custom", 0, "4144", "Fix achievement counters for each type of achievement", false);

registerPatch(253, "SkipHiddenMenuButtons", "Skip some hidden menu icon buttons", "Custom", 12, "4144", "Allow skip buttons hidden by patches 'Hide XXX button'", false);

registerPatch(254, "SetMaxItemCount", "Change Max Items in inventory", "UI", 0, "Jchcc", "Change maximum items in player inventory.", false);

registerPatch(255, "SetAutoFollowDelay", "Change Auto Follow Delay", "Custom", 0, "Jchcc", "Can reduce auto follow delay.", false);

registerPatch(256, "DefaultBrowserInCashshop", "Use Default Web Browser In Cashshop", "Custom", 0, "Jchcc", "Open URL in the cashshop window with default web browser instead of IExplore.", false);

registerPatch(257, "UseDefaultBrowser", "Use Default Web Browser for <URL>", "Custom", 0, "Jchcc", "Use default web browser to open <URL> instead of built-in ROWebBrowser.", false);

registerPatch(258, "ShortcutAllItem", "Enable Shortcut All Item", "Fix", 0, "Jchcc", "Allow players put all items on the shortcut window make it easy to trace.", false);

registerPatch(259, "NavigationButton", "Set Navigation Button", "Custom", 0, "Jchcc", "Set navigation button hide or show.", false);

registerPatch(260, "BankButton", "Set Bank Button", "Custom", 0, "Jchcc", "Set bank button hide or show.", false);

registerPatch(261, "ReplayButton", "Set Replay Button", "Custom", 0, "Jchcc", "Set replay button hide or show.", false);

registerPatch(262, "MailButton", "Set Mail Button", "Custom", 0, "Jchcc", "Set mail button hide or show.", false);

registerPatch(263, "AchievementButton", "Set Achievement Button", "Custom", 0, "Jchcc", "Set achievement button hide or show.", false);

registerPatch(264, "TipButton", "Set Tip Button", "Custom", 0, "Jchcc", "Set tip button hide or show.", false);

registerPatch(265, "ShopButton", "Set Shop Button", "Custom", 0, "Jchcc", "Set shop button hide or show.", false);

registerPatch(266, "SNSButton", "Set SNS Button", "Custom", 0, "Jchcc", "Set SNS button hide or show.", false);

registerPatch(267, "AttendanceButton", "Set Attendance Button", "Custom", 0, "Jchcc", "Set attendance button hide or show.", false);

registerPatch(268, "RestoreChatFocus", "Restore chat focus", "Custom", 0, "4144", "Restore input focus from left mouse click.", false);

registerPatch(269, "ChangeDefaultBGM", "Change default BGM file", "Custom", 20, "Jian", "Change default BGM music file after login to account. Default is bgm\\01.mp3", false);

registerPatch(270, "ChangeAchievementListPath", "Change AchievementList*.lub path", "Custom", 20, "Jian", "Change AchievementList*.lub path", false);

registerPatch(271, "ChangeMonsterSizeEffectPath", "Change MonsterSizeEffect*.lub path", "Custom", 20, "Jian", "Change MonsterSizeEffect*.lub path", false);

registerPatch(272, "ChangeTowninfoPath", "Change Towninfo*.lub path", "Custom", 20, "Jian", "Change Towninfo*.lub path", false);

registerPatch(273, "ChangePetEvolutionClnPath", "Change PetEvolutionCln*.lub path", "Custom", 20, "Jian", "Change PetEvolutionCln*.lub path", false);

registerPatch(274, "ChangeTipboxPath", "Change Tipbox*.lub path", "Custom", 20, "Jian", "Change Tipbox*.lub path", false);

registerPatch(275, "ChangeCheckAttendancePath", "Change CheckAttendance*.lub path", "Custom", 20, "Jian", "Change CheckAttendance*.lub path", false);

registerPatch(276, "ChangeOngoingQuestInfoListPath", "Change OngoingQuestInfoList*.lub path", "Custom", 20, "Jian", "Change OngoingQuestInfoList*.lub path", false);

registerPatch(277, "ChangeRecommendedQuestInfoListPath", "Change RecommendedQuestInfoList*.lub path", "Custom", 20, "Jian", "Change RecommendedQuestInfoList*.lub path", false);

registerPatch(278, "ChangePrivateAirplanePath", "Change PrivateAirplane*.lub path", "Custom", 20, "Jian", "Change PrivateAirplane*.lub path", false);

registerPatch(279, "FixItemDescBug", "Fix item description bug", "Custom", 0, "Jchcc", "Fix item description '[' bug", false);

registerPatch(280, "ChangeGuildExpLimit", "Change guild exp limit", "Custom", 0, "4144", "Change guild exp limit percent. Default value is 50.", false);

registerPatch(281, "ChangeHealthBarSize", "Change hp bar size", "Custom", 0, "Jchcc", "Change hp/sp bar size drawed under character", false);

registerPatch(282, "ChangeMvpHealthBarSize", "Change MVP hp bar size", "Custom", 0, "Jchcc", "Change hp bar size drawed under MVP", false);

registerPatch(283, "ChangeFadeOutDelay", "Change fade in/out delay", "Custom", 0, "4144", "Change fade in/out time in warps on same map", false);

registerPatch(284, "CopyCDGuard", "Copy patched Cheat Defender Game Guard", "Fix", 0, "4144", "Copy patched/disabled Cheat Defender Game Guard into destination directory", false);

registerPatch(285, "FixActDelay", "Fix act delay for act files with many frames", "Fix", 0, "Functor, 4144", "Fix act delay for act files with big amount of frames", false);

registerPatch(286, "HideZeroDateInGuildMembers", "Hide zero date (1969-01-01) in guild members window", "Fix", 0, "4144", "Hide zero date (1969-01-01) in guild members window", false);

registerPatch(287, "ChangeDisplayCharDelDelay", "Change character display deletion time from actual date to relative date", "Custom", 0, "Functor", "Change character display deletion time from actual date to relative date", false);

registerPatch(288, "MoveShieldToTop", "Draw shield on top of other player sprites", "Custom", 0, "4144", "Move shield sprite closed to camera for draw on top of other player sprites", false);

registerPatch(289, "FixHomunculusAI", "Fix Homunculus attack AI", "Fix", 0, "Jchcc", "Fix issue in homunculus AI what prevent automatic attacks after in 20170920 clients and newer", false);

registerPatch(290, "HideBuildInfo", "Hide build info in client", "Protection", 0, "4144", "Hide actual build info in client by replacing it to useless data", true);

registerPatch(291, "HidePacketsFromPeek", "Hide packets from peek", "Protection", 0, "4144", "Simple way for hide packets from peek and bpe", true);

// registerPatch(292, "FixShortcutsInWine", "Fix shortcuts in wine", "Wine", 0, "4144", "Allow to use keyboard shortcuts in wine", false);

registerPatch(293, "IncreaseHairSpritesOld", "Increase hair style limit for human only in game (old)", "Custom", 19, "4144", "Allow use more hair styles than default limit", false);

// 294 reserved

registerPatch(295, "ChangeMaxPartyValue", "Change Max Party Value", "UI", 0, "Jchcc", "Change max party value displayed on Alt+Z", false);

registerPatch(296, "ForceLubStateIcon", "Force use icons only from stateiconimginfo.lub", "Fix", 0, "Jchcc", "Disable hardcoded status icons and read them only from stateiconimginfo.lub", false);

registerPatch(297, "HideKeyboardButton", "Hide keyboard button", "UI", 12, "4144", "Hide keyboard button", false);

registerPatch(298, "HideStatusButton", "Hide status/stats button", "UI", 12, "4144", "Hide status/stats button", false);

registerPatch(299, "HideEquipButton", "Hide equipment button", "UI", 12, "4144", "Hide equipment button", false);

registerPatch(300, "HideItemButton", "Hide inventory button", "UI", 12, "4144", "Hide inventory button", false);

registerPatch(301, "HideSkillButton", "Hide skills button", "UI", 12, "4144", "Hide skills button", false);

registerPatch(302, "HidePartyButton", "Hide party button", "UI", 12, "4144", "Hide party button", false);

registerPatch(303, "HideGuildButton", "Hide guild button", "UI", 12, "4144", "Hide guild button", false);

registerPatch(304, "HideOptionButton", "Hide options/settings button", "UI", 12, "4144", "Hide options/settings button", false);

registerPatch(305, "HideTipButton", "Hide tip button", "UI", 12, "4144", "Hide tip button", false);

registerPatch(306, "HideShopButton", "Hide shop button", "UI", 12, "4144", "Hide shop button", false);

registerPatch(307, "HideAttendanceButton", "Hide attendance button", "UI", 12, "4144", "Hide attendance button", false);

registerPatch(308, "HideAdventurerAgencyButton", "Hide adventurer agency button", "UI", 12, "4144", "Hide adventurer agency button", false);

registerPatch(309, "BookingButton", "Set booking button", "Custom", 0, "4144", "Set booking button hide or show.", false);

registerPatch(310, "AdventurerAgencyButton", "Set adventurer agency button", "Custom", 0, "4144", "Set adventurer agency button hide or show.", false);

registerPatch(311, "AllowSpamSkills", "Allow spam skills by hotkey", "Custom", 0, "Functor, 4144", "If hold key, allow spam skills by hotkey", false);

registerPatch(312, "Intravision", "Always see hidden/cloaked objects", "Custom", 0, "Secret, A.K.M.", "Always see black silhouette of hidden objects as if the player has intravision status", false);

registerPatch(313, "ChangeMapInfoPath", "Change MapInfo*.lub path", "Custom", 20, "X-EcutiOnner", "Change MapInfo*.lub path", false);

// 314 reserved

registerPatch(315, "HighlightSkillSlotColor", "Highlight Skillslot Color", "Color", 0, "Hanashi, 4144", "Changes the highlight skillslot color and sets it to the specified value. Default value is b4ffb4 (Celadon)", false);

registerPatch(316, "RemoveEquipmentSwap", "Remove Equipment Swap Button", "UI", 12, "Functor, X-EcutiOnner", "Remove equipment swap button on the equipment window", false);

registerPatch(317, "IgnoreQuestErrors", "Ignore Quest Errors", "Fix", 0, "X-EcutiOnner, 4144", "Prevents the client from displaying a error messages like 'Not found Quest Info = XXXX'.", false);

registerPatch(318, "FixCharsetForFonts", "Fix Charset For Custom Fonts", "Fix", 0, "jchcc", "Use correct charset for Official Custom Fonts on all LangType", false);

registerPatch(319, "OpeningToServiceSelect", "Opening To Service Select", "UI", 0, "jchcc", "Make Opening button to service select, change button text in msgstringtable,txt:3354", false);

registerPatch(320, "IgnoreTownInfoReading", "Ignore Towninfo*.lub Reading", "Custom", 0, "X-EcutiOnner", "Make the client ignore to reading Towninfo*.lub and prevents the client from displaying a error messages window", false);

registerPatch(321, "DisableWindows", "Disable specified Windows", "UI", 0, "jchcc", "Disable specified window/interface, check input/DisableWindows.txt for more information.", false);

registerPatch(322, "InsensitiveStorageSearch", "Case-Insensitive Storage Search", "UI", 0, "jchcc", "Case-insensitive search in storage UI.", false);

registerPatch(323, "RestoreSongsEffect", "Restore Songs Effect", "Fix", 0, "jchcc", "Restore Bard/Dancer songs ground effect on 2019+ clients.", false);

registerPatch(324, "ChangeSecondCharCreateJob", "Change second char create job", "Custom", 0, "4144", "Replace doram to custom job in char creation window.", false);

registerPatch(325, "RemoveEquipmentTitleUI", "Remove Equipment Title UI", "UI", 12, "jchcc, X-EcutiOnner", "Remove equipment title ui on the equipment window", false);

GlobalPostInit();
