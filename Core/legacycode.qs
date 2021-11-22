//######################################################################################
//# Purpose: Find the RVA of the Function specified. Optionally dllName can be used    #
//#          to pinpoint to a DLL and ordinal can be used in case of import by ordinal #
//######################################################################################

function GetFunction(funcName, dllName, ordinal)
{

  //Step 1a - Prep the optional arguments
  if (typeof(dllName) === "undefined")
    dllName = "";
  else
    dllName = dllName.toUpperCase();

  if (typeof(ordinal) === "undefined")
    ordinal = -1;

  //Step 1b - Prep the constants and return variable
  var funcAddr = -1; //The address will be stored here.
  var offset = GetDataDirectory(1).offset;//Import Table
  var imgBase = pe.getImageBase();//The Image Base

  //Step 1c - Iterate through each IMAGE_IMPORT_DESCRIPTOR
  for ( ;true; offset += 20)
  {
    var nameOff = pe.fetchDWord(offset+12);//Dll Name Offset (VA - ImageBase)
    var iatOff  = pe.fetchDWord(offset+16); //Thunk Offset - Start of the Imported Functions

    if (nameOff <= 0) break;//Ending entry wont have dll name so its offset will be 0
    if (iatOff  <= 0) continue;//Import Address Table <- points to the First Thunk

    //Step 1d - If DLL name is provided, only check if it matches with current DLL Name (case insensitively)
    if (dllName !== "")
    {
      nameOff = pe.vaToRaw(nameOff + imgBase);
      var nameEnd = pe.find("00", nameOff);
      if (dllName !== exe.fetch(nameOff, nameEnd - nameOff).toUpperCase()) continue;
    }

    //Step 1e - Get Raw Offset of FIrst Thunk
    var offset2 = pe.vaToRaw(iatOff + imgBase);

    //Step 2a - Iterate through each IMAGE_THUNK_DATA
    for ( ;true; offset2 += 4)
    {
      var funcData = pe.fetchDWord(offset2);//Ordinal Number or Offset of Function Name and Hint

      //Step 2b - Ends with a NULL DWORD
      if (funcData === 0) break;

      //Step 2c - Sign Bit also serves as an indicator of whether this functions is imported by Name (0) or Ordinal (1)
      if (funcData > 0)
      {

        //Step 2d - The Thunk will point to a location with first 2 bytes as Hint followed by Function Name.
        //          So extract it after 2nd byte
        nameOff = pe.vaToRaw((funcData & 0x7FFFFFFF) + imgBase) + 2;
        nameEnd = pe.find("00", nameOff);

        //Step 2e - Check if the Function name matches. If it does, save the address in IAT and break
        if (funcName === exe.fetch(nameOff, nameEnd - nameOff))
        {
          funcAddr = pe.rawToVa(offset2);
          break;
        }
      }
      else if ((funcData & 0xFFFF) === ordinal)
      { //If ordinal import then just compare directly.
        funcAddr = pe.rawToVa(offset2);
        break;
      }
    }

    //Step 2f - If we already got the address break out of the loop
    if (funcAddr !== -1) break;
  }

  return funcAddr;
}

//###############################################################################
//# Purpose: Get the offset and size of the Data Directory specified with index #
//###############################################################################

function GetDataDirectory(index)
{
  var offset = pe.getPeHeader() + 0x18 + 0x60;//Skipping header bytes unnecessary here.
  if (offset === 0x67) //i.e. PE Offset === -1 which is unlikely but still
    return -2;

  var size = pe.fetchDWord(offset + 0x8*index + 0x4);
  offset = pe.vaToRaw(pe.fetchDWord(offset + 0x8*index) + pe.getImageBase());
  return {"offset":offset, "size":size};
}
