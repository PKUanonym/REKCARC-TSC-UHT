VTABLE(_Main) {
    <empty>
    Main
    _Main.COPY;
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

FUNCTION(_Main.COPY) {
memo '_T5:4'
_Main.COPY:
    _T6 = 4
    parm _T6
    _T7 =  call _Alloc
    _T8 = VTBL <_Main>
    *(_T7 + 0) = _T8
    return _T7
}

FUNCTION(main) {
memo ''
main:
    _T11 = "hello"
    _T10 = _T11
    _T12 = 4
    _T13 = 5
    parm _T12
    parm _T13
    _T14 =  call _Main.test
    _T9 = _T14
    parm _T9
    call _PrintInt
    parm _T10
    call _PrintString
}

FUNCTION(_Main.test) {
memo '_T0:4 _T1:8'
_Main.test:
    _T15 = (_T0 + _T1)
    return _T15
}

