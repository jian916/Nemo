//
// Copyright (C) 2020-2021  Andrei Karas (4144)
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
//############################################################################
//# Purpose: Allow select custom job in char create window (replacing doram) #
//############################################################################

function ChangeSecondCharCreateJob()
{
    consoleLog("search doram character job id");
    var code =
        "8B 83 ?? ?? ?? 00 " +        // 0 mov eax, [ebx+UINewMakeCharWnd.char_type_selection]
        "83 E8 00 " +                 // 6 sub eax, 0
        "74 1B " +                    // 9 jz short loc_5190D2
        "48 " +                       // 11 dec eax
        "75 21 " +                    // 12 jnz short loc_5190DB
        "B8 7A 10 00 00 " +           // 14 mov eax, 107Ah
        "8B CB " +                    // 19 mov ecx, ebx
        "66 89 83 ?? ?? ?? 00 " +     // 21 mov [ebx+UINewMakeCharWnd.selected_job], ax
        "E8 ?? ?? ?? ?? " +           // 28 call UINewMakeCharWnd_update_selected_job
        "E9 ?? ?? ?? ?? " +           // 33 jmp loc_5193CD
        "33 C0 " +                    // 38 xor eax, eax
        "66 89 83 ?? ?? ?? 00 " +     // 40 mov [ebx+UINewMakeCharWnd.selected_job], ax
        "8B CB " +                    // 47 mov ecx, ebx
        "E8 ?? ?? ?? ?? " +           // 49 call UINewMakeCharWnd_update_selected_job
        "E9 ";                        // 54 jmp loc_5193CD
    var charTypeOffset = [2, 4];
    var doramJobOffset = 15;
    var selectedJobOffsets = [[24, 4], [43, 4]];
    var updateSelectedJobOffsets = [29, 50];

    var offset = pe.findCode(code);

    if (offset === -1)
    {
        code =
            "8B 86 ?? ?? ?? 00 " +        // 0 mov eax, [esi+UINewMakeCharWnd.char_type_selection]
            "83 E8 00 " +                 // 6 sub eax, 0
            "74 1D " +                    // 9 jz short loc_53E088
            "83 E8 01 " +                 // 11 sub eax, 1
            "75 21 " +                    // 14 jnz short loc_53E091
            "B8 7A 10 00 00 " +           // 16 mov eax, 107Ah
            "8B CE " +                    // 21 mov ecx, esi
            "66 89 86 ?? ?? ?? 00 " +     // 23 mov word ptr [esi+UINewMakeCharWnd.selected_job], ax
            "E8 ?? ?? ?? ?? " +           // 30 call UINewMakeCharWnd_update_selected_job
            "E9 ?? ?? ?? ?? " +           // 35 jmp loc_53E376
            "33 C0 " +                    // 40 xor eax, eax
            "66 89 86 ?? ?? ?? 00 " +     // 42 mov word ptr [esi+UINewMakeCharWnd.selected_job], ax
            "8B CE " +                    // 49 mov ecx, esi
            "E8 ?? ?? ?? ?? " +           // 51 call UINewMakeCharWnd_update_selected_job
            "E9 ";                        // 56 jmp loc_53E376

        charTypeOffset = [2, 4];
        doramJobOffset = 17;
        selectedJobOffsets = [[26, 4], [45, 4]];
        updateSelectedJobOffsets = [31, 52];

        offset = pe.findCode(code);
    }

    if (offset === -1)
        return "Failed in step 1 - pattern not found";

    doramJobOffset = offset + doramJobOffset
    logField("UINewMakeCharWnd::m_char_type_selection", offset, charTypeOffset);
    for (var i = 0; i < selectedJobOffsets.length; i++)
    {
        logField("UINewMakeCharWnd::m_selected_job", offset, selectedJobOffsets[i]);
    }
    for (var i = 0; i < updateSelectedJobOffsets.length; i++)
    {
        logRawFunc("UINewMakeCharWnd_update_selected_job", offset, updateSelectedJobOffsets[i]);
    }

    consoleLog("search doram icon job id");

    code =
        "33 DB " +                    // 0 xor ebx, ebx
        "83 BF ?? ?? ?? 00 01 " +     // 2 cmp [edi+UIDescriptRace.is_doram], 1
        "B8 7A 10 00 00 " +           // 9 mov eax, 107Ah
        "0F 44 D8 " +                 // 14 cmovz ebx, eax
        "33 C0 " +                    // 17 xor eax, eax
        "38 87 ?? ?? ?? 00 " +        // 19 cmp [edi+UIDescriptRace.is_not_doram], al
        "89 9D ?? ?? ?? FF " +        // 25 mov [ebp+var_E4], ebx
        "0F 95 C0 ";                  // 31 setnz al
    var isDoramOffset = [4, 4];
    var isNotDoramOffset = [21, 4];
    var doramIconJobOffset = 10;

    var offset = pe.findCode(code);

    if (offset === -1)
    {
        code =
            "33 C0 " +                    // 0 xor eax, eax
            "BE 7A 10 00 00 " +           // 2 mov esi, 107Ah
            "83 BF ?? ?? ?? 00 01 " +     // 7 cmp [edi+UIDescriptRace.is_doram], 1
            "0F 45 F0 " +                 // 14 cmovnz esi, eax
            "38 87 ?? ?? ?? 00 " +        // 17 cmp byte ptr [edi+UIDescriptRace.is_not_doram], al
            "89 B5 ?? ?? ?? FF " +        // 23 mov [ebp+var_E8], esi
            "0F 95 C0 ";                  // 29 setnz al

        isDoramOffset = [9, 4];
        isNotDoramOffset = [19, 4];
        doramIconJobOffset = 3;

        offset = pe.findCode(code);
    }

    if (offset === -1)
        return "Failed in step 2 - pattern not found";

    doramIconJobOffset = offset + doramIconJobOffset
    logField("UIDescriptRace::m_is_doram", offset, isDoramOffset);
    logField("UIDescriptRace::m_is_not_doram", offset, isNotDoramOffset);

    consoleLog("Search for hair images limit");

    // 유저인터페이스\make_character_ver2\img_hairStyle_doramGirl%02d.bmp
    offset = pe.stringVa(
        "\xC0\xAF\xC0\xFA\xC0\xCE\xC5\xCD\xC6\xE4\xC0\xCC\xBD\xBA\x5C\x6D" +
        "\x61\x6B\x65\x5F\x63\x68\x61\x72\x61\x63\x74\x65\x72\x5F\x76\x65" +
        "\x72\x32\x5C\x69\x6D\x67\x5F\x68\x61\x69\x72\x53\x74\x79\x6C\x65" +
        "\x5F\x64\x6F\x72\x61\x6D\x47\x69\x72\x6C\x25\x30\x32\x64\x2E\x62" +
        "\x6D\x70");
    if (offset === -1)
        return "doram girl string not found";
    var girlHex = offset.packToHex(4)

    code =
        "83 F8 01 " +                 // 0 cmp eax, 1
        "75 ?? " +                    // 3 jnz short loc_5189DA
        "83 BE ?? ?? ?? 00 05 " +     // 5 cmp [esi+UIHairStyleButton.selected_hair_id], 5
        "8B 8E ?? ?? ?? 00 " +        // 12 mov ecx, [esi+UIHairStyleButton.hair_style_button]
        "7F ?? " +                    // 18 jg short loc_518935
        "8B 01 " +                    // 20 mov eax, [ecx]
        "6A 01 " +                    // 22 push 1
        "FF 90 ?? ?? 00 00 " +        // 24 call dword ptr [eax+0C0h]
        "8B 86 ?? ?? ?? 00 " +        // 30 mov eax, [esi+UIHairStyleButton.selected_hair_id]
        "40 " +                       // 36 inc eax
        "83 BE ?? ?? ?? 00 00 " +     // 37 cmp [esi+UIHairStyleButton.selected_sex], 0
        "50 " +                       // 44 push eax
        "8D 85 ?? ?? ?? FF " +        // 45 lea eax, [ebp+uiBmpName]
        "75 07 " +                    // 51 jnz short loc_5189CC
        "68 " + girlHex +             // 53 push offset aPFMake_character_
        "EB ";                        // 58 jmp short loc_5189D1
    var selectedHairIdOffsets = [[7, 4], [32, 4]];
    var hairStyleButtonOffsets = [14, 4];
    var selectedSexOffset = [39, 4];
    var hairLimitOffset = 11;

    offset = pe.findCode(code);

    if (offset === -1)
    {
        code =
            "83 F8 01 " +                 // 0 cmp eax, 1
            "75 ?? " +                    // 3 jnz short loc_53D990
            "83 BE ?? ?? ?? 00 05 " +     // 5 cmp [esi+UIHairStyleButton.selected_hair_id], 5
            "8B 8E ?? ?? ?? 00 " +        // 12 mov ecx, [esi+UIHairStyleButton.hair_style_button]
            "7F ?? " +                    // 18 jg short loc_53D8F1
            "8B 01 " +                    // 20 mov eax, [ecx]
            "6A 01 " +                    // 22 push 1
            "FF 90 ?? ?? 00 00 " +        // 24 call dword ptr [eax+0C0h]
            "8B 86 ?? ?? ?? 00 " +        // 30 mov eax, [esi+UIHairStyleButton.selected_hair_id]
            "40 " +                       // 36 inc eax
            "83 BE ?? ?? ?? 00 00 " +     // 37 cmp [esi+UIHairStyleButton.selected_sex], 0
            "50 " +                       // 44 push eax
            "75 ?? " +                    // 45 jnz short loc_53D97C
            "68 " + girlHex +             // 47 push offset aPFMake_character_ver2Img_hairstyle
            "EB ";                        // 52 jmp short loc_53D981

        selectedHairIdOffsets = [[7, 4], [32, 4]];
        hairStyleButtonOffsets = [14, 4];
        selectedSexOffset = [39, 4];
        hairLimitOffset = 11;

        offset = pe.findCode(code);
    }

    if (offset === -1)
        return "doram hair images limit not found";

    for (var i = 0; i < selectedHairIdOffsets.length; i++)
    {
        logField("UIHairStyleButton::m_selected_hair_id", offset, selectedHairIdOffsets[i]);
    }
    logField("UIHairStyleButton::m_hair_style_button", offset, hairStyleButtonOffsets);
    logField("UIHairStyleButton::m_selected_sex", offset, selectedSexOffset);

    hairLimitOffset = offset + hairLimitOffset;

    consoleLog("Ask new job ids");

    var newJob = exe.getUserInput("$secondJob", XTYPE_DWORD, _("Number Input"), _("Enter second job for char creation (character):"), 0x107A);
    if (newJob === 0x107A)
        return "New job is same with old. Patch cancelled";

    var newIconJob = exe.getUserInput("$secondIconJob", XTYPE_DWORD, _("Number Input"), _("Enter second job for char creation (icon):"), newJob);
    if (newIconJob === 0x107A)
        return "New job is same with old. Patch cancelled";

    consoleLog("Ask new hair images limit");

    var newHairLimit = exe.getUserInput("$secondJobHairLimit", XTYPE_DWORD, _("Number Input"), _("Enter second job images hair limit:"), 6, 1, 30);
    if (newHairLimit === 6)
        return "New hair limit is same with old. Patch cancelled";

    consoleLog("Patching jobs");

    pe.replaceDWord(doramJobOffset, newJob);
    pe.replaceDWord(doramIconJobOffset, newIconJob);

    consoleLog("Patching hair limit");

    pe.replaceByte(hairLimitOffset, newHairLimit - 1);

    return true;
}

function ChangeSecondCharCreateJob_()
{
    return exe.getClientDate() > 20170614;
}
