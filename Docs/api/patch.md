# **patch** object reference

**patch** object allow change or get something related to current patch.

## Functions

## patch.removePatchData

``patch.removePatchData(addrRaw)``

Remove patch data assigned to given raw address.


## patch.replacePatchDataDWord
``patch.replacePatchDataDWord(addrRaw, value)``

Replace dword in already patched data in current patch.

| Argument | Description |
| -------- | ----------- |
| addrRaw  | Raw address where value should be stored |
| value    | Value stored at given address |

Return number of changed patched blocks with given address.

If value was once patched, it will return 1.

If value was never patched it will return 0.


## patch.getPatchDataDWord
``patch.getPatchDataDWord(addrRaw)``

Read dword in already patched data in current patch.

| Argument | Description |
| -------- | ----------- |
| addrRaw  | Raw address where value should be read |

Return last value from patched data blocks.

If address was not patched, return false.

## patch.getName
``patch.getName()``

Return current patch name.

## patch.getState
``patch.getState()``

Return current patch state constant.

| Value | Description |
| ----- | ----------- |
| 0     | Called from patch functions |
| 1     | Called from apply patch functions |
| 2     | Called from ApplyPatches function |
