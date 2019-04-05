VTABLE(_Main) {
    <empty>
    Main
    _Main.COPY;
}

FUNCTION(_Main_New) {
memo ''
_Main_New:
    _T4 = 4
    parm _T4
    _T5 =  call _Alloc
    _T6 = VTBL <_Main>
    *(_T5 + 0) = _T6
    return _T5
}

FUNCTION(_Main.COPY) {
memo '_T7:4'
_Main.COPY:
    _T8 = 4
    parm _T8
    _T9 =  call _Alloc
    _T10 = VTBL <_Main>
    *(_T9 + 0) = _T10
    return _T9
}

FUNCTION(_Main.compareString) {
memo '_T0:4 _T1:8'
_Main.compareString:
    parm _T0
    parm _T1
    _T11 =  call _StringEqual
    if (_T11 == 0) branch _L13
    _T12 = "Equal"
    return _T12
    branch _L14
_L13:
    parm _T0
    parm _T1
    _T13 =  call _StringEqual
    _T14 = ! _T13
    if (_T14 == 0) branch _L15
    _T15 = "Unequal"
    return _T15
    branch _L16
_L15:
    _T16 = "The impossible happens!"
    return _T16
_L16:
_L14:
}

FUNCTION(_Main.printCompareString) {
memo '_T2:4 _T3:8'
_Main.printCompareString:
    _T17 = "\""
    parm _T17
    call _PrintString
    parm _T2
    call _PrintString
    _T18 = "\" and \""
    parm _T18
    call _PrintString
    parm _T3
    call _PrintString
    _T19 = "\": "
    parm _T19
    call _PrintString
    parm _T2
    parm _T3
    _T20 =  call _Main.compareString
    parm _T20
    call _PrintString
    _T21 = "\n"
    parm _T21
    call _PrintString
}

FUNCTION(main) {
memo ''
main:
    _T22 = "Jobs"
    _T23 = "Gates"
    parm _T22
    parm _T23
    call _Main.printCompareString
    _T24 = "case sensitive"
    _T25 = "CASE SENSITIVE"
    parm _T24
    parm _T25
    call _Main.printCompareString
    _T26 = "Hello"
    _T27 = "Hello"
    parm _T26
    parm _T27
    call _Main.printCompareString
}

