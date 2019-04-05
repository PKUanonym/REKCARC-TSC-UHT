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
    _T5 = "testing division by 0 runtime error1\n"
    parm _T5
    call _PrintString
    _T6 = 13
    _T7 = 0
    _T8 = 0
    _T9 = (_T7 == _T8)
    if (_T9 == 0) branch _L10
    _T10 = "Decaf runtime error: Division by zero error.\n"
    parm _T10
    call _PrintString
    call _Halt
_L10:
    _T11 = (_T6 / _T7)
    _T4 = _T11
    _T12 = "end"
    parm _T12
    call _PrintString
}

