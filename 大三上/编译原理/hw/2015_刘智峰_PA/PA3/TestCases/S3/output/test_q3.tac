VTABLE(_Main) {
    <empty>
    Main
}

VTABLE(_Base) {
    <empty>
    Base
}

VTABLE(_Sub1) {
    _Base
    Sub1
}

VTABLE(_Sub2) {
    _Base
    Sub2
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

FUNCTION(_Base_New) {
memo ''
_Base_New:
    _T7 = 4
    parm _T7
    _T8 =  call _Alloc
    _T9 = VTBL <_Base>
    *(_T8 + 0) = _T9
    return _T8
}

FUNCTION(_Sub1_New) {
memo ''
_Sub1_New:
    _T10 = 4
    parm _T10
    _T11 =  call _Alloc
    _T12 = VTBL <_Sub1>
    *(_T11 + 0) = _T12
    return _T11
}

FUNCTION(_Sub2_New) {
memo ''
_Sub2_New:
    _T13 = 4
    parm _T13
    _T14 =  call _Alloc
    _T15 = VTBL <_Sub2>
    *(_T14 + 0) = _T15
    return _T14
}

FUNCTION(main) {
memo ''
main:
    _T18 = 0
    _T17 = _T18
    branch _L13
_L14:
    _T19 = 1
    _T20 = (_T17 + _T19)
    _T17 = _T20
_L13:
    _T21 = 10
    _T22 = (_T17 < _T21)
    if (_T22 == 0) branch _L15
    _T23 =  call _Base_New
    _T24 = 1
    _T1 = (_T1 + _T24)
    _T16 = _T23
    branch _L14
_L15:
    parm _T1
    call _PrintInt
    _T25 = "\n"
    parm _T25
    call _PrintString
    _T26 = 0
    _T17 = _T26
    branch _L16
_L17:
    _T27 = 1
    _T28 = (_T17 + _T27)
    _T17 = _T28
_L16:
    _T29 = 11
    _T30 = (_T17 < _T29)
    if (_T30 == 0) branch _L18
    _T31 =  call _Sub1_New
    _T32 = 1
    _T2 = (_T2 + _T32)
    _T16 = _T31
    branch _L17
_L18:
    parm _T2
    call _PrintInt
    _T33 = "\n"
    parm _T33
    call _PrintString
    _T34 = 0
    _T17 = _T34
    branch _L19
_L20:
    _T35 = 1
    _T36 = (_T17 + _T35)
    _T17 = _T36
_L19:
    _T37 = 12
    _T38 = (_T17 < _T37)
    if (_T38 == 0) branch _L21
    _T39 =  call _Sub2_New
    _T40 = 1
    _T3 = (_T3 + _T40)
    _T16 = _T39
    branch _L20
_L21:
    parm _T3
    call _PrintInt
    _T41 = "\n"
    parm _T41
    call _PrintString
    _T42 = "\n"
    parm _T42
    call _PrintString
    parm _T1
    call _PrintInt
    _T43 = "\n"
    parm _T43
    call _PrintString
    parm _T2
    call _PrintInt
    _T44 = "\n"
    parm _T44
    call _PrintString
    parm _T3
    call _PrintInt
    _T45 = "\n"
    parm _T45
    call _PrintString
}

