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

registerGroup( 0, "�q��", false);

registerGroup( 1, "��ѭ���", true);

registerGroup( 2, "�ץ���������", true);

registerGroup( 3, "�X�W�����Z��", true);

registerGroup( 4, "�ϥιϥ�", true);

registerGroup( 5, "GRF�޲z", true);

registerGroup( 6, "�@�άV��", true)

registerGroup( 7, "�@�άV��", true);

registerGroup( 8, "�n�J�I��", true);

registerGroup( 9, "�ʥ]�V�c", false);

registerGroup(10, "�n�J�Ҧ�", true);

registerGroup(11, "�I�ưӫ�", true);

registerGroup(12, "���ë��s", false);

registerGroup(14, "���v����", true);

registerGroup(15, "�_������", true);

registerGroup(16, "���ʩ���", true);

registerGroup(17, "�_����", false);

registerGroup(18, "�ۭq�ޯ�", false);

registerGroup(19, "���|", false);

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

registerPatch(  2, "AllowChatFlood", "�o�ܬ~�W���ƭ���]�w", "UI", 1, "Shinryo", "�]�w�o�ܬ~�W������A�w�]�O�u��o3���@�ˤ��e", false);

registerPatch(  3, "RemoveChatLimit", "�o�ܬ~�W��������", "UI", 1, "Neo", "�����o�ܬ~�W������(�]�w���ƭ���ﶵ�|����)", false);

registerPatch(  4, "CustomAuraLimits", "Use Custom Aura Limits", "UI", 0, "Neo", "Allows the client to display standard auras within user specified limits for Classes and Levels", false);

registerPatch(  5, "EnableProxySupport", "Enable Proxy Support", "Fix", 0, "Ai4rei/AN", "Ignores server-provided IP addresses when changing servers", false);

registerPatch(  6, "ForceSendClientHash", "Force Send Client Hash Packet", "Packet", 0, "GreenBox, Neo", "Forces the client to send a packet with it's MD5 hash for all LangTypes. Only use if you have enabled it in your server", false);

//registerPatch(  7, "ChangeGravityErrorHandler", "Change Gravity Error Handler", "Fix", 0, " ", "It changes the Gravity Error Handler Mesage for a Custom One Pre-Defined by Diff Team", false);

registerPatch(  8, "CustomWindowTitle", "�ק�n�J�����D", "UI", 0, "Shinryo", "�ק�n�J�������D(���䴩����A����n��16�i��ۦ�ק�)�A�w�]�� 'Ragnarok'", false);

registerPatch(  9, "Disable1rag1Params", "����1rag1�����ҰʹC��", "Fix", 0, "Shinryo", "���� 1rag1 �ѼƴN�i�H�����ҰʹC��", true);

registerPatch( 10, "Disable4LetterCharnameLimit", "��������W�̤�4�Ӧr����", "Fix", 0, "Shinryo", "��������W�ٳ̤�4�Ӧr������(���A���٬O������)", false);

registerPatch( 11, "Disable4LetterUsernameLimit", "�����b���̤�4�Ӧr����", "Fix", 0, "Shinryo", "�����b���̤�4�Ӧr������(���A���٬O������)", false);

registerPatch( 12, "Disable4LetterPasswordLimit", "�����K�X�̤�4�Ӧr����", "Fix", 0, "Shinryo", "�����K�X�̤�4�Ӧr������(���A���٬O������)", false);

registerPatch( 13, "DisableFilenameCheck", "Disable Ragexe Filename Check", "Fix", 0, "Shinryo", "Disables the check that forces the client to quit if not called an official name like ragexe.exe for all LangTypes", true);

registerPatch( 14, "DisableHallucinationWavyScreen", "Disable Hallucination Wavy Screen", "Fix", 0, "Shinryo", "Disables the Hallucination effect (screen becomes wavy and lags the client), used by baphomet, horongs, and such", true);

