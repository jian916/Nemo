//#######################################################################################
//# Purpose: Dump the Entire Import Table Hierarchy in the loaded client to a text file #
//#######################################################################################

function DumpImportTable()
{

  consoleLog("Step 1a - Get the Import Data Directory Offset");
  var offset = GetDataDirectory(1).offset;
  if (offset === -1)
    throw "Wrong offset";

  consoleLog("Step 1b - Open text file for writing");
  var fp = new TextFile();
  if (!fp.open(APP_PATH + "/Output/importTable_Dump_" + exe.getClientDate() + ".txt", "w"))
    throw "Error: Unable to create text file in Output folder";

  consoleLog("Step 2a - Write the import address to file");
  fp.writeline("IMPORT TABLE (RAW) = 0x" + offset.toBE());

  for ( ;true; offset += 20)
  {
    consoleLog("Step 2b - Iterate through each IMAGE_IMPORT_DESCRIPTOR");
    var ilt = pe.fetchDWord(offset); //Lookup Table address
    var ts = pe.fetchDWord(offset + 4);//TimeStamp
    var fchain = pe.fetchDWord(offset + 8);//Forwarder Chain
    var dllName = pe.fetchDWord(offset + 12);//DLL Name address
    var iatRva = pe.fetchDWord(offset + 16);//Import Address Table <- points to the First Thunk

    consoleLog("Step 2c - Check if reached end - DLL name offset would be zero");
    if (dllName <= 0) break;

    consoleLog("Step 2d - Write the Descriptor Info to file");
    dllName = pe.vaToRaw(dllName + exe.getImageBase());
    var offset2 = pe.find("00", dllName);

    fp.writeline( "Lookup Table = 0x" + ilt.toBE()
                + ", TimeStamp = " + ts
                + ", Forwarder = " + fchain
                + ", Name = " + exe.fetch(dllName, offset2 - dllName)
                + ", Import Address Table = 0x" + (iatRva+exe.getImageBase()).toBE()
                );

    consoleLog("Step 2e - Get the Raw offset of First Thunk");
    offset2 = pe.vaToRaw(iatRva+exe.getImageBase());

    for ( ;true; offset2 += 4)
    {
      consoleLog("Step 2f - Iterate through each IMAGE_THUNK_DATA");
      var funcData = pe.fetchDWord(offset2);//Ordinal Number or Offset of Function Name

      consoleLog("Step 2e - Check which type it is accordingly Write out the info to file");
      if (funcData === 0)
      {
        consoleLog("End of Functions");
        fp.writeline("");
        break;
      }
      else if (funcData > 0)
      {
        consoleLog("First Bit (Sign) shows whether this functions is imported by Name (0) or Ordinal (1)");
        funcData = funcData & 0x7FFFFFFF;//Address pointing to IMAGE_IMPORT_BY_NAME struct (First 2 bytes is Hint, remaining is the Function Name)
        var offset3 = pe.vaToRaw(funcData + exe.getImageBase());
        if (offset3 === -1)
        {
            consoleLog("found wrong address");
            break;
        }
        var offset4 = pe.find("00", offset3 + 2);
        fp.writeline( "  Thunk Address (RVA) = 0x" + exe.Raw2Rva(offset2).toBE()
                    + ", Thunk Address(RAW) = 0x" + offset2.toBE()
                    + ", Function Hint = 0x" + exe.fetchHex(offset3, 2).replace(/ /g, "")
                    + ", Function Name = " + exe.fetch(offset3+2, offset4 - (offset3+2))
                    );
      }
      else
      {
        funcData = funcData & 0xFFFF;
        fp.writeline( "  Thunk Address (RVA) = 0x" + exe.Raw2Rva(offset2).toBE()
                    + ", Thunk Address(RAW) = 0x" + offset2.toBE()
                    + ", Function Ordinal = " + funcData
                    );
      }
    }
  }
  fp.close();

  return "Import Table has been dumped to Output folder";
}
