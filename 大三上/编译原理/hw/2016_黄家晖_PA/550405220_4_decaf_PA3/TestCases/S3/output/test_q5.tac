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
    _T9 = 10
    _T10 = (_T7 < _T9)
    if (_T10 == 0) branch _L12
    _T11 = 1
    _T12 = (_T7 + _T11)
    _T7 = _T12
    _T13 = 5
    _T14 = (_T7 > _T13)
    if (_T14 == 0) branch _L13
    branch _L11
_L13:
    parm _T7
    call _PrintInt
    _T15 = "\n"
    parm _T15
    call _PrintString
    branch _L11
_L12:
    parm _T7
    call _PrintInt
    _T16 = "\n\n"
    parm _T16
    call _PrintString
    _T17 = 0
    _T7 = _T17
    _T18 = 0
    _T7 = _T18
    branch _L14
_L15:
    _T19 = 2
    _T20 = (_T7 + _T19)
    _T7 = _T20
_L14:
    _T21 = 34
    _T22 = (_T7 < _T21)
    if (_T22 == 0) branch _L16
    _T23 = 15
    _T24 = (_T7 > _T23)
    if (_T24 == 0) branch _L17
    branch _L15
_L17:
    parm _T7
    call _PrintInt
    _T25 = "\n"
    parm _T25
    call _PrintString
    branch _L15
_L16:
    parm _T7
    call _PrintInt
    _T26 = "\n\n"
    parm _T26
    call _PrintString
    _T27 = 0
    _T7 = _T27
_L18:
    _T28 = 1
    _T29 = (_T7 + _T28)
    _T7 = _T29
    _T30 = 13
    _T31 = (_T7 > _T30)
    if (_T31 == 0) branch _L21
    branch _L19
_L21:
    parm _T7
    call _PrintInt
    _T32 = "\n"
    parm _T32
    call _PrintString
_L19:
    _T33 = 30
    _T34 = (_T7 >= _T33)
    if (_T34 != 0) branch _L20
    branch _L18
_L20:
    parm _T7
    call _PrintInt
    _T35 = "\n\n"
    parm _T35
    call _PrintString
}

