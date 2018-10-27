//##############################################
//# Purpose: Change the System\*.lub reference #
//#          to custom file specified by user  #
//##############################################

function ChangeAchievementList() {
	var iiName = getiiName(1);
	return ChangeLubPath(iiName, exe.getUserInput("$AchievementListPath", XTYPE_STRING, "String input - maximum 100 characters", "Please enter new path for AchievementList*.lub file", iiName, 1, 100));
}

function ChangeMonsterSizeEffect() {
	var iiName = getiiName(2);
	return ChangeLubPath(iiName, exe.getUserInput("$MonsterSizeEffectPath", XTYPE_STRING, "String input - maximum 100 characters", "Please enter new path for MonsterSizeEffect*.lub file", iiName, 1, 100));
}

function ChangeTowninfo() {
	var iiName = getiiName(3);
	return ChangeLubPath(iiName, exe.getUserInput("$TowninfoPath", XTYPE_STRING, "String input - maximum 100 characters", "Please enter new path for Towninfo*.lub file", iiName, 1, 100));
}

function ChangePetEvolutionCln() {
	var iiName = getiiName(4);
	return ChangeLubPath(iiName, exe.getUserInput("$PetEvolutionClnPath", XTYPE_STRING, "String input - maximum 100 characters", "Please enter new path for PetEvolutionCln*.lub file", iiName, 1, 100));
}

function ChangeTipbox() {
	var iiName = getiiName(5);
	return ChangeLubPath(iiName, exe.getUserInput("$TipboxPath", XTYPE_STRING, "String input - maximum 100 characters", "Please enter new path for Tipbox*.lub file", iiName, 1, 100));
}

function ChangeCheckAttendance() {
	var iiName = getiiName(6);
	return ChangeLubPath(iiName, exe.getUserInput("$CheckAttendancePath", XTYPE_STRING, "String input - maximum 100 characters", "Please enter new path for CheckAttendance*.lub file", iiName, 1, 100));
}

function ChangeOngoingQuestInfoList() {
	var iiName = getiiName(7);
	return ChangeLubPath(iiName, exe.getUserInput("$OngoingQuestInfoListPath", XTYPE_STRING, "String input - maximum 100 characters", "Please enter new path for OngoingQuestInfoList* file", iiName, 1, 100));
}

function ChangeRecommendedQuestInfoList() {
	var iiName = getiiName(8);
	return ChangeLubPath(iiName, exe.getUserInput("$RecommendedQuestInfoListPath", XTYPE_STRING, "String input - maximum 100 characters", "Please enter new path for RecommendedQuestInfoList* file", iiName, 1, 100));
}

function ChangePrivateAirplane() {
	var iiName = getiiName(9);
	return ChangeLubPath(iiName, exe.getUserInput("$PrivateAirplanePath", XTYPE_STRING, "String input - maximum 100 characters", "Please enter new path for PrivateAirplane*.lub file", iiName, 1, 100));
}

function getiiName(type) {
	var iiName = "";
	switch(type){
		case 1: {
			iiName = "system\\Achievement_list.lub";
			if (exe.findString(iiName, RVA) !== -1) return iiName;
			return "";
		}
		case 2: {
			iiName = "System/monster_size_effect_sak_new.lub";
			if (exe.findString(iiName, RVA) !== -1) return iiName;
			iiName = "System/monster_size_effect_sak.lub";
			if (exe.findString(iiName, RVA) !== -1) return iiName;
			iiName = "System/monster_size_effect_new.lub";
			if (exe.findString(iiName, RVA) !== -1) return iiName;
			iiName = "System/monster_size_effect.lub";
			if (exe.findString(iiName, RVA) !== -1) return iiName;
			return "";
		}
		case 3: {
			iiName = "System/Towninfo.lub";
			if (exe.findString(iiName, RVA) !== -1) return iiName;
			return "";
		}
		case 4: {
			iiName = "system\\PetEvolutionCln_sak.lub";
			if (exe.findString(iiName, RVA) !== -1) return iiName;
			iiName = "system\\PetEvolutionCln_true.lub";
			if (exe.findString(iiName, RVA) !== -1) return iiName;
			iiName = "system\\PetEvolutionCln.lub";
			if (exe.findString(iiName, RVA) !== -1) return iiName;
			return "";
		}
		case 5: {
			iiName = "System/tipbox.lub";
			if (exe.findString(iiName, RVA) !== -1) return iiName;
			return "";
		}
		case 6: {
			iiName = "System/CheckAttendance.lub";
			if (exe.findString(iiName, RVA) !== -1) return iiName;
			return "";
		}
		case 7: {
			iiName = "system\\OngoingQuestInfoList_Sakray";
			if (exe.findString(iiName, RVA) !== -1) return iiName;
			iiName = "system\\OngoingQuestInfoList_True";
			if (exe.findString(iiName, RVA) !== -1) return iiName;
			iiName = "system\\OngoingQuestInfoList";
			if (exe.findString(iiName, RVA) !== -1) return iiName;
			return "";
		}
		case 8: {
			iiName = "system\\RecommendedQuestInfoList_Sakray";
			if (exe.findString(iiName, RVA) !== -1) return iiName;
			iiName = "system\\RecommendedQuestInfoList_True";
			if (exe.findString(iiName, RVA) !== -1) return iiName;
			iiName = "system\\RecommendedQuestInfoList";
			if (exe.findString(iiName, RVA) !== -1) return iiName;
			return "";
		}
		case 9: {
			iiName = "System\\PrivateAirplane_Sakray.lub";
			if (exe.findString(iiName, RVA) !== -1) return iiName;
			iiName = "System\\PrivateAirplane_true.lub";
			if (exe.findString(iiName, RVA) !== -1) return iiName;
			return "";
		}
		default: {
			return "";
		}
	}
	return "";
}

function ChangeLubPath(old_path, new_path) {
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
function ChangeAchievementList_() {
    return (getiiName(1) !== "");
}

function ChangeMonsterSizeEffect_() {
    return (getiiName(2) !== "");
}

function ChangeTowninfo_() {
    return (getiiName(3) !== "");
}

function ChangePetEvolutionCln_() {
    return (getiiName(4) !== "");
}

function ChangeTipbox_() {
    return (getiiName(5) !== "");
}

function ChangeCheckAttendance_() {
    return (getiiName(6) !== "");
}

function ChangeOngoingQuestInfoList_() {
    return (getiiName(7) !== "");
}

function ChangeRecommendedQuestInfoList_() {
    return (getiiName(8) !== "");
}

function ChangePrivateAirplane_() {
    return (getiiName(9) !== "");
}