registerPatch( 15, "DisableHShield", "�����b�ȫO�@�{��", "Fix", 0, "Ai4rei/AN, Neo", "�����b�ȫO�@�{���A�n Diff �N�@�w�n����(���|�Y aossdk.dll v3hunt.dll)", true);

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

registerPatch( 41, "DisableNagleAlgorithm", "����Nagle�t��k", "Packet", 0, "Shinryo", "����Nagle�t��k�ANagle²�����O�w�ĺt��k(��ƨ�F�@�w���q�~�|�@�öǿ�)�A�ϥΦ��t��k�i�H��ֺ����ǿ�q�A���|�W�[����A�H�ثe�����W�e�����S���t�o�@�I�A�ҥH�|�Ŀ�", true);

registerPatch( 42, "SkipResurrectionButton", "Skip Resurrection Button", "UI", 15, "Shinryo", "Skip showing resurrection button when you die with Token of Ziegfried in inventory", false);

registerPatch( 43, "DeleteCharWithEmail", "�R������ϥΫH�c��K�X", "Fix", 0, "Neo", "�R������ɡA�ϥΫH�c�ӷ�K�X�A�j��Ҧ�(langtype)���ϥ�", false);

registerPatch( 44, "TranslateClient", "Translate Client", "UI", 0, "Ai4rei/AN, Neo", "This will translate some of the Hard-coded Korean phrases with strings stored in TranslateClient.txt. It also fixes the Korean Job name issue with LangType", true);

registerPatch( 45, "UseCustomAuraSprites", "Use Custom Aura Sprites", "Data", 0, "Shinryo", "This option will make it so your warp portals will not be affected by your aura sprites. For this you will have to make aurafloat.tga and auraring.bmp and place them in your 'data\\texture\\effect' folder", false);

registerPatch( 46, "UseNormalGuildBrackets", "Use Normal Guild Brackets", "UI", 0, "Shinryo", "On LangType 0, instead of square-brackets, japanese style brackets are used, this option reverts that behaviour to the normal square brackets '[' and ']'", true);

registerPatch( 47, "UseRagnarokIcon", "Use Ragnarok Icon", "UI", 4, "Shinryo, Neo", "Makes the hexed client use the RO program icon instead of the generic Win32 app icon", false);

registerPatch( 48, "UsePlainTextDescriptions", "Use Plain Text Descriptions", "Data", 0, "Shinryo", "Signals that the contents of text files are text files, not encoded", true);

registerPatch( 49, "EnableMultipleGRFs", "Enable Multiple GRFs", "UI", 5, "Shinryo", "Enables the use of multiple grf files by putting them in a data.ini file in your client folder.You can only load up to 10 total grf files with this option ( -9)", true);

registerPatch( 50, "SkipLicenseScreen", "Skip License Screen", "UI", 14, "Shinryo, MS", "Skip the warning screen and goes directly to the main window with the Service Select", false);

registerPatch( 51, "ShowLicenseScreen", "�Ұʮ���ܱ��v����", "UI", 14, "Neo", "�n�J����ܱ��v���ڡA�j��Ҧ�(langtype)�����", false);

registerPatch( 52, "UseCustomFont", "Use Custom Font", "UI", 0, "Ai4rei/AN", "Allows the use of user-defined font for all LangTypes. The LangType-specific charset is still being enforced, so if the selected font does not support it, the system falls back to a font that does", false);

registerPatch( 53, "UseAsciiOnAllLangTypes", "Use Ascii on All LangTypes", "UI", 0, "Ai4rei/AN", "Makes the Client Enable ASCII irrespective of Font or LangTypes", true);

registerPatch( 54, "ChatColorGM", "�ק�GM�T����r�C��", "Color", 0, "Ai4rei/AN, Shakto", "���� GM ��ѵ�����r���C��A�w�]�Ȭ� FFFF00 (����)", false);

registerPatch( 55, "ChatColorPlayerOther", "�ק�@��T����r�C��", "Color", 0, "Ai4rei/AN, Shakto", "���� �@���� ��ѵ�����r���C��A�w�]�Ȭ� FFFFFF (�զ�)" );

