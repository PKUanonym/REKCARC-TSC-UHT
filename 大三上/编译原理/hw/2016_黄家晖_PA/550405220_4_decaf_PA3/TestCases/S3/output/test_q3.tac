VTABLE(_Main) {
    <empty>
    Main
    _Main.COPY;
}

FUNCTION(_Main_New) {
memo ''
_Main_New:
    _T0 = 4
    parm _T0
    _T1 =  call _Alloc
    _T2 = VTBL <_Main>
    *(_T1 + 0) = _T2
    return _T1
}

FUNCTION(_Main.COPY) {
memo '_T3:4'
_Main.COPY:
    _T4 = 4
    parm _T4
    _T5 =  call _Alloc
    _T6 = VTBL <_Main>
    *(_T5 + 0) = _T6
    return _T5
}

FUNCTION(main) {
memo ''
main:
    _T8 = 0
    _T7 = _T8
    _T9 = 0
    _T7 = _T9
    branch _L11
_L12:
    _T10 = 1
    _T11 = (_T7 + _T10)
    _T7 = _T11
_L11:
    _T12 = 10
    _T13 = (_T7 <= _T12)
    if (_T13 == 0) branch _L13
    _T14 = 1
    _T15 = (_T7 == _T14)
    if (_T15 != 0) branch _L14
    _T16 = 2
    _T17 = (_T7 == _T16)
    if (_T17 != 0) branch _L15
    _T18 = 3
    _T19 = (_T7 == _T18)
    if (_T19 != 0) branch _L16
    _T20 = 4
    _T21 = (_T7 == _T20)
    if (_T21 != 0) branch _L17
    _T22 = 5
    _T23 = (_T7 == _T22)
    if (_T23 != 0) branch _L18
    _T24 = 6
    _T25 = (_T7 == _T24)
    if (_T25 != 0) branch _L19
    _T26 = 7
    _T27 = (_T7 == _T26)
    if (_T27 != 0) branch _L20
    _T28 = 8
    _T29 = (_T7 == _T28)
    if (_T29 != 0) branch _L21
    branch _L22
_L14:
    _T30 = "case 1:\n"
    parm _T30
    call _PrintString
_L15:
    _T31 = "case 2:\n"
    parm _T31
    call _PrintString
_L16:
    _T32 = "case 3:\n"
    parm _T32
    call _PrintString
    branch _L23
_L17:
_L18:
_L19:
    _T33 = "yes "
    parm _T33
    call _PrintString
    parm _T7
    call _PrintInt
    _T34 = "\n"
    parm _T34
    call _PrintString
    branch _L23
_L20:
    _T35 = "case 7:\n"
    parm _T35
    call _PrintString
    branch _L23
    parm _T7
    call _PrintInt
    _T36 = " no\n"
    parm _T36
    call _PrintString
_L21:
    _T37 = "case 8:\n"
    parm _T37
    call _PrintString
_L22:
    _T38 = "default:1\n"
    parm _T38
    call _PrintString
    _T39 = "default:2\n"
    parm _T39
    call _PrintString
    branch _L23
    _T40 = "default:3\n"
    parm _T40
    call _PrintString
_L23:
    branch _L12
_L13:
}

