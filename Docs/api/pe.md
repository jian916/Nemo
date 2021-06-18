# **exe** object reference

**exe** object allow different manipulation with loaded client exe.

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

### pe.rawToVa

``pe.rawToVa(rawAddr)``

Convert raw address into virtual address.

If address wrong, return -1.

### pe.vaToRaw

``pe.vaToRaw(vaAddr)``

Convert virtual address into raw address.

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