//Disabled since GM Chat Color also patches the Main color - to be removed
//registerPatch( 56, "ChatColorMain", "Chat Color - Main", "Color", 0, "Ai4rei/AN, Shakto", "Changes the Main Chat color and sets it to the specified value", false);

registerPatch( 57, "ChatColorGuild", "�ק綠�|�T����r�C��", "Color", 0, "Ai4rei/AN, Shakto", "���� ���| ��ѵ�����r���C��A�w�]�Ȭ� B4FFB4 (�G���)", false);

registerPatch( 58, "ChatColorPartyOther", "�ק�ն���L�H�T����r�C��", "Color", 0, "Ai4rei/AN, Shakto", "���� �ն���L�H ��ѵ�����r���C��A�w�]�Ȭ� FFC8C8 (������)", false);

registerPatch( 59, "ChatColorPartySelf", "�ק�ն��ۤv�o����r�C��", "Color", 0, "Ai4rei/AN, Shakto", "���� �ն��ۤv�o�� ���C��A�w�]�Ȭ� FFC800 (���)", false);

registerPatch( 60, "ChatColorPlayerSelf", "�ק�ۤv�o����r�C��", "Color", 0, "Ai4rei/AN, Shakto", "���� �ۤv�o�� ����ѵ�����r�C��A�w�]�Ȭ� 00FF00 (���)", false);

registerPatch( 61, "DisablePacketEncryption", "�����ʥ]�V�c", "UI", 0, "Ai4rei/AN", "�����ʥ]�V�c�A���\��ä��O�[�K�A�ӬO���C�ӫʥ]���@���H���y�����A�u�n����A�ݨS�������N�L�k�s�u", false);

registerPatch( 62, "DisableLoginEncryption", "Disable Login Encryption", "Fix", 0, "Neo", "Disable Encryption in Login Packet 0x2b0", true);

registerPatch( 63, "UseOfficialClothPalette", "Use Official Cloth Palettes", "UI", 0, "Neo", "Use Official Cloth Palette on all LangTypes. Do not use this if you are using the 'Enable Custom Jobs' patch", false);

registerPatch( 64, "FixChatAt", "�״_ @ �Ÿ� Bug", "UI", 0, "Shinryo", "�״_��ѵ��������J @ ������", true);

registerPatch( 65, "ChangeItemInfo", "Load Custom lua file instead of iteminfo*.lub", "�ۭq", 19, "Neo", "Makes the client load your own lua file instead of iteminfo*.lub . If you directly use itemInfo*.lub for your translated items, it may become lost during the next kRO update", true);

registerPatch( 66, "LoadItemInfoPerServer", "Load iteminfo with char server", "Data", 0, "Neo", "Load ItemInfo file and call main function with selected char server name as argument", false);

registerPatch( 67, "DisableQuakeEffect", "�����ޯ�_�ʮĪG", "UI", 0, "Ai4rei/AN", "�����ޯ�_�ʮĪG�B�a���B�z�𵥵�", false);

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

registerPatch( 88, "AllowSpaceInGuildName", "���\���|�W�٤����ť�", "UI", 0, "Shakto", "���\�Ф��|�ɡA���|�W���ϥΪť� (/guild \"�� ��\")", false);

registerPatch( 90, "EnableDNSSupport", "Enable DNS Support", "UI", 0, "Shinryo", "Enable DNS support for clientinfo.xml", true);

registerPatch( 91, "DCToLoginWindow", "Disconnect to Login Window", "UI", 0, "Neo", "Make the client return to Login Window upon disconnection", false);

registerPatch( 92, "PacketFirstKeyEncryption", "Packet First Key Encryption", "Packet", 9, "Shakto, Neo", "Change the 1st key for packet encryption. Dont select the patch Disable Packet Header Encryption if you are using this. Don't use it if you don't know what you are doing", false);

registerPatch( 93, "PacketSecondKeyEncryption", "Packet Second Key Encryption", "Packet", 9, "Shakto, Neo", "Change the 2nd key for packet encryption. Dont select the patch Disable Packet Header Encryption if you are using this. Don't use it if you don't know what you are doing", false);

