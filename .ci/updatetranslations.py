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
retCode = 0

patchesName = set()
patchesDescription = set()
patchesCategory = set()
patchesGroup = set()

def langToInit(lang):
    return "Patches_{0}.ini".format(lang)

def initPatchLang(name):
    patchesIni[name] = dict()
    patchesIni[name]["Name"] = dict()
    patchesIni[name]["Category"] = dict()
    patchesIni[name]["Description"] = dict()
    patchesIni[name]["Group"] = dict()

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

def addPatchIniGroup(name, groupName, group):
    if groupName == "":
        return
    patchesIni[name][groupName] = group

def parsePatchIni(name):
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
                addPatchIniGroup(name, groupName, group)
                group = dict()
                groupName = line[1:-1]
            else:
                idx = line.find("\"=\"")
                if idx < 0:
                    continue
                group[line[:idx+1]] = line[idx+2:]
        addPatchIniGroup(name, groupName, group)

def parsePatchLangs():
    for lang in langs:
        iniName = langToInit(lang)
        parsePatchIni(iniName)

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

def savePatchSection(w, name, patches, iniFile):
    section = iniFile[name]
    for line in patches:
        if line not in section:
            print "Add line in file {0}: {1}".format(name, line)
            section[line] = line
    w.write("\n[{0}]\n".format(name))
    for line in sorted(section.keys()):
        w.write("{0}={1}\n".format(line, section[line]))

def savePatchIni(name):
    iniFile = patchesIni[name]
    with open("../" + name, "wt") as w:
        w.write(";Patches translations\n")
        savePatchSection(w, "Name", patchesName, iniFile)
        savePatchSection(w, "Category", patchesCategory, iniFile)
        savePatchSection(w, "Description", patchesDescription, iniFile)
        savePatchSection(w, "Group", patchesGroup, iniFile)

def savePatchLangs():
    for lang in langs:
        iniName = langToInit(lang)
        savePatchIni(iniName)


findLangs()
parsePatchesList("index.txt")
parsePatchLangs()
savePatchLangs()

exit(retCode)
