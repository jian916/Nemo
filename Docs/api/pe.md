# **pe** object reference

**pe** object allow different manipulation with loaded client exe.

## Functions

### pe.findCode

```
pe.findCode(code)
```

Search first hex bytes pattern in main executable section.

| Argument | Description |
| -------- | ----------- |
| code     | Matched hex bytes or ?? |

Return first raw address with given bytes or -1 if nothing found.

Example:

```
pe.findCode("3B ?? 00 00");
```

### pe.findCodes

```
pe.findCodes(code)
```

Search all hex bytes pattern in main executable section.

| Argument | Description |
| -------- | ----------- |
| codes    | Matched hex bytes or ?? |

Return array with found raw addresses.

Example:

```
pe.findCodes("3B ?? 00 00");
```

### pe.findAnyCode

```
pe.findAnyCode(codeArray)
```

Search first hex bytes pattern in main executable section from given array of patterns.

Return object with first raw address with given bytes or -1 if nothing found.

For more info see usage of ``pe.findAnyCode`` in patches.

Example:

```
code = [
    ["3B ?? 00 00", {"offset1": [1, 1]}],
    ["3B ?? 00 01", {"offset1": [1, 1]}]
]
pe.findAnyCode(code);
```

### pe.find

```
pe.find(code)
pe.find(code, rawStart)
pe.find(code, rawStart, finish)
```

Search first hex bytes pattern in whole binary.

| Argument | Description |
| -------- | ----------- |
| code     | Matched hex bytes or ?? |
| rawStart | Start raw address for search. If missing used 0 |
| finish   | End raw address for search. If missing used last possible raw address |

Return first raw address with given bytes or -1 if nothing found.

Example:

```
pe.find("3B ?? 00 00");
```

### pe.findAll

```
pe.findAll(code)
pe.findAll(code, rawStart)
pe.findAll(code, rawStart, finish)
```

Search all hex bytes pattern in whole binary.

| Argument | Description |
| -------- | ----------- |
| code     | Matched hex bytes or ?? |
| rawStart | Start raw address for search. If missing used 0 |
| finish   | End raw address for search. If missing used last possible raw address |

Return array with found raw addresses.

Example:

```
pe.findAll("3B ?? 00 00");
```

### pe.match

``pe.match(code, rawAddr)``

Check is given bytes can be matched to given raw address.

| Argument | Description |
| -------- | ----------- |
| code     | Matched hex bytes |
| rawAddr  | Raw address for check with given bytes |

If given bytes matched, return true.

In other case return false.

### pe.stringVa

```
pe.stringVa(pattern)
```

Find string in whole binary and if found return virtual address of string.

If string not found, return -1.

### pe.halfStringVa

```
pe.halfStringVa(pattern)
```

Find string ending with given pattern in whole binary and if found return virtual address of string ending.

If string not found, return -1.

### pe.stringRaw

```
pe.stringRaw(pattern)
```

Find string in whole binary and if found return raw address of string.

If string not found, return -1.

### pe.halfStringRaw

```
pe.halfStringRaw(pattern)
```

Find string ending with given pattern in whole binary and if found return raw address of string ending.

If string not found, return -1.

### pe.stringHex4

```
pe.stringHex4(pattern)
```

Find string in whole binary and if found return virtual address packed into 4 bytes hex string.

If string not found, throw exception.

### pe.stringAnyVa

```
pe.stringAnyVa(pattern)
pe.stringAnyVa(pattern, ...)
```

Find first string from provided patterns in whole binary and if found return virtual address of string.

If all strings not found, return -1.

### pe.stringAnyRaw

```
pe.stringAnyRaw(pattern)
pe.stringAnyRaw(pattern, ...)
```

Find first string from provided patterns in whole binary and if found return raw address of string.

If all strings not found, return -1.

### pe.rawToVa

``pe.rawToVa(rawAddr)``

Convert raw address into virtual address.

If address wrong, return -1.

### pe.vaToRaw

``pe.vaToRaw(vaAddr)``

Convert virtual address into raw address.

If address wrong, return -1.

### pe.rvaToVa

``pe.rvaToRaw(vaAddr)``

Convert relative virtual address into virtual address.

If address wrong, return -1.

### pe.rvaToRaw

``pe.rvaToRaw(vaAddr)``

Convert relative virtual address into raw address.

If address wrong, return -1.


### pe.sectionRaw

``pe.sectionRaw(section)``

Return array with start and end raw addresses of given section.

### pe.sectionVa

``pe.sectionVa(section)``

