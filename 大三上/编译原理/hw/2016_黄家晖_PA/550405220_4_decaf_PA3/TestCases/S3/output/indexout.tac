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
    _T8 = 2
    _T9 = 0
    _T10 = (_T8 < _T9)
    if (_T10 == 0) branch _L11
    _T11 = "Decaf runtime error: Cannot create negative-sized array\n"
    parm _T11
    call _PrintString
    call _Halt
_L11:
    _T12 = 4
    _T13 = (_T12 * _T8)
    _T14 = (_T12 + _T13)
    parm _T14
    _T15 =  call _Alloc
    *(_T15 + 0) = _T8
    _T16 = 0
    _T15 = (_T15 + _T14)
_L12:
    _T14 = (_T14 - _T12)
    if (_T14 == 0) branch _L13
    _T15 = (_T15 - _T12)
    *(_T15 + 0) = _T16
    branch _L12
_L13:
    _T7 = _T15
    _T17 = 2
    _T18 = *(_T7 - 4)
    _T19 = (_T17 < _T18)
    if (_T19 == 0) branch _L14
    _T20 = 0
    _T21 = (_T17 < _T20)
    if (_T21 == 0) branch _L15
_L14:
    _T22 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T22
    call _PrintString
    call _Halt
_L15:
    _T23 = 4
    _T24 = (_T17 * _T23)
    _T25 = (_T7 + _T24)
    _T26 = *(_T25 + 0)
    _T27 = 0
    _T28 = 4
    _T29 = (_T17 * _T28)
    _T30 = (_T7 + _T29)
    *(_T30 + 0) = _T27
}

