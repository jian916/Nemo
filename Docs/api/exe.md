# **exe** object reference

**exe** object allow different manipulation with loaded client exe.

## Functions

### exe.findCode

```
exe.findCode(code)
exe.findCode(code, codeType)
exe.findCode(code, codeType, useMask)
exe.findCode(code, codeType, useMask, mask)
```

Search first hex bytes pattern in main executable section.

### exe.findCodes

```
exe.findCodes(code)
exe.findCodes(code, codeType)
exe.findCodes(code, codeType, useMask)
exe.findCodes(code, codeType, useMask, mask)
```

Search all hex bytes pattern in main executable section.

### exe.find

```
exe.find(code)
exe.find(code, codeType)
exe.find(code, codeType, useMask)
exe.find(code, codeType, useMask, mask)
exe.find(code, codeType, useMask, mask, start)
exe.find(code, codeType, useMask, mask, start, finish)
```

Search first hex bytes pattern in whole binary.

### exe.findAll

```
exe.findAll(code)
exe.findAll(code, codeType)
exe.findAll(code, codeType, useMask)
exe.findAll(code, codeType, useMask, mask)
exe.findAll(code, codeType, useMask, mask, start)
exe.findAll(code, codeType, useMask, mask, start, finish)
```

Search all hex bytes pattern in whole binary.

### exe.fetchDWord

``exe.fetchDWord(rawAddr)``

Read dword from given address.

### exe.fetchQWord

``exe.fetchQWord(rawAddr)``

Read qword from given address.

### exe.fetchWord

``exe.fetchWord(rawAddr)``

Read word from given address.

### exe.Raw2Rva

``exe.Raw2Rva(rawAddr)``

Convert raw address into virtual address.

If address wrong, return -1.

### exe.Rva2Raw

``exe.Rva2Raw(vaAddr)``

Convert virtual address into raw address.

If address wrong, return -1.

### exe.fetchUByte

``exe.fetchUByte(rawAddr)``

Read unsigned byte from given address.

### exe.fetchByte

``exe.fetchByte(rawAddr)``

Read signed byte from given address.

### exe.fetchHex

``exe.fetchHex(rawAddr, size)``

Read hex bytes from given address.

### exe.fetch

``exe.fetch(addr, size)``

Read null terminated string from given address.

### exe.findZeros

``exe.findZeros(size)``

Search first empty block in binary with given size.

### exe.findString

```
exe.findString(pattern)
exe.findString(pattern, addrType)
exe.findString(pattern, addrType, prefixZero)
```

Find string in whole binary.

### exe.insert

```
exe.insert(rawAddr, size, code)
exe.insert(rawAddr, size, code, codeType)
```

Insert custom block of bytes at address returned by exe.findZeros.

### exe.replace

```
exe.replace(rawAddr, code)
exe.replace(rawAddr, code, codeType)
```

Patch binary block at given address.

### exe.replaceByte

``exe.replaceByte(addr, data)``

Patch byte at given address.

### exe.replaceWord

``exe.replaceWord(addr, data)``

Patch word at given address.

### exe.replaceDWord

``exe.replaceDWord(addr, data)``

Patch dword at given address.

### exe.getUserInput

```
exe.getUserInput(varName, valType, title, prompt, value)
exe.getUserInput(varName, valType, title, prompt, value, minValue)
exe.getUserInput(varName, valType, title, prompt, value, minValue, maxValue)
```

Request information from user.

### exe.getROffset

``exe.getROffset(section)``

Return raw address of given section.

### exe.getRSize

``exe.getRSize(section)``

Return raw size of given section.

### exe.getVOffset

``exe.getVOffset(section)``

Return rva address of given section.

### exe.getVSize

``exe.getVSize(section)``

Return virtual size of given section.

### exe.getPEOffset

``exe.getPEOffset()``

Return PE header raw address.

### exe.getImageBase

``exe.getImageBase()``

Return image base.

### exe.getClientDate

``exe.getClientDate()``

Return client date.

### exe.isThemida

``exe.isThemida()``

Return true if client was packed with themida.

### exe.emptyPatch

``exe.emptyPatch(patch)``

Remove patched data for given patch.

### exe.setJmpVa

``exe.setJmpVa(patchAddr, jmpAddrVa, cmd)``

Store jmp command with address at given patchAddr.

| Argument | Description |
| -------- | ----------- |
| patchAddr| Raw address where jmp should be stored |
| jmpAddrVa| Virtual address where jmp should be jumped |
| cmd      | Jump command. Can be jmp, jz, jnz etc |

