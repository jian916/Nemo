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

pe.findCode("3B ?? 00 00");

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

pe.findCodes("3B ?? 00 00");

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

pe.find("3B ?? 00 00");

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

pe.findAll("3B ?? 00 00");

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

### pe.stringRaw

```
pe.stringRaw(pattern)
```

Find string in whole binary and if found return raw address of string.

If string not found, return -1.

### pe.stringHex4

```
pe.stringHex4(pattern)
```

Find string in whole binary and if found return virtual address packed into 4 bytes hex string.

If string not found, throw exception.

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

