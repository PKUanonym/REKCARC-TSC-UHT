VTABLE(_Cow) {
    <empty>
    Cow
    _Cow.COPY;
    _Cow.Init;
    _Cow.Moo;
}

VTABLE(_Main) {
    <empty>
    Main
    _Main.COPY;
}

FUNCTION(_Cow_New) {
memo ''
_Cow_New:
    _T4 = 12
    parm _T4
    _T5 =  call _Alloc
    _T6 = 0
    *(_T5 + 4) = _T6
    *(_T5 + 8) = _T6
    _T7 = VTBL <_Cow>
    *(_T5 + 0) = _T7
    return _T5
}

FUNCTION(_Cow.COPY) {
memo '_T8:4'
_Cow.COPY:
    _T9 = 12
    parm _T9
    _T10 =  call _Alloc
    _T11 = *(_T8 + 4)
    *(_T10 + 4) = _T11
    _T12 = *(_T8 + 8)
    *(_T10 + 8) = _T12
    _T13 = VTBL <_Cow>
    *(_T10 + 0) = _T13
    return _T10
}

FUNCTION(_Main_New) {
memo ''
_Main_New:
    _T14 = 4
    parm _T14
    _T15 =  call _Alloc
    _T16 = VTBL <_Main>
    *(_T15 + 0) = _T16
    return _T15
}

FUNCTION(_Main.COPY) {
memo '_T17:4'
_Main.COPY:
    _T18 = 4
    parm _T18
    _T19 =  call _Alloc
    _T20 = VTBL <_Main>
    *(_T19 + 0) = _T20
    return _T19
}

FUNCTION(_Cow.Init) {
memo '_T0:4 _T1:8 _T2:12'
_Cow.Init:
    _T21 = *(_T0 + 8)
    *(_T0 + 8) = _T1
    _T22 = *(_T0 + 4)
    *(_T0 + 4) = _T2
}

FUNCTION(_Cow.Moo) {
memo '_T3:4'
_Cow.Moo:
    _T23 = *(_T3 + 4)
    parm _T23
    call _PrintInt
    _T24 = " "
    parm _T24
    call _PrintString
    _T25 = *(_T3 + 8)
    parm _T25
    call _PrintInt
    _T26 = "\n"
    parm _T26
    call _PrintString
}

FUNCTION(main) {
memo ''
main:
    _T28 =  call _Cow_New
    _T27 = _T28
    _T29 = 100
    _T30 = 122
    parm _T27
    parm _T29
    parm _T30
    _T31 = *(_T27 + 0)
    _T32 = *(_T31 + 12)
    call _T32
    parm _T27
    _T33 = *(_T27 + 0)
    _T34 = *(_T33 + 16)
    call _T34
}

