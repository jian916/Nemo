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
registerPatch(  1, "UseTildeForMatk", "�ϥ�~�����Matk�d��", "����", 0, "Neo", "�����檺Matk�϶����~���A�Ӥ��O+���AMatk �O�϶��ˮ`", false);

registerPatch(  2, "AllowChatFlood", "�o�ܬ~�W�P�_����", "����", 1, "Shinryo", "�]�w�o�ܬ~�W������A�w�]�O�u��o3���@�ˤ��e", false);

registerPatch(  3, "RemoveChatLimit", "�o�ܬ~�W��������", "����", 1, "Neo", "�����o�ܬ~�W������(�]�w���ƭ���ﶵ�|����)", false);

registerPatch(  4, "CustomAuraLimits", "�ۭq������ܱ���", "����", 0, "Neo", "�i�H�ק������ܪ�����(�d���ɦbInput\auraSpec.txt)", false);

registerPatch(  5, "EnableProxySupport", "�ҥΥN�z���A��", "�״_", 0, "Ai4rei/AN", "�O�_�䴩�N�z���A��", false);

registerPatch(  6, "ForceSendClientHash", "�o�e�n�J������X", "�ʥ]", 0, "GreenBox, Neo", "�O�_�o�e�n�J���� MD5 ����X�A�ݭn�������䴩�A�i�H����n�J���Q�ק�A�άO���ӭ���n�J��(�blogin_athena.conf�]�w)", false);

//registerPatch(  7, "ChangeGravityErrorHandler", "Change Gravity Error Handler", "�״_", 0, " ", "It changes the Gravity Error Handler Mesage for a Custom One Pre-Defined by Diff Team", false);

registerPatch(  8, "CustomWindowTitle", "�ק�n�J�����D[�^��]", "����", 0, "Shinryo", "�ק�n�J�������D(���䴩����A����n��16�i��ۦ�ק�)�A�w�]�� 'Ragnarok'", false);

registerPatch(  9, "Disable1rag1Params", "���ΰѼƪ����ҰʹC��", "�״_", 0, "Shinryo", "���� 1rag1 �ѼƴN�i�H�����ҰʹC���A�Y�S�ΰѼƱҰʹC���|��ܪťժ� Error", true);

registerPatch( 10, "Disable4LetterCharnameLimit", "��������W�̤�4�Ӧr����", "�״_", 0, "Shinryo", "��������W�ٳ̤�4�Ӧr������ (���A���٬O������)", false);

registerPatch( 11, "Disable4LetterUsernameLimit", "�����b���̤�4�Ӧr����", "�״_", 0, "Shinryo", "�����b���̤�4�Ӧr������ (���A���٬O������)", false);

registerPatch( 12, "Disable4LetterPasswordLimit", "�����K�X�̤�4�Ӧr����", "�״_", 0, "Shinryo", "�����K�X�̤�4�Ӧr������ (���A���٬O������)", false);

registerPatch( 13, "DisableFilenameCheck", "�����n�J���W���ˬd", "�״_", 0, "Shinryo", "�����n�J���W���ˬd�A�ѨM�ɦW�u�n���ORagexe.exe�N�L�k�ҰʹC�������D", true);

registerPatch( 14, "DisableHallucinationWavyScreen", "Disable Hallucination Wavy Screen", "�״_", 0, "Shinryo", "Disables the Hallucination effect (screen becomes wavy and lags the client), used by baphomet, horongs, and such", true);

registerPatch( 15, "DisableHShield", "�����b�ȫO�@�{��", "�״_", 0, "Ai4rei/AN, Neo", "�����b�ȫO�@�{���A�n Diff �N�@�w�n���� (���|�Y aossdk.dll �� v3hunt.dll)", true);

registerPatch( 16, "DisableSwearFilter", "�����o���L�o", "����", 0, "Shinryo", "�����o���L�o����A���� manner.txt ��������r", false);

registerPatch( 17, "EnableOfficialCustomFonts", "�ϥΩx�誺�r��", "����", 0, "Shinryo", "�ϥΩx��i�諸�r��(�u�Yeot�r���ɡA�i��ttf����)", false);

registerPatch( 18, "SkipServiceSelect", "���L���A����ܤ���", "����", 0, "Shinryo", "���L���A����ܪ������A�w�]�|��Ĥ@�Ӧ��A��", false);

registerPatch( 19, "EnableTitleBarMenu", "�C�����D��ܥ\��C", "����", 0, "Shinryo", "���C�����k�W����ܥ\��C(�Y�p&����)", false);

registerPatch( 20, "ExtendChatBox", "�X�W��ѿ�J����", "����", 0, "Shinryo", "�X�W��ѵ�����J���r�ƭ���(�̤�70�B�̦h234)", false);

registerPatch( 21, "ExtendChatRoomBox", "�X�W��ѫǿ�J����", "����", 0, "Shinryo", "�X�W��ѫǿ�J���r�ƭ���(�̤�70�B�̦h234)", false);

registerPatch( 22, "ExtendPMBox", "�X�W�K�W��J����", "����", 0, "Shinryo", "�X�W�K�W(1:1)���r�ƭ���(�̤�70�B�̦h221)", false);

registerPatch( 23, "EnableWhoCommand", "�}�� /who ���O", "����", 0, "Neo", "�}�� /who ���O�A�d�߽u�W�H�ơA��Ҧ�(langtype)���}�� (�ݭn���A�ݤ䴩)", true);

