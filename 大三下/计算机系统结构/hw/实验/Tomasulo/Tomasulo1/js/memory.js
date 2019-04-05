(function() {
	'use strict';

	function Memory(size) {
		this.data = new Array(size);
		this.size = size;
		for (var i = 0; i < this.data.length; ++i) {
			this.data[i] = i;
		}
	}

	Memory.prototype._check_addr = function(addr) {
		if (addr >= this.size || addr < 0) {
			throw new Error('[MEMORY] Invalid address "' + addr + '"');
		}
	};

	Memory.prototype.load = function(addr) {
		this._check_addr(addr);
		return this.data[addr];
	};

	Memory.prototype.store = function(addr, value) {
		this._check_addr(addr);
		this.data[addr] = value;
	};

	if (typeof module === 'object') {
		module.exports = Memory;
	} else {
		this.Memory = Memory;
	}

}).call(this);

