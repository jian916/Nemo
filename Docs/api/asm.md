# **asm** object reference

**asm** object allow convert assembler code into bytes.

It can be used for crafting patch code.

## Functions

### asm.textToBytes

``asm.textToBytes(addrVa, commands, vars)``

Convert assembler text into bytes sequence.

| Argument  | Description |
| --------  | ----------- |
| addrVa    | Virtual address where code should be located |
| commands  | Assembler text with commands |
| vars      | Variables for assembler text |

If error happened, returns **false**.

In other case returns array.

Array index 0 contains bytes sequence.

Array index 1 contains variables.

### asm.cmdToBytes

``asm.cmdToBytes(addrVa, command, vars)``

Convert one assembler command into all possible bytes sequences.

| Argument | Description |
| -------- | ----------- |
| addrVa   | Virtual address where code should be located |
| commands | Assembler text with commands |
| vars     | Variables for assembler text |

If error happened, returns **false**.

In other case returns array.

Array index 0 contains index for best bytes sequence in array with index 1.

Array index 1 contains array of all possible bytes sequences.

### asm.textToObjVa

``asm.textToObjVa(addrVa, commands, vars)``

Convert assembler text into bytes sequence and put into object.

| Argument | Description |
| -------- | ----------- |
| addrVa   | Virtual address where code should be located |
| commands | Assembler text with commands |
| vars     | Variables for assembler text |

If error happened, returns **false**.

In other case returns object.

| Field    | Description |
| -------- | ----------- |
| bytes    | Bytes sequence |
| code     | Bytes in hex format |
| vars     | Variables |

### asm.textToObjRaw

``asm.textToObjRaw(addrRaw, commands, vars)``

Convert assembler text into bytes sequence and put into object.

| Argument | Description |
| -------- | ----------- |
| addRaw   | Raw address where code should be located |
| commands | Assembler text with commands |
| vars     | Variables for assembler text |

If error happened, returns **false**.

In other case returns object.

| Field    | Description |
| -------- | ----------- |
| bytes    | Bytes sequence |
| code     | Bytes in hex format |
| vars     | Variables |

### asm.textToHexVa

``asm.textToHexVa(addrVa, commands, vars)``

Convert assembler text into bytes sequence.

| Argument  | Description |
| --------  | ----------- |
| addrVa    | Virtual address where code should be located |
| commands  | Assembler text with commands |
| vars      | Variables for assembler text |

If error happened, returns **false**.

In other case returns bytes sequence in hex format.

### asm.textToHexVaLength

``asm.textToHexVaLength(addrVa, commands, vars)``

Convert assembler text into bytes sequence and return length of sequence.

| Argument  | Description |
| --------  | ----------- |
| addrVa    | Virtual address where code should be located |
| commands  | Assembler text with commands |
| vars      | Variables for assembler text |

If error happened, returns **false**.

In other case returns sequence size.

### asm.textToHexRaw

``asm.textToHexRaw(addrRaw, commands, vars)``

Convert assembler text into bytes sequence.

| Argument  | Description |
| --------  | ----------- |
| addRaw    | Raw address where code should be located |
| commands  | Assembler text with commands |
| vars      | Variables for assembler text |

If error happened, returns **false**.

In other case returns bytes sequence in hex format.

### asm.textToHexRawLength

``asm.textToHexRawLength(addrRaw, commands, vars)``

Convert assembler text into bytes sequence and return length of sequence.

| Argument  | Description |
| --------  | ----------- |
| addRaw    | Raw address where code should be located |
| commands  | Assembler text with commands |
| vars      | Variables for assembler text |

If error happened, returns **false**.

In other case returns sequence size.

### asm.cmdToObjVa

``asm.cmdToObjVa(addrVa, command, vars)``

Convert one assembler command into all possible bytes sequences and put into object.

| Argument | Description |
| -------- | ----------- |
| addrVa   | Virtual address where code should be located |
| commands | Assembler text with commands |
| vars     | Variables for assembler text |

If error happened, returns **false**.

In other case returns object.

In other case returns object.

| Field    | Description |
| -------- | ----------- |
| bestIndex | Best bytes sequence index in bytes and codes fields |
| bytes    | Array of bytes sequences |
| codes    | Array of bytes sequences in hex format |
| bestCode | Best bytes sequence |

### asm.cmdToObjRaw

``asm.cmdToObjRaw(addrRaw, command, vars)``

Convert one assembler command into all possible bytes sequences and put into object.

| Argument | Description |
| -------- | ----------- |
| addRaw    | Raw address where code should be located |
| commands | Assembler text with commands |
| vars     | Variables for assembler text |

If error happened, returns **false**.

In other case returns object.

In other case returns object.

| Field    | Description |
| -------- | ----------- |
| bestIndex | Best bytes sequence index in bytes and codes fields |
| bytes    | Array of bytes sequences |
| codes    | Array of bytes sequences in hex format |
| bestCode | Best bytes sequence |

### asm.cmdToHexVa

``asm.cmdToHexVa(addrVa, command, vars)``

Convert one assembler command into best possible bytes in hex format.

| Argument | Description |
| -------- | ----------- |
| addrVa   | Virtual address where code should be located |
| commands | Assembler text with commands |
| vars     | Variables for assembler text |

If error happened, returns **false**.

In other case returns bytes sequence.

### asm.cmdToHexRaw

``asm.cmdToHexRaw(addrRaw, command, vars)``

Convert one assembler command into best possible bytes in hex format.

| Argument | Description |
| -------- | ----------- |
| addRaw    | Raw address where code should be located |
| commands | Assembler text with commands |
| vars     | Variables for assembler text |

If error happened, returns **false**.

In other case returns bytes sequence.

### asm.hexToAsm

``asm.hexToAsm(code)``

Convert hex codes into format accepted by assembler.

| Argument | Description |
| -------- | ----------- |
| code     | Any bytes sequence in hex format |

Returns assembler text command with given bytes.

### asm.stringToAsm

``asm.stringToAsm(code)``

Convert text string into format accepted by assembler.

| Argument | Description |
| -------- | ----------- |
| code     | Any bytes sequence in hex format |

Returns assembler text command with given text.

### asm.combine

``asm.combine(arguments)``

Combine any assembler commands in separate lines into ready to use assembler text.
