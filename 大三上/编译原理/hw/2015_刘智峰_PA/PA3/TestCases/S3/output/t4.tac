VTABLE(_Main) {
    <empty>
    Main
    _Main.tester;
    _Main.start;
}

FUNCTION(_Main_New) {
memo ''
_Main_New:
    _T4 = 12
    parm _T4
    _T5 =  call _Alloc
    _T6 = 0
    *(_T5 + 4) = _T6
    *(_T5 + 8) = _T6
    _T7 = VTBL <_Main>
    *(_T5 + 0) = _T7
    return _T5
}

FUNCTION(_Main.tester) {
memo '_T1:4 _T2:8'
_Main.tester:
    _T8 = *(_T1 + 8)
    _T9 = 1
    _T10 = 0
    _T11 = (_T9 < _T10)
    if (_T11 == 0) branch _L12
    _T12 = "Decaf runtime error: Cannot create negative-sized array\n"
    parm _T12
    call _PrintString
    call _Halt
_L12:
    _T13 = 4
    _T14 = (_T13 * _T9)
    _T15 = (_T13 + _T14)
    parm _T15
    _T16 =  call _Alloc
    *(_T16 + 0) = _T9
    _T17 = 0
    _T16 = (_T16 + _T15)
_L13:
    _T15 = (_T15 - _T13)
    if (_T15 == 0) branch _L14
    _T16 = (_T16 - _T13)
    *(_T16 + 0) = _T17
    branch _L13
_L14:
    *(_T1 + 8) = _T16
    _T18 = 0
    _T19 = (_T2 < _T18)
    if (_T19 == 0) branch _L15
    _T20 = "Decaf runtime error: Cannot create negative-sized array\n"
    parm _T20
    call _PrintString
    call _Halt
_L15:
    _T21 = 4
    _T22 = (_T21 * _T2)
    _T23 = (_T21 + _T22)
    parm _T23
    _T24 =  call _Alloc
    *(_T24 + 0) = _T2
    _T25 = 0
    _T24 = (_T24 + _T23)
_L16:
    _T23 = (_T23 - _T21)
    if (_T23 == 0) branch _L17
    _T24 = (_T24 - _T21)
    *(_T24 + 0) = _T25
    branch _L16
_L17:
    return _T24
}

FUNCTION(_Main.start) {
memo '_T3:4'
_Main.start:
    _T29 = 1
    _T26 = _T29
_L18:
    _T30 = 5
    _T31 = (_T26 < _T30)
    if (_T31 == 0) branch _L19
    _T32 = 2
    _T33 = 0
    _T34 = (_T32 == _T33)
    if (_T34 == 0) branch _L20
    _T35 = "Decaf runtime error: Division by zero error.\n"
    parm _T35
    call _PrintString
    call _Halt
_L20:
    _T36 = (_T26 % _T32)
    _T37 = 0
    _T38 = (_T36 == _T37)
    if (_T38 == 0) branch _L21
    parm _T3
    parm _T26
    _T39 = *(_T3 + 0)
    _T40 = *(_T39 + 8)
    _T41 =  call _T40
    _T28 = _T41
    branch _L19
_L21:
    _T42 = "Loop "
    parm _T42
    call _PrintString
    parm _T26
    call _PrintInt
    _T43 = "\n"
    parm _T43
    call _PrintString
    _T44 = 1
    _T45 = (_T26 + _T44)
    _T26 = _T45
    branch _L18
_L19:
    _T46 = 0
    _T47 = *(_T28 - 4)
    _T48 = (_T46 < _T47)
    if (_T48 == 0) branch _L22
    _T49 = 0
    _T50 = (_T46 < _T49)
    if (_T50 == 0) branch _L23
_L22:
    _T51 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T51
    call _PrintString
    call _Halt
_L23:
    _T52 = 4
    _T53 = (_T46 * _T52)
    _T54 = (_T28 + _T53)
    _T55 = *(_T54 + 0)
    _T56 = 0
    _T57 = 4
    _T58 = (_T46 * _T57)
    _T59 = (_T28 + _T58)
    *(_T59 + 0) = _T56
    _T60 = 0
    _T61 = *(_T28 - 4)
    _T62 = (_T60 < _T61)
    if (_T62 == 0) branch _L24
    _T63 = 0
    _T64 = (_T60 < _T63)
    if (_T64 == 0) branch _L25
_L24:
    _T65 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T65
    call _PrintString
    call _Halt
_L25:
    _T66 = 4
    _T67 = (_T60 * _T66)
    _T68 = (_T28 + _T67)
    _T69 = *(_T68 + 0)
    _T70 = *(_T28 - 4)
    _T71 = (_T69 < _T70)
    if (_T71 == 0) branch _L26
    _T72 = 0
    _T73 = (_T69 < _T72)
    if (_T73 == 0) branch _L27
_L26:
    _T74 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T74
    call _PrintString
    call _Halt
_L27:
    _T75 = 4
    _T76 = (_T69 * _T75)
    _T77 = (_T28 + _T76)
    _T78 = *(_T77 + 0)
    parm _T78
    call _PrintInt
    _T79 = "\n"
    parm _T79
    call _PrintString
    _T80 = *(_T28 - 4)
    parm _T80
    call _PrintInt
    _T81 = "\n"
    parm _T81
    call _PrintString
}

FUNCTION(main) {
memo ''
main:
    _T82 =  call _Main_New
    _T83 = 1
    _T0 = (_T0 + _T83)
    parm _T82
    _T84 = *(_T82 + 0)
    _T85 = *(_T84 + 12)
    call _T85
}

