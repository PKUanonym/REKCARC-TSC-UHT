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
    _T5 = 2
    _T6 = 0
    _T7 = (_T5 < _T6)
    if (_T7 == 0) branch _L10
    _T8 = "Decaf runtime error: Cannot create negative-sized array\n"
    parm _T8
    call _PrintString
    call _Halt
_L10:
    _T9 = 4
    _T10 = (_T9 * _T5)
    _T11 = (_T9 + _T10)
    parm _T11
    _T12 =  call _Alloc
    *(_T12 + 0) = _T5
    _T13 = 0
    _T12 = (_T12 + _T11)
_L11:
    _T11 = (_T11 - _T9)
    if (_T11 == 0) branch _L12
    _T12 = (_T12 - _T9)
    *(_T12 + 0) = _T13
    branch _L11
_L12:
    _T4 = _T12
    _T14 = 2
    _T15 = *(_T4 - 4)
    _T16 = (_T14 < _T15)
    if (_T16 == 0) branch _L13
    _T17 = 0
    _T18 = (_T14 < _T17)
    if (_T18 == 0) branch _L14
_L13:
    _T19 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T19
    call _PrintString
    call _Halt
_L14:
    _T20 = 4
    _T21 = (_T14 * _T20)
    _T22 = (_T4 + _T21)
    _T23 = *(_T22 + 0)
    _T24 = 0
    _T25 = 4
    _T26 = (_T14 * _T25)
    _T27 = (_T4 + _T26)
    *(_T27 + 0) = _T24
}