### exe.setJmpRaw

``exe.setJmpRaw(patchAddr, jmpAddrRaw, cmd)``

Store jmp command with address at given **patchAddr**.

| Argument | Description |
| -------- | ----------- |
| patchAddr| Raw address where jmp should be stored |
| jmpAddrEaw| Raw address where jmp should be jumped |
| cmd      | Jump command. Can be jmp, jz, jnz etc |

### exe.setShortJmpVa

``exe.setShortJmpVa(patchAddr, jmpAddrVa, cmd)``

Store short jmp command (2 bytes) with address at given patchAddr.

| Argument | Description |
| -------- | ----------- |
| patchAddr| Raw address where jmp should be stored |
| jmpAddrVa| Virtual address where jmp should be jumped |
| cmd      | Jump command. Can be jmp, jz, jnz etc |

### exe.setShortJmpRaw

``exe.setShortJmpRaw(patchAddr, jmpAddrRaw, cmd)``

Store short jmp command (2 bytes) with address at given **patchAddr**.

| Argument | Description |
| -------- | ----------- |
| patchAddr| Raw address where jmp should be stored |
| jmpAddrEaw| Raw address where jmp should be jumped |
| cmd      | Jump command. Can be jmp, jz, jnz etc |

### exe.setNops

``exe.setNops(patchAddr, nopsCount)``

Store nops at given **patchAddr** with count **nopsCount**.

| Argument | Description |
| -------- | ----------- |
| patchAddr| Raw address where nops should be stored |
| nopsCount| Number of nop bytes stored |

### exe.setNopsRange

``exe.setNopsRange(patchStartAddr, patchEndAddr)``

Store nops from address **patchStartAddr** to **patchEndAddr**.

| Argument | Description |
| -------- | ----------- |
| patchStartAddr| Start raw address where nops should be stored |
| patchEndAddr| End raw address where nops should be stored |

### exe.insertAsmText

``exe.insertAsmText(commands, vars)``

Insert assembler code in free block in binary.

| Argument | Description |
| -------- | ----------- |
| commands  | Assembler text with commands |
| vars      | Variables for assembler text |

If fail trigger exception.

If success, return array.

Array index 0 contains raw address where bytes was stored.

Array index 1 contains bytes sequence.

### exe.replaceAsmText

``exe.replaceAsmText(patchAddr, commands, vars)``

Replace bytes at raw address patchAddr to given assembler code.

| Argument | Description |
| -------- | ----------- |
| patchAddr| Raw address where code should be stored |
| commands | Assembler text with commands |
| vars     | Variables for assembler text |

On success return bytes in hex format from assembler text.

### exe.match

``exe.match(code, useMask, rawAddr)``

Check is given bytes can be matched to given raw address.

| Argument | Description |
| -------- | ----------- |
| code     | Matched hex bytes |
| useMask  | Flag for enable use mask in matching |
| rawAddr  | Raw address for check with given bytes |

If given bytes matched, return true.

In other case return false.

### exe.fetchValue

``exe.fetchValue(offset, offset2)``

Allow fetch value from binary with raw address offset plus offset2.

In offset2 also exists size of fetched value in bytes.

| Argument | Description |
| -------- | ----------- |
| offset   | Raw address (int) |
| offset2  | additional offset and size (two ints) |

On success return fetched bytes.

### exe.fetchRelativeValue

``exe.fetchValue(offset, offset2)``

Allow fetch relative address value from binary with raw address offset plus offset2.

In offset2 also exists size of fetched value in bytes.

| Argument | Description |
| -------- | ----------- |
| offset   | Raw address (int) |
| offset2  | additional offset and size (two ints) |

On success return fetched relative address converted to absolute virtual address.

### exe.fetchHexBytes

``exe.fetchHexBytes(offset, offset2)``

Allow fetch hex bytes from binary with raw address offset plus offset2.

In offset2 also exists size of fetched value in bytes.

| Argument | Description |
| -------- | ----------- |
| offset   | Raw address (int) |
| offset2  | additional offset and size (two ints) |

On success return fetched bytes in hex string format.

### exe.setValue

``exe.setValue(offset, offset2, value)``

Set value into binary with raw address offset plus offset2.

In offset2 also exists size of saved value in bytes.

| Argument | Description |
| -------- | ----------- |
| offset   | Raw address (int) |
| offset2  | additional offset and size (two ints) |
| value    | Saved value in hex |
