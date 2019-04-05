VTABLE(_Main) {
    <empty>
    Main
    _Main.COPY;
}

VTABLE(_Base) {
    <empty>
    Base
    _Base.COPY;
}

VTABLE(_Sub1) {
    _Base
    Sub1
    _Sub1.COPY;
}

VTABLE(_Sub2) {
    _Base
    Sub2
    _Sub2.COPY;
}

VTABLE(_Sub3) {
    _Sub1
    Sub3
    _Sub3.COPY;
}

VTABLE(_Sub4) {
    _Sub3
    Sub4
    _Sub4.COPY;
}

FUNCTION(_Main_New) {
memo ''
_Main_New:
    _T1 = 4
    parm _T1
    _T2 =  call _Alloc
    _T3 = VTBL <_Main>
    *(_T2 + 0) = _T3
    return _T2
}

FUNCTION(_Main.COPY) {
memo '_T4:4'
_Main.COPY:
    _T5 = 4
    parm _T5
    _T6 =  call _Alloc
    _T7 = VTBL <_Main>
    *(_T6 + 0) = _T7
    return _T6
}

FUNCTION(_Base_New) {
memo ''
_Base_New:
    _T8 = 4
    parm _T8
    _T9 =  call _Alloc
    _T10 = VTBL <_Base>
    *(_T9 + 0) = _T10
    return _T9
}

FUNCTION(_Base.COPY) {
memo '_T11:4'
_Base.COPY:
    _T12 = 4
    parm _T12
    _T13 =  call _Alloc
    _T14 = VTBL <_Base>
    *(_T13 + 0) = _T14
    return _T13
}

FUNCTION(_Sub1_New) {
memo ''
_Sub1_New:
    _T15 = 4
    parm _T15
    _T16 =  call _Alloc
    _T17 = VTBL <_Sub1>
    *(_T16 + 0) = _T17
    return _T16
}

FUNCTION(_Sub1.COPY) {
memo '_T18:4'
_Sub1.COPY:
    _T19 = 4
    parm _T19
    _T20 =  call _Alloc
    _T21 = VTBL <_Sub1>
    *(_T20 + 0) = _T21
    return _T20
}

FUNCTION(_Sub2_New) {
memo ''
_Sub2_New:
    _T22 = 4
    parm _T22
    _T23 =  call _Alloc
    _T24 = VTBL <_Sub2>
    *(_T23 + 0) = _T24
    return _T23
}

FUNCTION(_Sub2.COPY) {
memo '_T25:4'
_Sub2.COPY:
    _T26 = 4
    parm _T26
    _T27 =  call _Alloc
    _T28 = VTBL <_Sub2>
    *(_T27 + 0) = _T28
    return _T27
}

FUNCTION(_Sub3_New) {
memo ''
_Sub3_New:
    _T29 = 4
    parm _T29
    _T30 =  call _Alloc
    _T31 = VTBL <_Sub3>
    *(_T30 + 0) = _T31
    return _T30
}

FUNCTION(_Sub3.COPY) {
memo '_T32:4'
_Sub3.COPY:
    _T33 = 4
    parm _T33
    _T34 =  call _Alloc
    _T35 = VTBL <_Sub3>
    *(_T34 + 0) = _T35
    return _T34
}

FUNCTION(_Sub4_New) {
memo ''
_Sub4_New:
    _T36 = 4
    parm _T36
    _T37 =  call _Alloc
    _T38 = VTBL <_Sub4>
    *(_T37 + 0) = _T38
    return _T37
}

FUNCTION(_Sub4.COPY) {
memo '_T39:4'
_Sub4.COPY:
    _T40 = 4
    parm _T40
    _T41 =  call _Alloc
    _T42 = VTBL <_Sub4>
    *(_T41 + 0) = _T42
    return _T41
}

FUNCTION(main) {
memo ''
main:
    _T48 =  call _Base_New
    _T43 = _T48
    _T49 =  call _Sub1_New
    _T44 = _T49
    _T50 =  call _Sub2_New
    _T45 = _T50
    _T51 =  call _Sub3_New
    _T46 = _T51
    _T52 =  call _Sub4_New
    _T47 = _T52
    parm _T43
    call _Main.printType
    parm _T44
    call _Main.printType
    parm _T45
    call _Main.printType
    parm _T46
    call _Main.printType
    parm _T47
    call _Main.printType
    _T43 = _T47
    parm _T43
    call _Main.printType
    _T54 = VTBL <_Sub1>
    _T55 = *(_T43 + 0)
_L22:
    _T53 = (_T54 == _T55)
    if (_T53 != 0) branch _L23
    _T55 = *(_T55 + 0)
    if (_T55 != 0) branch _L22
    _T56 = "Decaf runtime error: "
    parm _T56
    call _PrintString
    _T57 = *(_T43 + 0)
    _T58 = *(_T57 + 4)
    parm _T58
    call _PrintString
    _T59 = " cannot be cast to "
    parm _T59
    call _PrintString
    _T60 = VTBL <_Sub1>
    _T61 = *(_T60 + 4)
    parm _T61
    call _PrintString
    _T62 = "\n"
    parm _T62
    call _PrintString
    call _Halt
_L23:
    _T44 = _T43
    parm _T44
    call _Main.printType
}

FUNCTION(_Main.printType) {
memo '_T0:4'
_Main.printType:
    _T64 = VTBL <_Sub4>
    _T65 = *(_T0 + 0)
_L24:
    _T63 = (_T64 == _T65)
    if (_T63 != 0) branch _L25
    _T65 = *(_T65 + 0)
    if (_T65 != 0) branch _L24
    _T63 = 0
_L25:
    if (_T63 == 0) branch _L26
    _T66 = "Sub4\n"
    parm _T66
    call _PrintString
    branch _L27
_L26:
    _T68 = VTBL <_Sub3>
    _T69 = *(_T0 + 0)
_L28:
    _T67 = (_T68 == _T69)
    if (_T67 != 0) branch _L29
    _T69 = *(_T69 + 0)
    if (_T69 != 0) branch _L28
    _T67 = 0
_L29:
    if (_T67 == 0) branch _L30
    _T70 = "Sub3\n"
    parm _T70
    call _PrintString
    branch _L31
_L30:
    _T72 = VTBL <_Sub2>
    _T73 = *(_T0 + 0)
_L32:
    _T71 = (_T72 == _T73)
    if (_T71 != 0) branch _L33
    _T73 = *(_T73 + 0)
    if (_T73 != 0) branch _L32
    _T71 = 0
_L33:
    if (_T71 == 0) branch _L34
    _T74 = "Sub2\n"
    parm _T74
    call _PrintString
    branch _L35
_L34:
    _T76 = VTBL <_Sub1>
    _T77 = *(_T0 + 0)
_L36:
    _T75 = (_T76 == _T77)
    if (_T75 != 0) branch _L37
    _T77 = *(_T77 + 0)
    if (_T77 != 0) branch _L36
    _T75 = 0
_L37:
    if (_T75 == 0) branch _L38
    _T78 = "Sub1\n"
    parm _T78
    call _PrintString
    branch _L39
_L38:
    _T80 = VTBL <_Base>
    _T81 = *(_T0 + 0)
_L40:
    _T79 = (_T80 == _T81)
    if (_T79 != 0) branch _L41
    _T81 = *(_T81 + 0)
    if (_T81 != 0) branch _L40
    _T79 = 0
_L41:
    if (_T79 == 0) branch _L42
    _T82 = "Base\n"
    parm _T82
    call _PrintString
_L42:
_L39:
_L35:
_L31:
_L27:
}

