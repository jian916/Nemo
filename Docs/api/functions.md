# Global functions reference

## getEcxSessionHex

``getEcxSessionHex()``


## getEcxWindowMgrHex

``getEcxWindowMgrHex()``

## getEcxModeMgrHex

``getEcxModeMgrHex()``

## getEcxFileMgrHex

``getEcxFileMgrHex()``

## getActivePatches

``getActivePatches()``

## isPatchActive

``isPatchActive(functionName)``

Return true if patch with given function active

## enablePatch

``enablePatch(functionName)``

Enable (turn on) patch with given function name.

## enablePatchAndCheck

``enablePatchAndCheck(functionName)``

Enable (turn on) patch with given function name and check is it really enabled.

If patch failed to enable throw exception.

## registerGroup

``registerGroup(id, name, mutualExclude)``

## registerPatch

``registerPatch(id, functionName, patchName, category, groupId, author, description, recommended, needPatches, isHidden)``

## registerAddon

``registerAddon(functionName, description, tooltip)``

## copyFileToDst

``copyFileToDst(srcName, dstName)``

## _

``_(text)``

## N_

``N_(text)``

## floatToDWord

``floatToDWord(text``
