VTABLE(_QueueItem) {
    <empty>
    QueueItem
    _QueueItem.Init;
    _QueueItem.GetData;
    _QueueItem.GetNext;
    _QueueItem.GetPrev;
    _QueueItem.SetNext;
    _QueueItem.SetPrev;
}

VTABLE(_Queue) {
    <empty>
    Queue
    _Queue.Init;
    _Queue.EnQueue;
    _Queue.DeQueue;
}

VTABLE(_Main) {
    <empty>
    Main
}

FUNCTION(_QueueItem_New) {
memo ''
_QueueItem_New:
    _T18 = 16
    parm _T18
    _T19 =  call _Alloc
    _T20 = 0
    *(_T19 + 4) = _T20
    *(_T19 + 8) = _T20
    *(_T19 + 12) = _T20
    _T21 = VTBL <_QueueItem>
    *(_T19 + 0) = _T21
    return _T19
}

FUNCTION(_Queue_New) {
memo ''
_Queue_New:
    _T22 = 12
    parm _T22
    _T23 =  call _Alloc
    _T24 = 0
    *(_T23 + 4) = _T24
    *(_T23 + 8) = _T24
    _T25 = VTBL <_Queue>
    *(_T23 + 0) = _T25
    return _T23
}

FUNCTION(_Main_New) {
memo ''
_Main_New:
    _T26 = 4
    parm _T26
    _T27 =  call _Alloc
    _T28 = VTBL <_Main>
    *(_T27 + 0) = _T28
    return _T27
}

FUNCTION(_QueueItem.Init) {
memo '_T3:4 _T4:8 _T5:12 _T6:16'
_QueueItem.Init:
    _T29 = *(_T3 + 4)
    *(_T3 + 4) = _T4
    _T30 = *(_T3 + 8)
    *(_T3 + 8) = _T5
    _T31 = *(_T5 + 12)
    *(_T5 + 12) = _T3
    _T32 = *(_T3 + 12)
    *(_T3 + 12) = _T6
    _T33 = *(_T6 + 8)
    *(_T6 + 8) = _T3
}

FUNCTION(_QueueItem.GetData) {
memo '_T7:4'
_QueueItem.GetData:
    _T34 = *(_T7 + 4)
    return _T34
}

FUNCTION(_QueueItem.GetNext) {
memo '_T8:4'
_QueueItem.GetNext:
    _T35 = *(_T8 + 8)
    return _T35
}

FUNCTION(_QueueItem.GetPrev) {
memo '_T9:4'
_QueueItem.GetPrev:
    _T36 = *(_T9 + 12)
    return _T36
}

FUNCTION(_QueueItem.SetNext) {
memo '_T10:4 _T11:8'
_QueueItem.SetNext:
    _T37 = *(_T10 + 8)
    *(_T10 + 8) = _T11
}

FUNCTION(_QueueItem.SetPrev) {
memo '_T12:4 _T13:8'
_QueueItem.SetPrev:
    _T38 = *(_T12 + 12)
    *(_T12 + 12) = _T13
}

FUNCTION(_Queue.Init) {
memo '_T14:4'
_Queue.Init:
    _T39 = *(_T14 + 8)
    _T40 =  call _QueueItem_New
    _T41 = 1
    _T0 = (_T0 + _T41)
    *(_T14 + 8) = _T40
    _T42 = *(_T14 + 8)
    _T43 = 0
    _T44 = *(_T14 + 8)
    _T45 = *(_T14 + 8)
    parm _T42
    parm _T43
    parm _T44
    parm _T45
    _T46 = *(_T42 + 0)
    _T47 = *(_T46 + 8)
    call _T47
}

FUNCTION(_Queue.EnQueue) {
memo '_T15:4 _T16:8'
_Queue.EnQueue:
    _T49 =  call _QueueItem_New
    _T50 = 1
    _T0 = (_T0 + _T50)
    _T48 = _T49
    _T51 = *(_T15 + 8)
    parm _T51
    _T52 = *(_T51 + 0)
    _T53 = *(_T52 + 16)
    _T54 =  call _T53
    _T55 = *(_T15 + 8)
    parm _T48
    parm _T16
    parm _T54
    parm _T55
    _T56 = *(_T48 + 0)
    _T57 = *(_T56 + 8)
    call _T57
}

