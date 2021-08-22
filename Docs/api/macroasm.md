# **macroasm** object reference

**macroasm** object impliment macro assembler for extend buildin assembler with macro commands.

## Functions

### macroAsm.create

``macroAsm.create(addrVa, commands, vars)``

Create macro assembler object for future usage.

| Argument  | Description |
| --------  | ----------- |
| addrVa    | Virtual address where code should be located |
| commands  | Assembler text with commands |
| vars      | Variables for assembler text |

Returns macro assembler object with fields:

| Field    | Description |
| -------- | ----------- |
| addrVa   | Virtual address where code should be located |
| text     | Assembler text with commands |
| vars     | Variables for assembler text |

### macroAsm.convert

``macroAsm.convert(obj)``

Accept macro assembler object.

Convert macro assembler object for usage with normal assembler.

If error happened, throw error.

### macroAsm.replaceCmds

``macroAsm.replaceCmds(obj)``

Accept macro assembler object.

Replace all support macro assembler commands except variables in assembler text.

If error happened, throw error.

### macroAsm.addMacroses

``macroAsm.addMacroses()``

Register all macro commands in global macro assembler state.

### macroAsm.addNewLine

``macroAsm_addNewLine(text)``

Add new line at end of string if it not present and return string.


## Macro assembler commands

### {VARIABLE}

``{VARIABLE}``

Allow replace ``{VARIABLE}`` to value from variable ``VARIABLE`` variable value.

### %insasm

``%insasm VARIABLE``

Insert assembler text from given variable.

### %inshex

``%inshex VARIABLE``

Insert hex codes from given variable.

### %insstr

``%insstr VARIABLE``

Insert string from given variable.

### %include

``%include FILENAME``

Insert assembler text from given file name from ``include`` directory.

### %tablevar

``%tablevar VAR=TABLEVAR``

Assign to variable ``VAR`` value from table with table variable name ``table.TABLEVAR``.

If table var not exists throw error.

``%tablevar TABLEVAR``

Assign to variable ``TABLEVAR`` value from table with table variable name ``table.TABLEVAR``.

If table var not exists throw error.

### %tablevar0

``%tablevar0 VAR=TABLEVAR``

Assign to variable ``VAR`` value from table with table variable name ``table.TABLEVAR``

If value not exists, return 0 or -1.

``%tablevar0 TABLEVAR``

Assign to variable ``TABLEVAR`` value from table with table variable name ``table.TABLEVAR``.

If value not exists, return 0 or -1.

### %setvar

``%setvar VAR=VALUE``

Assign to variable ``VAR`` value ``VALUE``.

### %def

``%def VAR=VALUE``

Register define for replace in all code ``VAR`` to ``VALUE``.

### db

``db arg[, arg, ...]``

Allow put into assembler any bytes or strings given in arguments.


### asciz

``asciz "string without null terminator"``

Allow put string into assembler. After string add null terminate char.

### %import

``%import FUNC``
``%import FUNC, DLL``
``%import FUNC, DLL, ORDINAL``
``%import VAR=FUNC``
``%import VAR=FUNC, DLL``
``%import VAR=FUNC, DLL, ORDINAL``

Assign to variable address of import function

Any arguments except FUNC can be missing.

If VAR argument missing, for var named used FUNC.
