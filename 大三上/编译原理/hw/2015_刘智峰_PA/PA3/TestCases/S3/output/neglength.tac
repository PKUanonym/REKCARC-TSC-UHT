VTABLE(_Main) {
    <empty>
    Main
    _Main.create;
}

FUNCTION(_Main_New) {
memo ''
_Main_New:
    _T3 = 8
    parm _T3
    _T4 =  call _Alloc
    _T5 = 0
    *(_T4 + 4) = _T5
    _T6 = VTBL <_Main>
    *(_T4 + 0) = _T6
    return _T4
}

FUNCTION(main) {
memo ''
main:
    _T7 =  call _Main_New
    _T8 = 1
    _T0 = (_T0 + _T8)
    _T9 = 1
    _T10 = - _T9
    parm _T7
    parm _T10
    _T11 = *(_T7 + 0)
    _T12 = *(_T11 + 8)
    call _T12
}

FUNCTION(_Main.create) {
memo '_T1:4 _T2:8'
_Main.create:
    _T13 = *(_T1 + 4)
    _T14 = 0
    _T15 = (_T2 < _T14)
    if (_T15 == 0) branch _L11
    _T16 = "Decaf runtime error: Cannot create negative-sized array\n"
    parm _T16
    call _PrintString
    call _Halt
_L11:
    _T17 = 4
    _T18 = (_T17 * _T2)
    _T19 = (_T17 + _T18)
    parm _T19
    _T20 =  call _Alloc
    *(_T20 + 0) = _T2
    _T21 = 0
    _T20 = (_T20 + _T19)
_L12:
    _T19 = (_T19 - _T17)
    if (_T19 == 0) branch _L13
    _T20 = (_T20 - _T17)
    *(_T20 + 0) = _T21
    branch _L12
_L13:
    *(_T1 + 4) = _T20
}

