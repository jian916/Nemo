//###############################################################################
//# Purpose: Override data.grf loading with a custom function which loads a set #
//#          of grfs directly. The list of files is read by the patch from INI  #
//###############################################################################

function EnableMultipleGRFsV2()
{ //The initial steps are same as EnableMultipleGRFs. Maybe we can make it shared?

    //Step 1a - Find data.grf location
    var grf = pe.stringHex4("data.grf");

    //Step 1b - Find its reference
    var code =
        " 68" + grf       //PUSH OFFSET addr1; "data.grf"
      + getEcxFileMgrHex() //MOV ECX, OFFSET g_fileMgr
    ;

    var offset = pe.findCode(code);
    var setEcxOffset = 5;
    var pushOffset = 0;
    var addpackOffset = -1;

    if (offset === -1)
    {   // 2019-02-13
        var code =
            getEcxFileMgrHex() +          // 0 mov ecx, offset g_FileMgr
            "85 C0 " +                    // 5 test eax, eax
            "0F 95 05 ?? ?? ?? ?? " +     // 7 setnz byte ptr g_session+4D8Eh
            "68 " + grf +                 // 14 push offset aData_grf
            "E8 ";                        // 19 call CFileMgr_AddPak
        offset = pe.findCode(code);
        setEcxOffset = 0;
        pushOffset = 14;
        fnoffset = offset;
        addpackOffset = 20;
    }

    if (offset === -1)
        return "Failed in Step 1";

    //Step 2a - Extract the g_FileMgr assignment
    var setECX = getEcxFileMgrHex()

    //Step 2b - Find the AddPak call after the push
    if (addpackOffset === -1)
    {
        code =
            " E8 ?? ?? ?? ??"    //CALL CFileMgr::AddPak()
          + " 8B ?? ?? ?? ?? 00" //MOV reg32, DWORD PTR DS:[addr1]
          + " A1 ?? ?? ?? 00"    //MOV EAX, DWORD PTR DS:[addr2]
        ;
        var fnoffset = pe.find(code, offset + 10, offset + 40);
        var addpackOffset = 1;
    }

    if (fnoffset === -1)
    { //VC9 Client
        code =
            " E8 ?? ?? ?? ??" //CALL CFileMgr::AddPak()
          + " A1 ?? ?? ?? 00" //MOV EAX, DWORD PTR DS:[addr2]
        ;
        fnoffset = pe.find(code, offset + 10, offset + 40);
    }

    if (fnoffset === -1)
    { //Older Clients
        code =
            " E8 ?? ?? ?? ??" //CALL CFileMgr::AddPak()
          + " BF ?? ?? ?? 00" //MOV EDI, OFFSET addr2
        ;
        fnoffset = pe.find(code, offset + 10, offset + 40);
    }

    if (fnoffset === -1)
        return "Failed in Step 2";

    //Step 2c - Extract AddPak function address
    var AddPak = pe.rawToVa(fnoffset + addpackOffset + 4) + pe.fetchDWord(fnoffset + addpackOffset);

    //Step 3a - Get the INI file from user to read
    var f = new TextFile();
    if (!GetInputFile(f, "$inpMultGRF", _('File Input - Enable Multiple GRF'), _('Enter your INI file'), APP_PATH + "/Input/DATA.INI") )
        return "Patch Cancelled";

    if (f.eof())
        return "Patch Cancelled";

    //Step 3b - Read the GRF filenames from the INI
    var temp = [];
    while (!f.eof())
    {
        var str = f.readline().trim();
        if (str.charAt(1) === "=")
        {
            var key = parseInt(str.charAt(0));
            if (!isNaN(key))
                temp[key] = str.substr(2);//full length is retrieved.
        }
    }

    f.close();

    //Step 3c - Put into an array in order.
    var grfs = [];
    for (var i = 0; i < 10; i++)
    {
        if (temp[i])
            grfs.push(temp[i]);
    }
    if (!grfs[0])
        grfs.push("data.grf");

    //Step 4a - Prep code for GRF loading
    var template =
        " 68" + GenVarHex(1) //PUSH OFFSET addr; GRF name
      + setECX               //MOV ECX, OFFSET g_fileMgr
      + " E8" + GenVarHex(2) //CALL CFileMgr::AddPak()
    ;

    //Step 4b - Get Size of code & strings to allocate
    var strcode = grfs.join("\x00") + "\x00";
    var size = strcode.length + grfs.length * template.hexlength() + 2;

    //Step 4c - Allocate space to inject
    var free = exe.findZeros(size);
    if (free === -1)
        return "Failed in Step 4 - Not enough free space";

    var freeRva = pe.rawToVa(free);

    //Step 4d - Starting offsets to replace GenVarHex with
    var o2 = freeRva + grfs.length * template.hexlength() + 2;
    var fn = AddPak - o2 + 2;

    //Step 4e - Create the full code from template for each grf & add strings
    var code = "";
    for (var j = 0; j < grfs.length; j++)
    {
        code = ReplaceVarHex(template, [1, 2], [o2, fn]) + code;
        o2 += grfs[j].length + 1; //Extra 1 for NULL byte
        fn += template.hexlength();
    }
    code += " C3 00";//RETN and 1 extra NULL
    code += strcode.toHex();

    //Step 4f - Create a call to the free space that was found before.
    exe.replace(offset + pushOffset, "B9", PTYPE_HEX);//Little trick to avoid changing 10 bytes - apparently the push gets nullified in the original
    exe.replaceDWord(fnoffset + addpackOffset, freeRva - pe.rawToVa(fnoffset + addpackOffset + 4));

    //Step 5 - Insert everything.
    exe.insert(free, size, code, PTYPE_HEX);

    //Step 6 - Find offset of rdata.grf (if present zero it out)
    offset = pe.stringRaw("rdata.grf");
    if (offset !== -1)
        exe.replace(offset, "00", PTYPE_HEX);

    return true;
}