registerPatch( 94, "PacketThirdKeyEncryption", "Packet Third Key Encryption", "Packet", 9, "Shakto, Neo", "Change the 3rd key for packet encryption. Dont select the patch Disable Packet Header Encryption if you are using this. Don't use it if you don't know what you are doing", false);

registerPatch( 95, "UseSSOLoginPacket", "Use SSO Login Packet", "Packet", 10, "Ai4rei/AN", "Enable using SSO packet on all LangType (to use login and pass with a launcher)", false);

registerPatch( 96, "RemoveGMSprite", "Remove GM Sprites", "UI", 0, "Neo", "Remove the GM sprites and keeping all the functionality like Yellow name and Admin right click menu", false);

registerPatch( 97, "CancelToLoginWindow", "������^�n�J����", "Fix", 0, "Neo", "�b��ܨ���ɡA�i�H�I������^�n�J�����A�Ӥ��O�����C��", true);

registerPatch( 98, "DisableDCScream", "Disable dc_scream.txt", "UI", 0, "Neo", "Disable chat on file dc_scream", false);

registerPatch( 99, "DisableBAFrostJoke", "Disable ba_frostjoke.txt", "UI", 0, "Neo", "Disable chat on file ba_frostjoke", false);

registerPatch(100, "DisableMultipleWindows", "�T��n�J�����}", "UI", 0, "Shinryo, Ai4rei/AN", "�T��n�J�����}(�o�L�k�������})", false);

registerPatch(101, "SkipCheaterFriendCheck", "Skip Friend list Cheat Check", "UI", 0, "Ai4rei/AN", "Prevents warnings during PM's when the sender has similar name to one of your friends", false);

registerPatch(102, "SkipCheaterGuildCheck", "Skip Guild Member Cheat Check", "UI", 0, "Ai4rei/AN", "Prevents warnings during PM's when the sender has similar name to one of your guild members", false);

registerPatch(103, "DisableAutofollow", "�����۰ʸ��H�\��", "UI", 0, "Functor, Neo", "�����۰ʸ��H���\�� Shift+�k��", false);

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

registerPatch(114, "ChangeVendingLimit", "�ק怜�ʰө����B����[Experimental]", "Data", 0, "Neo", "�ק怜�ʰө��̦h100�U������", false);

registerPatch(115, "EnableEffectForAllMaps", "Enable Effect for all Maps [Experimental]", "Data", 0, "Neo", "Make the client load the corresponding file in EffectTool folder for all maps", false);

//registerPatch(151, "UseArialOnAllLangTypes", "Use Arial on All LangTypes", "UI", 0, "Ai4rei/AN, Shakto", "Makes Arial the default font on all LangTypes (it's enable ascii by default)", true);

//FixTetraVortex patch is removed since the black screen animation issue is fixed Server Side

//======================================//
// Special Patches by Neo and Curiosity //
//======================================//

registerPatch(200, "EnableMultipleGRFsV2", "Enable Multiple GRFs - Embedded", "�ۭq", 5, "Neo", "Enables the use of multiple grf files without needing INI file in client folder. Instead you specify the INI file as input to the patch", false);

registerPatch(201, "EnableCustomHomunculus", "Enable Custom Homunculus", "�ۭq", 0, "Neo", "Enables the addition of Custom Homunculus using Lua Files", false);

registerPatch(202, "EnableCustomJobs", "Enable Custom Jobs", "�ۭq", 0, "Neo", "Enables the use of Custom Jobs (using Lua Files similar to Xray)", false);

registerPatch(203, "EnableCustomShields", "Enable Custom Shields", "�ۭq", 0, "Neo", "Enables the use of Custom Shield Types (using Lua Files similar to Xray)", false);

registerPatch(204, "IncreaseAtkDisplay", "Increase Attack Display", "�ۭq", 0, "Neo", "Increases the limit of digits displayed while attacking from 6 to 10", false);