Return array with start and end virtual addresses of given section.

### pe.dataBaseRaw

``pe.dataBaseRaw()``

Return raw address for data start. Most time start of data segment or end of code segment.

### pe.directReplaceBytes

``pe.directReplaceBytes(rawAddr, bytes)``

Allow replace data in bytes format in exe at given raw address.

No rollback is possible. If patch disabled or cleared, changed data still present.

This function can be usefull for apply changes outside of patches.

### pe.directReplace

``pe.directReplace(rawAddr, hexData)``

Allow replace data in hex format in exe at given raw address.

No rollback is possible. If patch disabled or cleared, changed data still present.

This function can be usefull for apply changes outside of patches.

### pe.directReplaceDWord

``pe.directReplaceDWord(rawAddr, value)``

Allow replace dword in exe at given raw address.

No rollback is possible. If patch disabled or cleared, changed data still present.

This function can be usefull for apply changes outside of patches.

### pe.fetchQWord

``pe.fetchQWord(rawAddr)``

Read signed qword from given address.

### pe.fetchDWord

``pe.fetchDWord(rawAddr)``

Read signed dword from given address.

### pe.fetchWord

``pe.fetchWord(rawAddr)``

Read signed word from given address.

### pe.fetchByte

``pe.fetchByte(rawAddr)``

Read signed byte from given address.

### pe.fetchUQWord

``pe.fetchUQWord(rawAddr)``

Read unsigned qword from given address.

### pe.fetchUDWord

``pe.fetchUDWord(rawAddr)``

Read unsigned dword from given address.

### pe.fetchUWord

``pe.fetchUWord(rawAddr)``

Read unsigned word from given address.

### pe.fetchString

``pe.fetchString(rawAddr)``

Read null terminated string from given address.

### pe.fetchUByte

``pe.fetchUByte(rawAddr)``

Read unsigned byte from given address.

### pe.fetchValue

``pe.fetchValue(offset, offset2)``

Allow fetch value from binary with raw address offset plus offset2.

In offset2 also exists size of fetched value in bytes.

| Argument | Description |
| -------- | ----------- |
| offset   | Raw address (int) |
| offset2  | additional offset and size (two ints) |

On success return fetched bytes.

### pe.fetchValueSimple

``pe.fetchValueSimple(offset)``

Allow fetch value from binary with raw address and size.

In offset2 also exists size of fetched value in bytes.

| Argument | Description |
| -------- | ----------- |
| offset   | Raw address and size (two ints) |

On success return fetched bytes.

### pe.fetchRelativeValue

``pe.fetchRelativeValue(offset, offset2)``

Allow fetch relative address value from binary with raw address offset plus offset2.

In offset2 also exists size of fetched value in bytes.

| Argument | Description |
| -------- | ----------- |
| offset   | Raw address (int) |
| offset2  | additional offset and size (two ints) |

On success return fetched relative address converted to absolute virtual address.

### pe.fetchHex

``pe.fetchHex(rawAddr, size)``

Read hex bytes from given address.

### pe.fetch

``pe.fetch(addr, size)``

Read null terminated string from given address.

### pe.replace

```
exe.replace(rawAddr, code)
```

Patch binary block at given address.

| Argument | Description |
| -------- | ----------- |
| rawAddr  | Raw address where to patch data |
| code     | String like data to patch |


### pe.replaceByte

``pe.replaceByte(rawAddr, data)``

Patch byte at given raw address.

### pe.replaceWord

``pe.replaceWord(rawAddr, data)``

Patch word at given raw address.

### pe.replaceDWord

``pe.replaceDWord(rawAddr, data)``

Patch dword at given raw address.

### pe.replaceAsmText

``pe.replaceAsmText(patchAddr, commands, vars)``

Replace bytes at raw address patchAddr to given assembler code.

| Argument | Description |
| -------- | ----------- |
| patchAddr| Raw address where code should be stored |
| commands | Assembler text with commands |
| vars     | Variables for assembler text |

On success return bytes in hex format from assembler text.

### pe.replaceAsmFile

``pe.replaceAsmFile(fileName, commands, vars)``

Replace bytes at raw address patchAddr to assembler code from given file name.

| Argument | Description |
| -------- | ----------- |
| fileName | File name with assembler code |
| commands | Assembler text with commands |
| vars     | Variables for assembler text |

On success return bytes in hex format from assembler text.

### pe.insertHexAt

``pe.insertHexAt(rawAddr, code)``

Insert code in hex format at given raw address.

