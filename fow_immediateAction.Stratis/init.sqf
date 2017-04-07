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

	fow_ia_factions_blu = ["Wehrmacht","Fallschirmjäger","IJA","SNLF"];
	fow_ia_factions_red = [];
	fow_ia_factions_green = ["US","USMC","UK","UK Para"];
	
	fow_ia_squads_blu = [
		//wehr
		[(configFile >> "CfgGroups" >> "West" >> "fow_wehrmacht" >> "Infantry" >> "fow_ger_RifleSquad"),(configFile >> "CfgGroups" >> "West" >> "fow_wehrmacht" >> "Infantry" >> "fow_ger_RifleTeam"),(configFile >> "CfgGroups" >> "West" >> "fow_wehrmacht" >> "Infantry" >> "fow_ger_MGTeam")],
		//Fallschirmjäger
		[(configFile >> "CfgGroups" >> "West" >> "fow_wehrmacht" >> "Infantry" >> "fow_ger_RifleSquad"),(configFile >> "CfgGroups" >> "West" >> "fow_wehrmacht" >> "Infantry" >> "fow_ger_RifleTeam"),(configFile >> "CfgGroups" >> "West" >> "fow_wehrmacht" >> "Infantry" >> "fow_ger_MGTeam")],
		//IJA
		[(configFile >> "CfgGroups" >> "West" >> "fow_ija" >> "Infantry" >> "fow_ija_RifleSquad"),(configFile >> "CfgGroups" >> "West" >> "fow_ija" >> "Infantry" >> "fow_ija_RifleTeam"),(configFile >> "CfgGroups" >> "West" >> "fow_ija" >> "Infantry" >> "fow_ija_MGTeam")],
		//SNLF
		[(configFile >> "CfgGroups" >> "West" >> "fow_ija" >> "Infantry" >> "fow_ija_snlf_RifleSquad"),(configFile >> "CfgGroups" >> "West" >> "fow_ija" >> "Infantry" >> "fow_ija_snlf_RifleTeam"),(configFile >> "CfgGroups" >> "West" >> "fow_ija" >> "Infantry" >> "fow_ija_snlf_MGTeam")]
	];
	fow_ia_squads_green = [
		//"US"
		[(configFile >> "CfgGroups" >> "Indep" >> "fow_usa" >> "Infantry" >> "fow_us_RifleSquad"),(configFile >> "CfgGroups" >> "Indep" >> "fow_usa" >> "Infantry" >> "fow_us_RifleTeam"),(configFile >> "CfgGroups" >> "Indep" >> "fow_usa" >> "Infantry" >> "fow_us_MGTeam")],
		//"USMC"
		[(configFile >> "CfgGroups" >> "Indep" >> "fow_usmc" >> "Infantry" >> "fow_usmc_RifleSquad"),(configFile >> "CfgGroups" >> "Indep" >> "fow_usmc" >> "Infantry" >> "fow_usmc_RifleTeam"),(configFile >> "CfgGroups" >> "Indep" >> "fow_usmc" >> "Infantry" >> "fow_usmc_MGTeam")],
		//"UK"
		[(configFile >> "CfgGroups" >> "Indep" >> "fow_uk" >> "Infantry" >> "fow_uk_RifleSquad"),(configFile >> "CfgGroups" >> "Indep" >> "fow_uk" >> "Infantry" >> "fow_uk_RifleTeam"),(configFile >> "CfgGroups" >> "Indep" >> "fow_uk" >> "Infantry" >> "fow_uk_MGTeam")],
		//"UK Para"
		[(configFile >> "CfgGroups" >> "Indep" >> "fow_uk" >> "Infantry" >> "fow_uk_para_RifleSquad"),(configFile >> "CfgGroups" >> "Indep" >> "fow_uk" >> "Infantry" >> "fow_uk_para_RifleTeam"),(configFile >> "CfgGroups" >> "Indep" >> "fow_uk" >> "Infantry" >> "fow_uk_para_MGTeam")]
	];
	
	fow_ia_debug = true;
	fow_ia_spawnDistanceFromCenter = 200;
	
	fow_ia_numberSquads = 4;
	fow_ia_numberSquadsRandom = 3;

	_getRandomStartPos = {
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
	
	fow_ia_fnc_pickSides = {
		fow_ia_team1 = selectRandom fow_ia_factions_blu;
		fow_ia_team2 = selectRandom fow_ia_factions_green;
		
		fow_ia_playerTeam = selectRandom [fow_ia_team1,fow_ia_team2];
		
		true
	};
	
	fow_ia_fnc_spawnUnits = {
	
		_n_1 = round (fow_ia_numberSquads + random fow_ia_numberSquadsRandom);
		_n_2 = round (fow_ia_numberSquads + random fow_ia_numberSquadsRandom);
	
		_squads_1_id = fow_ia_factions_blu find fow_ia_team1;
		_squads_1 = fow_ia_squads_blu select _squads_1_id;
		
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
		
		_squads_2_id = fow_ia_factions_green find fow_ia_team2;
		_squads_2 = fow_ia_squads_green select _squads_2_id;
		
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
		
		if (fow_ia_debug) then {systemChat format ["Team 1: %1 squads - Team 2: %2 squads",_n_1,_n_2];diag_log format ["Team 1: %1 squuds - Team 2: %2 squads",_n_1,_n_2];};
		
	};
	
	fow_ia_fnc_startGame = {
		
		_pos = [] call _getRandomStartPos;
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
		
		[] call fow_ia_fnc_pickSides;
		
		west setFriend [resistance, 0];
		resistance setFriend [west, 0];
		east setFriend [resistance, 0];
		resistance setFriend [east, 0];
		
		[] call fow_ia_fnc_spawnUnits;
		
		if (fow_ia_debug) then {_t = format ["Team 1: %1 - Team 2: %2 - Team Player: %3",fow_ia_team1,fow_ia_team2,fow_ia_playerTeam];systemChat _t;diag_log _t;};
		
		[] spawn {sleep 1;player action ["TeamSwitch", player];_oldVehicle = vehicle player; waitUntil {vehicle player != _oldVehicle};removeSwitchableUnit _oldVehicle;};
	};
	
	
	[] call fow_ia_fnc_startGame;
	
	//{deleteMarker _x} foreach ["fow_ia_center","fow_ia_team1Spawn","fow_ia_team2Spawn"];