registerPatch( 24, "FixCameraAnglesRecomm", "�ץ���������(��ĳ)", "����", 2, "Shinryo", "�ץ����������סA��ĳ������ 60 ��", true);

registerPatch( 25, "FixCameraAnglesLess", "�ץ���������(�̤p)", "����", 2, "Shinryo", "�ץ����������סA����̤p���� 30 ��", false);

registerPatch( 26, "FixCameraAnglesFull", "�ץ���������(�L����)", "����", 2, "Shinryo", "�ץ����������סA�L����� (shift+�k����۲���)", false);

registerPatch( 27, "HKLMtoHKCU", "�n�����x�s��m(HKLM��HKCU)", "�״_", 0, "Shinryo", "�����]�w�b�n�����x�s����m�A�ҰʹC�����мu Setup �N�O�o�ӭ�]", false);

registerPatch( 28, "IncreaseViewID", "�X�W�Y���s��", "���", 0, "Shinryo", "�X�W�Y�����s��(�w�]2000�A�̤j32000)", false);

registerPatch( 29, "DisableGameGuard", "Disable Game Guard", "�״_", 0, "Neo", "Disables Game Guard from new clients", true);

registerPatch( 30, "IncreaseZoomOut50Per", "��������W�[ 50%", "����", 3, "Shinryo", "�W�[ 50% �������񭭨� (�u���Ի���)", false);

registerPatch( 31, "IncreaseZoomOut75Per", "��������W�[ 75%", "����", 3, "Shinryo", "�W�[ 75% �������񭭨� (�u���Ի���)", false);

registerPatch( 32, "IncreaseZoomOutMax", "�����������", "����", 3, "Shinryo", "�����������񭭨� (�u���Ի���)", false);

registerPatch( 33, "KoreaServiceTypeXMLFix", "Always Call SelectKoreaClientInfo()", "�״_", 0, "Shinryo", "Calls SelectKoreaClientInfo() always before SelectClientInfo() allowing you to use features that would be only visible on Korean Service Type", true);

registerPatch( 34, "EnableShowName", "�w�]�ҥ�/showname�\��", "�״_", 0, "Neo", "���\��|��W�r�򤽷|�ٸ��ﴫ�A²�ƨå[����ܡA���òն��W�򤽷|�W (�w�]�ҥ�/showname�\��)", false);

registerPatch( 35, "ReadDataFolderFirst", "�u��Ū��data��Ƨ�", "���", 0, "Shinryo", "�u��Ū��data��Ƨ����ɮ�", true);

registerPatch( 36, "ReadMsgstringtabledottxt", "�ϥ�msgstringtable.txt�����T��", "���", 0, "Shinryo", "�ϥ�msgstringtable.txt���Ҧ������T���A�S�Ŀ�w�]�O����ýX", true);

registerPatch( 37, "ReadQuestid2displaydottxt", "�ϥ�questid2display.txt���ȰT��", "���", 0, "Shinryo", "�ϥ�questid2display.txt���Q�ʥ��ȰT��", true);

registerPatch( 38, "RemoveGravityAds", "����Gravity���s�i", "����", 0, "Shinryo", "�����n�J������ܪ� Gravity �s�i", true);

registerPatch( 39, "RemoveGravityLogo", "����Gravity��Logo", "����", 0, "Shinryo", "�����n�J������ܪ� Gravity Logo", true);

registerPatch( 40, "RestoreLoginWindow", "��_�ª��n�J�ɭ�", "�״_", 10, "Shinryo, Neo", "��_�ª����n�J�ɭ��A�S�Ŀ�N�S�n�J�ɭ���", true);

registerPatch( 41, "DisableNagleAlgorithm", "����Nagle���d�w��", "�ʥ]", 0, "Shinryo", "���� Nagle �t��k�ANagle ²�����O�w�ĺt��k(��ƨ�F�@�w���q�~�|�@�öǿ�)�A�ϥΦ��t��k�i�H��ֺ����ǿ�q�A���|�W�[����A�H�ثe�����W�e�����S���t�o�@�I�A�ҥH�|�Ŀ�����", true);

registerPatch( 42, "SkipResurrectionButton", "���í�a�_���ﶵ", "����", 15, "Shinryo", "���⦺�`�ɡA����ܭ�a�_���ﶵ", false);

registerPatch( 43, "DeleteCharWithEmail", "�ϥΫH�c��R�����⪺�K�X", "�״_", 0, "Neo", "�R������ɡA�ϥΫH�c�ӷ�K�X�A�Ӥ��A��J�ͤ�A�j��Ҧ�(langtype)���ϥ�", false);

registerPatch( 44, "TranslateClient", "½Ķ�n�J���g��������", "����", 0, "Ai4rei/AN, Neo", "�״_�@�Ǽg���A�n�J�����L�k½Ķ������A�|��TranslateClient.txt�����", true);

registerPatch( 45, "UseCustomAuraSprites", "�ϥΦۻs����������", "���", 0, "Shinryo", "�ϥΦۻs����������", false);

registerPatch( 46, "UseNormalGuildBrackets", "���ܤu�|�W�٥~��", "����", 0, "Shinryo", "�ק﨤��ID����ܪ��u�|�W�٥~�ءA�w�]()�A�Ŀ�ϥ�[]", true);

registerPatch( 47, "UseRagnarokIcon", "�ϥ�RO�w�]Icon�ϥ�", "����", 4, "Shinryo, Neo", "�ϥ�RO�w�]��Icon�ϥ�", false);

