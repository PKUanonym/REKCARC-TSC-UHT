VTABLE(_Computer) {
    <empty>
    Computer
    _Computer.COPY;
    _Computer.Crash;
}

VTABLE(_Mac) {
    _Computer
    Mac
    _Mac.COPY;
    _Mac.Crash;
}

VTABLE(_Main) {
    <empty>
    Main
    _Main.COPY;
}

FUNCTION(_Computer_New) {
memo ''
_Computer_New:
    _T4 = 8
    parm _T4
    _T5 =  call _Alloc
    _T6 = 0
    *(_T5 + 4) = _T6
    _T7 = VTBL <_Computer>
    *(_T5 + 0) = _T7
    return _T5
}

FUNCTION(_Computer.COPY) {
memo '_T8:4'
_Computer.COPY:
    _T9 = 8
    parm _T9
    _T10 =  call _Alloc
    _T11 = *(_T8 + 4)
    *(_T10 + 4) = _T11
    _T12 = VTBL <_Computer>
    *(_T10 + 0) = _T12
    return _T10
}

FUNCTION(_Mac_New) {
memo ''
_Mac_New:
    _T13 = 12
    parm _T13
    _T14 =  call _Alloc
    _T15 = 0
    *(_T14 + 4) = _T15
    *(_T14 + 8) = _T15
    _T16 = VTBL <_Mac>
    *(_T14 + 0) = _T16
    return _T14
}

FUNCTION(_Mac.COPY) {
memo '_T17:4'
_Mac.COPY:
    _T18 = 12
    parm _T18
    _T19 =  call _Alloc
    _T20 = *(_T17 + 4)
    *(_T19 + 4) = _T20
    _T21 = *(_T17 + 8)
    *(_T19 + 8) = _T21
    _T22 = VTBL <_Mac>
    *(_T19 + 0) = _T22
    return _T19
}

FUNCTION(_Main_New) {
memo ''
_Main_New:
    _T23 = 4
    parm _T23
    _T24 =  call _Alloc
    _T25 = VTBL <_Main>
    *(_T24 + 0) = _T25
    return _T24
}

FUNCTION(_Main.COPY) {
memo '_T26:4'
_Main.COPY:
    _T27 = 4
    parm _T27
    _T28 =  call _Alloc
    _T29 = VTBL <_Main>
    *(_T28 + 0) = _T29
    return _T28
}

FUNCTION(_Computer.Crash) {
memo '_T0:4 _T1:8'
_Computer.Crash:
    _T31 = 0
    _T30 = _T31
    branch _L17
_L18:
    _T32 = 1
    _T33 = (_T30 + _T32)
    _T30 = _T33
_L17:
    _T34 = (_T30 < _T1)
    if (_T34 == 0) branch _L19
    _T35 = "sad\n"
    parm _T35
    call _PrintString
    branch _L18
_L19:
}

FUNCTION(_Mac.Crash) {
memo '_T2:4 _T3:8'
_Mac.Crash:
    _T36 = "ack!"
    parm _T36
    call _PrintString
}

FUNCTION(main) {
memo ''
main:
    _T38 =  call _Mac_New
    _T37 = _T38
    _T39 = 2
    parm _T37
    parm _T39
    _T40 = *(_T37 + 0)
    _T41 = *(_T40 + 12)
    call _T41
}

