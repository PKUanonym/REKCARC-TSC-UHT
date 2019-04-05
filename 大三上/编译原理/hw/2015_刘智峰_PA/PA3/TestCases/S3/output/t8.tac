VTABLE(_Animal) {
    <empty>
    Animal
    _Animal.InitAnimal;
    _Animal.GetHeight;
    _Animal.GetMom;
}

VTABLE(_Cow) {
    _Animal
    Cow
    _Animal.InitAnimal;
    _Animal.GetHeight;
    _Animal.GetMom;
    _Cow.InitCow;
    _Cow.IsSpottedCow;
}

VTABLE(_Main) {
    <empty>
    Main
}

FUNCTION(_Animal_New) {
memo ''
_Animal_New:
    _T13 = 12
    parm _T13
    _T14 =  call _Alloc
    _T15 = 0
    *(_T14 + 4) = _T15
    *(_T14 + 8) = _T15
    _T16 = VTBL <_Animal>
    *(_T14 + 0) = _T16
    return _T14
}

FUNCTION(_Cow_New) {
memo ''
_Cow_New:
    _T17 = 16
    parm _T17
    _T18 =  call _Alloc
    _T19 = 0
    *(_T18 + 4) = _T19
    *(_T18 + 8) = _T19
    *(_T18 + 12) = _T19
    _T20 = VTBL <_Cow>
    *(_T18 + 0) = _T20
    return _T18
}

FUNCTION(_Main_New) {
memo ''
_Main_New:
    _T21 = 4
    parm _T21
    _T22 =  call _Alloc
    _T23 = VTBL <_Main>
    *(_T22 + 0) = _T23
    return _T22
}

FUNCTION(_Animal.InitAnimal) {
memo '_T3:4 _T4:8 _T5:12'
_Animal.InitAnimal:
    _T24 = *(_T3 + 4)
    *(_T3 + 4) = _T4
    _T25 = *(_T3 + 8)
    *(_T3 + 8) = _T5
}

FUNCTION(_Animal.GetHeight) {
memo '_T6:4'
_Animal.GetHeight:
    _T26 = *(_T6 + 4)
    return _T26
}

FUNCTION(_Animal.GetMom) {
memo '_T7:4'
_Animal.GetMom:
    _T27 = *(_T7 + 8)
    return _T27
}

FUNCTION(_Cow.InitCow) {
memo '_T8:4 _T9:8 _T10:12 _T11:16'
_Cow.InitCow:
    _T28 = *(_T8 + 12)
    *(_T8 + 12) = _T11
    parm _T8
    parm _T9
    parm _T10
    _T29 = *(_T8 + 0)
    _T30 = *(_T29 + 8)
    call _T30
}

FUNCTION(_Cow.IsSpottedCow) {
memo '_T12:4'
_Cow.IsSpottedCow:
    _T31 = *(_T12 + 12)
    return _T31
}

FUNCTION(main) {
memo ''
main:
    _T34 =  call _Cow_New
    _T35 = 1
    _T1 = (_T1 + _T35)
    _T32 = _T34
    _T36 = 5
    _T37 = 0
    _T38 = 1
    parm _T32
    parm _T36
    parm _T37
    parm _T38
    _T39 = *(_T32 + 0)
    _T40 = *(_T39 + 20)
    call _T40
    _T33 = _T32
    parm _T33
    _T41 = *(_T33 + 0)
    _T42 = *(_T41 + 16)
    _T43 =  call _T42
    _T44 = "spots: "
    parm _T44
    call _PrintString
    parm _T32
    _T45 = *(_T32 + 0)
    _T46 = *(_T45 + 24)
    _T47 =  call _T46
    parm _T47
    call _PrintBool
    _T48 = "    height: "
    parm _T48
    call _PrintString
    parm _T33
    _T49 = *(_T33 + 0)
    _T50 = *(_T49 + 12)
    _T51 =  call _T50
    parm _T51
    call _PrintInt
}

