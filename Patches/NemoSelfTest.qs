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
//#############################################################
//# Purpose: Nemo self test                                   #
//#############################################################

function logBool(log, data, text)
{
    if (data)
        log.writeline(text + ": true");
    else
        log.writeline(text + ": false");
}

function logData(log, data, text)
{
    log.writeline(text + ": " + typeof(data) + " '" + data + "'");
}

function logTest(log, text)
{
    log.writeline("\nTest: " + text);
}

function NemoSelfTest()
{
    // open log
    var log = new TextFile();
    if (!log.open(APP_PATH + "/Output/selftest/selftest.log", "w"))
        return "Open log file failed";

    // open test file for read
    logTest(log, "TextFile read");
    var f = new TextFile();
    logBool(log, f, "new TextFile");
    logData(log, f.open(APP_PATH + "/Input/tests/testfile1.txt", "r"), "open testfile1.txt r");
    logData(log, f.eof(), "eof");
    logData(log, f.readline(), "readline");
    logData(log, f.eof(), "eof");
    logData(log, f.readline(), "readline");
    logData(log, f.eof(), "eof");
    logData(log, f.readline(), "readline");
    logData(log, f.eof(), "eof");
    logData(log, f.readline(), "readline");
    logData(log, f.close(), "close");
    logData(log, f.eof(), "eof");
    logData(log, f.open(APP_PATH + "/Input/tests/testfile3.txt", "r"), "open testfile3.txt r");
    logData(log, f.eof(), "eof");
    logData(log, f.readline(), "readline");
    logData(log, f.eof(), "eof");
    logData(log, f.close(), "close");
    logData(log, f.eof(), "eof");

    // open test file for write/read
    logTest(log, "TextFile write/read");
    f = new TextFile();
    logBool(log, f, "new TextFile");
    logData(log, f.open(APP_PATH + "/Output/testfile2.txt", "w"), "open testfile2.txt w");
    logData(log, f.eof(), "eof");
    logData(log, f.writeline("test1"), "writeline");
    logData(log, f.eof(), "eof");
    logData(log, f.write("other str "), "write");
    logData(log, f.eof(), "eof");
    logData(log, f.writeline("test2"), "writeline");
    logData(log, f.eof(), "eof");
    logData(log, f.close(), "close");
    logData(log, f.eof(), "eof");
    logBool(log, f, "new TextFile");
    logData(log, f.eof(), "eof");
    logData(log, f.open(APP_PATH + "/Output/testfile2.txt", "r"), "open testfile2.txt r");
    logData(log, f.eof(), "eof");
    logData(log, f.readline(), "readline");
    logData(log, f.eof(), "eof");
    logData(log, f.readline(), "readline");
    logData(log, f.eof(), "eof");
    logData(log, f.readline(), "readline");
    logData(log, f.eof(), "eof");
    logData(log, f.readline(), "readline");
    logData(log, f.eof(), "eof");
    logData(log, f.close(), "close");
    logData(log, f.eof(), "eof");

    // close log
    log.close();

    return true;
}
