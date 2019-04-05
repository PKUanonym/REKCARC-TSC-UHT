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
    _T5 = 0
    _T4 = _T5
    _T6 = 0
    _T7 = (_T4 + _T6)
    _T8 = 1
    _T9 = (_T4 + _T8)
    _T4 = _T9
    parm _T7
    call _PrintInt
    _T10 = "\n"
    parm _T10
    call _PrintString
    parm _T4
    call _PrintInt
    _T11 = "\n"
    parm _T11
    call _PrintString
    _T12 = 1
    _T13 = (_T4 + _T12)
    _T14 = 1
    _T15 = (_T4 + _T14)
    _T4 = _T15
    parm _T13
    call _PrintInt
    _T16 = "\n"
    parm _T16
    call _PrintString
    parm _T4
    call _PrintInt
    _T17 = "\n"
    parm _T17
    call _PrintString
    _T18 = 0
    _T19 = (_T4 - _T18)
    _T20 = 1
    _T21 = (_T4 - _T20)
    _T4 = _T21
    parm _T19
    call _PrintInt
    _T22 = "\n"
    parm _T22
    call _PrintString
    parm _T4
    call _PrintInt
    _T23 = "\n"
    parm _T23
    call _PrintString
    _T24 = 1
    _T25 = (_T4 - _T24)
    _T26 = 1
    _T27 = (_T4 - _T26)
    _T4 = _T27
    parm _T25
    call _PrintInt
    _T28 = "\n"
    parm _T28
    call _PrintString
    parm _T4
    call _PrintInt
    _T29 = "\n"
    parm _T29
    call _PrintString
}