registerPatch( 48, "UsePlainTextDescriptions", "��r�ɨϥί¤�r", "���", 0, "Shinryo", "��r�ɨϥί¤�r�A�Ӥ��O�s�X�L��", true);

registerPatch( 49, "EnableMultipleGRFs", "Ū���h�� GRF [INI]", "�ۭq", 5, "Shinryo", "�ҥΫ�Ū���h��GRF�A�Ŀ�ɥi��J�ۭq���W��(�w�] data.ini)�A�̦h�u��Ū��10�� GRF", true);

registerPatch( 50, "SkipLicenseScreen", "���L���v���ڤ���", "����", 14, "Shinryo, MS", "���L����ܱ��v���ڡA��������A����ܵe��", false);

registerPatch( 51, "ShowLicenseScreen", "�ҰʹC������ܱ��v����", "����", 14, "Neo", "�j��n�J����ܱ��v���ڡA�j��Ҧ�(langtype)�����", false);

registerPatch( 52, "UseCustomFont", "�ϥΦۭq�r��", "����", 0, "Ai4rei/AN", "�ϥΦۭq���r���A�t�Φr���۰�����", false);

registerPatch( 53, "UseAsciiOnAllLangTypes", "�ϥ� Ascii �s�X��ܤ�r", "����", 0, "Ai4rei/AN", "�ϥ� Ascii �s�X��ܤ�r", true);

registerPatch( 54, "ChatColorGM", "�ק�GM�T����r�C��", "�C��", 0, "Ai4rei/AN, Shakto", "���� GM ��ѵ�����r���C��A�w�]�Ȭ� FFFF00 (����)", false);

registerPatch( 55, "ChatColorPlayerOther", "�ק�@��T����r�C��", "�C��", 0, "Ai4rei/AN, Shakto", "���� �@���� ��ѵ�����r���C��A�w�]�Ȭ� FFFFFF (�զ�)" );

//Disabled since GM Chat Color also patches the Main color - to be removed
//registerPatch( 56, "ChatColorMain", "Chat Color - Main", "�C��", 0, "Ai4rei/AN, Shakto", "Changes the Main Chat color and sets it to the specified value", false);

registerPatch( 57, "ChatColorGuild", "�ק綠�|�T����r�C��", "�C��", 0, "Ai4rei/AN, Shakto", "���� ���| ��ѵ�����r���C��A�w�]�Ȭ� B4FFB4 (�G���)", false);

registerPatch( 58, "ChatColorPartyOther", "�ק�ն���L�H�T����r�C��", "�C��", 0, "Ai4rei/AN, Shakto", "���� �ն���L�H ��ѵ�����r���C��A�w�]�Ȭ� FFC8C8 (������)", false);

registerPatch( 59, "ChatColorPartySelf", "�ק�ն��ۤv�o����r�C��", "�C��", 0, "Ai4rei/AN, Shakto", "���� �ն��ۤv�o�� ���C��A�w�]�Ȭ� FFC800 (���)", false);

registerPatch( 60, "ChatColorPlayerSelf", "�ק�ۤv�o����r�C��", "�C��", 0, "Ai4rei/AN, Shakto", "���� �ۤv�o�� ����ѵ�����r�C��A�w�]�Ȭ� 00FF00 (���)", false);

registerPatch( 61, "DisablePacketEncryption", "�����ʥ]�V�c", "�ʥ]", 0, "Ai4rei/AN", "�����ʥ]�V�c�A���\��ä��O�[�K�A�ӬO���C�ӫʥ]���@���H���y�����A�u�n����A�ݨS�������N�L�k�s�u", false);

registerPatch( 62, "DisableLoginEncryption", "�����n�J�ʥ]�[�K", "�ʥ]", 0, "Neo", "�����n�J�ʥ]�[�K�A�ʥ] 0x2b0", true);

registerPatch( 63, "UseOfficialClothPalette", "�ϥΩx��~�[�V����", "����", 0, "Neo", "�ϥΩx��w�]���~�[�V����", false);

registerPatch( 64, "FixChatAt", "�״_ @ �Ÿ� Bug", "�״_", 0, "Shinryo", "�״_��ѵ��������J @ ������", true);