| Argument | Description |
| -------- | ----------- |
| rawAddr  | Address where insert data |
| code     | Hex code of data to insert |

On success return true.

On error return false.

### pe.setValue

``pe.setValue(offset, offset2, value)``

Set value into binary with raw address offset plus offset2.

In offset2 also exists size of saved value in bytes.

| Argument | Description |
| -------- | ----------- |
| offset   | Raw address (int) |
| offset2  | additional offset and size (two ints) |
| value    | Saved value in hex |

### pe.setValueSimple

``pe.setValueSimple(offset, value)``

Set value into binary with raw address offset.

In offset also exists size of saved value in bytes.

| Argument | Description |
| -------- | ----------- |
| offset2  | Raw address and size (two ints) |
| value    | Saved value in hex |

### pe.setJmpVa

```
pe.setJmpVa(patchAddr, jmpAddrVa)
pe.setJmpVa(patchAddr, jmpAddrVa, cmd)
pe.setJmpVa(patchAddr, jmpAddrVa, cmd, codeLen)
```

Store jmp command with address at given patchAddr.

| Argument | Description |
| -------- | ----------- |
| patchAddr| Raw address where jmp should be stored |
| jmpAddrVa| Virtual address where jmp should be jumped |
| cmd      | Jump command. Can be jmp, jz, jnz etc |
| codeLen  | Requested jmp code len. If need add nops at end |

### pe.setJmpRaw

```
pe.setJmpRaw(patchAddr, jmpAddrRaw)
pe.setJmpRaw(patchAddr, jmpAddrRaw, cmd)
pe.setJmpVa(patchAddr, jmpAddrVa, cmd, codeLen)
```

Store jmp command with address at given **patchAddr**.

| Argument | Description |
| -------- | ----------- |
| patchAddr| Raw address where jmp should be stored |
| jmpAddrEaw| Raw address where jmp should be jumped |
| cmd      | Jump command. Can be jmp, jz, jnz etc |
| codeLen  | Requested jmp code len. If need add nops at end |

### pe.setNops

``pe.setNops(patchAddr, nopsCount)``

Store nops at given **patchAddr** with count **nopsCount**.

| Argument | Description |
| -------- | ----------- |
| patchAddr| Raw address where nops should be stored |
| nopsCount| Number of nop bytes stored |

### pe.setNopsRange

``pe.setNopsRange(patchStartAddr, patchEndAddr)``

Store nops from address **patchStartAddr** to **patchEndAddr**.

| Argument | Description |
| -------- | ----------- |
| patchStartAddr| Start raw address where nops should be stored |
| patchEndAddr| End raw address where nops should be stored |

### pe.setNopsValueRange

``pe.setNopsValueRange(offset1, offset2)``

Store nops from address **offset1** plus **offset2**.

| Argument | Description |
| -------- | ----------- |
| offset   | Raw address (int) |
| offset2  | additional offset and size (two ints) |

### pe.setShortJmpVa

``pe.setShortJmpVa(patchAddr, jmpAddrVa, cmd)``

Store short jmp command (2 bytes) with address at given patchAddr.

| Argument | Description |
| -------- | ----------- |
| patchAddr| Raw address where jmp should be stored |
| jmpAddrVa| Virtual address where jmp should be jumped |
| cmd      | Jump command. Can be jmp, jz, jnz etc |

### pe.setShortJmpRaw

``pe.setShortJmpRaw(patchAddr, jmpAddrRaw, cmd)``

Store short jmp command (2 bytes) with address at given **patchAddr**.

| Argument | Description |
| -------- | ----------- |
| patchAddr| Raw address where jmp should be stored |
| jmpAddrEaw| Raw address where jmp should be jumped |
| cmd      | Jump command. Can be jmp, jz, jnz etc |

### pe.getImportTable

``pe.getImportTable()``

Return information about location and size of import table.

If import table cant be found, throw exception.

Returned fields:

| Field   | Description |
| ------- | ----------- |
| offset  | Raw address where import table located. |
| size    | Size of import table in bytes. |

### pe.getSubSection

``pe.getSubSection(Id)``

Return information about location and size of sub section with given id/index.

If sub section cant be found, throw exception.

Returned fields:

| Field   | Description |
| ------- | ----------- |
| offset  | Raw address where sub section located. |
| size    | Size of sub section in bytes. |

### pe.getImageBase

``pe.getImageBase()``

Return image base.

### pe.getPeHeader

``pe.getPeHeader()``

Return PE header raw address.

### pe.getOptHeader

``pe.getOptHeader()``

Return PE optional header raw address.

