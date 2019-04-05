VTABLE(_Stack) {
    <empty>
    Stack
    _Stack.Init;
    _Stack.Push;
    _Stack.Pop;
    _Stack.NumElems;
}

VTABLE(_Main) {
    <empty>
    Main
}

FUNCTION(_Stack_New) {
memo ''
_Stack_New:
    _T7 = 12
    parm _T7
    _T8 =  call _Alloc
    _T9 = 0
    *(_T8 + 4) = _T9
    *(_T8 + 8) = _T9
    _T10 = VTBL <_Stack>
    *(_T8 + 0) = _T10
    return _T8
}

FUNCTION(_Main_New) {
memo ''
_Main_New:
    _T11 = 4
    parm _T11
    _T12 =  call _Alloc
    _T13 = VTBL <_Main>
    *(_T12 + 0) = _T13
    return _T12
}

FUNCTION(_Stack.Init) {
memo '_T2:4'
_Stack.Init:
    _T14 = *(_T2 + 8)
    _T15 = 100
    _T16 = 0
    _T17 = (_T15 < _T16)
    if (_T17 == 0) branch _L16
    _T18 = "Decaf runtime error: Cannot create negative-sized array\n"
    parm _T18
    call _PrintString
    call _Halt
_L16:
    _T19 = 4
    _T20 = (_T19 * _T15)
    _T21 = (_T19 + _T20)
    parm _T21
    _T22 =  call _Alloc
    *(_T22 + 0) = _T15
    _T23 = 0
    _T22 = (_T22 + _T21)
_L17:
    _T21 = (_T21 - _T19)
    if (_T21 == 0) branch _L18
    _T22 = (_T22 - _T19)
    *(_T22 + 0) = _T23
    branch _L17
_L18:
    *(_T2 + 8) = _T22
    _T24 = *(_T2 + 4)
    _T25 = 0
    *(_T2 + 4) = _T25
    _T26 = 3
    parm _T2
    parm _T26
    _T27 = *(_T2 + 0)
    _T28 = *(_T27 + 12)
    call _T28
}

FUNCTION(_Stack.Push) {
memo '_T3:4 _T4:8'
_Stack.Push:
    _T29 = *(_T3 + 8)
    _T30 = *(_T3 + 4)
    _T31 = *(_T29 - 4)
    _T32 = (_T30 < _T31)
    if (_T32 == 0) branch _L19
    _T33 = 0
    _T34 = (_T30 < _T33)
    if (_T34 == 0) branch _L20
_L19:
    _T35 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T35
    call _PrintString
    call _Halt
_L20:
    _T36 = 4
    _T37 = (_T30 * _T36)
    _T38 = (_T29 + _T37)
    _T39 = *(_T38 + 0)
    _T40 = 4
    _T41 = (_T30 * _T40)
    _T42 = (_T29 + _T41)
    *(_T42 + 0) = _T4
    _T43 = *(_T3 + 4)
    _T44 = *(_T3 + 4)
    _T45 = 1
    _T46 = (_T44 + _T45)
    *(_T3 + 4) = _T46
}

FUNCTION(_Stack.Pop) {
memo '_T5:4'
_Stack.Pop:
    _T48 = *(_T5 + 8)
    _T49 = *(_T5 + 4)
    _T50 = 1
    _T51 = (_T49 - _T50)
    _T52 = *(_T48 - 4)
    _T53 = (_T51 < _T52)
    if (_T53 == 0) branch _L21
    _T54 = 0
    _T55 = (_T51 < _T54)
    if (_T55 == 0) branch _L22
_L21:
    _T56 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T56
    call _PrintString
    call _Halt
_L22:
    _T57 = 4
    _T58 = (_T51 * _T57)
    _T59 = (_T48 + _T58)
    _T60 = *(_T59 + 0)
    _T47 = _T60
    _T61 = *(_T5 + 4)
    _T62 = *(_T5 + 4)
    _T63 = 1
    _T64 = (_T62 - _T63)
    *(_T5 + 4) = _T64
    return _T47
}

FUNCTION(_Stack.NumElems) {
memo '_T6:4'
_Stack.NumElems:
    _T65 = *(_T6 + 4)
    return _T65
}

FUNCTION(_Stack.main) {
memo ''
_Stack.main:
    _T67 =  call _Stack_New
    _T68 = 1
    _T0 = (_T0 + _T68)
    _T66 = _T67
    parm _T66
    _T69 = *(_T66 + 0)
    _T70 = *(_T69 + 8)
    call _T70
    _T71 = 3
    parm _T66
    parm _T71
    _T72 = *(_T66 + 0)
    _T73 = *(_T72 + 12)
    call _T73
    _T74 = 7
    parm _T66
    parm _T74
    _T75 = *(_T66 + 0)
    _T76 = *(_T75 + 12)
    call _T76
    _T77 = 4
    parm _T66
    parm _T77
    _T78 = *(_T66 + 0)
    _T79 = *(_T78 + 12)
    call _T79
    parm _T66
    _T80 = *(_T66 + 0)
    _T81 = *(_T80 + 20)
    _T82 =  call _T81
    parm _T82
    call _PrintInt
    _T83 = " "
    parm _T83
    call _PrintString
    parm _T66
    _T84 = *(_T66 + 0)
    _T85 = *(_T84 + 16)
    _T86 =  call _T85
    parm _T86
    call _PrintInt
    _T87 = " "
    parm _T87
    call _PrintString
    parm _T66
    _T88 = *(_T66 + 0)
    _T89 = *(_T88 + 16)
    _T90 =  call _T89
    parm _T90
    call _PrintInt
    _T91 = " "
    parm _T91
    call _PrintString
    parm _T66
    _T92 = *(_T66 + 0)
    _T93 = *(_T92 + 16)
    _T94 =  call _T93
    parm _T94
    call _PrintInt
    _T95 = " "
    parm _T95
    call _PrintString
    parm _T66
    _T96 = *(_T66 + 0)
    _T97 = *(_T96 + 20)
    _T98 =  call _T97
    parm _T98
    call _PrintInt
}

FUNCTION(main) {
memo ''
main:
    call _Stack.main
}

