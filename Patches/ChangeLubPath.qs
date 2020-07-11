//##############################################
//# Purpose: Change the System\*.lub reference #
//#          to custom file specified by user  #
//##############################################

function ChangeAchievementListPath()
{
    var iiName = ChangeLubPathGetIIName(1);
    return ChangeLubPath(iiName, exe.getUserInput("$AchievementListPath", XTYPE_STRING,
        _("String input - maximum 100 characters"),
        _("Please enter new path for AchievementList*.lub file"), iiName, 1, 100));
}

function ChangeMonsterSizeEffectPath()
{
    var iiName = ChangeLubPathGetIIName(2);
    return ChangeLubPath(iiName, exe.getUserInput("$MonsterSizeEffectPath", XTYPE_STRING,
        _("String input - maximum 100 characters"),
        _("Please enter new path for MonsterSizeEffect*.lub file"), iiName, 1, 100));
}

function ChangeTowninfoPath()
{
    var iiName = ChangeLubPathGetIIName(3);
    return ChangeLubPath(iiName, exe.getUserInput("$TowninfoPath", XTYPE_STRING,
        _("String input - maximum 100 characters"),
        _("Please enter new path for Towninfo*.lub file"), iiName, 1, 100));
}

function ChangePetEvolutionClnPath()
{
    var iiName = ChangeLubPathGetIIName(4);
    return ChangeLubPath(iiName, exe.getUserInput("$PetEvolutionClnPath", XTYPE_STRING,
        _("String input - maximum 100 characters"),
        _("Please enter new path for PetEvolutionCln*.lub file"), iiName, 1, 100));
}

function ChangeTipboxPath()
{
    var iiName = ChangeLubPathGetIIName(5);
    return ChangeLubPath(iiName, exe.getUserInput("$TipboxPath", XTYPE_STRING,
        _("String input - maximum 100 characters"),
        _("Please enter new path for Tipbox*.lub file"), iiName, 1, 100));
}

function ChangeCheckAttendancePath()
{
    var iiName = ChangeLubPathGetIIName(6);
    return ChangeLubPath(iiName, exe.getUserInput("$CheckAttendancePath", XTYPE_STRING,
        _("String input - maximum 100 characters"),
        _("Please enter new path for CheckAttendance*.lub file"), iiName, 1, 100));
}

function ChangeOngoingQuestInfoListPath()
{
    var iiName = ChangeLubPathGetIIName(7);
    return ChangeLubPath(iiName, exe.getUserInput("$OngoingQuestInfoListPath", XTYPE_STRING,
        _("String input - maximum 100 characters"),
        _("Please enter new path for OngoingQuestInfoList* file"), iiName, 1, 100));
}

function ChangeRecommendedQuestInfoListPath()
{
    var iiName = ChangeLubPathGetIIName(8);
    return ChangeLubPath(iiName, exe.getUserInput("$RecommendedQuestInfoListPath", XTYPE_STRING,
        _("String input - maximum 100 characters"),
        _("Please enter new path for RecommendedQuestInfoList* file"), iiName, 1, 100));
}

function ChangePrivateAirplanePath()
{
    var iiName = ChangeLubPathGetIIName(9);
    return ChangeLubPath(iiName, exe.getUserInput("$PrivateAirplanePath", XTYPE_STRING,
        _("String input - maximum 100 characters"),
        _("Please enter new path for PrivateAirplane*.lub file"), iiName, 1, 100));
}

function ChangeMapInfoPath()
{
    var iiName = ChangeLubPathGetIIName(10);
    return ChangeLubPath(iiName, exe.getUserInput("$MapInfoPath", XTYPE_STRING,
        _("String input - maximum 100 characters"),
        _("Please enter new path for MapInfo*.lub file"), iiName, 1, 100));
}

