private ["_id","_pos","_building","_tracked","_civs","_vehs","_group","_all","_shopkeeper"];
if (!isServer) exitwith {};

_active = false;
_spawned = false;

_count = 0;
_id = _this select 0;
_pos = _this select 1;
_building = _this select 3;

_hour = date select 3;

_civs = []; //Stores all civs for tear down
_groups = [];

waitUntil{spawner getVariable _id};

while{true} do {
	//Do any updates here that should happen whether spawned or not
	
	//Main spawner
	if !(_active) then {
		//Shop hours are 9am to 9pm
		if (spawner getVariable _id) then {
			_active = true;
			//Spawn shop furniture in
			_tracked = _building call spawnTemplate;
			sleep 1;
			_vehs = _tracked select 0;
			[_civs,_vehs] call BIS_fnc_arrayPushStack;
			
			_cashdesk = _pos nearestObject AIT_item_ShopRegister;
			_cashpos = [getpos _cashdesk,1,getDir _cashdesk] call BIS_fnc_relPos;
			
			if(_hour > 8 and _hour < 22) then {
				//Shop is open, spawn shopkeeper
				
				_pos = [[[_cashpos,50]]] call BIS_fnc_randomPos;
				
				_group = createGroup civilian;	
				_groups pushback _group;
				_group setBehaviour "CARELESS";
				_type = (AIT_civTypes_locals + AIT_civTypes_expats) call BIS_Fnc_selectRandom;		
				_shopkeeper = _group createUnit [_type, _pos, [],0, "NONE"];
				
				_civs pushback _shopkeeper;
				
				_wp = _group addWaypoint [_cashpos,2];
				_wp setWaypointType "MOVE";
				_wp setWaypointSpeed "LIMITED";
				
				_shopkeeper remoteExec ["initShopLocal",0,true];
				[_shopkeeper] call initShopkeeper;	
				
				if((_hour > 18 and _hour < 22) or (_hour < 9 and _hour > 5)) then {
					//Put a light on
					_pos = getpos _building;
					_light = "#lightpoint" createVehicle [_cashpos select 0,_cashpos select 1,(_cashpos select 2)+2.2];
					_light setLightBrightness 0.11;
					_light setLightAmbient[.9, .9, .6];
					_light setLightColor[.5, .5, .4];
					_civs pushback _light;				
				};
			};
		};
	}else{
		if (spawner getVariable _id) then {
			//Do updates here that should happen only while spawned
			//...
			
		}else{			
			_active = false;
			//Tear it all down
			{
				deleteVehicle _x;		
			}foreach(_civs);
			{
				deleteGroup _x;
			}foreach(_groups);
			_groups = [];
			_civs = [];
		};
	};
	sleep 0.5;
};