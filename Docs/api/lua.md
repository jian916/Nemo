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

| Argument  | Description |
| --------  | ----------- |
| existingName | Full path of existing lua file |
| newNamesList | Array of full paths to new lua files |
| free         | Buffer where to put lua loader code. If free is missing or -1 new buffer will be allocated |

If error happened, returns string with error.

In other case returns true.

### lua.loadAfter

``lua.loadAfter(existingName, newNamesList)``
``lua.loadAfter(existingName, newNamesList, free)``

Allow load lua files after existingName file name.

| Argument  | Description |
| --------  | ----------- |
| existingName | Full path of existing lua file |
| newNamesList | Array of full paths to new lua files |
| free         | Buffer where to put lua loader code. If free is missing or -1 new buffer will be allocated |

If error happened, returns string with error.

In other case returns true.

### lua.load

``lua.load(existingName, beforeNamesList, afterNamesList)``
``lua.load(existingName, beforeNamesList, afterNamesList, free)``

Allow load lua files before and after existingName file name.

| Argument  | Description |
| --------  | ----------- |
| existingName | Full path of existing lua file |
| beforeNamesList | Array of full paths of lua files for load before existingName |
| afterNamesList | Array of full paths of lua files for load after existingName |
| free         | Buffer where to put lua loader code. If free is missing or -1 new buffer will be allocated |

If error happened, returns string with error.

In other case returns true.

### lua_getCLuaLoadInfo

``lua_getCLuaLoadInfo(stackOffset)``

Return object with push asm code for copy argruments for CLua::Load.

| Argument  | Description |
| --------  | ----------- |
| stackOffset | Offset adding to stack pointer for copy CLua::Load arguments |

Return object with this fields:

| Field     | Description |
| --------  | ----------- |
| type      | CLua::Load type (pushs count) |
| pushLine  | Asm code for one push         |
| asmCopyArgs | All pushed for copy arguments in stack |
| argsOffset | Offset in bytes for CLua::Load arguments |
