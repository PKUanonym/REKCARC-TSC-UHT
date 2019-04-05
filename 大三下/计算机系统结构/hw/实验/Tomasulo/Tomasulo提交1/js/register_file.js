(function() {
	'use strict';

	function RegisterFile(count, prefix) {
		this.registers = new Array(count);
		for (var i = 0; i < this.registers.length; ++i) {
			this.registers[i] = 1;
		}
		this.count = count;
		this.prefix = prefix.toUpperCase();
	}

	RegisterFile.prototype._getIndex = function(name) {
		name = name.toUpperCase();
		if (name.substring(0, this.prefix.length) === this.prefix) {
			var index = parseInt(name.substring(this.prefix.length), 10);
			if (index >= 0 && index < this.count) {
				return index;
			}
		}
		throw new Error('[REGISTER_FILE] Invalid register "' + name + '"');
	};

	RegisterFile.prototype.get = function(name) {
		return this.registers[this._getIndex(name)];
	};

	RegisterFile.prototype.set = function(name, value) {
		this.registers[this._getIndex(name)] = value;
	};


	if (typeof module === 'object') {
		module.exports = RegisterFile;
	} else {
		this.RegisterFile = RegisterFile;
	}

}).call(this);

