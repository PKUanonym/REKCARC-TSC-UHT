VTABLE(_Cow) {
    <empty>
    Cow
    _Cow.Init;
    _Cow.Moo;
}

VTABLE(_Main) {
    <empty>
    Main
}

FUNCTION(_Cow_New) {
memo ''
_Cow_New:
    _T6 = 12
    parm _T6
    _T7 =  call _Alloc
    _T8 = 0
    *(_T7 + 4) = _T8
    *(_T7 + 8) = _T8
    _T9 = VTBL <_Cow>
    *(_T7 + 0) = _T9
    return _T7
}

FUNCTION(_Main_New) {
memo ''
_Main_New:
    _T10 = 4
    parm _T10
    _T11 =  call _Alloc
    _T12 = VTBL <_Main>
    *(_T11 + 0) = _T12
    return _T11
}

FUNCTION(_Cow.Init) {
memo '_T2:4 _T3:8 _T4:12'
_Cow.Init:
    _T13 = *(_T2 + 8)
    *(_T2 + 8) = _T3
    _T14 = *(_T2 + 4)
    *(_T2 + 4) = _T4
}

FUNCTION(_Cow.Moo) {
memo '_T5:4'
_Cow.Moo:
    _T15 = *(_T5 + 4)
    parm _T15
    call _PrintInt
    _T16 = " "
    parm _T16
    call _PrintString
    _T17 = *(_T5 + 8)
    parm _T17
    call _PrintInt
    _T18 = "\n"
    parm _T18
    call _PrintString
}

FUNCTION(main) {
memo ''
main:
    _T20 =  call _Cow_New
    _T21 = 1
    _T0 = (_T0 + _T21)
    _T19 = _T20
    _T22 = 100
    _T23 = 122
    parm _T19
    parm _T22
    parm _T23
    _T24 = *(_T19 + 0)
    _T25 = *(_T24 + 8)
    call _T25
    parm _T19
    _T26 = *(_T19 + 0)
    _T27 = *(_T26 + 12)
    call _T27
}

