VTABLE(_Main) {
    <empty>
    Main
}

FUNCTION(_Main_New) {
memo ''
_Main_New:
    _T5 = 4
    parm _T5
    _T6 =  call _Alloc
    _T7 = VTBL <_Main>
    *(_T6 + 0) = _T7
    return _T6
}

FUNCTION(_Main.compareString) {
memo '_T1:4 _T2:8'
_Main.compareString:
    parm _T1
    parm _T2
    _T8 =  call _StringEqual
    if (_T8 == 0) branch _L12
    _T9 = "Equal"
    return _T9
    branch _L13
_L12:
    parm _T1
    parm _T2
    _T10 =  call _StringEqual
    _T11 = ! _T10
    if (_T11 == 0) branch _L14
    _T12 = "Unequal"
    return _T12
    branch _L15
_L14:
    _T13 = "The impossible happens!"
    return _T13
_L15:
_L13:
}

FUNCTION(_Main.printCompareString) {
memo '_T3:4 _T4:8'
_Main.printCompareString:
    _T14 = "\""
    parm _T14
    call _PrintString
    parm _T3
    call _PrintString
    _T15 = "\" and \""
    parm _T15
    call _PrintString
    parm _T4
    call _PrintString
    _T16 = "\": "
    parm _T16
    call _PrintString
    parm _T3
    parm _T4
    _T17 =  call _Main.compareString
    parm _T17
    call _PrintString
    _T18 = "\n"
    parm _T18
    call _PrintString
}

FUNCTION(main) {
memo ''
main:
    _T19 = "Jobs"
    _T20 = "Gates"
    parm _T19
    parm _T20
    call _Main.printCompareString
    _T21 = "case sensitive"
    _T22 = "CASE SENSITIVE"
    parm _T21
    parm _T22
    call _Main.printCompareString
    _T23 = "Hello"
    _T24 = "Hello"
    parm _T23
    parm _T24
    call _Main.printCompareString
}