registerPatch(205, "EnableMonsterTables", "Enable Monster Tables", "�ۭq", 0, "Ind, Neo", "Enables Loading of MonsterTalkTable.xml, PetTalkTable.xml & MonsterSkillInfo.xml for all LangTypes", false);

registerPatch(206, "LoadCustomQuestLua", "Load Custom Quest Lua/Lub files", "�ۭq", 0, "Neo", "Enables loading of custom lua files used for quests. You need to specify a txt file containing list of files in the 'lua files\\quest' folder to load (one file per line)", false);

registerPatch(207, "ResizeFont", "Resize Font", "�ۭq", 0, "Yommy, Neo", "Resizes the height of the font used to the value specified", false);

registerPatch(208, "RestoreCashShop", "Restore Cash Shop Icon", "Special", 0, "Neo", "Restores the Cash Shop Icon in RE clients that can have them", false);

registerPatch(209, "EnableMailBox", "Enable Mail Box for All LangTypes", "�ۭq", 0, "Neo", "Enables the full use of Mail Boxes and @mail commands (write is disabled for few LangTypes by default in 2013 Clients)", false);

registerPatch(210, "UseCustomIcon", "Use Custom Icon", "�ۭq", 4, "Neo", "Makes the hexed client use the User specified icon. Icon file should have an 8bpp (256 color) 32x32 image", false);

registerPatch(211, "UseCustomDLL", "Use Custom DLL", "�ۭq", 0, "Neo", "Makes the hexed client load the specified DLL and functions", false);

registerPatch(212, "RestoreRoulette", "Restore Roulette", "�ۭq", 0, "Neo", "Brings back the Roulette Icon that was removed in new clients", false);

registerPatch(213, "DisableHelpMsg", "�����C������", "�ۭq", 0, "Neo", "�����n�J�C����ܪ�����", true);

registerPatch(214, "RestoreModelCulling", "Restore Model Culling", "�ۭq", 0, "Curiosity", "Culls models in front of player by turning them transparent", false);

registerPatch(215, "IncreaseMapQuality", "Increase Map Quality", "�ۭq", 0, "Curiosity", "Makes client use 32 bit color maps for Map Textures", false);

registerPatch(216, "HideCashShop", "Hide Cash Shop", "�ۭq", 0, "Neo", "Hide Cash Shop Icon", false);

registerPatch(217, "HideRoulette", "Hide Roulette", "�ۭq", 0, "Neo", "Hide Roulette Icon", false);

registerPatch(218, "ShowExpNumbers", "Show Exp Numbers", "�ۭq", 0, "Neo", "Show Base and Job Exp numbers in Basic Info Window", false);

registerPatch(219, "ShowResurrectionButton", "��ܭ�a�_�����s", "�ۭq", 15, "Neo", "���⦺�`�ɱj����ܭ�a�_�����s(����mapflag���|���)", false);

registerPatch(220, "DisableMapInterface", "�����@�ɦa��", "�ۭq", 0, "Neo", "�����@�ɦa�ϥ\��", false);

registerPatch(221, "RemoveJobsFromBooking", "Remove Jobs from Booking", "�ۭq", 0, "Neo", "Removes user specified set of Job Names from Party Booking Window.", false);

registerPatch(222, "ShowReplayButton", "Show Replay Button", "�ۭq", 0, "Neo", "Makes the client show Replay button on Service Select screen that opens the Replay File List window", false);

registerPatch(223, "MoveItemCountUpwards", "Move Item Count Upwards [Experimental]", "�ۭq", 0, "Neo", "Move Item Count upwards in Shortcut Window so as to align with Skill Level display", false);

//registerPatch(224, "IncreaseNpcIDs", "Increase NPC Ids [Experimental]", "�ۭq", 0, "Neo", "Increase the Loaded NPC IDs to include 10K+ range IDs. Limits are configurable", false);

registerPatch(225, "ShowRegisterButton", "Show Register Button", "�ۭq", 0, "Neo", "Makes the client always show register button on Login Window for all Langtypes. Clicking the button will open <registrationweb> from clientinfo and closes the client.", false);

