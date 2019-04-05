function init(program) {
	'use strict';
	var System = {};
	System.memory = new Memory(4096);
	System.registerFile = new RegisterFile(11, 'F');
	System.commonDataBus = new CommonDataBus();
	System.reservationStations = {
		ADD_1: new ReservationStation('ADD_1'),
		ADD_2: new ReservationStation('ADD_2'),
		ADD_3: new ReservationStation('ADD_3'),

		MUL_1: new ReservationStation('MUL_1'),
		MUL_2: new ReservationStation('MUL_2'),

		LOAD_1: new Buffer('LOAD_1', System.memory),
		LOAD_2: new Buffer('LOAD_2', System.memory),
		LOAD_3: new Buffer('LOAD_3', System.memory),

		STORE_1: new Buffer('STORE_1', System.memory),
		STORE_2: new Buffer('STORE_2', System.memory),
		STORE_3: new Buffer('STORE_3', System.memory)
		
	};
	System.instructionTypes = {
		'ADDD': new InstructionType('ADDD', 2, 0,
									[InstructionType.PARAMETER_TYPE_REGISTER,
									 InstructionType.PARAMETER_TYPE_REGISTER,
									 InstructionType.PARAMETER_TYPE_REGISTER],
									function(p) { return p[1] + p[2]; },
									[System.reservationStations['ADD_1'],
									 System.reservationStations['ADD_2'],
									 System.reservationStations['ADD_3']]),

		'SUBD': new InstructionType('SUBD', 2, 0,
									[InstructionType.PARAMETER_TYPE_REGISTER,
									 InstructionType.PARAMETER_TYPE_REGISTER,
									 InstructionType.PARAMETER_TYPE_REGISTER],
									function(p) { return p[1] - p[2]; },
									[System.reservationStations['ADD_1'],
									 System.reservationStations['ADD_2'],
									 System.reservationStations['ADD_3']]),

		'MULD': new InstructionType('MULD', 10, 0,
									[InstructionType.PARAMETER_TYPE_REGISTER,
									 InstructionType.PARAMETER_TYPE_REGISTER,
									 InstructionType.PARAMETER_TYPE_REGISTER],
									function(p) { return p[1] * p[2]; },
									[System.reservationStations['MUL_1'],
									 System.reservationStations['MUL_2']]),

		'DIVD': new InstructionType('DIVD', 40, 0,
									[InstructionType.PARAMETER_TYPE_REGISTER,
									 InstructionType.PARAMETER_TYPE_REGISTER,
									 InstructionType.PARAMETER_TYPE_REGISTER],
									function(p) { return p[1] / p[2]; },
									[System.reservationStations['MUL_1'],
									 System.reservationStations['MUL_2']]),

		'LD': new InstructionType('LD', 3, 0,
								  [InstructionType.PARAMETER_TYPE_REGISTER,
								   InstructionType.PARAMETER_TYPE_ADDRESS],
								  function(p) { return this.memory.load(p[1]); },
								  [System.reservationStations['LOAD_1'],
								   System.reservationStations['LOAD_2'],
								   System.reservationStations['LOAD_3']]),

		'ST': new InstructionType('ST', 2, 1,
								  [InstructionType.PARAMETER_TYPE_REGISTER,
								   InstructionType.PARAMETER_TYPE_ADDRESS],
								  function(p) { this.memory.store(p[1], p[0]); return p[0]; },
								  [System.reservationStations['STORE_1'],
								   System.reservationStations['STORE_2'],
								   System.reservationStations['STORE_3']])
	};
	
	return new Main(program, System);
};
var interval;
function initGUI(main){
	$('.station:not(.title)').remove();
	$('.instruction:not(.title)').remove();
	$('.register:not(.title)').remove();
	var CONSTVAR={
		'newreg' : function(name){
			console.log(name);
			//return '<li class="register"> <span class="name">'+name+'</span> <span class="value" id="reg-' + name + '"> </span> </li>';
			return '<div class = "mine" class="register"><span class="name">&nbsp;&nbsp;&nbsp;'+name+'&nbsp;&nbsp;&nbsp;&nbsp;</span><button class="btn btn-info" type="submit"> <span class="value" id="reg-' + name + '"> </button></span> &nbsp;</div>';
		},
		'newstation' : function(name){
			return '<li class="station" id="station-' + name + '"> <span class="name">' + name + '</span> <span class="time-remaining"></span>  <span class="instruction-number"> </span> <span class="state"> </span> <span class="p1">  </span> <span class="p2"> </span> <span class="p3"></span> </li>';
		},
		'newinst' : function(linenum, detail){
			return '<li class="instruction" id="inst-'+linenum+'"> <span class="inst-linenum">'+linenum+'</span><span class="instruction-detail">' + detail + '</span> <span class="issue-time"></span> <span class="exec-time"></span> <span class="writeback-time"></span> </li>';
		},
		'newmem' : function(addr, value){
			return '<div id="m' + addr + '" class="memory"><span class="addr">'+ addr + '</span><span class="value">' + value + '</span></div>';
		}
	};
	var _html = '';
	for (var i = 0; i < main.system.registerFile.count; i++){
		if(i<10){
			_html += CONSTVAR.newreg(main.system.registerFile.prefix +'0'+ i);
		}
		else{
			_html += CONSTVAR.newreg(main.system.registerFile.prefix + i);
		}	
	}
	$('#float-registers').get(0).innerHTML += ((_html));
	var _html = '';
	for (rs in main.system.reservationStations){
		_html += CONSTVAR.newstation(rs);
	}
	$('#reservation-stations').get(0).innerHTML += ((_html));

	var _html = '';
	for (var i = 0; i < main.instructions.length; i++){
		var ii = main.instructions[i];
		_html += CONSTVAR.newinst(ii.id, ii.type.name + ' ' + ii.parameters.join(', '));
	}
	$('#instruction-show').get(0).innerHTML += ((_html));
	var _html = '';
	for (var i = 0; i < main.system.memory.size; i++){
		_html += CONSTVAR.newmem(i, main.system.memory.data[i]);
	}
	//document.getElementById('memory-show').innerHTML = _html ;
	$('#memory-show').on('click', '.memory', function() {
		editMemory(this.id.substring(1));
	});
}

