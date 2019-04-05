VTABLE(_Math) {
    <empty>
    Math
}

VTABLE(_Main) {
    <empty>
    Main
}

FUNCTION(_Math_New) {
memo ''
_Math_New:
    _T10 = 4
    parm _T10
    _T11 =  call _Alloc
    _T12 = VTBL <_Math>
    *(_T11 + 0) = _T12
    return _T11
}

FUNCTION(_Main_New) {
memo ''
_Main_New:
    _T13 = 4
    parm _T13
    _T14 =  call _Alloc
    _T15 = VTBL <_Main>
    *(_T14 + 0) = _T15
    return _T14
}

FUNCTION(_Math.abs) {
memo '_T2:4'
_Math.abs:
    _T16 = 0
    _T17 = (_T2 >= _T16)
    if (_T17 == 0) branch _L16
    return _T2
    branch _L17
_L16:
    _T18 = - _T2
    return _T18
_L17:
}

FUNCTION(_Math.pow) {
memo '_T3:4 _T4:8'
_Math.pow:
    _T21 = 1
    _T20 = _T21
    _T22 = 0
    _T19 = _T22
    branch _L18
_L19:
    _T23 = 1
    _T24 = (_T19 + _T23)
    _T19 = _T24
_L18:
    _T25 = (_T19 < _T4)
    if (_T25 == 0) branch _L20
    _T26 = (_T20 * _T3)
    _T20 = _T26
    branch _L19
_L20:
    return _T20
}

FUNCTION(_Math.log) {
memo '_T5:4'
_Math.log:
    _T27 = 1
    _T28 = (_T5 < _T27)
    if (_T28 == 0) branch _L21
    _T29 = 1
    _T30 = - _T29
    return _T30
_L21:
    _T32 = 0
    _T31 = _T32
_L22:
    _T33 = 1
    _T34 = (_T5 > _T33)
    if (_T34 == 0) branch _L23
    _T35 = 1
    _T36 = (_T31 + _T35)
    _T31 = _T36
    _T37 = 2
    _T38 = 0
    _T39 = (_T37 == _T38)
    if (_T39 == 0) branch _L24
    _T40 = "Decaf runtime error: Division by zero error.\n"
    parm _T40
    call _PrintString
    call _Halt
_L24:
    _T41 = (_T5 / _T37)
    _T5 = _T41
    branch _L22
_L23:
    return _T31
}

FUNCTION(_Math.max) {
memo '_T6:4 _T7:8'
_Math.max:
    _T42 = (_T6 > _T7)
    if (_T42 == 0) branch _L25
    return _T6
    branch _L26
_L25:
    return _T7
_L26:
}

FUNCTION(_Math.min) {
memo '_T8:4 _T9:8'
_Math.min:
    _T43 = (_T8 < _T9)
    if (_T43 == 0) branch _L27
    return _T8
    branch _L28
_L27:
    return _T9
_L28:
}

FUNCTION(main) {
memo ''
main:
    _T44 = 1
    _T45 = - _T44
    parm _T45
    _T46 =  call _Math.abs
    parm _T46
    call _PrintInt
    _T47 = "\n"
    parm _T47
    call _PrintString
    _T48 = 2
    _T49 = 3
    parm _T48
    parm _T49
    _T50 =  call _Math.pow
    parm _T50
    call _PrintInt
    _T51 = "\n"
    parm _T51
    call _PrintString
    _T52 = 16
    parm _T52
    _T53 =  call _Math.log
    parm _T53
    call _PrintInt
    _T54 = "\n"
    parm _T54
    call _PrintString
    _T55 = 1
    _T56 = 2
    parm _T55
    parm _T56
    _T57 =  call _Math.max
    parm _T57
    call _PrintInt
    _T58 = "\n"
    parm _T58
    call _PrintString
    _T59 = 1
    _T60 = 2
    parm _T59
    parm _T60
    _T61 =  call _Math.min
    parm _T61
    call _PrintInt
    _T62 = "\n"
    parm _T62
    call _PrintString
}

