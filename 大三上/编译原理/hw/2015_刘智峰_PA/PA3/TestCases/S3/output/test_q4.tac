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
    _T4 = 1
    if (_T4 == 0) branch _L11
    _T5 = "branch1\n"
    parm _T5
    call _PrintString
    branch _L10
_L11:
_L10:
    _T6 = 1
    if (_T6 == 0) branch _L12
    _T7 = "branch2\n"
    parm _T7
    call _PrintString
    branch _L10
_L12:
_L10:
    _T8 = 1
    if (_T8 == 0) branch _L13
    _T9 = "branch3\n"
    parm _T9
    call _PrintString
    branch _L10
_L13:
_L10:
    _T10 = 0
    if (_T10 == 0) branch _L15
    _T11 = "branch1\n"
    parm _T11
    call _PrintString
    branch _L14
_L15:
_L14:
    _T12 = 1
    if (_T12 == 0) branch _L16
    _T13 = "branch2\n"
    parm _T13
    call _PrintString
    branch _L14
_L16:
_L14:
    _T14 = 0
    if (_T14 == 0) branch _L17
    _T15 = "branch3\n"
    parm _T15
    call _PrintString
    branch _L14
_L17:
_L14:
    _T16 = 1
    if (_T16 == 0) branch _L18
    _T17 = "branch4\n"
    parm _T17
    call _PrintString
    branch _L14
_L18:
_L14:
    _T18 = 0
    if (_T18 == 0) branch _L20
    _T19 = "branch1\n"
    parm _T19
    call _PrintString
    branch _L19
_L20:
_L19:
    _T20 = 0
    if (_T20 == 0) branch _L21
    _T21 = "branch2\n"
    parm _T21
    call _PrintString
    branch _L19
_L21:
_L19:
    _T22 = 1
    if (_T22 == 0) branch _L22
    _T23 = "branch3\n"
    parm _T23
    call _PrintString
    branch _L19
_L22:
_L19:
    _T24 = 1
    if (_T24 == 0) branch _L23
    _T25 = "branch4\n"
    parm _T25
    call _PrintString
    branch _L19
_L23:
_L19:
}

