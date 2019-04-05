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
    _T6 = _T7
    _T8 = "wow!"
    _T5 = _T8
    _T9 = 3
    _T4 = _T9
    if (_T6 == 0) branch _L10
    _T10 = 5
    _T11 = (_T4 * _T10)
    _T4 = _T11
_L10:
    parm _T6
    call _PrintBool
    _T12 = " "
    parm _T12
    call _PrintString
    parm _T4
    call _PrintInt
}