registerPatch(226, "DisableWalkToDelay", "Disable Walk To Delay.", "Fix", 16, "MegaByte", "Will have a quicker response to walking clicks. But client may likely send more/duplicated packets.", false);

registerPatch(227, "SetWalkToDelay", "Change Walk To Delay.", "Fix", 16, "MegaByte", "Can have a quicker response to walking clicks. But client may likely send more/duplicated packets.", false);

registerPatch(228, "DisableDoram", "Disable Doram Character Creation UI [Experimental]", "UI", 0, "Ai4Rei, Secret", "Disable Doram race in the character creation UI. Server-side disabling is also recommended", false);

registerPatch(229, "EnableEmblemForBG", "Enable Emblem hover for BG", "UI", 0, "Neo", "Makes the client show the Emblem on top of the character for Battleground mode as well along with GvG", false);

registerPatch(230, "AlwaysReadKrExtSettings", "Always load Korea ExternalSettings lua file", "Fix", 0, "Secret", "Makes the client load Korea server's ExternalSettings file for all langtypes.", false);

registerPatch(231, "RemoveHardcodedAddress", "Remove hardcoded address/port", "Fix", 17, "4144", "Remove hardcoded addresses and ports. For Zero client only.", false);

registerPatch(232, "RestoreOldLoginPacket", "Restore old login packet", "Fix", 17, "4144", "Make client send old 0x64 login packet. For Zero client only.", false);

registerPatch(233, "HideSNSButton", "Hide SNS Button", "UI", 12, "Secret", "Hide SNS (Twitter) button", false);

registerPatch(234, "IgnoreLuaErrors", "Ignore Lua Errors", "Fix", 0, "4144", "Prevents the client from displaying a error messages from lua code like 'attempt to call nil value'.", false);

registerPatch(235, "EnableGuildWhenInClan", "Enable guild while in clan", "�ۭq", 0, "Functor, Secret", "Remove restriction of guild functionality while being a member of a clan", false);

registerPatch(236, "EnablePlayerSkills", "Enable Custom Player Skills [Experimental]", "�ۭq", 18, "Neo", "Enables the use of custom skills castable on players (using Lua Files)", false);

registerPatch(237, "EnableHomunSkills", "Enable Custom Homunculus Skills [Experimental]", "�ۭq", 18, "Neo", "Enables the use of custom skills for Homunculus (using Lua Files)", false);

registerPatch(238, "EnableMerceSkills", "Enable Custom Mercenary Skills [Experimental]", "�ۭq", 18, "Neo", "Enables the use of custom skills for Mercenaries (using Lua Files)", false);

registerPatch(239, "IgnoreAccountArgument", "Ignore /account: command line argument", "Fix", 0, "Secret", "Makes the client ignore /account: command line argument to prevent custom clientinfo.xml from being used.", false);

registerPatch(240, "LoadCustomClientInfo", "Load custom ClientInfo file", "�ۭq", 0, "Secret", "Makes the client load your own clientinfo file instead of *clientinfo.xml", false);

registerPatch(241, "AlwaysLoadClientPlugins", "Always Load Client Plugins [Experimental]", "Fix", 0, "Secret", "Makes the client load client plug-ins regardless of its sound settings", false);

registerPatch(242, "DisableKROSiteLaunch", "Disable kRO Site Launch", "Fix", 0, "mrjnumber1", "Disable ro.gnjoy.com launching after in-game settings change", false);

registerPatch(243, "ChangeQuickSwitchDelay", "Change Quick Switch Delay", "Fix", 0, "mrjnumber1", "Change quick item switch delay", false);

registerPatch(244, "DisableCDGuard", "Disable Cheat Defender Game Guard", "Fix", 0, "4144", "Disables Cheat Defender Game Guard from new clients", false);

registerPatch(245, "FixedCharJobCreate", "Set fixed job id in char create dialog", "�ۭq", 0, "4144", "Override selected job in char creation packet", false);

