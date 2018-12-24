//##############################################
//# Purpose: Change the System\*.lub reference #
//#          to custom file specified by user  #
//##############################################

function ChangeAchievementListPath() {
	var iiName = ChangeLubPathGetIIName(1);
	return ChangeLubPath(iiName, exe.getUserInput("$AchievementListPath", XTYPE_STRING, "��J��r - �̦h�i��J 100 �Ӧr��", "�п�J�ۭq�����N AchievementList*.lub �ɮ� (������ RO �۹諸�ؿ�)", iiName, 1, 100));
}

function ChangeMonsterSizeEffectPath() {
	var iiName = ChangeLubPathGetIIName(2);
	return ChangeLubPath(iiName, exe.getUserInput("$MonsterSizeEffectPath", XTYPE_STRING, "��J��r - �̦h�i��J 100 �Ӧr��", "�п�J�ۭq���]���]�w MonsterSizeEffect*.lub �ɮ� (������ RO �۹諸�ؿ�)", iiName, 1, 100));
}

function ChangeTowninfoPath() {
	var iiName = ChangeLubPathGetIIName(3);
	return ChangeLubPath(iiName, exe.getUserInput("$TowninfoPath", XTYPE_STRING, "��J��r - �̦h�i��J 100 �Ӧr��", "�п�J�ۭq���ϼ� Towninfo*.lub �ɮ� (������ RO �۹諸�ؿ�)", iiName, 1, 100));
}

function ChangePetEvolutionClnPath() {
	var iiName = ChangeLubPathGetIIName(4);
	return ChangeLubPath(iiName, exe.getUserInput("$PetEvolutionClnPath", XTYPE_STRING, "��J��r - �̦h�i��J 100 �Ӧr��", "�п�J�ۭq���ͩR�� PetEvolutionCln*.lub �ɮ� (������ RO �۹諸�ؿ�)", iiName, 1, 100));
}

function ChangeTipboxPath() {
	var iiName = ChangeLubPathGetIIName(5);
	return ChangeLubPath(iiName, exe.getUserInput("$TipboxPath", XTYPE_STRING, "��J��r - �̦h�i��J 100 �Ӧr��", "�п�J�ۭq���о� Tipbox*.lub �ɮ� (������ RO �۹諸�ؿ�)", iiName, 1, 100));
}

function ChangeCheckAttendancePath() {
	var iiName = ChangeLubPathGetIIName(6);
	return ChangeLubPath(iiName, exe.getUserInput("$CheckAttendancePath", XTYPE_STRING, "��J��r - �̦h�i��J 100 �Ӧr��", "�п�J�ۭq��ñ�� CheckAttendance*.lub �ɮ� (������ RO �۹諸�ؿ�)", iiName, 1, 100));
}

function ChangeOngoingQuestInfoListPath() {
	var iiName = ChangeLubPathGetIIName(7);
	return ChangeLubPath(iiName, exe.getUserInput("$OngoingQuestInfoListPath", XTYPE_STRING, "��J��r - �̦h�i��J 100 �Ӧr��", "�п�J�ۭq������ OngoingQuestInfoList* �ɮ� (������ RO �۹諸�ؿ�)", iiName, 1, 100));
}

function ChangeRecommendedQuestInfoListPath() {
	var iiName = ChangeLubPathGetIIName(8);
	return ChangeLubPath(iiName, exe.getUserInput("$RecommendedQuestInfoListPath", XTYPE_STRING, "��J��r - �̦h�i��J 100 �Ӧr��", "�п�J�ۭq������ RecommendedQuestInfoList* �ɮ� (������ RO �۹諸�ؿ�)", iiName, 1, 100));
}

function ChangePrivateAirplanePath() {
	var iiName = ChangeLubPathGetIIName(9);
	return ChangeLubPath(iiName, exe.getUserInput("$PrivateAirplanePath", XTYPE_STRING, "��J��r - �̦h�i��J 100 �Ӧr��", "�п�J�ۭq�����Ÿ� PrivateAirplane*.lub �ɮ� (������ RO �۹諸�ؿ�)", iiName, 1, 100));
}

function ChangeLubPathGetIIName(type) {
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
			iiName = "System\\PrivateAirplane_True.lub";
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
		return "�ɤB���� - �s���]�w���ª��]�w�ۦP";

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
function ChangeAchievementListPath_() {
    return (ChangeLubPathGetIIName(1) !== "");
}

function ChangeMonsterSizeEffectPath_() {
    return (ChangeLubPathGetIIName(2) !== "");
}

function ChangeTowninfoPath_() {
    return (ChangeLubPathGetIIName(3) !== "");
}

function ChangePetEvolutionClnPath_() {
    return (ChangeLubPathGetIIName(4) !== "");
}

function ChangeTipboxPath_() {
    return (ChangeLubPathGetIIName(5) !== "");
}

function ChangeCheckAttendancePath_() {
    return (ChangeLubPathGetIIName(6) !== "");
}

function ChangeOngoingQuestInfoListPath_() {
    return (ChangeLubPathGetIIName(7) !== "");
}

function ChangeRecommendedQuestInfoListPath_() {
    return (ChangeLubPathGetIIName(8) !== "");
}

function ChangePrivateAirplanePath_() {
    return (ChangeLubPathGetIIName(9) !== "");
}
