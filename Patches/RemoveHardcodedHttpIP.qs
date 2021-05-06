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
//# Purpose: Remove hardcoded HTTP service ip address.             #
//##################################################################

function RemoveHardcodedHttpIP()
{

  var ipaddrs = ["http://112.175.128.140:3000", "http://112.175.128.30:3000", "http://192.168.5.54:3000"];
  var found = false;

  for (var i =0; i < ipaddrs.length; i ++)
  {
    var offsets = pe.findAll(ipaddrs[i].toHex());
    if (offsets.length > 0)
        found = true;
    for (var j = 0; j < offsets.length; j++)
    {
      exe.replace(offsets[j], "http://0.0.0.0/\x00", PTYPE_STRING);
    }
  }
  if (found === false)
    return "Found nothing to patch";

  return true;
}
