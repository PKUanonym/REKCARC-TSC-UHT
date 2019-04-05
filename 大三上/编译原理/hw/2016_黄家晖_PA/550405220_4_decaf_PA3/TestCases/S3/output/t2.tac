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
    _T10 = 1
    _T9 = _T10
    _T11 = "wow!"
    _T8 = _T11
    _T12 = 3
    _T7 = _T12
    if (_T9 == 0) branch _L11
    _T13 = 5
    _T14 = (_T7 * _T13)
    _T7 = _T14
_L11:
    parm _T9
    call _PrintBool
    _T15 = " "
    parm _T15
    call _PrintString
    parm _T7
    call _PrintInt
}

