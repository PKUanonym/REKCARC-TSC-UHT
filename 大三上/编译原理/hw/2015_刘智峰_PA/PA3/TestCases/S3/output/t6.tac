VTABLE(_Main) {
    <empty>
    Main
}

FUNCTION(_Main_New) {
memo ''
_Main_New:
    _T4 = 4
    parm _T4
    _T5 =  call _Alloc
    _T6 = VTBL <_Main>
    *(_T5 + 0) = _T6
    return _T5
}

FUNCTION(_Main.Binky) {
memo '_T1:4 _T2:8 _T3:12'
_Main.Binky:
    _T7 = 0
    _T8 = *(_T3 - 4)
    _T9 = (_T7 < _T8)
    if (_T9 == 0) branch _L11
    _T10 = 0
    _T11 = (_T7 < _T10)
    if (_T11 == 0) branch _L12
_L11:
    _T12 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T12
    call _PrintString
    call _Halt
_L12:
    _T13 = 4
    _T14 = (_T7 * _T13)
    _T15 = (_T3 + _T14)
    _T16 = *(_T15 + 0)
    _T17 = *(_T2 - 4)
    _T18 = (_T16 < _T17)
    if (_T18 == 0) branch _L13
    _T19 = 0
    _T20 = (_T16 < _T19)
    if (_T20 == 0) branch _L14
_L13:
    _T21 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T21
    call _PrintString
    call _Halt
_L14:
    _T22 = 4
    _T23 = (_T16 * _T22)
    _T24 = (_T2 + _T23)
    _T25 = *(_T24 + 0)
    return _T25
}

