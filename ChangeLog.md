# 2018-12-19 Patches update

## Patches

- Add new patch [Hide zero date (1969-01-01) in guild members window](HideZeroDateInGuildMembers) by 4144.

# 2018-11-29 Patches update

## Patches

 - Fix patch [Change fade in/out delay](http://nemo.herc.ws/patches/ChangeFadeOutDelay/#success-clients) for some old clients (by 4144)
 - Add fix for total counter into patch [Fix achievement counters for each type of achievement](http://nemo.herc.ws/patches/FixAchievementCounters/#success-clients) by 4144

# 2018-11-24 Patches update

## Patches

 - Fix patch [Restore old login packet](http://nemo.herc.ws/patches/RestoreOldLoginPacket/#success-clients) for new Ragexe clients.
 - Include patch [Restore old login packet](http://nemo.herc.ws/patches/RestoreOldLoginPacket/#success-clients) into recommented patches list.

# 2018-11-23 Different updates.

## Patches

 - Fix patch [Change PrivateAirplane*.lub path](http://nemo.herc.ws/patches/ChangePrivateAirplanePath/#success-clients)
 - Add new patch [Copy patched Cheat Defender Game Guard](http://nemo.herc.ws/patches/CopyCDGuard/#success-clients) by 4144
 - Add new patch [Fix achievement counters for each type of achievement](http://nemo.herc.ws/patches/FixAchievementCounters/#success-clients) by 4144
 - Add new patch [Fix act delay for act files with many frames](http://nemo.herc.ws/patches/FixActDelay/#success-clients) by Functor, 4144

## Translations

 - Fix codepage for patch files. Now All files loaded as utf-8.
 - Add support for right to left languages.
 - Add support for translation almost all strings in UI.
 - Add support for translation texts inside patches.
 - Add partial translation for Russian language by 4144.
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

 - Add new patch [Change fade in/out delay](http://nemo.herc.ws/patches/ChangeFadeOutDelay/#success-clients) by 4144
 - Enable patch [Remove hardcoded connection address/port](http://nemo.herc.ws/patches/RemoveHardcodedAddress/#success-clients) for new main and re clients by 4144.

## Other

 - Remove windows end lines from some translations.

# 2018-10-31 Patches update

## Patches

 - Fix patch [Increase hair style limit in game](http://nemo.herc.ws/patches/IncreaseHairSprites/#success-clients) for old 2018 clients by 4144.


# 2018-10-29 Patches update

## Patches

 - Add patch [Change hp bar size](http://nemo.herc.ws/patches/ChangeHealthBarSize/#success-clients) by Jchcc.
 - Add patch [Change mvp hp bar size](http://nemo.herc.ws/patches/ChangeMvpHealthBarSize/#success-clients) by Jchcc.
 - Fix patch [Show Exp Numbers](http://nemo.herc.ws/patches/ShowExpNumbers/#success-clients) for new clients (fix by Jchcc).


# 2018-10-29 Patches update

## Patches

 - Add patch [Change guild exp limit](http://nemo.herc.ws/patches/ChangeGuildExpLimit/#success-clients) by 4144

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

 - Add patch for restore input focus if click outside of window: [Restore chat focus](http://nemo.herc.ws/patches/RestoreChatFocus/#success-clients) by 4144
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
