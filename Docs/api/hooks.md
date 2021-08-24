# **hooks** object reference

**hooks** object contains different function for apply hooks.

## Functions

### hooks.matchFunctionStart

```
hooks.matchFunctionStart(rawAddr)
```

Match function start for hook space.

If address matched, return object with fields:

| field | Description |
| -------- | ----------- |
| patchAddr | Matched raw address |
| stolenCode | All code hex bytes stolen for apply hook |
| stolenCode1 | Same with stolenCode |
| continueOffsetVa | Virtual address to next instruction after stolen code |
| retCode  | Empty string |
| endHook  | false |

If matching failed, throw error.


### hooks.matchFunctionEnd

```
 hooks.matchFunctionEnd(rawAddr)
```

Match function end for hook space.

If address matched, return object with fields:

| field | Description |
| -------- | ----------- |
| patchAddr | Matched raw address |
| stolenCode | Code hex bytes stolen for apply hook |
| stolenCode1 | Code hex bytes stolen for apply hook except retCode |
| continueOffsetVa | 0 |
| retCode | ret code after restored stack |
| endHook  | true |

If matching failed, throw error.


### hooks.matchImportCallUsage

```
hooks.matchImportCallUsage(offset, importOffset)
```

Match import calls.

If address matched, return object with match fields.

### hooks.matchImportJmpUsage

```
hooks.matchImportJmpUsage(offset, importOffset)
```

Match import jmps.

If address matched, return object with match fields.


### hooks.addPostEndHook

```
hooks.addPostEndHook(rawAddr, text, vars)
```

Add hook on function before call to ret/retn.

| Argument | Description |
| -------- | ----------- |
| rawAddr  | Address where possible to put post hook |
! text     | Custom asm text inserted after register restore and before ret/retn |
| vars     | Variables for asm text |

If hook set success, return object with fields:

| field | Description |
| -------- | ----------- |
| text | Asm code used for hook |
| free | Raw address where hook was inserted |
| vars | Vars returned from compiled asm code |
| stolenCode | Code hex bytes stolen for apply hook |
| stolenCode1 | Code hex bytes stolen for apply hook except retCode |
| retCode | ret code after restored stack |

If hook set failed, throw exception with error.


### hooks.initHook

```
hooks.initHook(patchAddr, matchFunc)
```

Create hook object with given address and match function.

Return created hook object or throw error.

### hooks.initEndHook

```
hooks.initEndHook(patchAddr)
```

Create hook object with given address at end of function.

Return created hook object or throw error.


### hooks.initTableEndHook

```
hooks.initTableEndHook(varId)
```

Create hook object with given table variable id at end of function.

Return created hook object or throw error.


### hooks.initImportCallHooks

```
hooks.initImportCallHooks(funcName, dllName, ordinal)
```

Create hook for import function calls usage with given import name.

Return created hook object or throw error.

### hooks.initImportJmpHooks

```
hooks.initImportJmpHooks(funcName, dllName, ordinal)
```

Create hook for import function jmps usage with given import name.

Return created hook object or throw error.

### hooks.applyFinal

```
hooks.applyFinal(obj)
```

Apply final changes for given hook object.

### hooks.applyAllFinal

```
hooks.applyAllFinal()
```

Apply final changes for all existing hook objects.

### hooks.removePatchHooks

```
hooks.removePatchHooks()
```

Remove current patch changes fro all hook objects.


### hooks.createHookObj

```
hooks.createHookObj()
```

Create initial hook object. Can be used in hook match functions.
