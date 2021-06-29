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

### lua.replace

``lua.replace(existingName, newNamesList)``
``lua.replace(existingName, newNamesList, free)``

Allow replace loading existingName to files from newNamesList.

| Argument  | Description |
| --------  | ----------- |
| existingName | Full path of existing lua file |
| newNamesList | Array of full paths to new lua files |
| free         | Buffer where to put lua loader code. If free is missing or -1 new buffer will be allocated |

If error happened, returns string with error.

In other case returns true.

### lua.load

``lua.load(existingName, beforeNamesList, afterNamesList, loadDefault)``
``lua.load(existingName, beforeNamesList, afterNamesList, loadDefault, free)``

Allow load lua files before and after existingName file name.

| Argument  | Description |
| --------  | ----------- |
| existingName | Full path of existing lua file |
| beforeNamesList | Array of full paths of lua files for load before existingName |
| afterNamesList | Array of full paths of lua files for load after existingName |
| loadDefault | Boolean flag for allow load default lua file.
| free         | Buffer where to put lua loader code. If free is missing or -1 new buffer will be allocated |

If error happened, returns string with error.

In other case returns true.

### lua.getLoadObj

``lua.getLoadObj(existingName, beforeNamesList, afterNamesList)``

Generate asm text for load lua files before and after existingName file name.

| Argument  | Description |
| --------  | ----------- |
| existingName | Full path of existing lua file |
| beforeNamesList | Array of full paths of lua files for load before existingName |
| afterNamesList | Array of full paths of lua files for load after existingName |

If error happened, returns string with error.

In other case returns object with fields:

| Field     | Description |
| --------  | ----------- |
| hookAddrRaw | Raw address where hook for lua load code should be placed |
| asmText   | Asm text for lua load code |
| vars      | Variables what should be used for convert asm text into code |


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
