//
// Copyright (C) 2020  CH.C
//
// Hercules is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
//##################################################################
//# Purpose: Reconstruct songs code by borrow LandProtector's code #
//#          inside CSkill::OnProcess function.                    #
//##################################################################
function RestoreSongsEffect()
{
    //Step 1a - Find CSkill::OnProcess
    var code =
        " E8 ?? ?? ?? ??"       //0 call CGameActor::GetJob
      + " 83 C0 82"             //5 add eax,-7E
      + " 3D ?? 00 00 00"       //8 cmp eax,MAX_EFNUM
      + " 0F 87 ?? ?? ?? ??"    //13 ja addr
      + " 0F B6 80 ?? ?? ?? ??" //19 movzx eax,byte ptr [eax+iswTable]
      + " FF 24 85 ?? ?? ?? ??" //26 jmp dword ptr [eax*4+swTable]
    ;

    var getJobOffset = 1;
    var switch1Offset = 22;
    var switch2Offset = 29;

    var offset = pe.findCode(code);
    if (offset === -1)
        return "Failed in Step 1 - CSkill::OnProcess not found";

    logRawFunc("CGameActor_GetJob", offset, getJobOffset);
    logVaVar("CSkill_OnProcess switch1", offset, switch1Offset);
    logVaVar("CSkill_OnProcess switch2", offset, switch2Offset);

    //Step 1b - Get the address of indirect switch table
    var iswTable = pe.fetchDWord(offset + switch1Offset);

    //Step 2 - Find & borrow the code of LandProtector
    code =
        " 83 BE ?? ?? 00 00 00"    //0 cmp dword ptr [esi+3E0],00
      + " 0F 85 ?? ?? ?? ??"       //7 jne addr
      + " 83 EC 10"                //13 sub esp,10
      + " 8B CC"                   //16 mov ecx,esp
      + " C7 44 24 ?? 00 00 00 00" //18 mov [esp+0C],0
      + " 68 F2 00 00 00"          //26 push F2
      + " E9"                      //31 jmp addr
    ;
    var patchOffset = 26;
    var loopOffset = [2, 4];

    offset = pe.findCode(code);
    if (offset === -1)
    { //2019's clients
        code =
            " 8B 8E ?? ?? 00 00" //0 mov ecs,[esi+3E0]
          + " 85 C9"             //6 test ecx,ecx
          + " 0F 85 ?? ?? ?? ??" //8 jne addr
          + " 83 EC 10"          //14 sub esp,10
          + " 89 4C 24 ??"       //17 mov [esp+0C],ecx
          + " 8B CC"             //21 mov ecx,esp
          + " 68 F2 00 00 00"    //23 push F2
          + " E9"                //28 jmp addr
        ;
        patchOffset = 23;
        loopOffset = [2, 4];
        offset = pe.findCode(code);
    }
    if (offset === -1)
    { //2020's clients
        code =
            " 8B 8E ?? ?? 00 00" //0 mov ecs,[esi+3E0]
          + " 85 C9"             //6 test ecx,ecx
          + " 0F 85 ?? ?? ?? ??" //8 jne addr
          + " 83 EC 10"          //14 sub esp,10
          + " 89 4D ??"          //17 mov [ebp-10],ecx
          + " 8B 45 ??"          //20 mov eax,[ebp-10]
          + " 89 4C 24 ??"       //23 mov [esp+0C],ecx
          + " 8B CC"             //27 mov ecx,esp
          + " 68 F2 00 00 00"    //29 push F2
          + " E9"                //34 jmp addr
        ;
        patchOffset = 29;
        loopOffset = [2, 4];
        offset = pe.findCode(code);
    }
    if (offset === -1)
        return "Failed in Step 2 - Borrow code not found";

    logField("CSkill::m_LoopEffect", offset, loopOffset);

    var patchAddr = offset + patchOffset;
    var retAddr = pe.rawToVa(patchAddr + 5).packToHex(4);

    //Step 3 - get skill id offset
    code =
        " B8 ?? ?? 00 00"     //0 mov eax,1094h
      + " 75 06"              //5 jne short
      + " 8B 86 ?? ?? 00 00"  //7 mov eax,[esi+skillOffset]
      + " 5E"                 //13 pop esi
      + " C3"                 //14 ret
    ;
    var jobOffset = [9, 4];
    offset = pe.findCode(code);
    if (offset === -1)
        return "Failed in Step 3 - skill offset not found";

    var sidOffset = pe.fetchHex(offset + jobOffset[0], jobOffset[1]);
    logField("CGameActor::m_job", offset, jobOffset);

    //Step 4a - Prepare effectID list
    var effectID = [242, 278, 279, 280, 281, 282, 283, 284, 285, 277, 286, 287, 288, 289, 290, 291, 292, 293, 294];

    //Step 4b - Prepare the code to insert
    var ins =
        " 50"                   //push eax
      + " 8B 86" + sidOffset    //mov eax,[esi+250]
      + " 2D 9D 00 00 00"       //sub eax,9D
      + " FF 24 85 XX XX XX XX" //jmp dword ptr [eax*4+swTable]
    ;

    var case1Offset = ins.hexlength();
    var size = case1Offset + (effectID.length * 16);
    var free = exe.findZeros(size + 4);
    if (free === -1)
        return "Failed in Step 4 - No enough free space";

    //Step 4c - Find free space
    var freeRva = pe.rawToVa(free);
    var swTable = free + case1Offset + (effectID.length * 12);
    ins = ins.replace(" XX XX XX XX", pe.rawToVa(swTable).packToHex(4));

    //Step 4d - Add switch cases
    for (var i = 0; i < effectID.length; i++)
    {
        code =
            " 58"                            //pop eax
          + " 68" + effectID[i].packToHex(4) //push effectID
          + " 68" + retAddr                  //push retAddr
          + " C3"                            //ret
        ;

        ins += code;
    }

    //Step 4e - Add switch address table
    for (var i = 0; i < effectID.length; i++)
    {
        var swAddr = free + case1Offset + (i * 12);
        ins += pe.rawToVa(swAddr).packToHex(4);
    }

    //Step 4f - Inject the code
    code = " E9" + (freeRva - pe.rawToVa(patchAddr + 5)).packToHex(4);

    exe.insert(free, size, ins, PTYPE_HEX);
    pe.replaceHex(patchAddr, code);

    //Step 5 - Modify indirect switch table
    var firstUnitID = 126;
    var LPUnirID = 157;
    var firstSongUnitID = 158;
    var LPtblOffset = pe.fetchHex(pe.vaToRaw(iswTable + (LPUnirID - firstUnitID)), 1);

    code = LPtblOffset.repeat(effectID.length - 1);

    pe.replaceHex(pe.vaToRaw(iswTable + (firstSongUnitID - firstUnitID)), code);

    return true;
}
