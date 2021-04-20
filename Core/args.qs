//
// Copyright (C) 2018-2021  Andrei Karas (4144)
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

function checkArgs(args, types2)
{
    var args = Array.prototype.slice.call(args);
    var valid = false;
    var err = "";

    for (var typesIdx = 0; typesIdx < types2.length; typesIdx ++)
    {
        var types = types2[typesIdx];
        if (args.length != types.length)
            continue;

        var idx = 0;
        var found = true;
        for (var idx = 0; idx < types.length; idx ++)
        {
            var type = types[idx];
            var obj = Object.prototype.toString.call(args[idx]).replace(/^\[object |\]$/g, '');
            if (obj != type)
            {
                err = args[idx] + ": " + type + " vs " + obj;
                found = false;
                break;
            }
            idx ++;
        }
        if (found === true)
        {
            valid = true;
            break;
        }
    }
    if (valid !== true)
    {
        if (err === "")
        {
            logArgsError("Wrong arguments count: " + args.length);
        }
        else
        {
            logArgsError("Wrong arguments '" + args.toString() + "': " + err);
        }
    }
}
