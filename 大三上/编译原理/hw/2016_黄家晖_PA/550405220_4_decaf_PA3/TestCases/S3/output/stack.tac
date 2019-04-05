VTABLE(_Stack) {
    <empty>
    Stack
    _Stack.COPY;
    _Stack.Init;
    _Stack.Push;
    _Stack.Pop;
    _Stack.NumElems;
}

VTABLE(_Main) {
    <empty>
    Main
    _Main.COPY;
}

FUNCTION(_Stack_New) {
memo ''
_Stack_New:
    _T5 = 12
    parm _T5
    _T6 =  call _Alloc
    _T7 = 0
    *(_T6 + 4) = _T7
    *(_T6 + 8) = _T7
    _T8 = VTBL <_Stack>
    *(_T6 + 0) = _T8
    return _T6
}

FUNCTION(_Stack.COPY) {
memo '_T9:4'
_Stack.COPY:
    _T10 = 12
    parm _T10
    _T11 =  call _Alloc
    _T12 = *(_T9 + 4)
    *(_T11 + 4) = _T12
    _T13 = *(_T9 + 8)
    *(_T11 + 8) = _T13
    _T14 = VTBL <_Stack>
    *(_T11 + 0) = _T14
    return _T11
}

FUNCTION(_Main_New) {
memo ''
_Main_New:
    _T15 = 4
    parm _T15
    _T16 =  call _Alloc
    _T17 = VTBL <_Main>
    *(_T16 + 0) = _T17
    return _T16
}

FUNCTION(_Main.COPY) {
memo '_T18:4'
_Main.COPY:
    _T19 = 4
    parm _T19
    _T20 =  call _Alloc
    _T21 = VTBL <_Main>
    *(_T20 + 0) = _T21
    return _T20
}

FUNCTION(_Stack.Init) {
memo '_T0:4'
_Stack.Init:
    _T22 = *(_T0 + 8)
    _T23 = 100
    _T24 = 0
    _T25 = (_T23 < _T24)
    if (_T25 == 0) branch _L18
    _T26 = "Decaf runtime error: Cannot create negative-sized array\n"
    parm _T26
    call _PrintString
    call _Halt
_L18:
    _T27 = 4
    _T28 = (_T27 * _T23)
    _T29 = (_T27 + _T28)
    parm _T29
    _T30 =  call _Alloc
    *(_T30 + 0) = _T23
    _T31 = 0
    _T30 = (_T30 + _T29)
_L19:
    _T29 = (_T29 - _T27)
    if (_T29 == 0) branch _L20
    _T30 = (_T30 - _T27)
    *(_T30 + 0) = _T31
    branch _L19
_L20:
    *(_T0 + 8) = _T30
    _T32 = *(_T0 + 4)
    _T33 = 0
    *(_T0 + 4) = _T33
    _T34 = 3
    parm _T0
    parm _T34
    _T35 = *(_T0 + 0)
    _T36 = *(_T35 + 16)
    call _T36
}

FUNCTION(_Stack.Push) {
memo '_T1:4 _T2:8'
_Stack.Push:
    _T37 = *(_T1 + 8)
    _T38 = *(_T1 + 4)
    _T39 = *(_T37 - 4)
    _T40 = (_T38 < _T39)
    if (_T40 == 0) branch _L21
    _T41 = 0
    _T42 = (_T38 < _T41)
    if (_T42 == 0) branch _L22
_L21:
    _T43 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T43
    call _PrintString
    call _Halt
_L22:
    _T44 = 4
    _T45 = (_T38 * _T44)
    _T46 = (_T37 + _T45)
    _T47 = *(_T46 + 0)
    _T48 = 4
    _T49 = (_T38 * _T48)
    _T50 = (_T37 + _T49)
    *(_T50 + 0) = _T2
    _T51 = *(_T1 + 4)
    _T52 = *(_T1 + 4)
    _T53 = 1
    _T54 = (_T52 + _T53)
    *(_T1 + 4) = _T54
}

FUNCTION(_Stack.Pop) {
memo '_T3:4'
_Stack.Pop:
    _T56 = *(_T3 + 8)
    _T57 = *(_T3 + 4)
    _T58 = 1
    _T59 = (_T57 - _T58)
    _T60 = *(_T56 - 4)
    _T61 = (_T59 < _T60)
    if (_T61 == 0) branch _L23
    _T62 = 0
    _T63 = (_T59 < _T62)
    if (_T63 == 0) branch _L24
_L23:
    _T64 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T64
    call _PrintString
    call _Halt
_L24:
    _T65 = 4
    _T66 = (_T59 * _T65)
    _T67 = (_T56 + _T66)
    _T68 = *(_T67 + 0)
    _T55 = _T68
    _T69 = *(_T3 + 4)
    _T70 = *(_T3 + 4)
    _T71 = 1
    _T72 = (_T70 - _T71)
    *(_T3 + 4) = _T72
    return _T55
}

FUNCTION(_Stack.NumElems) {
memo '_T4:4'
_Stack.NumElems:
    _T73 = *(_T4 + 4)
    return _T73
}

FUNCTION(_Stack.main) {
memo ''
_Stack.main:
    _T75 =  call _Stack_New
    _T74 = _T75
    parm _T74
    _T76 = *(_T74 + 0)
    _T77 = *(_T76 + 12)
    call _T77
    _T78 = 3
    parm _T74
    parm _T78
    _T79 = *(_T74 + 0)
    _T80 = *(_T79 + 16)
    call _T80
    _T81 = 7
    parm _T74
    parm _T81
    _T82 = *(_T74 + 0)
    _T83 = *(_T82 + 16)
    call _T83
    _T84 = 4
    parm _T74
    parm _T84
    _T85 = *(_T74 + 0)
    _T86 = *(_T85 + 16)
    call _T86
    parm _T74
    _T87 = *(_T74 + 0)
    _T88 = *(_T87 + 24)
    _T89 =  call _T88
    parm _T89
    call _PrintInt
    _T90 = " "
    parm _T90
    call _PrintString
    parm _T74
    _T91 = *(_T74 + 0)
    _T92 = *(_T91 + 20)
    _T93 =  call _T92
    parm _T93
    call _PrintInt
    _T94 = " "
    parm _T94
    call _PrintString
    parm _T74
    _T95 = *(_T74 + 0)
    _T96 = *(_T95 + 20)
    _T97 =  call _T96
    parm _T97
    call _PrintInt
    _T98 = " "
    parm _T98
    call _PrintString
    parm _T74
    _T99 = *(_T74 + 0)
    _T100 = *(_T99 + 20)
    _T101 =  call _T100
    parm _T101
    call _PrintInt
    _T102 = " "
    parm _T102
    call _PrintString
    parm _T74
    _T103 = *(_T74 + 0)
    _T104 = *(_T103 + 24)
    _T105 =  call _T104
    parm _T105
    call _PrintInt
}

FUNCTION(main) {
memo ''
main:
    call _Stack.main
}

