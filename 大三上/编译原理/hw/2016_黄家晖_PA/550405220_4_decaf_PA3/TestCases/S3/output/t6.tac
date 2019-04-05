VTABLE(_Main) {
    <empty>
    Main
    _Main.COPY;
}

FUNCTION(_Main_New) {
memo ''
_Main_New:
    _T3 = 4
    parm _T3
    _T4 =  call _Alloc
    _T5 = VTBL <_Main>
    *(_T4 + 0) = _T5
    return _T4
}

FUNCTION(_Main.COPY) {
memo '_T6:4'
_Main.COPY:
    _T7 = 4
    parm _T7
    _T8 =  call _Alloc
    _T9 = VTBL <_Main>
    *(_T8 + 0) = _T9
    return _T8
}

FUNCTION(_Main.Binky) {
memo '_T0:4 _T1:8 _T2:12'
_Main.Binky:
    _T10 = 0
    _T11 = *(_T2 - 4)
    _T12 = (_T10 < _T11)
    if (_T12 == 0) branch _L12
    _T13 = 0
    _T14 = (_T10 < _T13)
    if (_T14 == 0) branch _L13
_L12:
    _T15 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T15
    call _PrintString
    call _Halt
_L13:
    _T16 = 4
    _T17 = (_T10 * _T16)
    _T18 = (_T2 + _T17)
    _T19 = *(_T18 + 0)
    _T20 = *(_T1 - 4)
    _T21 = (_T19 < _T20)
    if (_T21 == 0) branch _L14
    _T22 = 0
    _T23 = (_T19 < _T22)
    if (_T23 == 0) branch _L15
_L14:
    _T24 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T24
    call _PrintString
    call _Halt
_L15:
    _T25 = 4
    _T26 = (_T19 * _T25)
    _T27 = (_T1 + _T26)
    _T28 = *(_T27 + 0)
    return _T28
}

