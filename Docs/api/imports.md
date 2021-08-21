# **imports** object reference

**imports** object containes different functions for interact with imports.

It can be used for find import functions by name.

## Functions

### imports.load

``imports.load``

Initial load import functions information. Callee automatically.

### imports.loadDescriptor

``imports.loadDescriptor(offset)``

Load import descriptor object based on given raw offset.

If descriptor is wrong, return false.

If descriptor correct, return dictionary with fields:

| Field | Description |
| ----- | ----------- |
| names | Raw address with function names list. |
| dll   | Dll name string. |
| funcs | Raw address with function pointers used in code. |


### imports.parseDescriptor

``imports.parseDescriptor(descriptor)``

Parse import descriptor loaded by imports.loadDescriptor.

### imports.add

``imports.add(dllName, funcId, funcName, funcPtr)``

Add given import function into different dictionaries for future searches.

| Argument  | Description |
| --------  | ----------- |
| dllName   | Function dll name. |
| funcId    | Function id. |
| funcName  | Function name. |
| funcPtr   | Function pointer virtual address. |

### imports.importByName

``imports.importByName(funcName)``
``imports.importByName(funcName, dllName)``

Search information about given import function name.

| Argument  | Description |
| --------  | ----------- |
| funcName  | Function name. |
| dllName   | Function dll name. Can be missing. |

If function not found, return false.

If function found return dictionary with fields:

| Field | Description |
| ----- | ----------- |
| dll   | Function dll name. |
| id    | Function id. |
| name  | Function name. |
| ptr   | Function pointer. |

### imports.ptr

``imports.ptr(funcName)``
``imports.ptr(funcName, dllName)``
``imports.ptr(funcName, dllName, ordinal)``

Search function pointer address for given import function name.

| Argument  | Description |
| --------  | ----------- |
| funcName  | Function name. Can be missing. |
| dllName   | Function dll name. Can be missing. |
| ordinal   | Function ordinal. Can be missing. |

If function not found, return -1.

If function found, return virtual address of function pointer.

### imports.ptrValidated

``imports.ptr(funcName)``
``imports.ptr(funcName, dllName)``
``imports.ptr(funcName, dllName, ordinal)``

Search function pointer address for given import function name.

| Argument  | Description |
| --------  | ----------- |
| funcName  | Function name. Can be missing. |
| dllName   | Function dll name. Can be missing. |
| ordinal   | Function ordinal. Can be missing. |

If function not found, throw error.

If function found, return virtual address of function pointer.
