/*
[] spawn {
	_a = [];
	for "_i" from 0 to 50 do {
		_worldsize = getnumber (configfile >> "CfgWorlds" >> worldName >> "mapSize"); 
		_zone = [(random [200, _worldsize/2, _worldsize - 200]), (random [200, _worldsize/2, _worldsize - 200]), 0];
		_markerstr = createMarker [str(_i),_zone];
		_markerstr setMarkerShape "ICON";
		_markerstr setMarkerType "hd_dot";
		_a pushBack str(_i);
	};
	sleep 10;
	{deleteMarker _x} foreach _a;
};




*/
	//DEFINES

	fow_ia_factions_blu = ["Wehrmacht","Fallschirmjäger","IJA","SNLF"];//0
	fow_ia_factions_red = [];//1
	fow_ia_factions_green = ["USA","USMC","UK","UK Para"];//2
	
	fow_ia_squads_blu = [
		//wehr
		[(configFile >> "CfgGroups" >> "West" >> "fow_wehrmacht" >> "Infantry" >> "fow_ger_RifleSquad"),(configFile >> "CfgGroups" >> "West" >> "fow_wehrmacht" >> "Infantry" >> "fow_ger_RifleTeam"),(configFile >> "CfgGroups" >> "West" >> "fow_wehrmacht" >> "Infantry" >> "fow_ger_MGTeam")],
		//Fallschirmjäger
		[(configFile >> "CfgGroups" >> "West" >> "fow_wehrmacht" >> "Infantry" >> "fow_ger_luft_RifleSquad"),(configFile >> "CfgGroups" >> "West" >> "fow_wehrmacht" >> "Infantry" >> "fow_ger_luft_RifleTeam"),(configFile >> "CfgGroups" >> "West" >> "fow_wehrmacht" >> "Infantry" >> "fow_ger_luft_MGTeam")],
		//IJA
		[(configFile >> "CfgGroups" >> "West" >> "fow_ija" >> "Infantry" >> "fow_ija_RifleSquad"),(configFile >> "CfgGroups" >> "West" >> "fow_ija" >> "Infantry" >> "fow_ija_RifleTeam"),(configFile >> "CfgGroups" >> "West" >> "fow_ija" >> "Infantry" >> "fow_ija_MGTeam")],
		//SNLF
		[(configFile >> "CfgGroups" >> "West" >> "fow_ija" >> "Infantry" >> "fow_ija_snlf_RifleSquad"),(configFile >> "CfgGroups" >> "West" >> "fow_ija" >> "Infantry" >> "fow_ija_snlf_RifleTeam"),(configFile >> "CfgGroups" >> "West" >> "fow_ija" >> "Infantry" >> "fow_ija_snlf_MGTeam")]
	];
	fow_ia_squads_green = [
		//"USA"
		[(configFile >> "CfgGroups" >> "Indep" >> "fow_usa" >> "Infantry" >> "fow_us_RifleSquad"),(configFile >> "CfgGroups" >> "Indep" >> "fow_usa" >> "Infantry" >> "fow_us_RifleTeam"),(configFile >> "CfgGroups" >> "Indep" >> "fow_usa" >> "Infantry" >> "fow_us_MGTeam"),(configFile >> "CfgGroups" >> "Indep" >> "fow_usa" >> "Infantry" >> "fow_us_MGTeam_M1919A6")],
		//"USMC"
		[(configFile >> "CfgGroups" >> "Indep" >> "fow_usmc" >> "Infantry" >> "fow_usmc_RifleSquad"),(configFile >> "CfgGroups" >> "Indep" >> "fow_usmc" >> "Infantry" >> "fow_usmc_RifleTeam"),(configFile >> "CfgGroups" >> "Indep" >> "fow_usmc" >> "Infantry" >> "fow_usmc_MGTeam"),(configFile >> "CfgGroups" >> "Indep" >> "fow_usmc" >> "Infantry" >> "fow_usmc_MGTeam_M1919A6")],
		//"UK"
		[(configFile >> "CfgGroups" >> "Indep" >> "fow_uk" >> "Infantry" >> "fow_uk_RifleSquad"),(configFile >> "CfgGroups" >> "Indep" >> "fow_uk" >> "Infantry" >> "fow_uk_RifleTeam"),(configFile >> "CfgGroups" >> "Indep" >> "fow_uk" >> "Infantry" >> "fow_uk_MGTeam")],
		//"UK Para"
		[(configFile >> "CfgGroups" >> "Indep" >> "fow_uk" >> "Infantry" >> "fow_uk_para_RifleSquad"),(configFile >> "CfgGroups" >> "Indep" >> "fow_uk" >> "Infantry" >> "fow_uk_para_RifleTeam"),(configFile >> "CfgGroups" >> "Indep" >> "fow_uk" >> "Infantry" >> "fow_uk_para_MGTeam")]
	];
	
	fow_ia_debug = true;
	fow_ia_spawnDistanceFromCenter = 200;
	
	fow_ia_numberSquads = 4;
	fow_ia_numberSquadsRandom = 3;
	fow_ia_numberOfWaves = 2;//FIRST DOESN'T COUNT
	
	fow_ia_numberOfWaves_team1 = fow_ia_numberOfWaves;
	fow_ia_numberOfWaves_team2 = fow_ia_numberOfWaves;
	
	//AAS
	fow_ia_aas_flags_n = 3;
	fow_ia_aas_flags_area = 80;
	fow_ia_aas_flags_minDistance = 250;
	fow_ia_aas_flags_maxDistance = 400;
	fow_ia_aas_wavesAttacker = 2;
	fow_ia_aas_wavesDefender = 1;
	fow_ia_aas_numberSquadsA = 4;
	fow_ia_aas_numberSquadsD = 3;
	fow_ia_aas_numberSquadsRandomA = 3;
	fow_ia_aas_numberSquadsRandomD = 2;
	
	
	//END DEFINES
	fow_ia_fnc_createTrigger = {
		private ["_pos","_area","_act","_stat","_trg"];

		_pos    = _this select 0;
		_area   = _this select 1;
		_act    = _this select 2;
		_stat   = _this select 3;

		_trg = createTrigger ["EmptyDetector", _pos];
		_trg setTriggerArea _area;
		_trg setTriggerActivation _act;
		_trg setTriggerStatements _stat;

		_trg	
	};
	fow_ia_fnc_getRandomStartPos = {
		_worldsize = getnumber (configfile >> "CfgWorlds" >> worldName >> "mapSize");
		_r = [(random [200, _worldsize/2, _worldsize - 200]), (random [200, _worldsize/2, _worldsize - 200]), 0];
		_r
	};
	
	fow_ia_fnc_randomizePos = {
		private ["_pos","_random_area","_return_pos","_pos_random"];

		_pos = _this select 0;
		_random_area = _this select 1;

		_pos_random = [((_pos select 0) + ((random _random_area) - (random _random_area))),((_pos select 1) + ((random _random_area) - (random _random_area))),0];

		_return_pos = [_pos_random, 0, 50, 5, 0, 0, 0, [], []] call BIS_fnc_findSafePos;

		_return_pos	
	};
	
	fow_ia_fnc_selectPositions = {

		_pos = [] call fow_ia_fnc_getRandomStartPos;
		fow_ia_center = [_pos, 0, 1000, 5, 0, 0, 0, [], []] call BIS_fnc_findSafePos;
		
		_pos_team_1 = random 360;
		_pos_team_2 = _pos_team_1 + 180;if (_pos_team_2 > 360) then {_pos_team_2 = _pos_team_2 - 360};
		
		_pos_team_1_spawn = [fow_ia_center, fow_ia_spawnDistanceFromCenter, _pos_team_1] call BIS_fnc_relPos;
		fow_ia_team1Spawn = [_pos_team_1_spawn, 0, 80, 0, 0, 0, 0, [], []] call BIS_fnc_findSafePos;
		_pos_team_2_spawn = [fow_ia_center, fow_ia_spawnDistanceFromCenter, _pos_team_2] call BIS_fnc_relPos;
		fow_ia_team2Spawn = [_pos_team_2_spawn, 0, 80, 0, 0, 0, 0, [], []] call BIS_fnc_findSafePos;
		
		if (fow_ia_debug) then {
			_marker = createMarker ["fow_ia_center",fow_ia_center];_marker setMarkerShape "ICON";_marker setMarkerType "hd_dot";_marker setMarkerText "Center";
			_marker = createMarker ["fow_ia_team1Spawn",fow_ia_team1Spawn];_marker setMarkerShape "ICON";_marker setMarkerType "hd_dot";_marker setMarkerText "Team1Spawn";
			_marker = createMarker ["fow_ia_team2Spawn",fow_ia_team2Spawn];_marker setMarkerShape "ICON";_marker setMarkerType "hd_dot";_marker setMarkerText "Team2Spawn";
		};	
	};

	fow_ia_fnc_aas_selectPositions = {
		_pos = [] call fow_ia_fnc_getRandomStartPos;
		
		fow_ia_center = [_pos, 0, 1000, 5, 0, 0, 0, [], []] call BIS_fnc_findSafePos;
		
		fow_ia_aas_flags = _this select 0;
		if (count fow_ia_aas_flags > 0) exitWith {true};

		_first = fow_ia_center;
		_second = [];
		for "_i" from 1 to (fow_ia_aas_flags_n) do {
			if (_i isEqualTo 1) then {
				_pos = [fow_ia_center, fow_ia_aas_flags_minDistance, fow_ia_aas_flags_maxDistance, 5, 0, 0, 0, [], []] call BIS_fnc_findSafePos;
				fow_ia_aas_flags pushBack _pos;
				_second = _pos;
			} else {
				_dir = (_first getDir _second) + (random 80 - random 80);
				_poswip = [_second, (fow_ia_aas_flags_minDistance + fow_ia_aas_flags_maxDistance)/2, _dir] call BIS_fnc_relPos;
				_pos = [_poswip, 0, 150, 5, 0, 0, 0, [], []] call BIS_fnc_findSafePos;
				fow_ia_aas_flags pushBack _pos;
				_first = _second;
				_second = _pos;
			};
		};
		
		if (fow_ia_debug) then {
			_marker = createMarker [str(fow_ia_center),fow_ia_center];_marker setMarkerShape "ICON";_marker setMarkerType "hd_dot";_marker setMarkerText "Start";
			for "_i" from 0 to (count fow_ia_aas_flags - 1) do {_marker = createMarker [str(_i),(fow_ia_aas_flags select _i)];_marker setMarkerShape "ICON";_marker setMarkerType "hd_dot";_marker setMarkerText str(_i);};
		};			
	};

	fow_ia_fnc_aas_startGame = {
		
		[[]] call fow_ia_fnc_aas_selectPositions;
		
		fow_ia_ass_flagId = 0;
		fow_ia_aas_spawnAttackersPoint = fow_ia_center;
		
		[] call fow_ia_fnc_aas_pickSides;
		
		[] call fow_ia_fnc_aas_flagAssign;
		
		//[] call fow_ia_fnc_selectPositions;
		
		//[] call fow_ia_fnc_pickSides;
		
		west setFriend [resistance, 0];
		resistance setFriend [west, 0];
		east setFriend [resistance, 0];
		resistance setFriend [east, 0];
		
		if (fow_ia_debug) then {_t = format ["Team Defender: %1 - Team Attacker: %2 - Team Player: %3",fow_ia_aas_defender,fow_ia_aas_attacker,fow_ia_playerTeam];systemChat _t;diag_log _t;};
		
		[] spawn {sleep 1;player action ["TeamSwitch", player];_oldVehicle = vehicle player; waitUntil {vehicle player != _oldVehicle};removeSwitchableUnit _oldVehicle;};
		
		//[] spawn fow_ia_fnc_missionControl;
	};
	
	fow_ia_fnc_aas_pickSides = {
		_sides = [0,2];//,1
		_attacker = selectRandom _sides;
		_sides = _sides - [_attacker];
		_defender = selectRandom _sides;
		
		switch (_attacker) do {
			case 0 : {fow_ia_aas_attacker = selectRandom fow_ia_factions_blu;fow_ia_aas_attacker_side = west;fow_ia_aas_attacker_id = fow_ia_factions_blu find fow_ia_aas_attacker;fow_ia_aas_attacker_squads = fow_ia_squads_blu;};
			case 1 : {};
			case 2 : {fow_ia_aas_attacker = selectRandom fow_ia_factions_green;fow_ia_aas_attacker_side = resistance;fow_ia_aas_attacker_id = fow_ia_factions_green find fow_ia_aas_attacker;fow_ia_aas_attacker_squads = fow_ia_squads_green;};
		};		
		switch (_defender) do {
			case 0 : {fow_ia_aas_defender = selectRandom fow_ia_factions_blu;fow_ia_aas_defender_side = west;fow_ia_aas_defender_id = fow_ia_factions_blu find fow_ia_aas_defender;fow_ia_aas_defender_squads = fow_ia_squads_blu;};
			case 1 : {};
			case 2 : {fow_ia_aas_defender = selectRandom fow_ia_factions_green;fow_ia_aas_defender_side = resistance;fow_ia_aas_defender_id = fow_ia_factions_green find fow_ia_aas_defender;fow_ia_aas_defender_squads = fow_ia_squads_green;};
		};
		
		
		fow_ia_playerTeam = selectRandom [fow_ia_aas_attacker,fow_ia_aas_defender];
		
		true
	};
	
	fow_ia_fnc_aas_flagAssign = {
		
		_flagPos = fow_ia_aas_flags select fow_ia_ass_flagId;
		
		[_flagPos] call fow_ia_fnc_aas_spawnDefenders;
		[] call fow_ia_fnc_aas_spawnAttackers;//Tweak it
		
		[_flagPos, [fow_ia_aas_flags_area,fow_ia_aas_flags_area,0,false], [str (fow_ia_aas_defender_side), "PRESENT", false], ["count thisList < 2", "[] call fow_ia_fnc_aas_flagCaptured", ""]] call fow_ia_fnc_createTrigger;		
	};	
	fow_ia_fnc_aas_flagCaptured = {
		
		hint "FLAG CAPTURED!";
		fow_ia_aas_spawnAttackersPoint = fow_ia_aas_flags select fow_ia_ass_flagId;
		
		//Check if more flags
		
		fow_ia_ass_flagId = fow_ia_ass_flagId + 1;
		
		{
			if (side _x isEqualTo fow_ia_aas_attacker_side) then {
				_wp =_x addWaypoint [(fow_ia_aas_flags select fow_ia_ass_flagId), 30];
				_wp setWaypointType "SAD";
				_x setBehaviour "AWARE";
				_x setCombatMode "RED";
				_x setSpeedMode "FULL";			
			};
		} foreach allGroups;
		
		[] call fow_ia_fnc_aas_flagAssign;

	};
	
	fow_ia_fnc_aas_spawnDefenders = {
		_flagPos = _this select 0;

		_n = round (fow_ia_aas_numberSquadsD + random fow_ia_aas_numberSquadsRandomD);
	
		_squads = fow_ia_aas_defender_squads select fow_ia_aas_defender_id;
		
		for "_i" from 1 to _n do {
			_type = selectRandom _squads;
			_pos = [_flagPos, 30] call fow_ia_fnc_randomizePos;
			_group = [_pos, fow_ia_aas_defender_side, _type] call BIS_fnc_spawnGroup;
			_wp =_group addWaypoint [_flagPos, 30];
			_wp setWaypointType "SENTRY";
			_group setBehaviour "AWARE";
			_group setCombatMode "RED";
			_group setSpeedMode "FULL";
			
			if (fow_ia_playerTeam isEqualTo fow_ia_aas_defender) then {
				{addSwitchableUnit _x} foreach units _group;
			};
			
			//if (fow_ia_debug) then {_marker = createMarker [str(_group),_pos];_marker setMarkerShape "ICON";_marker setMarkerType "hd_dot";};		
		};
		if (fow_ia_debug) then {systemChat format ["Team Defender: %1 squads",_n];diag_log format ["Team Defender: %1 squads",_n];};
	};
	
	fow_ia_fnc_aas_spawnAttackers = {

		_n = round (fow_ia_aas_numberSquadsA + random fow_ia_aas_numberSquadsRandomA);
	
		_squads = fow_ia_aas_attacker_squads select fow_ia_aas_attacker_id;
		
		for "_i" from 1 to _n do {
			_type = selectRandom _squads;
			_pos = [fow_ia_aas_spawnAttackersPoint, 30] call fow_ia_fnc_randomizePos;
			_group = [_pos, fow_ia_aas_attacker_side, _type] call BIS_fnc_spawnGroup;
			_wp =_group addWaypoint [(fow_ia_aas_flags select fow_ia_ass_flagId), 30];
			_wp setWaypointType "SAD";
			_group setBehaviour "AWARE";
			_group setCombatMode "RED";
			_group setSpeedMode "FULL";
			
			if (fow_ia_playerTeam isEqualTo fow_ia_aas_attacker) then {
				{addSwitchableUnit _x} foreach units _group;
			};
			
			//if (fow_ia_debug) then {_marker = createMarker [str(_group),_pos];_marker setMarkerShape "ICON";_marker setMarkerType "hd_dot";};		
		};
		if (fow_ia_debug) then {systemChat format ["Team Attacker: %1 squads",_n];diag_log format ["Team Attacker: %1 squads",_n];};
	};
	
	fow_ia_fnc_aas_missionControl = {
		sleep 10;//wait for the game start
		
		while {true} do {//Not true -> game live
			_team1 = west countSide allUnits;
			_team2 = resistance countSide allUnits;
			
			if (_team1 < 10 && {fow_ia_numberOfWaves_team1 > 0}) then {
				fow_ia_numberOfWaves_team1 = fow_ia_numberOfWaves_team1 - 1;
				[fow_ia_team1] call fow_ia_fnc_spawnWave;
			};
			if (_team2 < 10 && {fow_ia_numberOfWaves_team2 > 0}) then {
				fow_ia_numberOfWaves_team2 = fow_ia_numberOfWaves_team2 - 1;
				[fow_ia_team2] call fow_ia_fnc_spawnWave;
			};
			if (_team1 isEqualTo 0 && fow_ia_numberOfWaves_team1 isEqualTo 0) exitWith {hintC format ["Game finished! %1 wins!",fow_ia_team2];};
			if (_team2 isEqualTo 0 && fow_ia_numberOfWaves_team2 isEqualTo 0) exitWith {hintC format ["Game finished! %1 wins!",fow_ia_team1];};
		};
	};
	
	fow_ia_fnc_pickSides = {
		fow_ia_team1 = selectRandom fow_ia_factions_blu;
		fow_ia_team2 = selectRandom fow_ia_factions_green;
		
		fow_ia_team1_id = fow_ia_factions_blu find fow_ia_team1;
		fow_ia_team2_id = fow_ia_factions_green find fow_ia_team2;
		
		fow_ia_playerTeam = selectRandom [fow_ia_team1,fow_ia_team2];
		
		true
	};
	
	fow_ia_fnc_spawnUnits = {
	
		_n_1 = round (fow_ia_numberSquads + random fow_ia_numberSquadsRandom);
		_n_2 = round (fow_ia_numberSquads + random fow_ia_numberSquadsRandom);
	
		_squads_1 = fow_ia_squads_blu select fow_ia_team1_id;
		
		for "_i" from 1 to _n_1 do {
			_type = selectRandom _squads_1;
			_pos = [fow_ia_team1Spawn, 60] call fow_ia_fnc_randomizePos;
			_group = [_pos, west, _type] call BIS_fnc_spawnGroup;
			_wp =_group addWaypoint [fow_ia_center, 70];
			_wp setWaypointType "SAD";
			_group setBehaviour "AWARE";
			_group setCombatMode "RED";
			_group setSpeedMode "FULL";
			
			if (fow_ia_playerTeam isEqualTo fow_ia_team1) then {
				{addSwitchableUnit _x} foreach units _group;
			};
			
			if (fow_ia_debug) then {_marker = createMarker [str(_group),_pos];_marker setMarkerShape "ICON";_marker setMarkerType "hd_dot";};
		};
		
		_squads_2 = fow_ia_squads_green select fow_ia_team2_id;
		
		for "_i" from 1 to _n_2 do {
			_type = selectRandom _squads_2;
			_pos = [fow_ia_team2Spawn, 60] call fow_ia_fnc_randomizePos;
			_group = [_pos, resistance, _type] call BIS_fnc_spawnGroup;
			_wp =_group addWaypoint [fow_ia_center, 70];
			_wp setWaypointType "SAD";
			_group setBehaviour "AWARE";
			_group setCombatMode "RED";
			_group setSpeedMode "FULL";
			
			if (fow_ia_playerTeam isEqualTo fow_ia_team2) then {
				{addSwitchableUnit _x} foreach units _group;
			};
			
			if (fow_ia_debug) then {_marker = createMarker [str(_group),_pos];_marker setMarkerShape "ICON";_marker setMarkerType "hd_dot";};
		};
		
		if (fow_ia_debug) then {systemChat format ["Team 1: %1 squads - Team 2: %2 squads",_n_1,_n_2];diag_log format ["Team 1: %1 squads - Team 2: %2 squads",_n_1,_n_2];};
	};
	fow_ia_fnc_spawnWave = {
	
		_team = _this select 0;
		_id = objNull;
		_squads_array = objNull;
		_spawn_pos = [0,0,0];
		_side = west;
		
		switch (_team) do {
			case fow_ia_team1 : {_id = fow_ia_team1_id;_squads_array = fow_ia_squads_blu;_spawn_pos = fow_ia_team1Spawn;_side = west;};
			case fow_ia_team2 : {_id = fow_ia_team2_id;_squads_array = fow_ia_squads_green;_spawn_pos = fow_ia_team2Spawn;_side = resistance;};
		};
		
		_n = round (fow_ia_numberSquads + random fow_ia_numberSquadsRandom);
	
		_squads = _squads_array select _id;
		
		for "_i" from 1 to _n do {
			_type = selectRandom _squads;
			_pos = [_spawn_pos, 60] call fow_ia_fnc_randomizePos;
			_group = [_pos, _side, _type] call BIS_fnc_spawnGroup;
			_wp =_group addWaypoint [fow_ia_center, 70];
			_wp setWaypointType "SAD";
			_group setBehaviour "AWARE";
			_group setCombatMode "RED";
			_group setSpeedMode "FULL";
			
			if (fow_ia_playerTeam isEqualTo _team) then {
				{addSwitchableUnit _x} foreach units _group;
			};
		};
		
		if (fow_ia_debug) then {systemChat format ["Team %1: %2 squads reinforcement",_team,_n];diag_log format ["Team %1: %2 squads reinforcement",_team,_n];};
	};
	
	fow_ia_fnc_missionControl = {
		sleep 10;//wait for the game start
		
		while {true} do {//Not true -> game live
			_team1 = west countSide allUnits;
			_team2 = resistance countSide allUnits;
			
			if (_team1 < 10 && {fow_ia_numberOfWaves_team1 > 0}) then {
				fow_ia_numberOfWaves_team1 = fow_ia_numberOfWaves_team1 - 1;
				[fow_ia_team1] call fow_ia_fnc_spawnWave;
			};
			if (_team2 < 10 && {fow_ia_numberOfWaves_team2 > 0}) then {
				fow_ia_numberOfWaves_team2 = fow_ia_numberOfWaves_team2 - 1;
				[fow_ia_team2] call fow_ia_fnc_spawnWave;
			};
			if (_team1 isEqualTo 0 && fow_ia_numberOfWaves_team1 isEqualTo 0) exitWith {hintC format ["Game finished! %1 wins!",fow_ia_team2];};
			if (_team2 isEqualTo 0 && fow_ia_numberOfWaves_team2 isEqualTo 0) exitWith {hintC format ["Game finished! %1 wins!",fow_ia_team1];};
		};
	};
	
	fow_ia_fnc_startGame = {
		
		[] call fow_ia_fnc_selectPositions;
		
		[] call fow_ia_fnc_pickSides;
		
		west setFriend [resistance, 0];
		resistance setFriend [west, 0];
		east setFriend [resistance, 0];
		resistance setFriend [east, 0];
		
		[] call fow_ia_fnc_spawnUnits;
		
		if (fow_ia_debug) then {_t = format ["Team 1: %1 - Team 2: %2 - Team Player: %3",fow_ia_team1,fow_ia_team2,fow_ia_playerTeam];systemChat _t;diag_log _t;};
		
		[] spawn {sleep 1;player action ["TeamSwitch", player];_oldVehicle = vehicle player; waitUntil {vehicle player != _oldVehicle};removeSwitchableUnit _oldVehicle;};
		
		[] spawn fow_ia_fnc_missionControl;
	};
	
	
	//[] call fow_ia_fnc_startGame;
	[] call fow_ia_fnc_aas_startGame;
	
	//{deleteMarker _x} foreach ["fow_ia_center","fow_ia_team1Spawn","fow_ia_team2Spawn"];