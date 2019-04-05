VTABLE(_Main) {
    <empty>
    Main
    _Main.COPY;
    _Main.tester;
    _Main.start;
}

FUNCTION(_Main_New) {
memo ''
_Main_New:
    _T3 = 12
    parm _T3
    _T4 =  call _Alloc
    _T5 = 0
    *(_T4 + 4) = _T5
    *(_T4 + 8) = _T5
    _T6 = VTBL <_Main>
    *(_T4 + 0) = _T6
    return _T4
}

FUNCTION(_Main.COPY) {
memo '_T7:4'
_Main.COPY:
    _T8 = 12
    parm _T8
    _T9 =  call _Alloc
    _T10 = *(_T7 + 4)
    *(_T9 + 4) = _T10
    _T11 = *(_T7 + 8)
    *(_T9 + 8) = _T11
    _T12 = VTBL <_Main>
    *(_T9 + 0) = _T12
    return _T9
}

FUNCTION(_Main.tester) {
memo '_T0:4 _T1:8'
_Main.tester:
    _T13 = *(_T0 + 8)
    _T14 = 1
    _T15 = 0
    _T16 = (_T14 < _T15)
    if (_T16 == 0) branch _L13
    _T17 = "Decaf runtime error: Cannot create negative-sized array\n"
    parm _T17
    call _PrintString
    call _Halt
_L13:
    _T18 = 4
    _T19 = (_T18 * _T14)
    _T20 = (_T18 + _T19)
    parm _T20
    _T21 =  call _Alloc
    *(_T21 + 0) = _T14
    _T22 = 0
    _T21 = (_T21 + _T20)
_L14:
    _T20 = (_T20 - _T18)
    if (_T20 == 0) branch _L15
    _T21 = (_T21 - _T18)
    *(_T21 + 0) = _T22
    branch _L14
_L15:
    *(_T0 + 8) = _T21
    _T23 = 0
    _T24 = (_T1 < _T23)
    if (_T24 == 0) branch _L16
    _T25 = "Decaf runtime error: Cannot create negative-sized array\n"
    parm _T25
    call _PrintString
    call _Halt
_L16:
    _T26 = 4
    _T27 = (_T26 * _T1)
    _T28 = (_T26 + _T27)
    parm _T28
    _T29 =  call _Alloc
    *(_T29 + 0) = _T1
    _T30 = 0
    _T29 = (_T29 + _T28)
_L17:
    _T28 = (_T28 - _T26)
    if (_T28 == 0) branch _L18
    _T29 = (_T29 - _T26)
    *(_T29 + 0) = _T30
    branch _L17
_L18:
    return _T29
}

FUNCTION(_Main.start) {
memo '_T2:4'
_Main.start:
    _T34 = 1
    _T31 = _T34
_L19:
    _T35 = 5
    _T36 = (_T31 < _T35)
    if (_T36 == 0) branch _L20
    _T37 = 2
    _T38 = 0
    _T39 = (_T37 == _T38)
    if (_T39 == 0) branch _L21
    _T40 = "Decaf runtime error: Division by zero error.\n"
    parm _T40
    call _PrintString
    call _Halt
_L21:
    _T41 = (_T31 % _T37)
    _T42 = 0
    _T43 = (_T41 == _T42)
    if (_T43 == 0) branch _L22
    parm _T2
    parm _T31
    _T44 = *(_T2 + 0)
    _T45 = *(_T44 + 12)
    _T46 =  call _T45
    _T33 = _T46
    branch _L20
_L22:
    _T47 = "Loop "
    parm _T47
    call _PrintString
    parm _T31
    call _PrintInt
    _T48 = "\n"
    parm _T48
    call _PrintString
    _T49 = 1
    _T50 = (_T31 + _T49)
    _T31 = _T50
    branch _L19
_L20:
    _T51 = 0
    _T52 = *(_T33 - 4)
    _T53 = (_T51 < _T52)
    if (_T53 == 0) branch _L23
    _T54 = 0
    _T55 = (_T51 < _T54)
    if (_T55 == 0) branch _L24
_L23:
    _T56 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T56
    call _PrintString
    call _Halt
_L24:
    _T57 = 4
    _T58 = (_T51 * _T57)
    _T59 = (_T33 + _T58)
    _T60 = *(_T59 + 0)
    _T61 = 0
    _T62 = 4
    _T63 = (_T51 * _T62)
    _T64 = (_T33 + _T63)
    *(_T64 + 0) = _T61
    _T65 = 0
    _T66 = *(_T33 - 4)
    _T67 = (_T65 < _T66)
    if (_T67 == 0) branch _L25
    _T68 = 0
    _T69 = (_T65 < _T68)
    if (_T69 == 0) branch _L26
_L25:
    _T70 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T70
    call _PrintString
    call _Halt
_L26:
    _T71 = 4
    _T72 = (_T65 * _T71)
    _T73 = (_T33 + _T72)
    _T74 = *(_T73 + 0)
    _T75 = *(_T33 - 4)
    _T76 = (_T74 < _T75)
    if (_T76 == 0) branch _L27
    _T77 = 0
    _T78 = (_T74 < _T77)
    if (_T78 == 0) branch _L28
_L27:
    _T79 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T79
    call _PrintString
    call _Halt
_L28:
    _T80 = 4
    _T81 = (_T74 * _T80)
    _T82 = (_T33 + _T81)
    _T83 = *(_T82 + 0)
    parm _T83
    call _PrintInt
    _T84 = "\n"
    parm _T84
    call _PrintString
    _T85 = *(_T33 - 4)
    parm _T85
    call _PrintInt
    _T86 = "\n"
    parm _T86
    call _PrintString
}

FUNCTION(main) {
memo ''
main:
    _T87 =  call _Main_New
    parm _T87
    _T88 = *(_T87 + 0)
    _T89 = *(_T88 + 16)
    call _T89
}

