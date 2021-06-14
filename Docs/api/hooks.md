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
| stolenCode | Code hex bytes stolen for apply hook |
| continueOffsetVa | Virtual address to next instruction after stolen code |

If matching failed, throw error.


### hooks.matchFunctionEnd

```
 hooks.matchFunctionEnd(rawAddr)
```

Match function end for hook space.

If address matched, return object with fields:

| field | Description |
| -------- | ----------- |
| stolenCode | Code hex bytes stolen for apply hook |
| stolenCode1 | Code hex bytes stolen for apply hook except retCode |
| retCode | ret code after restored stack |

If matching failed, throw error.


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