FUNCTION(_Queue.DeQueue) {
memo '_T17:4'
_Queue.DeQueue:
    _T59 = *(_T17 + 8)
    parm _T59
    _T60 = *(_T59 + 0)
    _T61 = *(_T60 + 20)
    _T62 =  call _T61
    _T63 = *(_T17 + 8)
    _T64 = (_T62 == _T63)
    if (_T64 == 0) branch _L21
    _T65 = "Queue Is Empty"
    parm _T65
    call _PrintString
    _T66 = 0
    return _T66
    branch _L22
_L21:
    _T68 = *(_T17 + 8)
    parm _T68
    _T69 = *(_T68 + 0)
    _T70 = *(_T69 + 20)
    _T71 =  call _T70
    _T67 = _T71
    parm _T67
    _T72 = *(_T67 + 0)
    _T73 = *(_T72 + 12)
    _T74 =  call _T73
    _T58 = _T74
    parm _T67
    _T75 = *(_T67 + 0)
    _T76 = *(_T75 + 20)
    _T77 =  call _T76
    parm _T67
    _T78 = *(_T67 + 0)
    _T79 = *(_T78 + 16)
    _T80 =  call _T79
    parm _T77
    parm _T80
    _T81 = *(_T77 + 0)
    _T82 = *(_T81 + 24)
    call _T82
    parm _T67
    _T83 = *(_T67 + 0)
    _T84 = *(_T83 + 16)
    _T85 =  call _T84
    parm _T67
    _T86 = *(_T67 + 0)
    _T87 = *(_T86 + 20)
    _T88 =  call _T87
    parm _T85
    parm _T88
    _T89 = *(_T85 + 0)
    _T90 = *(_T89 + 28)
    call _T90
_L22:
    return _T58
}

FUNCTION(main) {
memo ''
main:
    _T93 =  call _Queue_New
    _T94 = 1
    _T1 = (_T1 + _T94)
    _T91 = _T93
    parm _T91
    _T95 = *(_T91 + 0)
    _T96 = *(_T95 + 8)
    call _T96
    _T97 = 0
    _T92 = _T97
    branch _L23
_L24:
    _T98 = 1
    _T99 = (_T92 + _T98)
    _T92 = _T99
_L23:
    _T100 = 10
    _T101 = (_T92 < _T100)
    if (_T101 == 0) branch _L25
    parm _T91
    parm _T92
    _T102 = *(_T91 + 0)
    _T103 = *(_T102 + 12)
    call _T103
    branch _L24
_L25:
    _T104 = 0
    _T92 = _T104
    branch _L26
_L27:
    _T105 = 1
    _T106 = (_T92 + _T105)
    _T92 = _T106
_L26:
    _T107 = 4
    _T108 = (_T92 < _T107)
    if (_T108 == 0) branch _L28
    parm _T91
    _T109 = *(_T91 + 0)
    _T110 = *(_T109 + 16)
    _T111 =  call _T110
    parm _T111
    call _PrintInt
    _T112 = " "
    parm _T112
    call _PrintString
    branch _L27
_L28:
    _T113 = "\n"
    parm _T113
    call _PrintString
    _T114 = 0
    _T92 = _T114
    branch _L29
_L30:
    _T115 = 1
    _T116 = (_T92 + _T115)
    _T92 = _T116
_L29:
    _T117 = 10
    _T118 = (_T92 < _T117)
    if (_T118 == 0) branch _L31
    parm _T91
    parm _T92
    _T119 = *(_T91 + 0)
    _T120 = *(_T119 + 12)
    call _T120
    branch _L30
_L31:
    _T121 = 0
    _T92 = _T121
    branch _L32
_L33:
    _T122 = 1
    _T123 = (_T92 + _T122)
    _T92 = _T123
_L32:
    _T124 = 17
    _T125 = (_T92 < _T124)
    if (_T125 == 0) branch _L34
    parm _T91
    _T126 = *(_T91 + 0)
    _T127 = *(_T126 + 16)
    _T128 =  call _T127
    parm _T128
    call _PrintInt
    _T129 = " "
    parm _T129
    call _PrintString
    branch _L33
_L34:
    _T130 = "\n"
    parm _T130
    call _PrintString
}

