(function() {
	'use strict';

	var id = 0;

	function Instruction(type, parameters) {
		this.id = ++id;
		this.type = type;
		this.time = type.cycles;
		this.parameters = parameters;
		this.issueTime = -1;
		this.executeTime = -1;
		this.writeBackTime = -1;
	}
	Instruction.resetID = function(){
		id = 0;
	}

	if (typeof module === 'object') {
		module.exports = Instruction;
	} else {
		this.Instruction = Instruction;
	}

}).call(this);