function initGUI1(main){
	$('.station:not(.title)').remove();
	$('.instruction:not(.title)').remove();
	$('.register:not(.title)').remove();
	var CONSTVAR={
		'newreg' : function(name){
			//return '<li class="register"> <span class="name">'+name+'</span> <span class="value" id="reg-' + name + '"> </span> </li>';
			return '<div class = "mine" class="register"><span class="name">&nbsp;&nbsp;&nbsp;'+name+'&nbsp;&nbsp;&nbsp;&nbsp;</span><button class="btn btn-info" type="submit"> <span class="value" id="reg-' + name + '"> </button></span> &nbsp;</div>';
		},
		'newstation' : function(name){
			return '<li class="station" id="station-' + name + '"> <span class="name">' + name + '</span> <span class="time-remaining"></span>  <span class="instruction-number"> </span> <span class="state"> </span> <span class="p1">  </span> <span class="p2"> </span> <span class="p3"></span> </li>';
		},
		'newinst' : function(linenum, detail){
			return '<li class="instruction" id="inst-'+linenum+'"> <span class="inst-linenum">'+linenum+'</span><span class="instruction-detail">' + detail + '</span> <span class="issue-time"></span> <span class="exec-time"></span> <span class="writeback-time"></span> </li>';
		},
		'newmem' : function(addr, value){
			return '<div id="m' + addr + '" class="memory"><span class="addr">'+ addr + '</span><span class="value">' + value + '</span></div>';
		}
	};
	var _html = '';
	// for (var i = 0; i < main.system.registerFile.count; i++){
	// 	_html += CONSTVAR.newreg(main.system.registerFile.prefix + i);
	// }
	$('#float-registers').get(0).innerHTML += ((_html));
	var _html = '';
	for (rs in main.system.reservationStations){
		_html += CONSTVAR.newstation(rs);
	}
	$('#reservation-stations').get(0).innerHTML += ((_html));

	var _html = '';
	for (var i = 0; i < main.instructions.length; i++){
		var ii = main.instructions[i];
		_html += CONSTVAR.newinst(ii.id, ii.type.name + ' ' + ii.parameters.join(', '));
	}
	$('#instruction-show').get(0).innerHTML += ((_html));
	var _html = '';
	for (var i = 0; i < main.system.memory.size; i++){
		_html += CONSTVAR.newmem(i, main.system.memory.data[i]);
	}
	//document.getElementById('memory-show').innerHTML = _html ;
	// $('#memory-show').on('click', '.memory', function() {
	// 	editMemory(this.id.substring(1));
	// });
}


