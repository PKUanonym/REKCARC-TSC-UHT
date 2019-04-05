VTABLE(_Main) {
    <empty>
    Main
}

VTABLE(_Base) {
    <empty>
    Base
}

VTABLE(_Sub1) {
    _Base
    Sub1
}

VTABLE(_Sub2) {
    _Base
    Sub2
}

VTABLE(_Sub3) {
    _Sub1
    Sub3
}

VTABLE(_Sub4) {
    _Sub3
    Sub4
}

FUNCTION(_Main_New) {
memo ''
_Main_New:
    _T7 = 4
    parm _T7
    _T8 =  call _Alloc
    _T9 = VTBL <_Main>
    *(_T8 + 0) = _T9
    return _T8
}

FUNCTION(_Base_New) {
memo ''
_Base_New:
    _T10 = 4
    parm _T10
    _T11 =  call _Alloc
    _T12 = VTBL <_Base>
    *(_T11 + 0) = _T12
    return _T11
}

FUNCTION(_Sub1_New) {
memo ''
_Sub1_New:
    _T13 = 4
    parm _T13
    _T14 =  call _Alloc
    _T15 = VTBL <_Sub1>
    *(_T14 + 0) = _T15
    return _T14
}

FUNCTION(_Sub2_New) {
memo ''
_Sub2_New:
    _T16 = 4
    parm _T16
    _T17 =  call _Alloc
    _T18 = VTBL <_Sub2>
    *(_T17 + 0) = _T18
    return _T17
}

FUNCTION(_Sub3_New) {
memo ''
_Sub3_New:
    _T19 = 4
    parm _T19
    _T20 =  call _Alloc
    _T21 = VTBL <_Sub3>
    *(_T20 + 0) = _T21
    return _T20
}

FUNCTION(_Sub4_New) {
memo ''
_Sub4_New:
    _T22 = 4
    parm _T22
    _T23 =  call _Alloc
    _T24 = VTBL <_Sub4>
    *(_T23 + 0) = _T24
    return _T23
}

FUNCTION(main) {
memo ''
main:
    _T30 =  call _Base_New
    _T31 = 1
    _T1 = (_T1 + _T31)
    _T25 = _T30
    _T32 =  call _Sub1_New
    _T33 = 1
    _T2 = (_T2 + _T33)
    _T26 = _T32
    _T34 =  call _Sub2_New
    _T35 = 1
    _T3 = (_T3 + _T35)
    _T27 = _T34
    _T36 =  call _Sub3_New
    _T37 = 1
    _T4 = (_T4 + _T37)
    _T28 = _T36
    _T38 =  call _Sub4_New
    _T39 = 1
    _T5 = (_T5 + _T39)
    _T29 = _T38
    parm _T25
    call _Main.printType
    parm _T26
    call _Main.printType
    parm _T27
    call _Main.printType
    parm _T28
    call _Main.printType
    parm _T29
    call _Main.printType
    _T25 = _T29
    parm _T25
    call _Main.printType
    _T41 = VTBL <_Sub1>
    _T42 = *(_T25 + 0)
_L16:
    _T40 = (_T41 == _T42)
    if (_T40 != 0) branch _L17
    _T42 = *(_T42 + 0)
    if (_T42 != 0) branch _L16
    _T43 = "Decaf runtime error: "
    parm _T43
    call _PrintString
    _T44 = *(_T25 + 0)
    _T45 = *(_T44 + 4)
    parm _T45
    call _PrintString
    _T46 = " cannot be cast to "
    parm _T46
    call _PrintString
    _T47 = VTBL <_Sub1>
    _T48 = *(_T47 + 4)
    parm _T48
    call _PrintString
    _T49 = "\n"
    parm _T49
    call _PrintString
    call _Halt
_L17:
    _T26 = _T25
    parm _T26
    call _Main.printType
}

FUNCTION(_Main.printType) {
memo '_T6:4'
_Main.printType:
    _T51 = VTBL <_Sub4>
    _T52 = *(_T6 + 0)
_L18:
    _T50 = (_T51 == _T52)
    if (_T50 != 0) branch _L19
    _T52 = *(_T52 + 0)
    if (_T52 != 0) branch _L18
    _T50 = 0
_L19:
    if (_T50 == 0) branch _L20
    _T53 = "Sub4\n"
    parm _T53
    call _PrintString
    branch _L21
_L20:
    _T55 = VTBL <_Sub3>
    _T56 = *(_T6 + 0)
_L22:
    _T54 = (_T55 == _T56)
    if (_T54 != 0) branch _L23
    _T56 = *(_T56 + 0)
    if (_T56 != 0) branch _L22
    _T54 = 0
_L23:
    if (_T54 == 0) branch _L24
    _T57 = "Sub3\n"
    parm _T57
    call _PrintString
    branch _L25
_L24:
    _T59 = VTBL <_Sub2>
    _T60 = *(_T6 + 0)
_L26:
    _T58 = (_T59 == _T60)
    if (_T58 != 0) branch _L27
    _T60 = *(_T60 + 0)
    if (_T60 != 0) branch _L26
    _T58 = 0
_L27:
    if (_T58 == 0) branch _L28
    _T61 = "Sub2\n"
    parm _T61
    call _PrintString
    branch _L29
_L28:
    _T63 = VTBL <_Sub1>
    _T64 = *(_T6 + 0)
_L30:
    _T62 = (_T63 == _T64)
    if (_T62 != 0) branch _L31
    _T64 = *(_T64 + 0)
    if (_T64 != 0) branch _L30
    _T62 = 0
_L31:
    if (_T62 == 0) branch _L32
    _T65 = "Sub1\n"
    parm _T65
    call _PrintString
    branch _L33
_L32:
    _T67 = VTBL <_Base>
    _T68 = *(_T6 + 0)
_L34:
    _T66 = (_T67 == _T68)
    if (_T66 != 0) branch _L35
    _T68 = *(_T68 + 0)
    if (_T68 != 0) branch _L34
    _T66 = 0
_L35:
    if (_T66 == 0) branch _L36
    _T69 = "Base\n"
    parm _T69
    call _PrintString
_L36:
_L33:
_L29:
_L25:
_L21:
}

