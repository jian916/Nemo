# **lua** object reference

**lua** object containes different functions for intercat with lua.

It can be used for load custom lua code.

## Functions

### lua.injectLuaFiles

``lua.injectLuaFiles(origFile, nameList)``
``lua.injectLuaFiles(origFile, nameList, free)``
``lua.injectLuaFiles(origFile, nameList, free, loadBefore)``

Allow load lua files before or after origFile file name.

| Argument  | Description |
| --------  | ----------- |
| origFile  | Full path of existing lua file |
| nameList  | Array of full paths to new lua files |
| free      | Buffer where to put lua loader code. If free is missing or -1 new buffer will be allocated |
| loadBefore | If true, load new files before existing lua file. If false, load new files after existing lua file. By default true |

If error happened, returns string with error.

In other case returns true.

### lua.loadBefore

``lua.loadBefore(existingName, newNamesList)``
``lua.loadBefore(existingName, newNamesList, free)``

Allow load lua files before existingName file name.

| existingName | Full path of existing lua file |
| newNamesList | Array of full paths to new lua files |
| free         | Buffer where to put lua loader code. If free is missing or -1 new buffer will be allocated |

If error happened, returns string with error.

In other case returns true.

### lua.loadAfter

``lua.loadAfter(existingName, newNamesList)``
``lua.loadAfter(existingName, newNamesList, free)``

Allow load lua files after existingName file name.

| existingName | Full path of existing lua file |
| newNamesList | Array of full paths to new lua files |
| free         | Buffer where to put lua loader code. If free is missing or -1 new buffer will be allocated |

If error happened, returns string with error.

In other case returns true.
