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
//# Purpose: Insert custom code to auto mute audio when game       #
//#          window not actived.                                   #
//##################################################################
function AutoMute()
{
  //Step 1 - Get informations we need from load OptionInfo.lua function.
  var code =
      " 68 AB AB AB AB"    //0 push "Bgm_Volume"
    + " E8 AB AB AB AB"    //5 call GetOptionValue
    + " 50"                //10 push eax
    + " 8B CE"             //11 mov ecx,esi
    + " E8 AB AB AB AB"    //13 call SetStreamVolume
    + " 8B 35 AB AB AB AB" //18 mov esi,[g_mssVar]
    + " 8B CE"             //24 mov ecx,esi
    + " E8 AB AB AB AB"    //26 call GetStreamVolume
    + " 50"                //31 push eax
    + " 8B CE"             //32 mov ecx,esi
    + " E8 AB AB AB AB"    //34 call SetStreamVolume2
    + " 8B 0D AB AB AB AB" //39 mov ecx,[g_mssVar]
    + " 57"                //45 push edi
    + " E8 AB AB AB AB"    //46 call Set2DEffectVolume
    + " 8B 0D AB AB AB AB" //51 mov ecx,[g_mssVar]
    + " 57"                //57 push edi
    + " E8 AB AB AB AB"    //58 call Set3DEffectVolume
    ;

  var mssVarOffset = 20;
  var bgmOffset = 14;
  var eff2dOffset = 47;
  var eff3dOffset = 59;

  var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
  if (offset === -1)
  {
    code = code.replace(" 68 AB AB AB AB", " 68 AB AB AB AB 8B CB 8B F8");
    offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    mssVarOffset += 4;
    bgmOffset += 4;
    eff2dOffset += 4;
    eff3dOffset += 4;
  }
  if (offset === -1)
    return "Failed in Step 1";

  //Fetch all informations for later
  var mssVar = exe.fetchHex(offset + mssVarOffset, 4);
  var SetBgmFuncAddr = exe.Raw2Rva(offset + bgmOffset + 4) + exe.fetchDWord(offset + bgmOffset);
  var SetEff2DFuncAddr = exe.Raw2Rva(offset + eff2dOffset + 4) + exe.fetchDWord(offset + eff2dOffset);
  var SetEff3DFuncAddr = exe.Raw2Rva(offset + eff3dOffset + 4) + exe.fetchDWord(offset + eff3dOffset);

  //Step 2 - Find the CGameMode::OnUpdate function
  code =
      " 85 C0"             // test eax,eax
    + " 75 AB"             // jne short
    + " 8B 0D AB AB AB AB" // mov ecx,[offset1]
    + " 6A 00"             // push 0
    + " 6A 00"             // push 0
    + " 6A 00"             // push 0
    + " 8B 01"             // mov eax,[ecx]
    + " 6A 00"             // puah 0
    + " 6A 23"             // push 23
    + " 6A 00"             // push 0
    + " FF 90 AB 00 00 00" // call dword ptr [eax+88]
    ;

  offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
  if (offset === -1)
  {
    code = code.replace(" 6A 00 6A 00 6A 00 8B 01", " 6A 00 8B 01 6A 00 6A 00");
    offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
  }
  if (offset === -1)
    return "Failed in Step 2a";

  //Find the location to insert the jump
  code =
      " E8 AB AB AB AB"       //call UIWindowMgr::InvalidateAll
    + " B9 AB AB AB AB"       //mov ecx,offset g_Weather <--stole Byte from here
    + " E8 AB AB AB AB"       //call CWeather::Process
    + " 83 3D AB AB AB AB 00" //cmp dword ptr [g_isAppActive],0
    + " 75 AB"                //jne short
    ;

  offset = exe.find(code, PTYPE_HEX, true, "\xAB", offset, offset + 0x500);

  if (offset === -1)
    return "Failed in Step 2b";

  var jumpOffset = offset + 5;

  var varCode = exe.fetchHex(jumpOffset, 5);

  //Step 3 - Find the API:GetActiveWindow pointer
  var GetActiveWindow = GetFunction("GetActiveWindow", "User32.dll");
  if (GetActiveWindow === -1)
    return "Failed in Step 3 - GetActiveWindow not found";

  //Step 4 - Prepare the custom code
  code =
      " FF D7"                                //0 call edi (timeGetTime)
    + " 3B 05" + GenVarHex(1)                 //2 cmp eax,[lastCheck]
    + " 0F 8C 9A 00 00 00"                    //8 jl short
    + " 05 F4 01 00 00"                       //14 add eax,1F4 (500)
    + " A3" + GenVarHex(1)                    //19 mov [lastCheck],eax
    + " 83 3D" + GenVarHex(2) + " 01"         //24 cmp dword ptr [isMuted],01
    + " 74 1C"                                //31 je short
    + " 8B 0D" + mssVar                       //33 mov ecx,[mssVar]
    + " 8B 81 EC 00 00 00"                    //39 mov eax,[ecx+EC]
    + " A3" + GenVarHex(3)                    //45 [bgmVol],eax
    + " 8B 81 F0 00 00 00"                    //50 mov eax,[ecx+F0]
    + " A3" + GenVarHex(4)                    //56 [effVol],eax
    + " FF 15" + GetActiveWindow.packToHex(4) //61 call dword ptr [GetActiveWindow]
    + " 8B 0D" + mssVar                       //67 mov ecx,[mssVar]
    + " 85 C0"                                //73 test eax,eax
    + " 74 33"                                //75 je short
    + " 83 3D" + GenVarHex(2) + " 00"         //77 cmp dword ptr [isMuted],00
    + " 74 52"                                //84 je short
    + " 31 C0"                                //86 xor eax,eax
    + " A3" + GenVarHex(2)                    //88 mov [isMuted],eax
    + " FF 35" + GenVarHex(4)                 //93 push [effVol]
    + " E8" + GenVarHex(5)                    //99 call set2DEffectVolume
    + " FF 35" + GenVarHex(4)                 //104 push [effVol]
    + " E8" + GenVarHex(6)                    //110 call set3DEffectVolume
    + " FF 35" + GenVarHex(3)                 //115 push [bgmVol]
    + " E8" + GenVarHex(7)                    //121 call setBgmVolume
    + " EB 28"                                //126 jmp short
    + " 83 3D" + GenVarHex(2) + " 01"         //128 cmp dword ptr [isMuted],01
    + " 74 1F"                                //135 je short
    + " B8 01 00 00 00"                       //137 mov eax,01
    + " A3" + GenVarHex(2)                    //142 mov [isMuted],eax
    + " 6A 00"                                //147 push 0
    + " E8" + GenVarHex(5)                    //149 call set2DEffectVolume
    + " 6A 00"                                //154 push 0
    + " E8" + GenVarHex(6)                    //156 call set3DEffectVolume
    + " 6A 00"                                //161 push 0
    + " E8" + GenVarHex(7)                    //163 call setBgmVolume
    + varCode                                 //168 mov ecx,offset
    + " C3"                                   //173 ret
    ;

  //Prepare the buffer
  var buffer =
      " 00 00 00 00" //lastCheck
    + " 00 00 00 00" //isMuted
    + " 64 00 00 00" //bgmVol
    + " 64 00 00 00" //effVol
    ;

  //Find free space
  var size = buffer.hexlength() + code.hexlength() + 4;
  var free = exe.findZeros(size + 8);
  if (free === -1)
    return "Failed in Step 4 - Not enough free space";

  var freeRva = exe.Raw2Rva(free);
  var ins = buffer + code;

  //Fill in the blanks
  for (var i =0; i < 2; i++)
  {
    ins = ReplaceVarHex(ins, 1, freeRva);
  }

  for (var i =0; i < 5; i++)
  {
    ins = ReplaceVarHex(ins, 2, freeRva + 4);
  }

  for (var i =0; i < 2; i++)
  {
    ins = ReplaceVarHex(ins, 3, freeRva + 8);
  }

  for (var i =0; i < 3; i++)
  {
    ins = ReplaceVarHex(ins, 4, freeRva + 12);
  }

  var offsets = [100, 150]
  for (var i =0; i < 2; i++)
  {
    ins = ReplaceVarHex(ins, 5, SetEff2DFuncAddr - (freeRva + 16 + offsets[i] + 4));
  }

  offsets = [111, 157]
  for (var i =0; i < 2; i++)
  {
    ins = ReplaceVarHex(ins, 6, SetEff3DFuncAddr - (freeRva + 16 + offsets[i] + 4));
  }

  offsets = [122, 164]
  for (var i =0; i < 2; i++)
  {
    ins = ReplaceVarHex(ins, 7, SetBgmFuncAddr - (freeRva + 16 + offsets[i] + 4));
  }

  //Insert the code & jump
  exe.insert(free, size, ins, PTYPE_HEX);

  code = " E8" + ((freeRva + 16) - exe.Raw2Rva(jumpOffset + 5)).packToHex(4);

  exe.replace(jumpOffset, code, PTYPE_HEX);


  return true;
}
