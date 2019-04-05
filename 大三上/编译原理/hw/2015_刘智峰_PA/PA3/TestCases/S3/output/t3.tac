VTABLE(_Main) {
    <empty>
    Main
}

FUNCTION(_Main_New) {
memo ''
_Main_New:
    _T3 = 4
    parm _T3
    _T4 =  call _Alloc
    _T5 = VTBL <_Main>
    *(_T4 + 0) = _T5
    return _T4
}

FUNCTION(main) {
memo ''
main:
    _T8 = "hello"
    _T7 = _T8
    _T9 = 4
    _T10 = 5
    parm _T9
    parm _T10
    _T11 =  call _Main.test
    _T6 = _T11
    parm _T6
    call _PrintInt
    parm _T7
    call _PrintString
}

FUNCTION(_Main.test) {
memo '_T1:4 _T2:8'
_Main.test:
    _T12 = (_T1 + _T2)
    return _T12
}