FUNCTION(main) {
memo ''
main:
    _T28 = 5
    _T29 = 0
    _T30 = (_T28 < _T29)
    if (_T30 == 0) branch _L15
    _T31 = "Decaf runtime error: Cannot create negative-sized array\n"
    parm _T31
    call _PrintString
    call _Halt
_L15:
    _T32 = 4
    _T33 = (_T32 * _T28)
    _T34 = (_T32 + _T33)
    parm _T34
    _T35 =  call _Alloc
    *(_T35 + 0) = _T28
    _T36 = 0
    _T35 = (_T35 + _T34)
_L16:
    _T34 = (_T34 - _T32)
    if (_T34 == 0) branch _L17
    _T35 = (_T35 - _T32)
    *(_T35 + 0) = _T36
    branch _L16
_L17:
    _T27 = _T35
    _T37 = 0
    _T38 = *(_T27 - 4)
    _T39 = (_T37 < _T38)
    if (_T39 == 0) branch _L18
    _T40 = 0
    _T41 = (_T37 < _T40)
    if (_T41 == 0) branch _L19
_L18:
    _T42 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T42
    call _PrintString
    call _Halt
_L19:
    _T43 = 4
    _T44 = (_T37 * _T43)
    _T45 = (_T27 + _T44)
    _T46 = *(_T45 + 0)
    _T47 = 12
    _T48 = 0
    _T49 = (_T47 < _T48)
    if (_T49 == 0) branch _L20
    _T50 = "Decaf runtime error: Cannot create negative-sized array\n"
    parm _T50
    call _PrintString
    call _Halt
_L20:
    _T51 = 4
    _T52 = (_T51 * _T47)
    _T53 = (_T51 + _T52)
    parm _T53
    _T54 =  call _Alloc
    *(_T54 + 0) = _T47
    _T55 = 0
    _T54 = (_T54 + _T53)
_L21:
    _T53 = (_T53 - _T51)
    if (_T53 == 0) branch _L22
    _T54 = (_T54 - _T51)
    *(_T54 + 0) = _T55
    branch _L21
_L22:
    _T56 = 4
    _T57 = (_T37 * _T56)
    _T58 = (_T27 + _T57)
    *(_T58 + 0) = _T54
    _T59 = 10
    _T60 = 0
    _T61 = (_T59 < _T60)
    if (_T61 == 0) branch _L23
    _T62 = "Decaf runtime error: Cannot create negative-sized array\n"
    parm _T62
    call _PrintString
    call _Halt
_L23:
    _T63 = 4
    _T64 = (_T63 * _T59)
    _T65 = (_T63 + _T64)
    parm _T65
    _T66 =  call _Alloc
    *(_T66 + 0) = _T59
    _T67 = 0
    _T66 = (_T66 + _T65)
_L24:
    _T65 = (_T65 - _T63)
    if (_T65 == 0) branch _L25
    _T66 = (_T66 - _T63)
    *(_T66 + 0) = _T67
    branch _L24
_L25:
    _T26 = _T66
    _T68 = 0
    _T69 = *(_T26 - 4)
    _T70 = (_T68 < _T69)
    if (_T70 == 0) branch _L26
    _T71 = 0
    _T72 = (_T68 < _T71)
    if (_T72 == 0) branch _L27
_L26:
    _T73 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T73
    call _PrintString
    call _Halt
_L27:
    _T74 = 4
    _T75 = (_T68 * _T74)
    _T76 = (_T26 + _T75)
    _T77 = *(_T76 + 0)
    _T78 = 4
    _T79 = 5
    _T80 = 3
    _T81 = (_T79 * _T80)
    _T82 = 4
    _T83 = 0
    _T84 = (_T82 == _T83)
    if (_T84 == 0) branch _L28
    _T85 = "Decaf runtime error: Division by zero error.\n"
    parm _T85
    call _PrintString
    call _Halt
_L28:
    _T86 = (_T81 / _T82)
    _T87 = 2
    _T88 = 0
    _T89 = (_T87 == _T88)
    if (_T89 == 0) branch _L29
    _T90 = "Decaf runtime error: Division by zero error.\n"
    parm _T90
    call _PrintString
    call _Halt
_L29:
    _T91 = (_T86 % _T87)
    _T92 = (_T78 + _T91)
    _T93 = 4
    _T94 = (_T68 * _T93)
    _T95 = (_T26 + _T94)
    *(_T95 + 0) = _T92
    _T96 = 0
    _T97 = *(_T27 - 4)
    _T98 = (_T96 < _T97)
    if (_T98 == 0) branch _L30
    _T99 = 0
    _T100 = (_T96 < _T99)
    if (_T100 == 0) branch _L31
_L30:
    _T101 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T101
    call _PrintString
    call _Halt
_L31:
    _T102 = 4
    _T103 = (_T96 * _T102)
    _T104 = (_T27 + _T103)
    _T105 = *(_T104 + 0)
    _T106 = 0
    _T107 = *(_T26 - 4)
    _T108 = (_T106 < _T107)
    if (_T108 == 0) branch _L32
    _T109 = 0
    _T110 = (_T106 < _T109)
    if (_T110 == 0) branch _L33
_L32:
    _T111 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T111
    call _PrintString
    call _Halt
_L33:
    _T112 = 4
    _T113 = (_T106 * _T112)
    _T114 = (_T26 + _T113)
    _T115 = *(_T114 + 0)
    _T116 = *(_T105 - 4)
    _T117 = (_T115 < _T116)
    if (_T117 == 0) branch _L34
    _T118 = 0
    _T119 = (_T115 < _T118)
    if (_T119 == 0) branch _L35
_L34:
    _T120 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T120
    call _PrintString
    call _Halt
_L35:
    _T121 = 4
    _T122 = (_T115 * _T121)
    _T123 = (_T105 + _T122)
    _T124 = *(_T123 + 0)
    _T125 = 55
    _T126 = 4
    _T127 = (_T115 * _T126)
    _T128 = (_T105 + _T127)
    *(_T128 + 0) = _T125
    _T129 = 0
    _T130 = *(_T26 - 4)
    _T131 = (_T129 < _T130)
    if (_T131 == 0) branch _L36
    _T132 = 0
    _T133 = (_T129 < _T132)
    if (_T133 == 0) branch _L37
_L36:
    _T134 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T134
    call _PrintString
    call _Halt
_L37:
    _T135 = 4
    _T136 = (_T129 * _T135)
    _T137 = (_T26 + _T136)
    _T138 = *(_T137 + 0)
    parm _T138
    call _PrintInt
    _T139 = " "
    parm _T139
    call _PrintString
    _T140 = 2
    _T141 = 100
    _T142 = 0
    _T143 = *(_T27 - 4)
    _T144 = (_T142 < _T143)
    if (_T144 == 0) branch _L38
    _T145 = 0
    _T146 = (_T142 < _T145)
    if (_T146 == 0) branch _L39
_L38:
    _T147 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T147
    call _PrintString
    call _Halt
_L39:
    _T148 = 4
    _T149 = (_T142 * _T148)
    _T150 = (_T27 + _T149)
    _T151 = *(_T150 + 0)
    parm _T141
    parm _T151
    parm _T26
    _T152 =  call _Main.Binky
    _T153 = (_T140 * _T152)
    parm _T153
    call _PrintInt
}

