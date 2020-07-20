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
//#####################################################################
//# Purpose: Modify indirect switch table in UIWindowMgr::MakeWindow, #
//#          make specified windows go to default case.               #
//#####################################################################
function DisableWindows()
{
  //Get the address of UIWindowMgr::MakeWindow
  var WndMgr = GetWinMgrInfo();

  if (typeof(WndMgr) === "string")
    return "Failed in Step 1 - " + WndMgr;

  var makeWnd = exe.Rva2Raw(WndMgr['makeWin']);

  //Find switch table
  var code =
    " 0F B6 AB AB AB AB 00" //movzx eax,byte ptr [eax+iswTable]
  + " FF 24 85 AB AB AB 00" //jmp dword ptr [eax*4+swTable]
  ;
  var switch1Offset = 3;
  var switch2Offset = 10;

  var offset = exe.find(code, PTYPE_HEX, true, "\xAB", makeWnd, makeWnd + 0x200);
  if (offset === -1)
    return "Failed in Step 1 - Can't find indirect table for switch statement";

  logVaVar("UIWindowMgr_MakeWindow switch1", offset, switch1Offset);
  logVaVar("UIWindowMgr_MakeWindow switch2", offset, switch2Offset);

  var ITSS = exe.fetchDWord(offset + 3);

  //Find the default case offset, should be same in ID 54 & 67
  var dfCase = exe.fetchHex(exe.Rva2Raw(ITSS + 54), 1);
  if (dfCase !== exe.fetchHex(exe.Rva2Raw(ITSS + 67), 1))
    return "Failed in Step 2";

  //Get disable windows id list from input file
  var fp = new TextFile();
  var inpFile = GetInputFile(fp, "$DisableWindows", _("File Input - Disable Windows"), _("Enter the Disable Windows file"), APP_PATH + "/Input/DisableWindows.txt");
  if (!inpFile)
    return "Patch Cancelled";

  var WndID = [];
  while (!fp.eof())
  {
    var line = fp.readline().trim();
    if (line === "") continue;

    var matches;
    if (matches = line.match(/^([\d]{1,3})$/))
    {
      var value = parseInt(line.substr(0));
      if (!isNaN(value))
        WndID.push(value);
    }
  }
  fp.close();

  if (WndID.length === 0)
    return "Patch Cancelled";

  //Make specified windows jump to default case
  for (var i = 0; i < WndID.length; i++)
  {
    exe.replace(exe.Rva2Raw(ITSS + WndID[i]), dfCase, PTYPE_HEX);
  }

  return true;
}