FUNCTION(main) {
memo ''
main:
    _T31 = 5
    _T32 = 0
    _T33 = (_T31 < _T32)
    if (_T33 == 0) branch _L16
    _T34 = "Decaf runtime error: Cannot create negative-sized array\n"
    parm _T34
    call _PrintString
    call _Halt
_L16:
    _T35 = 4
    _T36 = (_T35 * _T31)
    _T37 = (_T35 + _T36)
    parm _T37
    _T38 =  call _Alloc
    *(_T38 + 0) = _T31
    _T39 = 0
    _T38 = (_T38 + _T37)
_L17:
    _T37 = (_T37 - _T35)
    if (_T37 == 0) branch _L18
    _T38 = (_T38 - _T35)
    *(_T38 + 0) = _T39
    branch _L17
_L18:
    _T30 = _T38
    _T40 = 0
    _T41 = *(_T30 - 4)
    _T42 = (_T40 < _T41)
    if (_T42 == 0) branch _L19
    _T43 = 0
    _T44 = (_T40 < _T43)
    if (_T44 == 0) branch _L20
_L19:
    _T45 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T45
    call _PrintString
    call _Halt
_L20:
    _T46 = 4
    _T47 = (_T40 * _T46)
    _T48 = (_T30 + _T47)
    _T49 = *(_T48 + 0)
    _T50 = 12
    _T51 = 0
    _T52 = (_T50 < _T51)
    if (_T52 == 0) branch _L21
    _T53 = "Decaf runtime error: Cannot create negative-sized array\n"
    parm _T53
    call _PrintString
    call _Halt
_L21:
    _T54 = 4
    _T55 = (_T54 * _T50)
    _T56 = (_T54 + _T55)
    parm _T56
    _T57 =  call _Alloc
    *(_T57 + 0) = _T50
    _T58 = 0
    _T57 = (_T57 + _T56)
_L22:
    _T56 = (_T56 - _T54)
    if (_T56 == 0) branch _L23
    _T57 = (_T57 - _T54)
    *(_T57 + 0) = _T58
    branch _L22
_L23:
    _T59 = 4
    _T60 = (_T40 * _T59)
    _T61 = (_T30 + _T60)
    *(_T61 + 0) = _T57
    _T62 = 10
    _T63 = 0
    _T64 = (_T62 < _T63)
    if (_T64 == 0) branch _L24
    _T65 = "Decaf runtime error: Cannot create negative-sized array\n"
    parm _T65
    call _PrintString
    call _Halt
_L24:
    _T66 = 4
    _T67 = (_T66 * _T62)
    _T68 = (_T66 + _T67)
    parm _T68
    _T69 =  call _Alloc
    *(_T69 + 0) = _T62
    _T70 = 0
    _T69 = (_T69 + _T68)
_L25:
    _T68 = (_T68 - _T66)
    if (_T68 == 0) branch _L26
    _T69 = (_T69 - _T66)
    *(_T69 + 0) = _T70
    branch _L25
_L26:
    _T29 = _T69
    _T71 = 0
    _T72 = *(_T29 - 4)
    _T73 = (_T71 < _T72)
    if (_T73 == 0) branch _L27
    _T74 = 0
    _T75 = (_T71 < _T74)
    if (_T75 == 0) branch _L28
_L27:
    _T76 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T76
    call _PrintString
    call _Halt
_L28:
    _T77 = 4
    _T78 = (_T71 * _T77)
    _T79 = (_T29 + _T78)
    _T80 = *(_T79 + 0)
    _T81 = 4
    _T82 = 5
    _T83 = 3
    _T84 = (_T82 * _T83)
    _T85 = 4
    _T86 = 0
    _T87 = (_T85 == _T86)
    if (_T87 == 0) branch _L29
    _T88 = "Decaf runtime error: Division by zero error.\n"
    parm _T88
    call _PrintString
    call _Halt
_L29:
    _T89 = (_T84 / _T85)
    _T90 = 2
    _T91 = 0
    _T92 = (_T90 == _T91)
    if (_T92 == 0) branch _L30
    _T93 = "Decaf runtime error: Division by zero error.\n"
    parm _T93
    call _PrintString
    call _Halt
_L30:
    _T94 = (_T89 % _T90)
    _T95 = (_T81 + _T94)
    _T96 = 4
    _T97 = (_T71 * _T96)
    _T98 = (_T29 + _T97)
    *(_T98 + 0) = _T95
    _T99 = 0
    _T100 = *(_T30 - 4)
    _T101 = (_T99 < _T100)
    if (_T101 == 0) branch _L31
    _T102 = 0
    _T103 = (_T99 < _T102)
    if (_T103 == 0) branch _L32
_L31:
    _T104 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T104
    call _PrintString
    call _Halt
_L32:
    _T105 = 4
    _T106 = (_T99 * _T105)
    _T107 = (_T30 + _T106)
    _T108 = *(_T107 + 0)
    _T109 = 0
    _T110 = *(_T29 - 4)
    _T111 = (_T109 < _T110)
    if (_T111 == 0) branch _L33
    _T112 = 0
    _T113 = (_T109 < _T112)
    if (_T113 == 0) branch _L34
_L33:
    _T114 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T114
    call _PrintString
    call _Halt
_L34:
    _T115 = 4
    _T116 = (_T109 * _T115)
    _T117 = (_T29 + _T116)
    _T118 = *(_T117 + 0)
    _T119 = *(_T108 - 4)
    _T120 = (_T118 < _T119)
    if (_T120 == 0) branch _L35
    _T121 = 0
    _T122 = (_T118 < _T121)
    if (_T122 == 0) branch _L36
_L35:
    _T123 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T123
    call _PrintString
    call _Halt
_L36:
    _T124 = 4
    _T125 = (_T118 * _T124)
    _T126 = (_T108 + _T125)
    _T127 = *(_T126 + 0)
    _T128 = 55
    _T129 = 4
    _T130 = (_T118 * _T129)
    _T131 = (_T108 + _T130)
    *(_T131 + 0) = _T128
    _T132 = 0
    _T133 = *(_T29 - 4)
    _T134 = (_T132 < _T133)
    if (_T134 == 0) branch _L37
    _T135 = 0
    _T136 = (_T132 < _T135)
    if (_T136 == 0) branch _L38
_L37:
    _T137 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T137
    call _PrintString
    call _Halt
_L38:
    _T138 = 4
    _T139 = (_T132 * _T138)
    _T140 = (_T29 + _T139)
    _T141 = *(_T140 + 0)
    parm _T141
    call _PrintInt
    _T142 = " "
    parm _T142
    call _PrintString
    _T143 = 2
    _T144 = 100
    _T145 = 0
    _T146 = *(_T30 - 4)
    _T147 = (_T145 < _T146)
    if (_T147 == 0) branch _L39
    _T148 = 0
    _T149 = (_T145 < _T148)
    if (_T149 == 0) branch _L40
_L39:
    _T150 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T150
    call _PrintString
    call _Halt
_L40:
    _T151 = 4
    _T152 = (_T145 * _T151)
    _T153 = (_T30 + _T152)
    _T154 = *(_T153 + 0)
    parm _T144
    parm _T154
    parm _T29
    _T155 =  call _Main.Binky
    _T156 = (_T143 * _T155)
    parm _T156
    call _PrintInt
}