function ChangeLubPathGetIIName(type)
{
    var iiName = "";
    switch(type)
    {
        case 1:
        {
            iiName = "system\\Achievement_list.lub";
            if (exe.findString(iiName, RVA) !== -1) return iiName;
            return "";
        }
        case 2:
        {
            if (IsSakray())
            {
                iiName = "System/monster_size_effect_sak_new.lub";
                if (exe.findString(iiName, RVA) !== -1) return iiName;
                iiName = "System/monster_size_effect_sak.lub";
                if (exe.findString(iiName, RVA) !== -1) return iiName;
            }
            iiName = "System/monster_size_effect_new.lub";
            if (exe.findString(iiName, RVA) !== -1) return iiName;
            iiName = "System/monster_size_effect.lub";
            if (exe.findString(iiName, RVA) !== -1) return iiName;
            return "";
        }
        case 3:
        {
            iiName = "System/Towninfo.lub";
            if (exe.findString(iiName, RVA) !== -1) return iiName;
            return "";
        }
        case 4:
        {
            if (IsSakray())
            {
                iiName = "system\\PetEvolutionCln_sak.lub";
                if (exe.findString(iiName, RVA) !== -1) return iiName;
            }
            else
            {
                iiName = "system\\PetEvolutionCln_true.lub";
                if (exe.findString(iiName, RVA) !== -1) return iiName;
            }
            iiName = "system\\PetEvolutionCln.lub";
            if (exe.findString(iiName, RVA) !== -1) return iiName;
            return "";
        }
        case 5:
        {
            iiName = "System/tipbox.lub";
            if (exe.findString(iiName, RVA) !== -1) return iiName;
            return "";
        }
        case 6:
        {
            iiName = "System/CheckAttendance.lub";
            if (exe.findString(iiName, RVA) !== -1) return iiName;
            return "";
        }
        case 7:
        {
            if (IsSakray())
            {
                iiName = "system\\OngoingQuestInfoList_Sakray";
                if (exe.findString(iiName, RVA) !== -1) return iiName;
            }
            else
            {
                iiName = "system\\OngoingQuestInfoList_True";
                if (exe.findString(iiName, RVA) !== -1) return iiName;
            }
            iiName = "system\\OngoingQuestInfoList";
            if (exe.findString(iiName, RVA) !== -1) return iiName;
            return "";
        }
        case 8:
        {
            if (IsSakray())
            {
                iiName = "system\\RecommendedQuestInfoList_Sakray";
                if (exe.findString(iiName, RVA) !== -1) return iiName;
            }
            else
            {
                iiName = "system\\RecommendedQuestInfoList_True";
                if (exe.findString(iiName, RVA) !== -1) return iiName;
            }
            iiName = "system\\RecommendedQuestInfoList";
            if (exe.findString(iiName, RVA) !== -1) return iiName;
            return "";
        }
        case 9:
        {
            if (IsSakray())
            {
                iiName = "System\\PrivateAirplane_Sakray.lub";
                if (exe.findString(iiName, RVA) !== -1) return iiName;
            }
            else
            {
                iiName = "System\\PrivateAirplane_True.lub";
                if (exe.findString(iiName, RVA) !== -1) return iiName;
            }
            return "";
        }
        case 10:
        {
            if (IsSakray())
            {
                iiName = "system\\mapInfo_sak.lub";
                if (exe.findString(iiName, RVA) !== -1) return iiName;
            }
            else
            {
                iiName = "system\\mapInfo_true.lub";
                if (exe.findString(iiName, RVA) !== -1) return iiName;
            }
            return "";
        }
        default:
        {
            return "";
        }
    }
    return "";
}

function ChangeLubPath(old_path, new_path)
{
    var offset = exe.findString(old_path, RVA);
    if (offset === -1)
        return "Failed in Step 1a - file name not found";

    offset = exe.findCode("68" + offset.packToHex(4),  PTYPE_HEX, false);
    if (offset === -1)
        return "Failed in Step 1b - reference not found";

    if (old_path === new_path)
        return "Patch Cancelled - New value is same as old";

    var free = exe.findZeros(new_path.length);
    if (free === -1)
        return "Failed in Step 2 - Not enough free space";

    exe.insert(free, new_path.length, new_path, PTYPE_STRING);
    exe.replace(offset+1, exe.Raw2Rva(free).packToHex(4), PTYPE_HEX);

    return true;
}

//=================================//
// Disable for Unsupported clients //
//=================================//
function ChangeAchievementListPath_()
{
    return (ChangeLubPathGetIIName(1) !== "");
}

function ChangeMonsterSizeEffectPath_()
{
    return (ChangeLubPathGetIIName(2) !== "");
}

function ChangeTowninfoPath_()
{
    return (ChangeLubPathGetIIName(3) !== "");
}

function ChangePetEvolutionClnPath_()
{
    return (ChangeLubPathGetIIName(4) !== "");
}

function ChangeTipboxPath_()
{
    return (ChangeLubPathGetIIName(5) !== "");
}

function ChangeCheckAttendancePath_()
{
    return (ChangeLubPathGetIIName(6) !== "");
}

function ChangeOngoingQuestInfoListPath_()
{
    return (ChangeLubPathGetIIName(7) !== "");
}

function ChangeRecommendedQuestInfoListPath_()
{
    return (ChangeLubPathGetIIName(8) !== "");
}

function ChangePrivateAirplanePath_()
{
    return (ChangeLubPathGetIIName(9) !== "");
}

function ChangeMapInfoPath_()
{
    return (ChangeLubPathGetIIName(10) !== "");
}
