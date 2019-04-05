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
    _T7 = 4
    _T5 = _T7
    _T8 = 1
    _T6 = _T8
    _T9 = 9
    _T4 = _T9
_L10:
    _T10 = 0
    _T11 = (_T5 > _T10)
    if (_T11 == 0) branch _L12
    _T12 = " "
    parm _T12
    call _PrintString
    _T13 = 1
    _T14 = (_T5 - _T13)
    _T5 = _T14
    branch _L10
_L12:
    _T15 = 0
    _T16 = (_T6 > _T15)
    if (_T16 == 0) branch _L13
    _T17 = "#"
    parm _T17
    call _PrintString
    _T18 = 1
    _T19 = (_T6 - _T18)
    _T6 = _T19
    branch _L10
_L13:
    _T20 = 0
    _T21 = (_T4 > _T20)
    if (_T21 == 0) branch _L14
    _T22 = "\n"
    parm _T22
    call _PrintString
    _T23 = 1
    _T24 = (_T4 - _T23)
    _T4 = _T24
    _T25 = 5
    _T26 = (_T4 >= _T25)
    if (_T26 == 0) branch _L15
    _T27 = 5
    _T28 = (_T4 - _T27)
    _T5 = _T28
    _T29 = 2
    _T30 = 10
    _T31 = (_T30 - _T4)
    _T32 = (_T29 * _T31)
    _T33 = 1
    _T34 = (_T32 - _T33)
    _T6 = _T34
    branch _L16
_L15:
    _T35 = 5
    _T36 = (_T35 - _T4)
    _T5 = _T36
    _T37 = 2
    _T38 = (_T37 * _T4)
    _T39 = 1
    _T40 = (_T38 - _T39)
    _T6 = _T40
_L16:
    branch _L10
_L14:
_L11:
}

