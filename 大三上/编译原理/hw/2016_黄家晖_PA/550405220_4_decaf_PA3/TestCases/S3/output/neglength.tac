VTABLE(_Main) {
    <empty>
    Main
    _Main.COPY;
    _Main.create;
}

FUNCTION(_Main_New) {
memo ''
_Main_New:
    _T2 = 8
    parm _T2
    _T3 =  call _Alloc
    _T4 = 0
    *(_T3 + 4) = _T4
    _T5 = VTBL <_Main>
    *(_T3 + 0) = _T5
    return _T3
}

FUNCTION(_Main.COPY) {
memo '_T6:4'
_Main.COPY:
    _T7 = 8
    parm _T7
    _T8 =  call _Alloc
    _T9 = *(_T6 + 4)
    *(_T8 + 4) = _T9
    _T10 = VTBL <_Main>
    *(_T8 + 0) = _T10
    return _T8
}

FUNCTION(main) {
memo ''
main:
    _T11 =  call _Main_New
    _T12 = 1
    _T13 = - _T12
    parm _T11
    parm _T13
    _T14 = *(_T11 + 0)
    _T15 = *(_T14 + 12)
    call _T15
}

FUNCTION(_Main.create) {
memo '_T0:4 _T1:8'
_Main.create:
    _T16 = *(_T0 + 4)
    _T17 = 0
    _T18 = (_T1 < _T17)
    if (_T18 == 0) branch _L12
    _T19 = "Decaf runtime error: Cannot create negative-sized array\n"
    parm _T19
    call _PrintString
    call _Halt
_L12:
    _T20 = 4
    _T21 = (_T20 * _T1)
    _T22 = (_T20 + _T21)
    parm _T22
    _T23 =  call _Alloc
    *(_T23 + 0) = _T1
    _T24 = 0
    _T23 = (_T23 + _T22)
_L13:
    _T22 = (_T22 - _T20)
    if (_T22 == 0) branch _L14
    _T23 = (_T23 - _T20)
    *(_T23 + 0) = _T24
    branch _L13
_L14:
    *(_T0 + 4) = _T23
}

