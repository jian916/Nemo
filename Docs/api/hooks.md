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
