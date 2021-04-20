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
      " 68 ?? ?? ?? ??"    //0 push "Bgm_Volume"
    + " E8 ?? ?? ?? ??"    //5 call GetOptionValue
    + " 50"                //10 push eax
    + " 8B CE"             //11 mov ecx,esi
    + " E8 ?? ?? ?? ??"    //13 call SetStreamVolume
    + " 8B 35 ?? ?? ?? ??" //18 mov esi,[g_soundMgr]
    + " 8B CE"             //24 mov ecx,esi
    + " E8 ?? ?? ?? ??"    //26 call GetStreamVolume
    + " 50"                //31 push eax
    + " 8B CE"             //32 mov ecx,esi
    + " E8 ?? ?? ?? ??"    //34 call SetStreamVolume2
    + " 8B 0D ?? ?? ?? ??" //39 mov ecx,[g_soundMgr]
    + " 57"                //45 push edi
    + " E8 ?? ?? ?? ??"    //46 call Set2DEffectVolume
    + " 8B 0D ?? ?? ?? ??" //51 mov ecx,[g_soundMgr]
    + " 57"                //57 push edi
    + " E8 ?? ?? ?? ??"    //58 call Set3DEffectVolume
    ;

  var GetOptionValueOffset = 6;
  var SetStreamVolumeOffset = 14;
  var GetStreamVolumeOffset = 27;
  var SetStreamVolume2Offset = 35;
  var Set2DEffectVolumeOffset = 47;
  var Set3DEffectVolumeOffset = 59;
  var soundMgrOffsets = [20, 41, 53];

  var offset = pe.findCode(code);
  if (offset === -1)
  {
        code =
            "68 ?? ?? ?? ?? " +           // 0 push offset aBgm_volume
            "8B CB " +                    // 5 mov ecx, ebx
            "8B F8 " +                    // 7 mov edi, eax
            "E8 ?? ?? ?? ?? " +           // 9 call CSession_GetOptionValue
            "50 " +                       // 14 push eax
            "8B CE " +                    // 15 mov ecx, esi
            "E8 ?? ?? ?? ?? " +           // 17 call CSession_SetStreamVolume
            "8B 35 ?? ?? ?? ?? " +        // 22 mov esi, g_soundMgr
            "8B CE " +                    // 28 mov ecx, esi
            "E8 ?? ?? ?? ?? " +           // 30 call CSoundMgr_GetStreamVolume
            "50 " +                       // 35 push eax
            "8B CE " +                    // 36 mov ecx, esi
            "E8 ?? ?? ?? ?? " +           // 38 call CSoundMgr_SetStreamVolume2
            "8B 0D ?? ?? ?? ?? " +        // 43 mov ecx, g_soundMgr
            "57 " +                       // 49 push edi
            "E8 ?? ?? ?? ?? " +           // 50 call CSoundMgr_Set2DEffectVolume
            "8B 0D ?? ?? ?? ?? " +        // 55 mov ecx, g_soundMgr
            "57 " +                       // 61 push edi
            "E8 ?? ?? ?? ?? ";            // 62 call CSoundMgr_Set3DEffectVolume
        GetOptionValueOffset = 10;
        SetStreamVolumeOffset = 18;
        GetStreamVolumeOffset = 31;
        SetStreamVolume2Offset = 39;
        Set2DEffectVolumeOffset = 51;
        Set3DEffectVolumeOffset = 63;
        soundMgrOffsets = [24, 45, 57];

        offset = pe.findCode(code);
  }
  if (offset === -1)
    return "Failed in Step 1";

  logRawFunc("CSession::GetOptionValue", offset, GetOptionValueOffset);
  logRawFunc("CSoundMgr::SetStreamVolume", offset, SetStreamVolumeOffset);
  logRawFunc("CSoundMgr::GetStreamVolume", offset, GetStreamVolumeOffset);
  logRawFunc("CSoundMgr::SetStreamVolume2", offset, SetStreamVolume2Offset);
  logRawFunc("CSoundMgr::Set2DEffectVolume", offset, Set2DEffectVolumeOffset);
  logRawFunc("CSoundMgr::Set3DEffectVolume", offset, Set3DEffectVolumeOffset);

  for (var i = 0; i < soundMgrOffsets.length; i++)
  {
    logVaVar("g_soundMgr", offset, soundMgrOffsets[i]);
  }

  //Fetch all informations for later
  var soundMgr = exe.fetchHex(offset + soundMgrOffsets[0], 4);
  var SetBgmFuncAddr = exe.Raw2Rva(offset + SetStreamVolumeOffset + 4) + exe.fetchDWord(offset + SetStreamVolumeOffset);
  var SetEff2DFuncAddr = exe.Raw2Rva(offset + Set2DEffectVolumeOffset + 4) + exe.fetchDWord(offset + Set2DEffectVolumeOffset);
  var SetEff3DFuncAddr = exe.Raw2Rva(offset + Set3DEffectVolumeOffset + 4) + exe.fetchDWord(offset + Set3DEffectVolumeOffset);

  //Step 2 - Find the CGameMode::OnUpdate function
    code =
        "85 C0 " +                    // 0 test eax, eax
        "75 1A " +                    // 2 jnz short loc_9DBA59
        "8B 0D ?? ?? ?? ?? " +        // 4 mov ecx, g_windowMgr.m_UIReplayControlWnd
        "6A 00 " +                    // 10 push 0
        "6A 00 " +                    // 12 push 0
        "6A 00 " +                    // 14 push 0
        "8B 01 " +                    // 16 mov eax, [ecx]
        "6A 00 " +                    // 18 push 0
        "6A 23 " +                    // 20 push 23h
        "6A 00 " +                    // 22 push 0
        "FF 90 ?? 00 00 00 ";         // 24 call [eax+UIReplayControlWnd_vtable.UIReplayControlWnd_SendMsg]
    var UIReplayControlWndOffset = [6, 4];
    var SendMsgOffset = [26, 4];

  offset = pe.findCode(code);
  if (offset === -1)
  {
        code =
            "85 C0 " +                    // 0 test eax, eax
            "75 1A " +                    // 2 jnz short loc_9C570F
            "8B 0D ?? ?? ?? ?? " +        // 4 mov ecx, g_windowMgr.m_UIReplayControlWnd
            "6A 00 " +                    // 10 push 0
            "8B 01 " +                    // 12 mov eax, [ecx+UIReplayControlWnd.vptr]
            "6A 00 " +                    // 14 push 0
            "6A 00 " +                    // 16 push 0
            "6A 00 " +                    // 18 push 0
            "6A 23 " +                    // 20 push 23h
            "6A 00 " +                    // 22 push 0
            "FF 90 ?? 00 00 00 ";         // 24 call [eax+UIReplayControlWnd_vtable.UIReplayControlWnd_virt136]
        UIReplayControlWndOffset = [6, 4];
        SendMsgOffset = [26, 4];

        offset = pe.findCode(code);
  }
  if (offset === -1)
    return "Failed in Step 2a";

  logFieldAbs("UIWindowMgr::m_UIReplayControlWnd", offset, UIReplayControlWndOffset);
  logField("UIReplayControlWnd_vtable::SendMsg", offset, SendMsgOffset)

  //Find the location to insert the jump
    code =
        "E8 ?? ?? ?? ?? " +           // 0 call UIWindowMgr_InvalidateAll
        "B9 ?? ?? ?? ?? " +           // 5 mov ecx, offset g_Weather <--stole Byte from here
        "E8 ?? ?? ?? ?? " +           // 10 call CWeather_Process
        "83 3D ?? ?? ?? ?? 00 " +     // 15 cmp g_isAppActive, 0
        "75 0D " +                    // 22 jnz short loc_9DBE78
        "83 3D ?? ?? ?? ?? 00 " +     // 24 cmp g_3dDevice.m_bIsFullscreen, 0
        "0F 85 ";                     // 31 jnz loc_9DC24D
  var jmpOffset = 5;
  var UIWindowMgr_InvalidateAllOffset = 1;
  var g_WeatherOffset = 6;
  var CWeather_Process = 11;
  var g_isAppActiveOffset = 17;
  var m_bIsFullscreenOffset = [26, 4];

  offset = pe.find(code, offset, offset + 0x500);

  if (offset === -1)
    return "Failed in Step 2b";

  logRawFunc("UIWindowMgr::InvalidateAll", offset, UIWindowMgr_InvalidateAllOffset);
  logVaVar("g_Weather", offset, g_WeatherOffset);
  logRawFunc("CWeather_Process", offset, CWeather_Process);
  logVaVar("g_isAppActive", offset, g_isAppActiveOffset);
  logFieldAbs("C3dDevice::m_bIsFullscreen", offset, m_bIsFullscreenOffset);

  var jumpAddr = offset + jmpOffset;

  var varCode = exe.fetchHex(jumpAddr, 5);

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
    + " 8B 0D" + soundMgr                     //33 mov ecx,[g_soundMgr]
    + " 8B 81 EC 00 00 00"                    //39 mov eax,[ecx+EC]
    + " A3" + GenVarHex(3)                    //45 [bgmVol],eax
    + " 8B 81 F0 00 00 00"                    //50 mov eax,[ecx+F0]
    + " A3" + GenVarHex(4)                    //56 [effVol],eax
    + " FF 15" + GetActiveWindow.packToHex(4) //61 call dword ptr [GetActiveWindow]
    + " 8B 0D" + soundMgr                     //67 mov ecx,[g_soundMgr]
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

  code = " E8" + ((freeRva + 16) - exe.Raw2Rva(jumpAddr + 5)).packToHex(4);

  exe.replace(jumpAddr, code, PTYPE_HEX);


  return true;
}
