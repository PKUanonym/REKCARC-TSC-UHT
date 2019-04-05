VTABLE(_Math) {
    <empty>
    Math
    _Math.COPY;
}

VTABLE(_Main) {
    <empty>
    Main
    _Main.COPY;
}

FUNCTION(_Math_New) {
memo ''
_Math_New:
    _T8 = 4
    parm _T8
    _T9 =  call _Alloc
    _T10 = VTBL <_Math>
    *(_T9 + 0) = _T10
    return _T9
}

FUNCTION(_Math.COPY) {
memo '_T11:4'
_Math.COPY:
    _T12 = 4
    parm _T12
    _T13 =  call _Alloc
    _T14 = VTBL <_Math>
    *(_T13 + 0) = _T14
    return _T13
}

FUNCTION(_Main_New) {
memo ''
_Main_New:
    _T15 = 4
    parm _T15
    _T16 =  call _Alloc
    _T17 = VTBL <_Main>
    *(_T16 + 0) = _T17
    return _T16
}

FUNCTION(_Main.COPY) {
memo '_T18:4'
_Main.COPY:
    _T19 = 4
    parm _T19
    _T20 =  call _Alloc
    _T21 = VTBL <_Main>
    *(_T20 + 0) = _T21
    return _T20
}

FUNCTION(_Math.abs) {
memo '_T0:4'
_Math.abs:
    _T22 = 0
    _T23 = (_T0 >= _T22)
    if (_T23 == 0) branch _L18
    return _T0
    branch _L19
_L18:
    _T24 = - _T0
    return _T24
_L19:
}

FUNCTION(_Math.pow) {
memo '_T1:4 _T2:8'
_Math.pow:
    _T27 = 1
    _T26 = _T27
    _T28 = 0
    _T25 = _T28
    branch _L20
_L21:
    _T29 = 1
    _T30 = (_T25 + _T29)
    _T25 = _T30
_L20:
    _T31 = (_T25 < _T2)
    if (_T31 == 0) branch _L22
    _T32 = (_T26 * _T1)
    _T26 = _T32
    branch _L21
_L22:
    return _T26
}

FUNCTION(_Math.log) {
memo '_T3:4'
_Math.log:
    _T33 = 1
    _T34 = (_T3 < _T33)
    if (_T34 == 0) branch _L23
    _T35 = 1
    _T36 = - _T35
    return _T36
_L23:
    _T38 = 0
    _T37 = _T38
_L24:
    _T39 = 1
    _T40 = (_T3 > _T39)
    if (_T40 == 0) branch _L25
    _T41 = 1
    _T42 = (_T37 + _T41)
    _T37 = _T42
    _T43 = 2
    _T44 = 0
    _T45 = (_T43 == _T44)
    if (_T45 == 0) branch _L26
    _T46 = "Decaf runtime error: Division by zero error.\n"
    parm _T46
    call _PrintString
    call _Halt
_L26:
    _T47 = (_T3 / _T43)
    _T3 = _T47
    branch _L24
_L25:
    return _T37
}

FUNCTION(_Math.max) {
memo '_T4:4 _T5:8'
_Math.max:
    _T48 = (_T4 > _T5)
    if (_T48 == 0) branch _L27
    return _T4
    branch _L28
_L27:
    return _T5
_L28:
}

FUNCTION(_Math.min) {
memo '_T6:4 _T7:8'
_Math.min:
    _T49 = (_T6 < _T7)
    if (_T49 == 0) branch _L29
    return _T6
    branch _L30
_L29:
    return _T7
_L30:
}

FUNCTION(main) {
memo ''
main:
    _T50 = 1
    _T51 = - _T50
    parm _T51
    _T52 =  call _Math.abs
    parm _T52
    call _PrintInt
    _T53 = "\n"
    parm _T53
    call _PrintString
    _T54 = 2
    _T55 = 3
    parm _T54
    parm _T55
    _T56 =  call _Math.pow
    parm _T56
    call _PrintInt
    _T57 = "\n"
    parm _T57
    call _PrintString
    _T58 = 16
    parm _T58
    _T59 =  call _Math.log
    parm _T59
    call _PrintInt
    _T60 = "\n"
    parm _T60
    call _PrintString
    _T61 = 1
    _T62 = 2
    parm _T61
    parm _T62
    _T63 =  call _Math.max
    parm _T63
    call _PrintInt
    _T64 = "\n"
    parm _T64
    call _PrintString
    _T65 = 1
    _T66 = 2
    parm _T65
    parm _T66
    _T67 =  call _Math.min
    parm _T67
    call _PrintInt
    _T68 = "\n"
    parm _T68
    call _PrintString
}

