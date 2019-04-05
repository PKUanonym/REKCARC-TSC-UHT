VTABLE(_Main) {
    <empty>
    Main
}

FUNCTION(_Main_New) {
memo ''
_Main_New:
    _T1 = 4
    parm _T1
    _T2 =  call _Alloc
    _T3 = VTBL <_Main>
    *(_T2 + 0) = _T3
    return _T2
}

FUNCTION(main) {
memo ''
main:
    _T7 = 1
    _T5 = _T7
    _T8 = 2
    _T6 = _T8
    _T9 = 1
    _T4 = _T9
    _T10 = 3
    _T11 = (_T5 + _T10)
    _T12 = (_T11 >= _T6)
    _T13 = 0
    if (_T12 == 0) branch _L10
    _T14 = (_T5 + _T6)
    _T13 = _T14
    branch _L11
_L10:
    _T15 = (_T5 - _T6)
    _T13 = _T15
_L11:
    _T4 = _T13
    parm _T4
    call _PrintInt
    _T16 = "\n"
    parm _T16
    call _PrintString
    _T17 = 3
    _T18 = (_T5 + _T17)
    _T19 = (_T18 < _T6)
    _T20 = 0
    if (_T19 == 0) branch _L12
    _T21 = (_T5 + _T6)
    _T20 = _T21
    branch _L13
_L12:
    _T22 = (_T5 - _T6)
    _T20 = _T22
_L13:
    _T4 = _T20
    parm _T4
    call _PrintInt
    _T23 = "\n"
    parm _T23
    call _PrintString
}

