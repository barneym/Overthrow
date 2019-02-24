
/*
	Author: Genesis

	Description:
		This function will execute the appropriate code && FSM's onto a group.
		These FSM's will run until the group is cleaned. They will be designed to halt when the group is empty or all units are dead.

	Parameter(s):
		0: GROUP

	Returns:
		NOTHING
*/

_this execFSM "\ot\functions\AI\VCOMAI\FSMS\SQUADBEH.fsm";
VcmAI_ActiveList pushback _this;