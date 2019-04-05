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
    _T8 = "testing division by 0 runtime error1\n"
    parm _T8
    call _PrintString
    _T9 = 13
    _T10 = 0
    _T11 = 0
    _T12 = (_T10 == _T11)
    if (_T12 == 0) branch _L11
    _T13 = "Decaf runtime error: Division by zero error.\n"
    parm _T13
    call _PrintString
    call _Halt
_L11:
    _T14 = (_T9 / _T10)
    _T7 = _T14
    _T15 = "end"
    parm _T15
    call _PrintString
}

