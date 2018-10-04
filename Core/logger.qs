//
// Copyright (C) 2018  Andrei Karas (4144)
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

function Logger()
{
    this.open = function(fileName)
    {
        this.file = new TextFile();
        this.file.open(APP_PATH + "/Output/selftest/" + exe.getClientDate() + "_" + fileName + ".log", "w");
    };
    this.close = function()
    {
        this.file.close();
    };
    this.reopen = function(fileName)
    {
        this.close();
        this.open(fileName);
    };
    this.bool = function(data, text)
    {
        if (data)
            this.file.writeline(text + ": true");
        else
            this.file.writeline(text + ": false");
    };
    this.data = function(data, text)
    {
        this.file.writeline(text + ": " + typeof(data) + " '" + data + "'");
    };
    this.hex = function(data, text)
    {
        if (data === false)
        {
            this.file.writeline(text + ": false");
        }
        else
        {
            if (Array.isArray(data))
            {
                this.file.writeline(text + ": array = " + data.length);
                for (var i = 0; i < data.length; i ++)
                {
                    this.file.writeline(" 0x" + data[i].toString(16));
                }
            }
            else if (typeof(data) === 'string' || data instanceof String)
            {
                this.file.writeline(text + ": 0x" + data.toHex1());
            }
            else
            {
                this.file.writeline(text + ": 0x" + data.toString(16));
            }
        }
    };

    this.test = function(text)
    {
        this.file.writeline("\nTest: " + text);
    };
}
