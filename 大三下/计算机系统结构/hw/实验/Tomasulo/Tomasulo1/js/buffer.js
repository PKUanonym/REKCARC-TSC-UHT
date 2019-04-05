(function() {
	'use strict';

	function Buffer(_, memory) {
		ReservationStation.apply(this, arguments);
		this.memory = memory;
		return this;
	}

	Buffer.prototype = new ReservationStation();

	if (typeof module === 'object') {
		module.exports = Buffer;
	} else {
		this.Buffer = Buffer;
	}

}).call(this);

