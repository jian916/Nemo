# 2021-06-29 Different updates

## Patches

- Add patch [Load custom lua files for most loaded lua files](http://nemo.herc.ws/patches/LoadCustomLuaBeforeAfterFiles/#success-clients). (by @4144).
- Add patch [Fixes the Korean Job name issue with LangType](http://nemo.herc.ws/patches/TaekwonJobNameFix/#success-clients) from translation patch. (by Ai4rei/AN, Neo, @4144).
- Add patch [Add loading custom lua files](http://nemo.herc.ws/patches/AddCustomLua/#success-clients). (by @4144).
- Fix patch [Move Cash Shop Icon](http://nemo.herc.ws/patches/MoveCashShopIcon/#success-clients). (fix by @4144).
- Fix patch [Disable kRO Site Launch](http://nemo.herc.ws/patches/DisableKROSiteLaunch/#success-clients). (fix by @4144).

## For devs

- Fix exe.insertAsmText with complex asm code.
- Fix asm.hexToAsm for emptry strings.
- Add new parameter into exe.setJmpVa and exe.setJmpRaw.
- Add hooks object.
- Add lua object.
- Add functions for check enabled patches.
- Add functions for search strings pe.stringVa, pe.stringRaw, pe.stringHex4.
- Add for generic count bytes length in asm text asm.textToHexLength.
- Reconfigure current themes to use one css file.
- Add support for additional css attributes in themes.
- Add proper css usage in selected patch.
- Add support for custom variables in css theme files.

## Other

- Update Chinese Traditional translation from chinese fork.
- Update Thai translation by @X-EcutiOnner.
- Improve loading speed.
- Partial apply new theme after theme selection without nemo restart.

# 2021-05-17 Different updates

## Patches

- Add patch [Increase Zoom Out 25%](http://nemo.herc.ws/patches/IncreaseZoomOut25Per/#success-clients). (by Shinryo, @4144).
- Add patch [Increase Zoom Out to custom value](http://nemo.herc.ws/patches/IncreaseZoomOutCustom/#success-clients). (by Shinryo, @4144).

## For devs

- Replace exe.findAll to pe.findAll in all files.
- Updated return value for exe.insertAsmText.
- Add function asm.stringToAsm for convert string in assembler format.
- Add function exe.insertAsmTextObj similar to exe.insertAsmText.
- Add javascript debugger (menu tools/debugger).
- Move function removePatchData into object patch.
- Add function patch.replacePatchDataDWord for replaced already patched dword.
- Add function patch.getPatchDataDWord for read already patched dword.

## Other

- Update tables with clients support.
- Add shortcut F1 for open patch information.
- Fix window resize on startup.


# 2021-05-06 Different updates

## Patches

- Add patch [Send client flags to server](http://nemo.herc.ws/patches/SendClientFlags/#success-clients). (by @4144).
- Add patch [Enable GvG Damage display](http://nemo.herc.ws/patches/EnableGvGDamage/#success-clients). (by @X-EcutiOnner, @4144).
- Add patch [Disable Adventure Agent button on Party Window](http://nemo.herc.ws/patches/DisableAdventureAgent/#success-clients). (by @X-EcutiOnner, @4144).
- Add patch [Translate Arrows Charset from korean to english](http://nemo.herc.ws/patches/FixArrowsCharset/#success-clients). (by @X-EcutiOnner, @4144).
- Remove wrong parameter from patch [Disable Game Guard](http://nemo.herc.ws/patches/DisableGameGuard/#success-clients). (by @4144).

## For devs

- Add script function isPatchActive. Checks if given patch name active.
- Add script function enablePatch. Enable patch with given name.
- Add script function removePatchData. Remove patch data from given address.
- Add functions for patches: NAME_cancel(). Called for patch if patch was enabled and switched to disabled state.
- Add function ApplyPatches. This function called after apply all patches.
- Add new variables in tables.

## Other

- Update tables with clients support.

# 2021-04-22 Different updates

## Patches

- Add patch [Restore auto follow](http://nemo.herc.ws/patches/RestoreAutoFollow/#success-clients). (by @4144).

## For devs

- Add function pe.find as improvement of exe.find.
- Add function pe.findAll as improvement of exe.findAll.
- Add function pe.findCode as improvement of exe.findCode.
- Add function pe.findCodes as improvement of exe.findCodes.
- Add function pe.match as improvement of exe.match.
- Add function pe.vaToRaw as improvement of exe.Raw2Rva.
- Add function pe.rawToVa as improvement of exe.Rva2Raw.
- Add function pe.sectionRaw as improvement of exe.getROffset.
- Add function pe.sectionVa as improvement of exe.getVOffset.
- Add function pe.dataBaseRaw for return start of data raw address.


# 2021-04-07 Patches update

- Fix patch [Disable Auto follow](http://nemo.herc.ws/patches/DisableAutofollow/#success-clients). (fix by @4144).
- Add patch [Disable OS Privileges execution level](http://nemo.herc.ws/patches/DisableRequireAdmin/#success-clients). (by @X-EcutiOnner).


# 2021-03-11 Patches update

- Fix patch [Enable Emblem hover for BG](http://nemo.herc.ws/patches/EnableEmblemForBG/#success-clients) for 2019 clients. (fix by @4144).


# 2021-03-11 Different updates

## Patches

- Add patch [Send at commands to server](http://nemo.herc.ws/patches/EnableSlashAtCommands/#success-clients). (by @4144).
- Fix patch [Enable Emblem hover for BG](http://nemo.herc.ws/patches/EnableEmblemForBG/#success-clients). (fix by @4144).

## Translations

- Update Thai translation (by @X-EcutiOnner).

## For devs

- Add function exe.fetchRelativeValue for fetch relative address for example from "call XXX".
- Add function exe.fetchHexBytes for fetch any number of hex bytes with offsets in standard format.

## Plugin

- Save/load previous profiles near patched exe.
- Fixed possible crash on load downloader scripts.

## Other

- Update tables with clients support.


# 2021-02-23 Different updates

## Patches

- Update translation strings in patch [Translate Client](http://nemo.herc.ws/patches/TranslateClient/#success-clients). (fix by @4144).

## For devs

- Add functions for put short jump in client: exe.setShortJmpVa and exe.setShortJmpRaw.
- Allow use any similar to jump commands in exe.setShortJmp* and exe.setJmp* as last parameter.

## Other

- Update tables with clients support.


# 2021-02-11 Patches update

## Patches

- Fix patch [Add support for preview button in cash shop](http://nemo.herc.ws/patches/ExtendCashShopPreview/#success-clients) for 2019-12-xx and newer. (fix by @4144).

## Other

- Update tables with clients support.


# 2021-02-10 Different updates

## Patches

- Add patch [Add support for preview button in cash shop](http://nemo.herc.ws/patches/ExtendCashShopPreview/#success-clients). (by @4144).
- Add patch [Change MerchantStore Url](http://nemo.herc.ws/patches/ChangeMerchantStoreUrl/#success-clients). (by @jchcc).
- Add patch [Mvp Drop Item Use Identified Name](http://nemo.herc.ws/patches/MvpItemIdentifyName/#success-clients). (by @jchcc, @4144).
- Fix patch [Skip some hidden menu icon buttons](http://nemo.herc.ws/patches/SkipHiddenMenuButtons/#success-clients) for some clients. (fix by @4144).
- Fix patch [Disable Ragexe Filename Check](http://nemo.herc.ws/patches/DisableFilenameCheck/#success-clients) for latest clients. (fix by @4144)
- Fix patch [Fix item description bug](http://nemo.herc.ws/patches/FixItemDescBug/#success-clients) for some clients. (fix by @jchcc).


## For devs

- Add function for match bytes at given address: exe.match.
- Add function for fetch value from binary with size defined in variable: exe.fetchValue.
- Add function for save value to binary with size defined in variable: exe.setValue.

## Other

- Update tables with clients support.
- Update chinese traditional translation from jian916 fork.


# 2021-02-04 Patches update

- Fix patch [Skip some hidden menu icon buttons](http://nemo.herc.ws/patches/SkipHiddenMenuButtons/#success-clients). (fix by @4144).


# 2021-01-26 Themes and docs.

## Plugin

- Add support for themes.

## For devs

- Add function insert asm code into empty block: exe.insertAsmText.
- Add function for replace code to asm text: exe.replaceAsmText.
- Fix function asm.cmdToObjVa.
- Add basic [documentation](Docs/api.md) about api functions.

## Themes

- Add support for themes.
- Add theme default, notheme, green.


# 2021-01-21 Different updates

## Patches

- Add patch [Ignore Entry Queue Errors](http://nemo.herc.ws/patches/IgnoreEntryQueueErrors/#success-clients). (by @X-EcutiOnner, @4144).
- Add patch [Disable mp3NameTable.txt](http://nemo.herc.ws/patches/DisableBGMAudio/#success-clients). (by @X-EcutiOnner).
- Add patch [Disable map sign display](http://nemo.herc.ws/patches/DisableMapInfo/#success-clients). (by @X-EcutiOnner, @4144).
- Fix patch [Change Walk To Delay](http://nemo.herc.ws/patches/SetWalkToDelay/#success-clients). (fix by @X-EcutiOnner).
- Fix patch [Enable /who command](http://nemo.herc.ws/patches/EnableWhoCommand/#success-clients). (fix by @4144).
- Update patch [Change minimal screen resolution limit](http://nemo.herc.ws/patches/ChangeMinimalResolutionLimit/#success-clients) with assembler usage. (fix by @4144).

## Plugin

- Add assembler functions asm.textToBytes and asm.cmdToBytes.

## For devs

- Add different functions for assembler usage.
- Add javascript function String.replaceAll.
- Add functions for put jump in client: exe.setJmpVa and exe.setJmpRaw.
- Add functions for put nops in client: exe.setNopsRange and exe.setNops.

## Other

- Update copyright year to 2021


# 2021-01-18 Clients support update

## Other

- Update tables with clients support.
- Update copyright year to 2021.


# 2020-12-11 Patches and translations update

## Patches

- Hide patches [Ignore Quest Errors](http://nemo.herc.ws/patches/IgnoreQuestErrors/#success-clients) and [Ignore Resource Errors](http://nemo.herc.ws/patches/IgnoreResourceErrors/#success-clients) (by @X-EcutiOnner)

## Translations

- Update Thai translation (by @X-EcutiOnner).


# 2020-12-09 Patches and plugin update

## Patches

- Add patch [Additional client validation](http://nemo.herc.ws/patches/ValidateClient/#success-clients). (by @4144).
- Fix patch [Show Replay Button](http://nemo.herc.ws/patches/ShowReplayButton/#success-clients). (fix by @jchcc).
- Fix patch [Disable Help Message on Login](http://nemo.herc.ws/patches/DisableHelpMsg/#success-clients). (fix by @X-EcutiOnner).
- Fix patch [Ignore Lua Errors](http://nemo.herc.ws/patches/IgnoreLuaErrors/#success-clients). (fix by @X-EcutiOnner, @4144).
- Update patch [Translate Client](http://nemo.herc.ws/patches/TranslateClient/#success-clients) for translating sign in achievement window. (fix by @X-EcutiOnner).
- Fixes for different patches due using tables.

## Addons

- Fix addon Extract msgstringtable by using tables. (by @4144).
- Fix addon Dump Import Table for different clients with broken import table. (by @4144).

## Plugin

- Add tables with known values.
- Validate all clients loading. Show error on non kro or modified clients exe.
- From now NEMO will not works with modified clients as source.
- New script variable IS_RO for check is loaded binary ro client or not.


# 2020-11-10 Patches update

## Patches

- Fix patch [Disable HShield](http://nemo.herc.ws/patches/DisableHShield/#success-clients). (fix by @4144).


# 2020-11-06 Patches and plugin update

## Patches

- Add patch [Change Max Friends Value](http://nemo.herc.ws/patches/ChangeMaxFriendsValue/#success-clients). (by @X-EcutiOnner, @4144).
- Add patch [Remove Hardcoded HTTP IP](http://nemo.herc.ws/patches/RemoveHardcodedHttpIP/#success-clients). (by @jchcc).
- Add patch [Enable HTTP Emblem on Ragexe](http://nemo.herc.ws/patches/EnableRagHTTPEmblem/#success-clients). (by @jchcc).
- Add patch [Remove Equipment Preview Button](http://nemo.herc.ws/patches/RemoveItemsEquipPreview/#success-clients). (by @X-EcutiOnner, @4144).
- Add patch [Change adventurer agency level range](http://nemo.herc.ws/patches/ChangeAdventureAgencyLevelRange/#success-clients). (by @Asheraf).
- Fix patch [Disable kRO Site Launch](http://nemo.herc.ws/patches/DisableKROSiteLaunch/#success-clients). (fix by @sctnightcore).
- Fix patch [Disable 1rag1 type parameters](http://nemo.herc.ws/patches/Disable1rag1Params/#success-clients). (fix by @X-EcutiOnner).
- Fix patch [Always load Korea ExternalSettings lua file](http://nemo.herc.ws/patches/AlwaysReadKrExtSettings/#success-clients). (fix by @X-EcutiOnner, @4144).
- Fix patch [Disable Cheat Defender Game Guard](http://nemo.herc.ws/patches/DisableCDGuard/#success-clients). (fix by @X-EcutiOnner, @4144).
- Fix patch [Load custom ClientInfo file](http://nemo.herc.ws/patches/LoadCustomClientInfo/#success-clients). (fix by @jchcc).
- Fix patch [Show Exp Numbers](http://nemo.herc.ws/patches/ShowExpNumbers/#success-clients). (fix by @jchcc).
- Fix patch [Ignore Lua Errors](http://nemo.herc.ws/patches/IgnoreLuaErrors/#success-clients). (fix by @X-EcutiOnner).
- Fix patch [Disable HShield](http://nemo.herc.ws/patches/DisableHShield/#success-clients). (fix by @X-EcutiOnner).
- Fix patch [Disable Help Message on Login](http://nemo.herc.ws/patches/DisableHelpMsg/#success-clients). (fix by @X-EcutiOnner).

## Plugin

- Prevent load files with name started from get_.
- Add discord link.

## For devs

- Add function for simple search/replace. See SimpleReplaceDemo.qs (by @4144).

## Other

- Update chinese traditional translation from jian916 fork.

# 2020-10-19 Patches update

## Patches

- Add patch [Ignore SignBoardList.lub Reading](http://nemo.herc.ws/patches/IgnoreSignBoardReading/#success-clients). (by @X-EcutiOnner, @4144).
- Add patch [Disable Blind skills effect](http://nemo.herc.ws/patches/DisableBlindEffect/#success-clients). (by @X-EcutiOnner, @4144).
- Fix patch [Hide packets from peek](http://nemo.herc.ws/patches/HidePacketsFromPeek/#success-clients). (fix by @X-EcutiOnner).


# 2020-10-05 Patches update

## Patches

- Add patch [Disable ViewPointTable.txt](http://nemo.herc.ws/patches/DisableCameraLock/#success-clients). (by @X-EcutiOnner).
- Fix patch [Change character display deletion time from actual date to relative date](http://nemo.herc.ws/patches/ChangeDisplayCharDelDelay/#success-clients). (fix by @jchcc).
- Fix patch [Disable Multiple Windows](http://nemo.herc.ws/patches/DisableMultipleWindows/#success-clients). (fix by @jchcc).
- Fix patch [Highlight Skillslot Color](http://nemo.herc.ws/patches/HighlightSkillSlotColor/#success-clients). (fix by @X-EcutiOnner).


# 2020-09-09 Patches update

## Patches

- Add patch [Disable OTP Login Packet](http://nemo.herc.ws/patches/DisableOTPLoginPacket/#success-clients). (by @jchcc).
- Add patch [Auto Mute Audio (Experimental)](http://nemo.herc.ws/patches/AutoMute/#success-clients). (by @jchcc).
- Add patch [Enable 44.1 kHz Audio Sampling Frequency](http://nemo.herc.ws/patches/Enable44khzAudio/#success-clients). (by @jchcc).
- Fix patch [Always Load Client Plugins (Experimental)](http://nemo.herc.ws/patches/AlwaysLoadClientPlugins/#success-clients). (fix by @jchcc).


# 2020-08-06 Patches update

## Patches

- Add patch [Remove Equipment Title UI](http://nemo.herc.ws/patches/RemoveEquipmentTitleUI/#success-clients). (by @jchcc, @X-EcutiOnner, fix by @4144).


# 2020-07-31 Patches update

## Patches

- Add patch [Change second char create job](http://nemo.herc.ws/patches/ChangeSecondCharCreateJob/#success-clients). (by @4144).


# 2020-07-27 Patches update

## Patches

- Fix patch [Case-Insensitive Storage Search](http://nemo.herc.ws/patches/InsensitiveStorageSearch/#success-clients). (fix by @jchcc).
- Fix patch [Hide attendance button](http://nemo.herc.ws/patches/HideAttendanceButton/#success-clients). (fix by @jchcc).
- Fix patch [Hide adventurer agency button](http://nemo.herc.ws/patches/HideAdventurerAgencyButton/#success-clients). (fix by @jchcc).
- Fix patch [Skip some hidden menu icon buttons](http://nemo.herc.ws/patches/SkipHiddenMenuButtons/#success-clients). (fix by @jchcc).
- Fix patch [Hide Cash Shop](http://nemo.herc.ws/patches/HideCashShop/#success-clients). (fix by @jchcc).
- Fix patch [Restore Songs Effect](http://nemo.herc.ws/patches/RestoreSongsEffect/#success-clients). (fix by @jchcc).
- Fix wrong insert buffer in different patches. (fix by @4144).


# 2020-07-20 Patches update

## Patches

- Add patch [Ignore Towninfo*.lub Reading](http://nemo.herc.ws/patches/IgnoreTownInfoReading/#success-clients). (by @X-EcutiOnner).
- Add patch [Disable specified Windows](http://nemo.herc.ws/patches/DisableWindows/#success-clients). (by @jchcc).
- Add patch [Case-Insensitive Storage Search](http://nemo.herc.ws/patches/InsensitiveStorageSearch/#success-clients). (by @jchcc).
- Add patch [Restore Songs Effect](http://nemo.herc.ws/patches/RestoreSongsEffect/#success-clients). (by @jchcc).


# 2020-07-17 Patches update

## Patches

- Fix patch [Disable 4 Letter Character Name Limit](http://nemo.herc.ws/patches/Disable4LetterCharnameLimit/#success-clients). (fix by @jchcc).
- Fix patch [Disable 4 Letter User Name Limit](http://nemo.herc.ws/patches/Disable4LetterUsernameLimit/#success-clients). (fix by @jchcc).
- Fix patch [Disable 4 Letter Password Limit](http://nemo.herc.ws/patches/Disable4LetterPasswordLimit/#success-clients). (fix by @jchcc).

# 2020-07-13 Patches update

## Patches

- Add patch [Opening To Service Select](http://nemo.herc.ws/patches/OpeningToServiceSelect/#success-clients). (by @jchcc).
- Fix patch [Change guild exp limit](http://nemo.herc.ws/patches/ChangeGuildExpLimit/#success-clients). (fix by @jchcc).
- Fix patch [Enable Multiple GRFs - Embedded](http://nemo.herc.ws/patches/EnableMultipleGRFsV2/#success-clients). (fix by @jchcc).
- Fix patch [Ignore Missing Palette Error](http://nemo.herc.ws/patches/IgnoreMissingPaletteError/#success-clients). (fix by @jchcc).
- Fix patch [Disconnect to Login Window](http://nemo.herc.ws/patches/DCToLoginWindow/#success-clients). (fix by @jchcc).


# 2020-07-11 Patches update

## Patches

- Fix patch [Change minimal screen resolution limit](http://nemo.herc.ws/patches/ChangeMinimalResolutionLimit/#success-clients). (fix by @jchcc).


# 2020-07-09 Patches update

## Patches

- Fix patch [Remove Hourly Announce](http://nemo.herc.ws/patches/RemoveHourlyAnnounce/#success-clients) for 2019-2020 clients. (fix by @jchcc).


# 2020-07-08 Patches update

## Patches

- Fix patch [Restore Model Culling](http://nemo.herc.ws/patches/RestoreModelCulling/#success-clients) for 2019-2020 clients. (fix by @jchcc).
- Fix patch [Change minimal screen resolution limit](http://nemo.herc.ws/patches/ChangeMinimalResolutionLimit/#success-clients) for 2019-2020 clients. (fix by @jchcc, @4144).


# 2020-07-07 Patches update

## Patches

- Fix patch [Increase hair style limit in game](http://nemo.herc.ws/patches/IncreaseHairSprites/#success-clients) for 2019-2020 clients. (fix by @jchcc).


# 2020-07-06 Patches update

## Patches

- Fix patch [Remove hardcoded address/port](http://nemo.herc.ws/patches/RemoveHardcodedAddress/#success-clients) for 2020-07-01 clients. (fix by @4144).
- Fix patch [Change hp bar size](http://nemo.herc.ws/patches/ChangeHealthBarSize/#success-clients) for 2019-2020 clients. (fix by @jchcc).
- Fix patch [Change Max Items in inventory](http://nemo.herc.ws/patches/SetMaxItemCount/#success-clients) for 2015, 2019-2020 clients. (fix by @jchcc).
- Fix patch [Change MVP hp bar size](http://nemo.herc.ws/patches/ChangeMvpHealthBarSize/#success-clients) for 2019-2020 clients. (fix by @jchcc).
- Fix patch [Enable Proxy Support](http://nemo.herc.ws/patches/EnableProxySupport/#success-clients) for 2019-2020 clients. (fix by @jchcc).
- Fix patch [Increase Zoom Out 50%](http://nemo.herc.ws/patches/IncreaseZoomOut50Per/#success-clients) for 2019-2020 clients. (fix by @jchcc).
- Fix patch [Increase Zoom Out 75%](http://nemo.herc.ws/patches/IncreaseZoomOut75Per/#success-clients) for 2019-2020 clients. (fix by @jchcc).
- Fix patch [Increase Zoom Out Max](http://nemo.herc.ws/patches/IncreaseZoomOutMax/#success-clients) for 2019-2020 clients. (fix by @jchcc).
- Fix patch [Use Ascii on All LangTypes](http://nemo.herc.ws/patches/UseAsciiOnAllLangTypes/#success-clients) for 2019-2020 clients. (fix by @jchcc).
- Fix patch [Use Plain Text Descriptions](http://nemo.herc.ws/patches/UsePlainTextDescriptions/#success-clients) for 2019-2020 clients. (fix by @jchcc).
- Add patch [Fix Charset For Custom Fonts](http://nemo.herc.ws/patches/FixCharsetForFonts/#success-clients) for 2015-2020 clients. (by @jchcc).


# 2020-07-01 Patches update

## Patches

- Fix patch [Increase Headgear ViewID](http://nemo.herc.ws/patches/IncreaseViewID/#success-clients) for 2020 clients. (fix by @jchcc).
- Fix patch [Allow space in guild name](http://nemo.herc.ws/patches/AllowSpaceInGuildName/#success-clients) for 2019-2020 clients. (fix by @jchcc).
- Fix patch [Enforce Official Login Background](http://nemo.herc.ws/patches/EnforceOfficialLoginBackground/#success-clients) for 2019-2020 clients. (fix by @jchcc).
- Fix patch [Show Exp Numbers](http://nemo.herc.ws/patches/ShowExpNumbers/#success-clients) for 2020 clients. (fix by @jchcc).
- Fix patch [Fix Homunculus attack AI](http://nemo.herc.ws/patches/FixHomunculusAI/#success-clients) for 2019-10-30 client and up. (fix by @X-EcutiOnner).


# 2020-06-24 Patches update

## Patches

- Fix change lub patches for support sakray and main strings in same binary (fix by @4144).


# 2020-06-23 Different updates

## Patches

- Add patch [Highlight Skillslot Color](http://nemo.herc.ws/patches/HighlightSkillSlotColor/#success-clients) (by Hanashi, fix by @4144).
- Add patch [Remove Equipment Swap Button](http://nemo.herc.ws/patches/RemoveEquipmentSwap/#success-clients) (by @X-EcutiOnner, fix by @4144).
- Add patch [Ignore Quest Errors](http://nemo.herc.ws/patches/IgnoreQuestErrors/#success-clients) (by @X-EcutiOnner, fix by @4144).

## Addons

- Removed global variable in addon GenMapEffectPlugin. (fix by @4144)

## Plugin

- Increase .xdiff section size to 0x8000 bytes. This allow use many big patches at same time. (fix by @4144)


# 2020-04-30 Translations update

## Translations

- Update PT-BR translations by Frost and factor (@danilloestrela)


# 2020-03-30 Patches update

## Patches

- Add new line into [Translate Client](http://nemo.herc.ws/patches/TranslateClient/#success-clients) (fix by @X-EcutiOnner).
- Fix patch [Use Default Web Browser In Cashshop](http://nemo.herc.ws/patches/DefaultBrowserInCashshop/#success-clients) for 2019+ clients. (fix by @X-EcutiOnner).
- Fix patch [Increase Map Quality](http://nemo.herc.ws/patches/IncreaseMapQuality/#success-clients) for 2019+ clients. (fix by @X-EcutiOnner).
- Fix patch [Remove Hourly Announce](http://nemo.herc.ws/patches/RemoveHourlyAnnounce/#success-clients) for 2019+ clients. (fix by @X-EcutiOnner).


# 2020-03-07 Patches update

## Patches

- Fix patch [Skip Service Selection Screen](http://nemo.herc.ws/patches/SkipServiceSelect/#success-clients) for 2019+ clients. (fix by @X-EcutiOnner).
- Fix patch [Chat Flood Remove Limit](http://nemo.herc.ws/patches/RemoveChatLimit/#success-clients) for 2019+ clients. (fix by @X-EcutiOnner).
- Fix patch [Chat Flood Allow](http://nemo.herc.ws/patches/AllowChatFlood/#success-clients) for 2019+ clients. (fix by @X-EcutiOnner).


# 2020-01-24 Patches update

## Patches

- Fix patch [Disable Cheat Defender Game Guard](http://nemo.herc.ws/patches/DisableCDGuard/#success-clients) for 2020-01-22. (fix by @4144).


# 2020-01-12 Patches update

## Patches

- Fix corruptions in [Translate Client](http://nemo.herc.ws/patches/TranslateClient/#success-clients) fix by @4144.


# 2020-01-09 Patches update

## Patches

- Fix patch [Custom Window Title](http://nemo.herc.ws/patches/CustomWindowTitle/#success-clients) for 2019 clients (fix by @X-EcutiOnner).

## Translations

- Update Thai translation by @X-EcutiOnner.

# 2020-01-06 Patches update

## Patches

- Fix patch [Always load Korea ExternalSettings lua file](http://nemo.herc.ws/patches/AlwaysReadKrExtSettings/#success-clients) for zero clients (fix by @4144).
- Fix patch [Enable Multiple GRFs - Embedded](http://nemo.herc.ws/patches/EnableMultipleGRFsV2/#success-clients) for 2019 clients (fix by @X-EcutiOnner).
- Add patch [Change MapInfo*.lub path](http://nemo.herc.ws/patches/ChangeMapInfoPath/#success-clients) by @X-EcutiOnner.


# 2020-01-01 Patches update

## Patches

- Fix patch [Disable Cheat Defender Game Guard](http://nemo.herc.ws/patches/DisableCDGuard/#success-clients) for 2019-12-xx. (fix by @4144).

# 2019-12-17 Patches update

## Patches

- Fix patch [Change new char name field height](http://nemo.herc.ws/patches/ChangeNewCharNameHeight/#success-clients) for some new clients by Functor.
- Fix patch [Enable Multiple GRFs](http://nemo.herc.ws/patches/EnableMultipleGRFs/#success-clients) for some new clients by Functor.
- Disable useless patch [Fix shortcuts in wine](http://nemo.herc.ws/patches/FixShortcutsInWine/#success-clients).

# 2019-11-12 Patches update

## Patches

- Fix patch [Hide packets from peek](http://nemo.herc.ws/patches/HidePacketsFromPeek/#success-clients) for old client by @4144.

# 2019-09-23 Patches update

## Patches

 - Add patch [Always see hidden/cloaked objects](http://nemo.herc.ws/patches/Intravision/#success-clients) by Secret, A.K.M.

# 2019-08-00 Patches update

## Patches

 - Fix typo in patch [Allow spam skills by hotkey](http://nemo.herc.ws/patches/AllowSpamSkills/#success-clients) by Functor.

# 2019-07-10 Patches and plugin update

## Patches

 - Copy patch [Increase hair style limit in game](http://nemo.herc.ws/patches/IncreaseHairSprites/#success-clients) into [Increase hair style limit in game (old)](http://nemo.herc.ws/patches/IncreaseHairSpritesOld/#success-clients)
 - Extend patch [Increase hair style limit in game](http://nemo.herc.ws/patches/IncreaseHairSprites/#success-clients) for support doram hairs by @4144.
 - Add Thai translation by Kelberwitz Blade's.
 - Add patch [Change Max Party Value](http://nemo.herc.ws/patches/ChangeMaxPartyValue/#success-clients) by Jchcc.
 - Add patch [Force use icons only from stateiconimginfo.lub](http://nemo.herc.ws/patches/ForceLubStateIcon/#success-clients) by Jchcc.
 - Add patches for hide all other buttons by @4144.
 - Add patches for set hide/show other buttons by @4144.
 - Add patch [Allow spam skills by hotkey](http://nemo.herc.ws/patches/AllowSpamSkills/#success-clients) by Functor, @4144.

## Plugin

 - Show client version always with UTC time zone.


# 2019-06-15 Patches update

## Patches

 - Fix patch [Change mvp hp bar size](http://nemo.herc.ws/patches/ChangeMvpHealthBarSize/#success-clients) for 20180919+ clients by Jchcc.

# 2019-06-12 Patches update

## Patches

- Fix patch [Skip some hidden menu icon buttons](http://nemo.herc.ws/patches/SkipHiddenMenuButtons/#success-clients) for 2019+ clients by @4144.

# 2019-04-22 Patches update

## Patches

- Fix patch [Enable Proxy Support](http://nemo.herc.ws/patches/EnableProxySupport/#success-clients) for 2015+ clients by Functor.

# 2019-04-01 Patches update

## Patches

- Fix patch [Read Data Folder First](http://nemo.herc.ws/patches/ReadDataFolderFirst/#success-clients) for 2019-03-20 RE+ by @4144.
- Add patch [Fix shortcuts in wine](http://nemo.herc.ws/patches/FixShortcutsInWine/#success-clients) by @4144.

# 2019-03-09 Patches update

## Patches

- Update patch [Fix Homunculus attack AI](http://nemo.herc.ws/patches/FixHomunculusAI/#success-clients) by jchcc.

## License

- Add some missing GPL headers.

# 2019-03-05 New translations

## Translations

- Add Turkish translation by BigLord

# 2019-02-28 New patches

## Patches

- Add patch [Hide build info in client](http://nemo.herc.ws/patches/HideBuildInfo/#success-clients) by @4144.
- Add patch [Hide packets from peek](http://nemo.herc.ws/patches/HidePacketsFromPeek/#success-clients) by @4144.

# For devs

- Add javascript function eraseString.

# 2019-02-22 Plugin update

## User interface

- Add link to support page.
- Add link to donation page.

# 2019-02-19 Patches update

## Patches

- Fix patch [Remove hardcoded connection address/port](http://nemo.herc.ws/patches/RemoveHardcodedAddress/#success-clients) for 2019-02-13 by @4144.
- Fix patch [Read Data Folder First](http://nemo.herc.ws/patches/ReadDataFolderFirst/#success-clients) for 2019-02-13. (fix by @4144)
- Fix patch [Read msgstringtable.txt](http://nemo.herc.ws/patches/ReadMsgstringtabledottxt/#success-clients) for 2019-02-13. (fix by @4144)
- Fix patch [Enable Multiple GRFs](http://nemo.herc.ws/patches/EnableMultipleGRFs/#success-clients) for 2019-02-13. (fix by @4144)
- Fix patch [Disable Ragexe Filename Check](http://nemo.herc.ws/patches/DisableFilenameCheck/#success-clients) for 2019-02-13. (fix by @4144)
- Fix patch [Disable Cheat Defender Game Guard](http://nemo.herc.ws/patches/DisableCDGuard/#success-clients) for 2019-02-13. (fix by @4144)
- Add patch [Fix Homunculus attack AI](http://nemo.herc.ws/patches/FixHomunculusAI/#success-clients) by jchcc.


# 2019-02-04 Functions update

# For devs

- Add new java script function for print text into stdout: ``print``.
- Add new java script function for convert float number into dword: ``floatToDWord``.
- Load qs files from Other directory.

# 2019-01-17 Patches update

## Patches

- Add patch [Draw shield on top of other player sprites](http://nemo.herc.ws/patches/MoveShieldToTop/#success-clients) by @4144.

# 2018-12-30 Patches update

## Patches

- Add patch [Change character display deletion time from actual date to relative date](http://nemo.herc.ws/patches/ChangeDisplayCharDelDelay/#success-clients) by Functor.

# 2018-12-19 Patches update

## Patches

- Add patch [Hide zero date (1969-01-01) in guild members window](http://nemo.herc.ws/patches/HideZeroDateInGuildMembers/#success-clients) by @4144.

# 2018-11-29 Patches update

## Patches

 - Fix patch [Change fade in/out delay](http://nemo.herc.ws/patches/ChangeFadeOutDelay/#success-clients) for some old clients (by @4144)
 - Add fix for total counter into patch [Fix achievement counters for each type of achievement](http://nemo.herc.ws/patches/FixAchievementCounters/#success-clients) by @4144

# 2018-11-24 Patches update

## Patches

 - Fix patch [Restore old login packet](http://nemo.herc.ws/patches/RestoreOldLoginPacket/#success-clients) for new Ragexe clients.
 - Include patch [Restore old login packet](http://nemo.herc.ws/patches/RestoreOldLoginPacket/#success-clients) into recommented patches list.

# 2018-11-23 Different updates.

## Patches

 - Fix patch [Change PrivateAirplane*.lub path](http://nemo.herc.ws/patches/ChangePrivateAirplanePath/#success-clients)
 - Add patch [Copy patched Cheat Defender Game Guard](http://nemo.herc.ws/patches/CopyCDGuard/#success-clients) by @4144
 - Add patch [Fix achievement counters for each type of achievement](http://nemo.herc.ws/patches/FixAchievementCounters/#success-clients) by @4144
 - Add patch [Fix act delay for act files with many frames](http://nemo.herc.ws/patches/FixActDelay/#success-clients) by Functor, @4144

## Translations

 - Fix codepage for patch files. Now All files loaded as utf-8.
 - Add support for right to left languages.
 - Add support for translation almost all strings in UI.
 - Add support for translation texts inside patches.
 - Add partial translation for Russian language by @4144.
 - Add partial translation for Arabic language by Asheraf.

## User interface

 - Fix status label height.
 - Add menu help.
 - Fix scroll bar issue in qtgui.dll with enabled right to left text direction.

## For devs

 - Add functions for patches: NAME_apply(). Called for each patch NAME after pressed button apply.
 - Add function for copy files into destination directory: copyFileToDst(srcPathWithName, dstName).
 - Add function for translate string and mark for translation: _(text)
 - Add function for mark for translation: N_(text)
 - Add script variable with plugin version: PLUGIN_VERSION.
 - Add script variables with source and destination client paths SRC_CLIENT_FILE, DST_CLIENT_FILE.

# 2018-11-16 Patches update

## Patches

 - Add patch [Change fade in/out delay](http://nemo.herc.ws/patches/ChangeFadeOutDelay/#success-clients) by @4144
 - Enable patch [Remove hardcoded connection address/port](http://nemo.herc.ws/patches/RemoveHardcodedAddress/#success-clients) for new main and re clients by @4144.

## Other

 - Remove windows end lines from some translations.

# 2018-10-31 Patches update

## Patches

 - Fix patch [Increase hair style limit in game](http://nemo.herc.ws/patches/IncreaseHairSprites/#success-clients) for old 2018 clients by @4144.


# 2018-10-29 Patches update

## Patches

 - Add patch [Change hp bar size](http://nemo.herc.ws/patches/ChangeHealthBarSize/#success-clients) by Jchcc.
 - Add patch [Change mvp hp bar size](http://nemo.herc.ws/patches/ChangeMvpHealthBarSize/#success-clients) by Jchcc.
 - Fix patch [Show Exp Numbers](http://nemo.herc.ws/patches/ShowExpNumbers/#success-clients) for new clients (fix by Jchcc).


# 2018-10-29 Patches update

## Patches

 - Add patch [Change guild exp limit](http://nemo.herc.ws/patches/ChangeGuildExpLimit/#success-clients) by @4144

# 2018-10-27 Patches update

## Patches

 - Add patch "Change default BGM file" by Jian.
 - Add different change paths patches by Jian.
 - Add patch "Fix item description bug" by Jchcc.
 - Update patch [Load custom ClientInfo file](http://nemo.herc.ws/patches/LoadCustomClientInfo/#success-clients) by jchcc.

## User interface

 - Changed nemo version string.

# 2018-10-27 First change log entry

## Patches

 - Add patch for restore input focus if click outside of window: [Restore chat focus](http://nemo.herc.ws/patches/RestoreChatFocus/#success-clients) by @4144
 - Fixed syntax errors and wrong parameters usage in different patches.
 - Unhide search errors from different patches.
 - Put conflicting increase hair sprites patches in same group.
 - Remove duplicated translation lines from TranslateClient.txt
 - Change id for some new patches related to show/hide buttons.

## User interface

 - Add default values to input fields.
 - Dont show success client loaded messages.
 - Update nemo version in title bar.

## For devs

 - Enable unbuffered writes into TextFile object.
 - Add append method into TextFile object.
 - Add xdiff section into CORE.dll.
 - Add basic script logger.
 - Add missing var keywords in different patches.
 - Fix call for function with wrong case in ShowCancelToServiceSelect.qs
