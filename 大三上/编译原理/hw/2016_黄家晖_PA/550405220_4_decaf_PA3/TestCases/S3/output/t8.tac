VTABLE(_Animal) {
    <empty>
    Animal
    _Animal.COPY;
    _Animal.InitAnimal;
    _Animal.GetHeight;
    _Animal.GetMom;
}

VTABLE(_Cow) {
    _Animal
    Cow
    _Cow.COPY;
    _Animal.InitAnimal;
    _Animal.GetHeight;
    _Animal.GetMom;
    _Cow.InitCow;
    _Cow.IsSpottedCow;
}

VTABLE(_Main) {
    <empty>
    Main
    _Main.COPY;
}

FUNCTION(_Animal_New) {
memo ''
_Animal_New:
    _T10 = 12
    parm _T10
    _T11 =  call _Alloc
    _T12 = 0
    *(_T11 + 4) = _T12
    *(_T11 + 8) = _T12
    _T13 = VTBL <_Animal>
    *(_T11 + 0) = _T13
    return _T11
}

FUNCTION(_Animal.COPY) {
memo '_T14:4'
_Animal.COPY:
    _T15 = 12
    parm _T15
    _T16 =  call _Alloc
    _T17 = *(_T14 + 4)
    *(_T16 + 4) = _T17
    _T18 = *(_T14 + 8)
    *(_T16 + 8) = _T18
    _T19 = VTBL <_Animal>
    *(_T16 + 0) = _T19
    return _T16
}

FUNCTION(_Cow_New) {
memo ''
_Cow_New:
    _T20 = 16
    parm _T20
    _T21 =  call _Alloc
    _T22 = 0
    *(_T21 + 4) = _T22
    *(_T21 + 8) = _T22
    *(_T21 + 12) = _T22
    _T23 = VTBL <_Cow>
    *(_T21 + 0) = _T23
    return _T21
}

FUNCTION(_Cow.COPY) {
memo '_T24:4'
_Cow.COPY:
    _T25 = 16
    parm _T25
    _T26 =  call _Alloc
    _T27 = *(_T24 + 4)
    *(_T26 + 4) = _T27
    _T28 = *(_T24 + 8)
    *(_T26 + 8) = _T28
    _T29 = *(_T24 + 12)
    *(_T26 + 12) = _T29
    _T30 = VTBL <_Cow>
    *(_T26 + 0) = _T30
    return _T26
}

FUNCTION(_Main_New) {
memo ''
_Main_New:
    _T31 = 4
    parm _T31
    _T32 =  call _Alloc
    _T33 = VTBL <_Main>
    *(_T32 + 0) = _T33
    return _T32
}

FUNCTION(_Main.COPY) {
memo '_T34:4'
_Main.COPY:
    _T35 = 4
    parm _T35
    _T36 =  call _Alloc
    _T37 = VTBL <_Main>
    *(_T36 + 0) = _T37
    return _T36
}

FUNCTION(_Animal.InitAnimal) {
memo '_T0:4 _T1:8 _T2:12'
_Animal.InitAnimal:
    _T38 = *(_T0 + 4)
    *(_T0 + 4) = _T1
    _T39 = *(_T0 + 8)
    *(_T0 + 8) = _T2
}

FUNCTION(_Animal.GetHeight) {
memo '_T3:4'
_Animal.GetHeight:
    _T40 = *(_T3 + 4)
    return _T40
}

FUNCTION(_Animal.GetMom) {
memo '_T4:4'
_Animal.GetMom:
    _T41 = *(_T4 + 8)
    return _T41
}

FUNCTION(_Cow.InitCow) {
memo '_T5:4 _T6:8 _T7:12 _T8:16'
_Cow.InitCow:
    _T42 = *(_T5 + 12)
    *(_T5 + 12) = _T8
    parm _T5
    parm _T6
    parm _T7
    _T43 = *(_T5 + 0)
    _T44 = *(_T43 + 12)
    call _T44
}

FUNCTION(_Cow.IsSpottedCow) {
memo '_T9:4'
_Cow.IsSpottedCow:
    _T45 = *(_T9 + 12)
    return _T45
}

FUNCTION(main) {
memo ''
main:
    _T48 =  call _Cow_New
    _T46 = _T48
    _T49 = 5
    _T50 = 0
    _T51 = 1
    parm _T46
    parm _T49
    parm _T50
    parm _T51
    _T52 = *(_T46 + 0)
    _T53 = *(_T52 + 24)
    call _T53
    _T47 = _T46
    parm _T47
    _T54 = *(_T47 + 0)
    _T55 = *(_T54 + 20)
    _T56 =  call _T55
    _T57 = "spots: "
    parm _T57
    call _PrintString
    parm _T46
    _T58 = *(_T46 + 0)
    _T59 = *(_T58 + 28)
    _T60 =  call _T59
    parm _T60
    call _PrintBool
    _T61 = "    height: "
    parm _T61
    call _PrintString
    parm _T47
    _T62 = *(_T47 + 0)
    _T63 = *(_T62 + 16)
    _T64 =  call _T63
    parm _T64
    call _PrintInt
}

