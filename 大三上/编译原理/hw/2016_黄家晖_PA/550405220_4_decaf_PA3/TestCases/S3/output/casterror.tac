VTABLE(_Main) {
    <empty>
    Main
    _Main.COPY;
}

VTABLE(_A) {
    _Main
    A
    _A.COPY;
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

FUNCTION(_A_New) {
memo ''
_A_New:
    _T7 = 4
    parm _T7
    _T8 =  call _Alloc
    _T9 = VTBL <_A>
    *(_T8 + 0) = _T9
    return _T8
}

FUNCTION(_A.COPY) {
memo '_T10:4'
_A.COPY:
    _T11 = 4
    parm _T11
    _T12 =  call _Alloc
    _T13 = VTBL <_A>
    *(_T12 + 0) = _T13
    return _T12
}

FUNCTION(main) {
memo ''
main:
    _T15 =  call _Main_New
    _T14 = _T15
    _T18 = VTBL <_A>
    _T19 = *(_T14 + 0)
_L13:
    _T17 = (_T18 == _T19)
    if (_T17 != 0) branch _L14
    _T19 = *(_T19 + 0)
    if (_T19 != 0) branch _L13
    _T20 = "Decaf runtime error: "
    parm _T20
    call _PrintString
    _T21 = *(_T14 + 0)
    _T22 = *(_T21 + 4)
    parm _T22
    call _PrintString
    _T23 = " cannot be cast to "
    parm _T23
    call _PrintString
    _T24 = VTBL <_A>
    _T25 = *(_T24 + 4)
    parm _T25
    call _PrintString
    _T26 = "\n"
    parm _T26
    call _PrintString
    call _Halt
_L14:
    _T16 = _T14
}

