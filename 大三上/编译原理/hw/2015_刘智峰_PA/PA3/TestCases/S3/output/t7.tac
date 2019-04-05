VTABLE(_Computer) {
    <empty>
    Computer
    _Computer.Crash;
}

VTABLE(_Mac) {
    _Computer
    Mac
    _Mac.Crash;
}

VTABLE(_Main) {
    <empty>
    Main
}

FUNCTION(_Computer_New) {
memo ''
_Computer_New:
    _T7 = 8
    parm _T7
    _T8 =  call _Alloc
    _T9 = 0
    *(_T8 + 4) = _T9
    _T10 = VTBL <_Computer>
    *(_T8 + 0) = _T10
    return _T8
}

FUNCTION(_Mac_New) {
memo ''
_Mac_New:
    _T11 = 12
    parm _T11
    _T12 =  call _Alloc
    _T13 = 0
    *(_T12 + 4) = _T13
    *(_T12 + 8) = _T13
    _T14 = VTBL <_Mac>
    *(_T12 + 0) = _T14
    return _T12
}

FUNCTION(_Main_New) {
memo ''
_Main_New:
    _T15 = 4
    parm _T15
    _T16 =  call _Alloc
    _T17 = VTBL <_Main>
    *(_T16 + 0) = _T17
    return _T16
}

FUNCTION(_Computer.Crash) {
memo '_T3:4 _T4:8'
_Computer.Crash:
    _T19 = 0
    _T18 = _T19
    branch _L14
_L15:
    _T20 = 1
    _T21 = (_T18 + _T20)
    _T18 = _T21
_L14:
    _T22 = (_T18 < _T4)
    if (_T22 == 0) branch _L16
    _T23 = "sad\n"
    parm _T23
    call _PrintString
    branch _L15
_L16:
}

FUNCTION(_Mac.Crash) {
memo '_T5:4 _T6:8'
_Mac.Crash:
    _T24 = "ack!"
    parm _T24
    call _PrintString
}

FUNCTION(main) {
memo ''
main:
    _T26 =  call _Mac_New
    _T27 = 1
    _T1 = (_T1 + _T27)
    _T25 = _T26
    _T28 = 2
    parm _T25
    parm _T28
    _T29 = *(_T25 + 0)
    _T30 = *(_T29 + 8)
    call _T30
}

