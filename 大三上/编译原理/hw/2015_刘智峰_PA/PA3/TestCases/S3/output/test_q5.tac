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
    _T7 = 3
    _T4 = _T7
    _T8 = 2
    _T5 = _T8
    _T9 = 1
    _T6 = _T9
_L10:
    _T10 = 0
    _T11 = (_T4 >= _T10)
    if (_T11 == 0) branch _L12
    _T12 = 1
    _T13 = (_T4 - _T12)
    _T4 = _T13
    _T14 = "branch1\n"
    parm _T14
    call _PrintString
    branch _L10
_L12:
    _T15 = 0
    _T16 = (_T5 >= _T15)
    if (_T16 == 0) branch _L13
    _T17 = 1
    _T18 = (_T5 - _T17)
    _T5 = _T18
    _T19 = "branch2\n"
    parm _T19
    call _PrintString
    branch _L10
_L13:
    _T20 = 0
    _T21 = (_T6 >= _T20)
    if (_T21 == 0) branch _L14
    _T22 = 1
    _T23 = (_T6 - _T22)
    _T6 = _T23
    _T24 = "branch3\n"
    parm _T24
    call _PrintString
    branch _L10
_L14:
_L11:
    _T25 = "\n"
    parm _T25
    call _PrintString
    _T26 = 3
    _T4 = _T26
    _T27 = 2
    _T5 = _T27
    _T28 = 1
    _T6 = _T28
_L15:
    _T29 = 0
    _T30 = (_T4 >= _T29)
    if (_T30 == 0) branch _L17
    _T31 = 1
    _T32 = (_T4 - _T31)
    _T4 = _T32
    _T33 = "branch1\n"
    parm _T33
    call _PrintString
    branch _L15
_L17:
    _T34 = 0
    _T35 = (_T5 >= _T34)
    if (_T35 == 0) branch _L18
    _T36 = 1
    _T37 = (_T5 - _T36)
    _T5 = _T37
    _T38 = "branch2\n"
    parm _T38
    call _PrintString
    _T39 = 1
    _T40 = (_T5 == _T39)
    if (_T40 == 0) branch _L19
    branch _L16
_L19:
    branch _L15
_L18:
    _T41 = 0
    _T42 = (_T6 >= _T41)
    if (_T42 == 0) branch _L20
    _T43 = 1
    _T44 = (_T6 - _T43)
    _T6 = _T44
    _T45 = "branch3\n"
    parm _T45
    call _PrintString
    branch _L15
_L20:
_L16:
}

