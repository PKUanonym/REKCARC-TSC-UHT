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
_L11:
    _T9 = 1
    _T10 = (_T7 + _T9)
    _T7 = _T10
    parm _T7
    call _PrintInt
    _T11 = "\n"
    parm _T11
    call _PrintString
_L12:
    _T12 = 1
    _T13 = (_T7 + _T12)
    _T14 = 10
    _T15 = 3
    _T16 = (_T14 - _T15)
    _T17 = 2
    _T18 = (_T16 + _T17)
    _T19 = 3
    _T20 = (_T18 + _T19)
    _T21 = 4
    _T22 = (_T20 - _T21)
    _T23 = (_T13 >= _T22)
    if (_T23 != 0) branch _L13
    branch _L11
_L13:
    parm _T7
    call _PrintInt
    _T24 = "\n\n"
    parm _T24
    call _PrintString
    _T25 = 0
    _T7 = _T25
_L14:
    _T26 = 1
    _T27 = (_T7 + _T26)
    _T7 = _T27
    _T28 = 8
    _T29 = (_T7 > _T28)
    if (_T29 == 0) branch _L17
    branch _L16
_L17:
    _T30 = 5
    _T31 = (_T7 > _T30)
    if (_T31 == 0) branch _L18
    branch _L15
_L18:
    parm _T7
    call _PrintInt
    _T32 = "\n"
    parm _T32
    call _PrintString
_L15:
    _T33 = 10
    _T34 = (_T7 >= _T33)
    if (_T34 != 0) branch _L16
    branch _L14
_L16:
    parm _T7
    call _PrintInt
    _T35 = "\n\n"
    parm _T35
    call _PrintString
    _T36 = 0
    _T7 = _T36
_L19:
    _T37 = 1
    _T38 = (_T7 + _T37)
    _T7 = _T38
    _T39 = 8
    _T40 = (_T7 > _T39)
    if (_T40 == 0) branch _L22
    branch _L21
_L22:
    _T41 = 5
    _T42 = (_T7 > _T41)
    if (_T42 == 0) branch _L23
    branch _L20
_L23:
    parm _T7
    call _PrintInt
    _T43 = "\n"
    parm _T43
    call _PrintString
_L20:
    _T44 = 0
    _T45 = (_T7 > _T44)
    if (_T45 != 0) branch _L21
    branch _L19
_L21:
    parm _T7
    call _PrintInt
    _T46 = "\n\n"
    parm _T46
    call _PrintString
}

