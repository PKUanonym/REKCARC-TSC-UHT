VTABLE(_Main) {
    <empty>
    Main
}

VTABLE(_A) {
    _Main
    A
}

FUNCTION(_Main_New) {
memo ''
_Main_New:
    _T2 = 4
    parm _T2
    _T3 =  call _Alloc
    _T4 = VTBL <_Main>
    *(_T3 + 0) = _T4
    return _T3
}

FUNCTION(_A_New) {
memo ''
_A_New:
    _T5 = 4
    parm _T5
    _T6 =  call _Alloc
    _T7 = VTBL <_A>
    *(_T6 + 0) = _T7
    return _T6
}

FUNCTION(main) {
memo ''
main:
    _T9 =  call _Main_New
    _T10 = 1
    _T0 = (_T0 + _T10)
    _T8 = _T9
    _T13 = VTBL <_A>
    _T14 = *(_T8 + 0)
_L11:
    _T12 = (_T13 == _T14)
    if (_T12 != 0) branch _L12
    _T14 = *(_T14 + 0)
    if (_T14 != 0) branch _L11
    _T15 = "Decaf runtime error: "
    parm _T15
    call _PrintString
    _T16 = *(_T8 + 0)
    _T17 = *(_T16 + 4)
    parm _T17
    call _PrintString
    _T18 = " cannot be cast to "
    parm _T18
    call _PrintString
    _T19 = VTBL <_A>
    _T20 = *(_T19 + 4)
    parm _T20
    call _PrintString
    _T21 = "\n"
    parm _T21
    call _PrintString
    call _Halt
_L12:
    _T11 = _T8
}

