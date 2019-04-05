(function() {
	'use strict';

	/* calculate: (args, memory) */
	function InstructionType(name, cycles, destParameter, parameters, calculate, stations) {
		this.name = name;
		this.cycles = cycles;
		this.parameters = parameters;
		this.destParameter = destParameter;
		this.calculate = calculate;
		this.stations = stations;
	}

	InstructionType.PARAMETER_TYPE_REGISTER = 0;
	InstructionType.PARAMETER_TYPE_ADDRESS = 1;

	if (typeof module === 'object') {
		module.exports = InstructionType;
	} else {
		this.InstructionType = InstructionType;
	}

}).call(this);