registerPatch(246, "IncreaseHairSprites", "Increase hair style limit in game", "�ۭq", 0, "4144", "Allow use more hair styles than default limit", false);

registerPatch(247, "ChangeNewCharNameHeight", "Change new char name field height", "�ۭq", 0, "4144", "Allow change height in input field in new char creation dialog", false);

registerPatch(248, "RemoveWrongCharFromCashShop", "Remove wrong chars from cash shop", "�ۭq", 0, "4144", "Hide wrong field with random values in cash shop", false);

registerPatch(249, "ChangeMinimalResolutionLimit", "Change minimal screen resolution limit", "�ۭq", 0, "4144", "Allow change minimal client resolution (default value is 1024x768", false);

registerPatch(250, "AllowLeavelPartyLeader", "Allow leader to leave party if no members on map", "�ۭq", 0, "4144", "Allow leader to leave party if not party members on same map", false);

registerPatch(251, "AllowCloseCutinByEsc", "Allow close cutin by pressing esc key", "�ۭq", 0, "4144", "Allow close cutin window by pressing esc key", false);

//registerPatch(252, "FixAchievementCounters", "Fix achievement counters for each type of achievement", "�ۭq", 0, "4144", "Fix achievement counters for each type of achievement for 2017 clients", false);

registerPatch(300, "FixItemDescBug", "�״_���~�����ýXBug", "UI", 0, "Jchcc", "�״_���~�k�䤺�e '[' �y�����ýX", false);

registerPatch(301, "SetMaxItemCount", "Change Max Items in inventory", "UI", 0, "Jchcc", "Change maximum items in player inventory.", false);

registerPatch(302, "SetAutoFollowDelay", "�ۭq�۰ʧ��H����", "�ۭq", 0, "Jchcc", "���۰ʧ��H���K,��ֹL�ϸ�᪺���p", false);

registerPatch(303, "DefaultBrowserInCashshop", "�ιw�]�s�����}�Ұӫ����s��", "�ۭq", 0, "Jchcc", "�ϥιw�]���s�����}�ҷs���ӫ�(2018)�����s��", false);

registerPatch(304, "UseDefaultBrowser", "�ιw�]�s�����}��<URL>�s��", "�ۭq", 0, "Jchcc", "�ϥιw�]�s�����}��<URL>���s��,���A�ϥ�RO���ت��s����", false);

registerPatch(311, "NavigationButton", "�]�w �ɯ� ���s", "�ۭq", 12, "Jchcc", "�]�w20180416����n�J�������W���\����s�O�_���", false);

registerPatch(312, "BankButton", "�]�w �Ȧ� ���s", "�ۭq", 12, "Jchcc", "�]�w20180416����n�J�������W���\����s�O�_���", false);

registerPatch(313, "ReplayButton", "�]�w ���� ���s", "�ۭq", 12, "Jchcc", "�]�w20180416����n�J�������W���\����s�O�_���", false);

registerPatch(314, "MailButton", "�]�w �l�� ���s", "�ۭq", 12, "Jchcc", "�]�w20180416����n�J�������W���\����s�O�_���", false);

registerPatch(315, "AchievementButton", "�]�w ���N�t�� ���s", "�ۭq", 12, "Jchcc", "�]�w20180416����n�J�������W���\����s�O�_���", false);

registerPatch(316, "TipButton", "�]�w ���ܮ� ���s", "�ۭq", 12, "Jchcc", "�]�w20180416����n�J�������W���\����s�O�_���", false);

registerPatch(317, "ShopButton", "�]�w �ӫ� ���s", "�ۭq", 12, "Jchcc", "�]�w20180416����n�J�������W���\����s�O�_���", false);

registerPatch(318, "SNSButton", "�]�w TWITTER ���s", "�ۭq", 12, "Jchcc", "�]�w20180416����n�J�������W���\����s�O�_���", false);

registerPatch(319, "AttendanceButton", "�]�w ñ�� ���s", "�ۭq", 12, "Jchcc", "�]�w20180416����n�J�������W���\����s�O�_���", false);
