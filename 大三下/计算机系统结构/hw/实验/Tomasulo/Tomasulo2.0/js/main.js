(function() {
	'use strict';

	var InstructionType, ReservationStation, Instruction;
	if (typeof module === 'object') { // nodejs
		InstructionType = require('./instruction_type.js');
		ReservationStation = require('./reservation_station.js');
		Instruction = require('./instruction.js');
	} else {
		InstructionType = this.InstructionType;
		ReservationStation = this.ReservationStation;
		Instruction = this.Instruction;
	}

	function Main(program, system) {
		Instruction.resetID();
		this.system = system;
		this.system.clock = 0;

		/* parse program */
		program = program.toUpperCase()
		                 .replace(/[\s,]+/g, ',')
		                 .replace(/^,|,$/g, '');

		var tokens = program.split(',');
		var instructions = [];

		for (var i = 0; i < tokens.length;) {
			var instructionType = this.system.instructionTypes[tokens[i++]];
			var params = [];
			for (var j = 0; j < instructionType.parameters.length; ++j, ++i) {
				switch (instructionType.parameters[j]) {
				case InstructionType.PARAMETER_TYPE_REGISTER:
					params.push(tokens[i]);
					break;
				case InstructionType.PARAMETER_TYPE_ADDRESS:
					params.push(parseInt(tokens[i], 10));
					break;
				}
			}
			instructions.push(new Instruction(instructionType, params));
		}

		this.instructions = instructions;
		this.issuedInstructions = 0;
	}

	/* return true if finished exec */
	Main.prototype.step = function() {
		++this.system.clock;

		/* START issue */
		if (this.instructions.length > this.issuedInstructions) {
			var instruction = this.instructions[this.issuedInstructions];
			var stations = instruction.type.stations;
			for (var i = 0; i < stations.length; ++i) {
				if (stations[i].state == ReservationStation.STATE_IDLE) {
					var station = stations[i];

					station.state = ReservationStation.STATE_ISSUE;
					station.instruction = instruction;
					instruction.issueTime = this.system.clock;

					var dest = instruction.type.destParameter;
					var paramCount = instruction.type.parameters.length;

					station.parameters = [];
					station.tags = [];
					for (var i = 0; i < paramCount; ++i) {
						var value = null;
						var tag = null;

						if (i !== dest) {
							switch (instruction.type.parameters[i]) {
							case InstructionType.PARAMETER_TYPE_REGISTER:
								tag = this.system.commonDataBus.getBusy(InstructionType.PARAMETER_TYPE_REGISTER, instruction.parameters[i]);
								if (tag === null) {
									value = this.system.registerFile.get(instruction.parameters[i]);
								}
								break;
							case InstructionType.PARAMETER_TYPE_ADDRESS:
								tag = this.system.commonDataBus.getBusy(InstructionType.PARAMETER_TYPE_ADDRESS, instruction.parameters[i]);
								value = instruction.parameters[i];
								break;
							}
						} else { // dest
							value = instruction.parameters[i];
						}

						station.parameters.push(value);
						station.tags.push(tag);
					}

					var type = instruction.type.parameters[dest];
					var name = instruction.parameters[dest];
					this.system.commonDataBus.setBusy(type, name, station);

					++this.issuedInstructions;
				}
			}
		}
		/* END issue */

		for (var i in this.system.reservationStations) {
			var station = this.system.reservationStations[i];
			if (station.state === ReservationStation.STATE_EXECUTE) {
				/* START execute */
				if ((--station.instruction.time) === 0) {
					station.instruction.executeTime = this.system.clock;
					station.state = ReservationStation.STATE_WRITE_BACK;
				}
				/* END execute */
			} else if (station.state === ReservationStation.STATE_WRITE_BACK) {
				/* START writeback */
				var dest = station.instruction.type.destParameter;
				var type = station.instruction.type.parameters[dest];
				var name = station.instruction.parameters[dest];
				var value = station.instruction.type.calculate.call(station, station.parameters);
				if (typeof value === 'undefined') {
					value = true;
				}

				if (this.system.commonDataBus.getBusy(type, name) === station) {
					switch (type) {
					case InstructionType.PARAMETER_TYPE_REGISTER:
						this.system.registerFile.set(name, value);
						break;
					case InstructionType.PARAMETER_TYPE_ADDRESS:
						value = name;
						break;
					}

					this.system.commonDataBus.setBusy(type, name, null);
					this.system.commonDataBus.setResult(station, value);
				}

				station.instruction.writeBackTime = this.system.clock;
				station.state = ReservationStation.STATE_IDLE;
				/* END writeback */
			}
		}

		var allDone = true;
		for (var i in this.system.reservationStations) {
			var station = this.system.reservationStations[i];
			if (station.state === ReservationStation.STATE_ISSUE) {
				/* check if all the values needed for execution is available */
				var needMoreValues = false;
				for (var j = 0; j < station.tags.length; ++j) {
					if (station.tags[j] !== null) {
						var value = this.system.commonDataBus.getResult(station.tags[j]);
						if (value !== null) {
							station.parameters[j] = value;
							station.tags[j] = null;
						} else {
							needMoreValues = true;
						}
					}
				}
				if (!needMoreValues) {
					station.state = ReservationStation.STATE_EXECUTE;
				}
			}

			if (station.state !== ReservationStation.STATE_IDLE) {
				allDone = false;
			}
		}

		this.system.commonDataBus.clearResult();
		return allDone;
	}

	Main.prototype.run = function() {
		while (!this.step()) {
			// ...
		}
	}

	if (typeof module === 'object') {
		module.exports = Main;
	} else {
		this.Main = Main;
	}

}).call(this);