function update(main) {
	document.getElementById('global-clock').innerText = main.system.clock;
	for (var i = 0; i < 11; ++i) {
		if(i<10){
			var busy = main.system.commonDataBus.getBusy(InstructionType.PARAMETER_TYPE_REGISTER, 'F' +'0'+ i);
			var value = main.system.registerFile.get('F' +'0'+ i);
			document.getElementById('reg-F' +'0'+ i).innerText = value.toFixed(5);

		}
		else{
			var busy = main.system.commonDataBus.getBusy(InstructionType.PARAMETER_TYPE_REGISTER, 'F' + i);
			var value = main.system.registerFile.get('F' + i);
			document.getElementById('reg-F' + i).innerText = value.toFixed(5);

		}
		
	}
	$('#total-inst').text(main.instructions.length);
	for (var i = 0; i < main.instructions.length; ++i) {
		var ii = main.instructions[i];
		var inst = document.getElementById('inst-' + ii.id);
		inst.querySelector('.issue-time').innerText = ii.issueTime > 0 ? ii.issueTime : '';
		inst.querySelector('.exec-time').innerText = ii.executeTime > 0 ? ii.executeTime : '';
		inst.querySelector('.writeback-time').innerText = ii.writeBackTime > 0 ? ii.writeBackTime : '';
	}
	for (var name in main.system.reservationStations) {
		var station = main.system.reservationStations[name]
		var guiItem = document.getElementById('station-' + name);
		var _state;
		switch (station.state) {
			case ReservationStation.STATE_IDLE:
				_state = 'IDLE';
				break;
			case ReservationStation.STATE_ISSUE:
				_state = 'ISSUE';
				break;
			case ReservationStation.STATE_EXECUTE:
				_state = 'EXEC';
				break;
			case ReservationStation.STATE_WRITE_BACK:
				_state = 'WRITE';
		}
		var _remain_time = -1;
		guiItem.querySelector('.state').innerText = _state;
		if (station.state !== ReservationStation.STATE_IDLE) {
			if (station.instruction){
				_remain_time = station.instruction.time;
			}
			var _curInst = '[' + station.instruction.id + ']';
			guiItem.querySelector('.instruction-number').innerText = _curInst;
			for (var i = 0; i < 3; i++){
				var td = guiItem.querySelector('.p' + (i + 1));
				if (i >= station.parameters.length){
					td.innerHTML = ' - ';
				}
				else{
					if (station.tags[i]){
						td.innerHTML = station.tags[i].name;
					}
					else {
						td.innerHTML = station.parameters[i];
					}
				}
			}
		}
		else{
			guiItem.querySelector('.instruction-number').innerText = '';
			for (var i = 0; i < 3; i++){
				var td = guiItem.querySelector('.p' + (i + 1));
					td.innerHTML = '';
			}
		}
		guiItem.querySelector('.time-remaining').innerText = _remain_time >= 0 ? _remain_time : '';
	}
	$('#cur-pc').text(main.issuedInstructions);
	for (var i = 0; i < main.system.memory.size; i++){
		//document.getElementById('m' + i).children[1].innerText = main.system.memory.data[i];
	}
}

$(function(){
	var program = 'ld F6, 105\n' +
	'ld f2, 101\n' +
	'muld f0, f2, f4\n' +
	'subd f8, f6, f2\n' +
	'divd f10, f0, f6\n' +
	'addd f6, f8, f2\n' +
	'muld f0, f2, f4\n' +
	'subd f8, f6, f2\n' +
	'addd f3, f8, f2\n' +
	'addd f2, f8, f2\n' ;
	var main = init(program);
	initGUI(main);
	update(main);
	$('#dialog').dialog({
		 autoOpen: false,
		 resizable: false,
		 height: 360,
		 width: 480,
		 modal: true,
	});
	$('#dialog2').dialog({
		 autoOpen: false,
		 resizable: false,
		 height: 100,
		 width: 600,
		 modal: true,
	});
	$('#action-step').button().on('click', function() {
		var done = main.step();
		update(main);
		if (done && interval) {
			clearInterval(interval);
			$('#action-run').attr('disabled', null);
		}
	});
	$('#action-run').button().on('click', function() {
		$('#action-run').attr('disabled', 'disabled');
		interval = setInterval(function(){$('#action-step').click();}, 100);
	});
	$('#action-stop').button().on('click', function() {
		clearInterval(interval);
		$('#action-run').attr('disabled', null);
		update(main);
	});
	$('#action-end').button().on('click', function() {
		main.run();
		update(main);
		$('#action-run').attr('disabled', null);
		if (interval) {
			clearInterval(interval);
		}
	});
	$('#action-restart').button().on('click', function(){
		if (interval) {
			clearInterval(interval);
		}
		main = init(program);
		initGUI1(main);
		update(main);
	});
	$('#action-multistep').button().on('click', function(){
		var n = prompt("请输入运行步数");
		$('#action-multistep').attr('disabled', 'disabled');
		for (var i = 0; i < n; i += 1){
			main.step();
		}
		update(main);
		$('#action-multistep').attr('disabled', null);
	});
	$('#action-inst-edit').on('click', function(){
		$('#inst-edit-input').val(program);
		$('#dialog').dialog('open');
	});
	$('#inst-submit').click(
		function(){
		program = $('#inst-edit-input').val();
		try{
			$('#action-restart').click();
			$('#dialog').dialog('close');
		}
		catch(e){
			alert("程序有误，请检查后重试");
		}
	}
	);

	var bwExpand = true;
	$('.bottom-wrap .explain').on('click', function() {
		if (bwExpand) {
			bwExpand = false;
			$('.bottom-wrap').animate({
				height: 26
			}, 500);
			$('.top-wrap').animate({
				bottom: 26
			}, 500);
		} else {
			bwExpand = true;
			$('.bottom-wrap').animate({
				height: 300
			}, 500);
			$('.top-wrap').animate({
				bottom: 300
			}, 500);

		}
	});
	window.editMemory = function(addr){
		$('#dialog2').dialog('open');
		$('#mem-addr').val(addr);
		$('#mem-val').val(main.system.memory.data[addr]);
	}
	$('#mem-submit').on('click', function(){
		var addr = $('#mem-addr').val();
		var val = $('#mem-val').val();
		main.system.memory.data[addr] = val;
		$('#m' + addr + ' .value').text(val);
		$('#dialog2').dialog('close');
	});
});