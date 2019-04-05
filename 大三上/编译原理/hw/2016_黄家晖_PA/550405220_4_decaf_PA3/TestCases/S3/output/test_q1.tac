VTABLE(_Main) {
    <empty>
    Main
    _Main.COPY;
}

FUNCTION(_Main_New) {
memo ''
_Main_New:
    _T4 = 4
    parm _T4
    _T5 =  call _Alloc
    _T6 = VTBL <_Main>
    *(_T5 + 0) = _T6
    return _T5
}

FUNCTION(_Main.COPY) {
memo '_T7:4'
_Main.COPY:
    _T8 = 4
    parm _T8
    _T9 =  call _Alloc
    _T10 = VTBL <_Main>
    *(_T9 + 0) = _T10
    return _T9
}

FUNCTION(_Main.max) {
memo '_T0:4 _T1:8'
_Main.max:
    _T12 = (_T0 > _T1)
    if (_T12 == 0) branch _L13
    _T11 = _T0
    branch _L14
_L13:
    _T11 = _T1
_L14:
    return _T11
}

FUNCTION(_Main.min) {
memo '_T2:4 _T3:8'
_Main.min:
    _T14 = (_T2 < _T3)
    if (_T14 == 0) branch _L15
    _T13 = _T2
    branch _L16
_L15:
    _T13 = _T3
_L16:
    return _T13
}

FUNCTION(main) {
memo ''
main:
    _T18 = 1
    _T15 = _T18
    _T19 = 2
    _T16 = _T19
    _T20 = 3
    _T17 = _T20
    _T22 = 3
    _T23 = (_T16 + _T22)
    _T24 = (_T23 >= _T17)
    if (_T24 == 0) branch _L17
    _T25 = (_T16 + _T17)
    _T21 = _T25
    branch _L18
_L17:
    _T26 = (_T16 - _T17)
    _T21 = _T26
_L18:
    _T15 = _T21
    parm _T15
    call _PrintInt
    _T27 = "\n"
    parm _T27
    call _PrintString
    _T29 = 3
    _T30 = (_T16 + _T29)
    _T31 = (_T30 < _T17)
    if (_T31 == 0) branch _L19
    _T32 = (_T16 + _T17)
    _T28 = _T32
    branch _L20
_L19:
    _T33 = (_T16 - _T17)
    _T28 = _T33
_L20:
    _T15 = _T28
    parm _T15
    call _PrintInt
    _T34 = "\n"
    parm _T34
    call _PrintString
    _T35 = 1234
    _T36 = 123
    parm _T35
    parm _T36
    _T37 =  call _Main.min
    parm _T37
    call _PrintInt
    _T38 = "\n"
    parm _T38
    call _PrintString
    _T39 = 335
    _T40 = 456
    parm _T39
    parm _T40
    _T41 =  call _Main.min
    parm _T41
    call _PrintInt
    _T42 = "\n"
    parm _T42
    call _PrintString
    _T43 = 22
    _T44 = 33
    parm _T43
    parm _T44
    _T45 =  call _Main.max
    parm _T45
    call _PrintInt
    _T46 = "\n"
    parm _T46
    call _PrintString
    _T47 = 34
    _T48 = 13
    parm _T47
    parm _T48
    _T49 =  call _Main.max
    parm _T49
    call _PrintInt
    _T50 = "\n"
    parm _T50
    call _PrintString
}