registerPatch( 65, "ChangeItemInfo", "�ק�iteminfo*.lub���|", "�ۭq", 19, "Neo", "�Ŀ��i�H��J�ۭq�����N iteminfo*.lub �ɮסA�p�G���x�誺��s�A�i�H����쥻�� lub �Q�л\", true);

registerPatch( 66, "LoadItemInfoPerServer", "�Φ��A���W�٦۰ʿ��iteminfo", "���", 0, "Neo", "�� iteminfo �� main function �ޤJ���A���W�١A�۰ʧP�_�ݭn�����e�A�����y�B�ݭn���Piteminfo�~�|�Ψ�", false);

registerPatch( 67, "DisableQuakeEffect", "�����ޯ�_�ʮĪG", "����", 0, "Ai4rei/AN", "�����ޯ�_�ʮĪG�B�a���B�z�𵥵�", false);

registerPatch( 68, "Enable64kHairstyle", "�Ѱ��v���ƶq����", "����", 0, "Ai4rei/AN", "�Ѱ��v���ƶq����A�䴩64k�ؾv���A�x��� 27 ��", false);

registerPatch( 69, "ExtendNpcBox", "�X�Winput���r�ƭ���", "����", 0, "Ai4rei/AN", "�X�W�}�� input ���r�ƭ���(�̤�2052�B�̦h4096)", false);

registerPatch( 70, "CustomExpBarLimits", "�ۭq�g�����ܱ���", "����", 0, "Neo", "�i�H�ק�g�����ܪ����� (�d���ɦbInput\\expBarSpec.txt)", false);

registerPatch( 71, "IgnoreResourceErrors", "�����ɤB�ɮ׿��~", "�״_", 0, "Shinryo", "�����Ҧ��귽���ɿ��~(�i���U�����ADeBug�ɤ��Τ�)", false);

registerPatch( 72, "IgnoreMissingPaletteError", "�����V���ɮ׿��~", "�״_", 0, "Shinryo", "�����V���ɮׯ��ɪ����~(�i���U�����ADeBug�ɤ��Τ�)", false);

registerPatch( 73, "RemoveHourlyAnnounce", "�������d����", "����", 0, "Ai4rei/AN", "�������d���ܡA�N�O�C�Ӥp�ɪ��ݭԻy", true);

registerPatch( 74, "IncreaseScreenshotQuality", "�ק�I�Ϫ��~��", "����", 0, "Ai4rei/AN", "�ק�I�� jpeg ���~�� (�̤p0%�A�̤j100%)", false);

registerPatch( 75, "EnableFlagEmotes", "�ҥκX�l��", "����", 0, "Neo", "�O�_�ҥκX�l���A�ݭn�ۦ�]�w�X�l���C��", false);

registerPatch( 76, "EnforceOfficialLoginBackground", "�ϥΩx��n�J�I��", "����", 0, "Shinryo", "�j��ϥΩx�誺�n�J�I����", false);

registerPatch( 77, "EnableCustom3DBones", "���J�ۻs��3D�ҫ�", "�ۭq", 0, "Ai4rei/AN", "�O�_���J�ۻs��3D�ҫ�", false);

registerPatch( 78, "MoveCashShopIcon", "���ʰӫ��ϥܦ�m", "����",  11, "Neo", "���ʰӫ��ϥ���ܪ���m", false);

registerPatch( 79, "SharedBodyPalettesV2", "�A�˦@�άV����", "����", 6, "Ai4rei/AN, Neo", "�A�˦@�γ�@�V���ɡA�榡��(body_%d.pal)", false);

registerPatch( 80, "SharedBodyPalettesV1", "�A�˦@�άV����(���k�k)", "����", 6, "Ai4rei/AN, Neo", "�A�˦@�γ�@�V����(���k�k)�A�榡��(body_%s_%d.pal)", false);

registerPatch( 81, "RenameLicenseTxt", "�ק���v���ڸ��|", "���", 0, "Neo", "�ק���v���� licence.txt ���ɮצW��", false);

registerPatch( 82, "SharedHeadPalettesV1", "�v��@�άV����(���k�k)", "����", 7, "Ai4rei/AN, Neo", "�v��@�γ�@�V����(���k�k)�A�榡��(head_%s_%d.pal)", false);

registerPatch( 83, "SharedHeadPalettesV2", "�v��@�άV����", "����", 7, "Ai4rei/AN, Neo", "�v��@�γ�@�V���ɡA�榡��(head_%d.pal)", false);

registerPatch( 84, "RemoveSerialDisplay", "�����k�U���Ǹ����", "����", 0, "Shinryo", "�����C�������k�U�����Ǹ����", true);

registerPatch( 85, "ShowCancelToServiceSelect","��ܦ��A���ɥi�W�@�B", "����", 0, "Neo", "�n�J�b���ɡA�i�H�I�W�@�B���s��ܦ��A��", false);

registerPatch( 86, "OnlyFirstLoginBackground", "�u��ܲĤ@�حI���Ϥ�", "����", 8, "Shinryo", "�u��ܲĤ@�حI���Ϥ�", false);

registerPatch( 87, "OnlySecondLoginBackground", "�u��ܲĤG�حI���Ϥ�", "����", 8, "Shinryo", "�u��ܲĤG�حI���Ϥ�", false);

registerPatch( 88, "AllowSpaceInGuildName", "���\���|�W�٤����ť�", "����", 0, "Shakto", "���\�Ф��|�ɡA���|�W���ϥΪť� (/guild \"�� ��\")", false);

registerPatch( 90, "EnableDNSSupport", "IP�䴩��W(DNS)�ѪR", "���", 0, "Shinryo", "�O�_�䴩��W�ѪR�A�ҥΫ� clientinfo.xml �Y�i�ϥκ��}������IP �Ҧp: roip.no-ip.net", true);

registerPatch( 91, "DCToLoginWindow", "�_�u��۰ʪ�^�n�J����", "����", 0, "Neo", "�_�u��O�_��^�n�J�����A�w�]�O���������C��", false);

registerPatch( 92, "PacketFirstKeyEncryption", "�]�w�ʥ]�V�c�Ĥ@��key", "�ʥ]", 9, "Shakto, Neo", "�ʥ]�V�c���Ĥ@��key (���ϥΪ��ܡA�ݸ����������)", false);

registerPatch( 93, "PacketSecondKeyEncryption", "�]�w�ʥ]�V�c�ĤG��key", "�ʥ]", 9, "Shakto, Neo", "�ʥ]�V�c���ĤG��key (���ϥΪ��ܡA�ݸ����������)", false);

registerPatch( 94, "PacketThirdKeyEncryption", "�]�w�ʥ]�V�c�ĤT��key", "�ʥ]", 9, "Shakto, Neo", "�ʥ]�V�c���ĤT��key (���ϥΪ��ܡA�ݸ����������)", false);

registerPatch( 95, "UseSSOLoginPacket", "�ϥ�SSO�n�J�ʥ]", "�ʥ]", 10, "Ai4rei/AN", "�ϥ�SSO�覡�n�J�A�i�H�ϥΰѼƪ��覡�n�J (�n�JRestore Login Window����Ŀ�)", false);

registerPatch( 96, "RemoveGMSprite", "����GM�~�[", "����", 0, "Neo", "����GM�~�[�A�ϥιw�]��¾�~�Ҳ�", false);

registerPatch( 97, "CancelToLoginWindow", "�﨤�ɨ�����^�n�J����", "�״_", 0, "Neo", "�b��ܨ���ɡA�i�H�I������^�n�J�����A�Ӥ��O�����C��", true);

registerPatch( 98, "DisableDCScream", "��Ū�����n�y�s���ɮ�", "����", 0, "Neo", "��Ū�����n�y�s���ɮ� dc_scream.txt", false);

registerPatch( 99, "DisableBAFrostJoke", "��Ū���N���ܪ��ɮ�", "����", 0, "Neo", "��Ū���N���ܪ��ɮ� ba_frostjoke.txt", false);

registerPatch(100, "DisableMultipleWindows", "�T��n�J�����}", "����", 0, "Shinryo, Ai4rei/AN", "�T��n�J�����}(�o�L�k�������})", false);

registerPatch(101, "SkipCheaterFriendCheck", "�����B�ͦW�٬ۦ�����", "����", 0, "Ai4rei/AN", "�b�K�y�������ۦ��B�ͦW�r������", false);

registerPatch(102, "SkipCheaterGuildCheck", "�������|���a�W�٬ۦ�����", "����", 0, "Ai4rei/AN", "�b�K�y�������ۦ��u�|���a�W�r������", false);

registerPatch(103, "DisableAutofollow", "�����۰ʸ��H�\��", "�ۭq", 0, "Functor, Neo", "�����۰ʸ��H���\�� Shift+�k��", false);

registerPatch(104, "IncreaseHairLimits", "�X�W�v����V���ɽs��", "����", 0, "Neo", "�X�W�v����V���ɽs��");

// registerPatch(105, "HideNavButton", "����[�ɯ�]���s", "����", 12, "Neo", "���þɯ誺���s", false);

// registerPatch(106, "HideBgButton", "����[�Գ�]���s", "����", 12, "Neo", "���þԳ������s", false);

// registerPatch(107, "HideBankButton", "����[�Ȧ�]���s", "����", 12, "Neo", "���ûȦ檺���s", false);

// registerPatch(108, "HideBooking", "����[�۶�]���s", "����", 12, "Neo", "���òն��۶Ҫ����s", false);

// registerPatch(109, "HideRodex", "����[�H�c]���s", "����", 12, "Neo", "���ëH�c(RODEX)�����s", false);

// registerPatch(110, "HideAchieve", "����[���N]���s", "����", 12, "Neo", "���æ��N�����s", false);

// registerPatch(111, "HideRecButton", "����[���v]���s", "����", 12, "Neo", "���ÿ��v�����s", false);

// registerPatch(112, "HideMapButton", "����[�a��]���s", "����", 12, "Neo", "���æa�Ϫ����s", false);

// registerPatch(113, "HideQuest", "����[����]���s", "����", 12, "Neo", "���å��Ȫ����s", false);

registerPatch(114, "ChangeVendingLimit", "�ק怜�ʰө����B���� [����]", "���", 0, "Neo", "�ק怜�ʰө��̦h100�U������", false);

registerPatch(115, "EnableEffectForAllMaps", "�}�Ҧa�ϯS�� [����]", "���", 0, "Neo", "�b�Ҧ��a�϶}�Ҧa�ϯS�� (EffectTool)", false);

//registerPatch(151, "UseArialOnAllLangTypes", "Use Arial on All LangTypes", "����", 0, "Ai4rei/AN, Shakto", "Makes Arial the default font on all LangTypes (it's enable ascii by default)", true);

//FixTetraVortex patch is removed since the black screen animation issue is fixed Server Side

//======================================//
// Special Patches by Neo and Curiosity //
//======================================//

registerPatch(200, "EnableMultipleGRFsV2", "Ū���h�� GRF [���O����]", "�ۭq", 5, "Neo", "�Ŀ�ɸ��J�w���]�w�n��(data.ini)�A���O�b�n�J����", false);

registerPatch(201, "EnableCustomHomunculus", "���J�ۻs���ͩR��", "�ۭq", 0, "Neo", "�O�_���J�ۻs���ͩR��", false);

registerPatch(202, "EnableCustomJobs", "���J�ۻs��¾�~�~�[", "�ۭq", 0, "Neo", "�O�_���J�ۻs��¾�~�~�[", false);

registerPatch(203, "EnableCustomShields", "���J�ۻs���޵P�~�[", "�ۭq", 0, "Neo", "�O�_���J�ۻs���޵P�~�[", false);

registerPatch(204, "IncreaseAtkDisplay", "�X�W�ˮ`��ܦ��", "�ۭq", 0, "Neo", "�X�W�ˮ`��ܪ���ơA�w�]�O6���99�U9999�A�ҥΫ���10��", false);

registerPatch(205, "EnableMonsterTables", "Ū���]������ɮ�", "�ۭq", 0, "Ind, Neo", "Ū���]������ɮסAMonsterTalkTable.xml�BPetTalkTable.xml �M MonsterSkillInfo.xml", false);

registerPatch(206, "LoadCustomQuestLua", "���J�ۻs������ lub ��", "�ۭq", 0, "Neo", "���J�ۻs������ lub �ɡA�b�ɤB lua files\quest �̭�", false);

registerPatch(207, "ResizeFont", "�ק�r���j�p", "����", 0, "Yommy, Neo", "�ק�r���j�p�A�w�]�O10�A�����j�|�ܫ���", false);

registerPatch(208, "RestoreCashShop", "��_�k�W��[�ӫ�]�ϥ�", "�S��", 0, "Neo", "��_�k�W��ӫ������s�ϥܡARE �����S���ӫ��~�n�Ŀ�", false);

registerPatch(209, "EnableMailBox", "��_�H�c�\��", "����", 0, "Neo", "�ҥΫH�c�\��(�ª��H�c�A�D RODEX)�A��Ҧ�(langtype)���䴩", false);

registerPatch(210, "UseCustomIcon", "�ϥΦۻs���ϥ�", "����", 4, "Neo", "�ϥΦۻs���ϥ� 8bpp (256 ��) 32x32 �Ϥ�", false);

registerPatch(211, "UseCustomDLL", "���J�ۻs�� DLL", "�ۭq", 0, "Neo", "�����ۻs�� DLL�A�Ҧp �Ұʰʵe (�d���ɦbInput\dlls.txt)", false);

registerPatch(212, "RestoreRoulette", "��_�k�W��[��L]�ϥ�", "�S��", 0, "Neo", "��_�k�W����L���s�ϥܡA�s���w�]�w����", false);

registerPatch(213, "DisableHelpMsg", "�����n�J�C�����оǴ���", "����", 0, "Neo", "�����n�J�C����ܪ��оǴ���", true);

registerPatch(214, "RestoreModelCulling", "��_�z���Ҳ�", "�S��", 0, "Curiosity", "�z���ҲաA���a�b�Фl�᭱�|�N�Фl�z���ƳB�z(���Ǧa�Ϧ�BUG)", false);

registerPatch(215, "IncreaseMapQuality", "�a�Ϥ䴩32�줸���z", "�ۭq", 0, "Curiosity", "���a�Ϥ䴩32�줸�C�⯾�z", false);

registerPatch(216, "HideCashShop", "���åk�W��[�ӫ�]�ϥ�", "����", 12, "Neo", "���åk�W��ӫ����s�ϥ�", false);

registerPatch(217, "HideRoulette", "���åk�W��[��L]�ϥ�", "����", 12, "Neo", "���åk�W����L���s�ϥ�", false);

registerPatch(218, "ShowExpNumbers", "��ܸg���", "����", 0, "Neo", "�b���W�����⪬�A����ܸg���", false);

registerPatch(219, "ShowResurrectionButton", "��ܭ�a�_�����s", "����", 15, "Neo", "���⦺�`�ɱj����ܭ�a�_�����s(����mapflag���|���)", false);

registerPatch(220, "DisableMapInterface", "�����@�ɦa��", "����", 0, "Neo", "�����@�ɦa�ϥ\��", false);

registerPatch(221, "RemoveJobsFromBooking", "�ն��۶Ҥ����¾�~�W��", "����", 0, "Neo", "�ն��۶Ҥ����¾�~�W��", false);

registerPatch(222, "ShowReplayButton", "��ܿ��v������s", "����", 0, "Neo", "��ܦ��A���ɡA��ܿ��v���񪺫��s", false);

registerPatch(223, "MoveItemCountUpwards", "���ƥ��W�����A��[����]", "����", 0, "Neo", "���ƥ��W�������A��", false);

//registerPatch(224, "IncreaseNpcIDs", "Increase NPC Ids[����]", "�ۭq", 0, "Neo", "Increase the Loaded NPC IDs to include 10K+ range IDs. Limits are configurable", false);

registerPatch(225, "ShowRegisterButton", "��ܵ��U���s", "����", 0, "Neo", "�b�n�J������ܵ��U���s", false);

registerPatch(226, "DisableWalkToDelay", "�������ʩ���[����ĳ]", "�ۭq", 16, "MegaByte", "�������ʩ���A�����a�i�H�L���𲾰ʡA�ҥΫ�|�y�����A���t��", false);

registerPatch(227, "SetWalkToDelay", "�קﲾ�ʩ���", "�ۭq", 16, "MegaByte", "�קﲾ�ʩ���A����V�C���ʤ����V�֡A�]�w�L�u�|�y�����A���t��", false);

registerPatch(228, "DisableDoram", "�����p�ڪ��}�⤶��[����]", "����", 0, "Ai4Rei, Secret", "�����p�ڪ��Х߸}�⤶�� (��ĳ���A�ݤ]�n����)", false);

registerPatch(229, "EnableEmblemForBG", "��ܤ��|�Ϧb�Գ�", "����", 0, "Neo", "�b�Գ���ܤ��|��", false);

registerPatch(230, "AlwaysReadKrExtSettings", "Always load Korea ExternalSettings lua file", "�״_", 0, "Secret", "Makes the client load Korea server's ExternalSettings file for all langtypes.", false);

registerPatch(231, "RemoveHardcodedAddress", "�����g���b�n�J����IP��Port", "�״_", 17, "4144", "�����g���b�n�J����IP��Port", false);

registerPatch(232, "RestoreOldLoginPacket", "��_�ª����n�J�ʥ]", "�S��", 17, "4144", "��_�ª����n�J�ʥ] 0x64", false);

// registerPatch(233, "HideSNSButton", "����[TWITTER]���s", "����", 12, "Secret", "���� TWITTER �����s", false);

registerPatch(234, "IgnoreLuaErrors", "���� Lua ���~", "�״_", 0, "4144", "�����Ҧ� Lua/Lub ���~(�i���U�����ADeBug�ɤ��Τ�)", false);

registerPatch(235, "EnableGuildWhenInClan", "Enable guild while in clan", "�ۭq", 0, "Functor, Secret", "Remove restriction of guild functionality while being a member of a clan", false);

registerPatch(236, "EnablePlayerSkills", "Enable Custom Player Skills[����]", "�ۭq", 18, "Neo", "Enables the use of custom skills castable on players (using Lua Files)", false);

registerPatch(237, "EnableHomunSkills", "Enable Custom Homunculus Skills[����]", "�ۭq", 18, "Neo", "Enables the use of custom skills for Homunculus (using Lua Files)", false);

registerPatch(238, "EnableMerceSkills", "Enable Custom Mercenary Skills[����]", "�ۭq", 18, "Neo", "Enables the use of custom skills for Mercenaries (using Lua Files)", false);

registerPatch(239, "IgnoreAccountArgument", "�T�� /account: �Ѽ�", "�״_", 0, "Secret", "�T�� /account: �Ѽ�", false);

registerPatch(240, "LoadCustomClientInfo", "�ק� clientinfo.xml ���|", "�ۭq", 0, "Secret", "�ק�ۭq�� clientinfo.xml ���|", false);

registerPatch(241, "AlwaysLoadClientPlugins", "�۰ʸ��J����[����]", "�״_", 0, "Secret", "�۰ʸ��J DLL ����", false);

registerPatch(242, "DisableKROSiteLaunch", "Disable kRO Site Launch", "�״_", 0, "mrjnumber1", "Disable ro.gnjoy.com launching after in-game settings change", false);

registerPatch(243, "ChangeQuickSwitchDelay", "Change Quick Switch Delay", "�״_", 0, "mrjnumber1", "Change quick item switch delay", false);

registerPatch(244, "DisableCDGuard", "���� Cheat Defender �C���O�@��", "�״_", 0, "4144", "�����s���n�J���� Cheat Defender �C���O�@��", false);

registerPatch(245, "FixedCharJobCreate", "Set fixed job id in char create dialog", "�ۭq", 0, "4144", "Override selected job in char creation packet", false);

registerPatch(246, "IncreaseHairSprites", "Increase hair style limit in game", "�ۭq", 0, "4144", "Allow use more hair styles than default limit", false);

registerPatch(247, "ChangeNewCharNameHeight", "Change new char name field height", "�ۭq", 0, "4144", "Allow change height in input field in new char creation dialog", false);

registerPatch(248, "RemoveWrongCharFromCashShop", "Remove wrong chars from cash shop", "�ۭq", 0, "4144", "Hide wrong field with random values in cash shop", false);

registerPatch(249, "ChangeMinimalResolutionLimit", "Change minimal screen resolution limit", "�ۭq", 0, "4144", "Allow change minimal client resolution (default value is 1024x768", false);

registerPatch(250, "AllowLeavelPartyLeader", "Allow leader to leave party if no members on map", "�ۭq", 0, "4144", "Allow leader to leave party if not party members on same map", false);

registerPatch(251, "AllowCloseCutinByEsc", "�i�ϥ� Esc ���� cutin �Ϥ�", "�ۭq", 0, "4144", "�i�ϥ� Esc ���� cutin NPC �Ϥ�", false);

//registerPatch(252, "FixAchievementCounters", "Fix achievement counters for each type of achievement", "�ۭq", 0, "4144", "Fix achievement counters for each type of achievement for 2017 clients", false);



registerPatch(300, "FixItemDescBug", "�״_���~�����ýX Bug", "����", 0, "Jchcc", "�״_���~�k�䤺�e '[' �y�����ýX", false);

registerPatch(301, "SetMaxItemCount", "�ק﨤��D��W�����", "����", 0, "Jchcc", "�ק﨤��D��e�q�̤j�W����ܪ��ƭ� (�u�O�n�J����ܡA����A�ݵL��)", false);

registerPatch(302, "SetAutoFollowDelay", "�]�w�۰ʸ��H����", "�ۭq", 0, "Jchcc", "���۰ʸ��H���K�A��ֹL�ϸ�᪺���p", false);

registerPatch(303, "DefaultBrowserInCashshop", "�ϥιw�]�s�����}�Ұӫ����s��", "����", 0, "Jchcc", "�ϥΨt�ιw�]���s�����}�ҷs���ӫ�(2018)�����s���A���ϥ� IE", false);

registerPatch(304, "UseDefaultBrowser", "�ϥιw�]�s�����}��NPC��<URL>�s��", "����", 0, "Jchcc", "�ϥΨt�ιw�]���s�����}�� NPC �� <URL> �s���A���A�ϥ�RO���ت��s����", false);

registerPatch(305, "ShortcutAllItem", "���\�Ҧ����~��ֱ��C", "Fix", 0, "Jchcc", "���Ҧ����~������ֱ��C�A��K���ƶq�l��", false);

registerPatch(310, "SetButtonBooking",	"����[�۶�]���s", "����", 12, "Jchcc", "���å��W���\���涤��۶ҫ��s", false);

registerPatch(311, "SetButtonBg",		"����[�Գ�]���s", "����", 12, "Jchcc", "���å��W���\����Գ����s", false);

registerPatch(312, "SetButtonQuest",	"����[����]���s", "����", 12, "Jchcc", "���å��W���\������ȫ��s", false);

registerPatch(313, "SetButtonMap",		"����[�a��]���s", "����", 12, "Jchcc", "���å��W���\����a�ϫ��s", false);

registerPatch(314, "SetButtonNav",		"����[�ɯ�]���s", "����", 12, "Jchcc", "���å��W���\����ɯ���s", false);

registerPatch(315, "SetButtonBank",		"����[�Ȧ�]���s", "����", 12, "Jchcc", "���å��W���\����Ȧ���s", false);

registerPatch(316, "SetButtonRec",		"����[���v]���s", "����", 12, "Jchcc", "���å��W���\������v���s", false);

registerPatch(317, "SetButtonMail",		"����[�H�c]���s", "����", 12, "Jchcc", "���å��W���\����H�c���s", false);

registerPatch(318, "SetButtonAchieve",	"����[���N]���s", "����", 12, "Jchcc", "���å��W���\���榨�N���s", false);

registerPatch(319, "SetButtonTip",		"����[����]���s", "����", 12, "Jchcc", "���å��W���\���洣�ܫ��s", false);

registerPatch(320, "SetButtonAttend",	"����[ñ��]���s", "����", 12, "Jchcc", "���å��W���\����ñ����s", false);

registerPatch(321, "SetButtonSNS",		"����[TWITTER]���s", "����", 12, "Jchcc", "���å��W���\����TWITTER���s", false);

registerPatch(322, "SetButtonCashShop",	"����[�ӫ�]���s", "����", 12, "Jchcc", "���å��W���\����ӫ����s", false);


registerPatch(350, "ChangeAchievementList", "�ק�AchievementList*.lub���|", "�ۭq", 19, "Jian", "�Ŀ��i�H��J�ۭq�����N AchievementList*.lub �ɮסA�p�G���x�誺��s�A�i�H����쥻�� lub �Q�л\", false);

registerPatch(351, "ChangeMonsterSizeEffect", "�ק�MonsterSizeEffect*.lub���|", "�ۭq", 19, "Jian", "�Ŀ��i�H��J�ۭq���]���]�w MonsterSizeEffect*.lub �ɮסA�p�G���x�誺��s�A�i�H����쥻�� lub �Q�л\", false);

registerPatch(353, "ChangeTowninfo", "�ק�Towninfo*.lub���|", "�ۭq", 19, "Jian", "�Ŀ��i�H��J�ۭq���ϼ� Towninfo*.lub �ɮסA�p�G���x�誺��s�A�i�H����쥻�� lub �Q�л\", false);

registerPatch(354, "ChangePetEvolutionCln", "�ק�PetEvolutionCln*.lub���|", "�ۭq", 19, "Jian", "�Ŀ��i�H��J�ۭq���ͩR�� PetEvolutionCln*.lub �ɮסA�p�G���x�誺��s�A�i�H����쥻�� lub �Q�л\", false);

registerPatch(355, "ChangeTipbox", "�ק�Tipbox*.lub���|", "�ۭq", 19, "Jian", "�Ŀ��i�H��J�ۭq���о� Tipbox*.lub �ɮסA�p�G���x�誺��s�A�i�H����쥻�� lub �Q�л\", false);

registerPatch(356, "ChangeCheckAttendance", "�ק�CheckAttendance*.lub���|", "�ۭq", 19, "Jian", "�Ŀ��i�H��J�ۭq��ñ�� CheckAttendance*.lub �ɮסA�p�G���x�誺��s�A�i�H����쥻�� lub �Q�л\", false);

registerPatch(357, "ChangeOngoingQuestInfoList", "�ק�OngoingQuestInfoList*���|", "�ۭq", 19, "Jian", "�Ŀ��i�H��J�ۭq������ OngoingQuestInfoList* �ɮסA�p�G���x�誺��s�A�i�H����쥻�� lub �Q�л\", false);

registerPatch(358, "ChangeRecommendedQuestInfoList", "�ק�RecommendedQuestInfoList*���|", "�ۭq", 19, "Jian", "�Ŀ��i�H��J�ۭq������ RecommendedQuestInfoList* �ɮסA�p�G���x�誺��s�A�i�H����쥻�� lub �Q�л\", false);

registerPatch(359, "ChangePrivateAirplane", "�ק�PrivateAirplane*.lub���|", "�ۭq", 19, "Jian", "�Ŀ��i�H��J�ۭq�����Ÿ� PrivateAirplane*.lub �ɮסA�p�G���x�誺��s�A�i�H����쥻�� lub �Q�л\", false);

registerPatch(360, "ChangeDefaultBGM", "�ק�w�] BGM ���|", "�ۭq", 19, "Jian", "�ק�w�] BGM ���|�A���ܵn�J�b���ɪ��n���A�x�謰 bgm\\01.mp3", false);
