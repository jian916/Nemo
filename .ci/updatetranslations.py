#! /usr/bin/env python2
# -*- coding: utf8 -*-
#
# Copyright (C) 2018 Andrei Karas (4144)
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 3 of the License, or
#  any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.

import os

langs = set()
# lang = dict(strGroup, dict(engText = transText))
patchesIni = dict()
# lang = dict(strGroup, dict(engText = transText))
oldPatchesIni = dict()
retCode = 0

patchesName = set()
patchesDescription = set()
patchesCategory = set()
patchesGroup = set()
scriptLines = set()

def langToInit(lang):
    return "Patches_{0}.ini".format(lang)

def initPatchLang(name):
    patchesIni[name] = dict()
    patchesIni[name]["Name"] = dict()
    patchesIni[name]["Category"] = dict()
    patchesIni[name]["Description"] = dict()
    patchesIni[name]["Group"] = dict()
    patchesIni[name]["Script"] = dict()
    oldPatchesIni["Input/backup/" + name] = dict()
    oldPatchesIni["Input/backup/" + name]["Name"] = dict()
    oldPatchesIni["Input/backup/" + name]["Category"] = dict()
    oldPatchesIni["Input/backup/" + name]["Description"] = dict()
    oldPatchesIni["Input/backup/" + name]["Group"] = dict()
    oldPatchesIni["Input/backup/" + name]["Script"] = dict()

def findLangs():
    files = sorted(os.listdir(".."))
    for file1 in files:
        if file1[0] == ".":
            continue
        if os.path.isfile("../" + file1) is False:
            continue
        if file1.find("UI_") != 0:
            continue
        lang = file1[3:-4]
        langs.add(lang)
        initPatchLang(langToInit(lang))

def addPatchIniGroup(name, groupName, group, iniDict):
    if groupName == "":
        return
    iniDict[name][groupName] = group

def parsePatchIni(name, iniDict, isOld):
    path = "../" + name
    if os.path.exists(path) is False:
        return
    # engText = transText
    group = dict()
    groupName = ""
    with open(path, "rt") as r:
        for line in r:
            if len(line) < 2:
                continue
            if line[-1] == "\n":
                line = line[:-1]
            if line[0] == ";":
                continue
            if line[0] == "[":
                addPatchIniGroup(name, groupName, group, iniDict)
                group = dict()
                groupName = line[1:-1]
            else:
                idx = line.find("\"=\"")
                if idx < 0:
                    continue
                line1 = line[:idx+1]
                line2 = line[idx+2:]
                if isOld is False or line1 != line2:
                    group[line1] = line2
        addPatchIniGroup(name, groupName, group, iniDict)

def parsePatchLangs():
    for lang in langs:
        iniName = langToInit(lang)
        parsePatchIni(iniName, patchesIni, False)
        parsePatchIni("Input/backup/" + iniName, oldPatchesIni, True)

def parsePatchesList(name):
    with open(name, "rt") as r:
        while True:
            func = r.readline()
            if func == "":
                break
            func = func[:-1]
            name = r.readline()[:-1]
            description = r.readline()[:-1]
            author = r.readline()[:-1]
            category = r.readline()[:-1]
            group = r.readline()[:-1]
            patchesName.add("\"" + name + "\"")
            patchesDescription.add("\"" + description + "\"")
            patchesCategory.add("\"" + category + "\"")
            patchesGroup.add("\"" + group + "\"")

def savePatchSection(w, name, patches, iniFile, oldIniFile, normalIni):
    global retCode
    section = iniFile[name]
    oldSection = oldIniFile[name]
    for line in patches:
        if normalIni and line not in section:
            if line in oldSection:
                print "Restore line in section {0}: {1}".format(name, line)
                section[line] = oldSection[line]
                del oldSection[line]
            else:
                print "Add line in section {0}: {1}".format(name, line)
                section[line] = line
            retCode = 1
    if normalIni:
        section2 = dict()
        for line in section:
            if line not in patches:
                print "backup old line: " + line
                oldSection[line] = section[line]
            else:
                section2[line] = section[line]
        section = section2
    w.write("\n[{0}]\n".format(name))
    for line in sorted(section.keys()):
        w.write("{0}={1}\n".format(line, section[line]))

def filterLines(name, strings, iniFile, oldIniFile, normalIni):
    section = iniFile[name]
    section2 = dict()
    if normalIni:
        oldSection = oldIniFile[name]
    for line in section:
        if line in strings:
            section2[line] = section[line]
        elif normalIni:
            print "backup old line: " + line
            if line != section[line]:
                oldSection[line] = section[line]
    iniFile[name] = section2
    if normalIni:
        oldIniFile[name] = oldSection

def savePatchIni(name, iniDict, normalIni):
    if normalIni:
        iniFile = iniDict[name]
    else:
        iniFile = iniDict[name]
    if normalIni:
        oldIniFile = oldPatchesIni["Input/backup/" + name]
    else:
        oldIniFile = oldPatchesIni[name]
    with open("../" + name, "wt") as w:
        w.write(";Patches translations\n")
        savePatchSection(w, "Name", patchesName, iniFile, oldIniFile, normalIni)
        savePatchSection(w, "Category", patchesCategory, iniFile, oldIniFile, normalIni)
        savePatchSection(w, "Description", patchesDescription, iniFile, oldIniFile, normalIni)
        savePatchSection(w, "Group", patchesGroup, iniFile, oldIniFile, normalIni)
        if normalIni:
            filterLines("Script", scriptLines, iniFile, oldIniFile, normalIni)
        savePatchSection(w, "Script", scriptLines, iniFile, oldIniFile, normalIni)

def savePatchLangs():
    for lang in langs:
        iniName = langToInit(lang)
        savePatchIni(iniName, patchesIni, True)
        savePatchIni("Input/backup/" + iniName, oldPatchesIni, False)

def parsePoFile(path):
    with open(path, "r") as f:
        flag = 0
        msgid = ""
        for line in f:
            if flag == 0:
                idx = line.find ("msgid ")
                if idx == 0:
                    msgid = line[len("msgid "):]
                    msgid = msgid[1:len(msgid) - 2]
                    flag = 1
            elif flag == 1:
                idx = line.find ("msgstr ")
                if idx == 0:
                    if msgid != "":
                        scriptLines.add("\"" + msgid + "\"")
                    flag = 0
            if line == "\n":
                if flag == 0:
                    if msgid != "":
                        scriptLines.add("\"" + msgid + "\"")
                    flag = 0

            idx = line.find ("\"")
            if idx == 0:
                line = line[1:len(line) - 2]
                if flag == 1:
                    msgid = msgid + line


findLangs()
parsePatchesList("index.txt")
parsePatchLangs()
parsePoFile("nemo.po")
savePatchLangs()

exit(retCode)
