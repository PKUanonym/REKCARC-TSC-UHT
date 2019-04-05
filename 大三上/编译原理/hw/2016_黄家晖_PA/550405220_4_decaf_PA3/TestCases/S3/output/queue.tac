VTABLE(_QueueItem) {
    <empty>
    QueueItem
    _QueueItem.COPY;
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
    _Queue.COPY;
    _Queue.Init;
    _Queue.EnQueue;
    _Queue.DeQueue;
}

VTABLE(_Main) {
    <empty>
    Main
    _Main.COPY;
}

FUNCTION(_QueueItem_New) {
memo ''
_QueueItem_New:
    _T15 = 16
    parm _T15
    _T16 =  call _Alloc
    _T17 = 0
    *(_T16 + 4) = _T17
    *(_T16 + 8) = _T17
    *(_T16 + 12) = _T17
    _T18 = VTBL <_QueueItem>
    *(_T16 + 0) = _T18
    return _T16
}

FUNCTION(_QueueItem.COPY) {
memo '_T19:4'
_QueueItem.COPY:
    _T20 = 16
    parm _T20
    _T21 =  call _Alloc
    _T22 = *(_T19 + 4)
    *(_T21 + 4) = _T22
    _T23 = *(_T19 + 8)
    *(_T21 + 8) = _T23
    _T24 = *(_T19 + 12)
    *(_T21 + 12) = _T24
    _T25 = VTBL <_QueueItem>
    *(_T21 + 0) = _T25
    return _T21
}

FUNCTION(_Queue_New) {
memo ''
_Queue_New:
    _T26 = 12
    parm _T26
    _T27 =  call _Alloc
    _T28 = 0
    *(_T27 + 4) = _T28
    *(_T27 + 8) = _T28
    _T29 = VTBL <_Queue>
    *(_T27 + 0) = _T29
    return _T27
}

FUNCTION(_Queue.COPY) {
memo '_T30:4'
_Queue.COPY:
    _T31 = 12
    parm _T31
    _T32 =  call _Alloc
    _T33 = *(_T30 + 4)
    *(_T32 + 4) = _T33
    _T34 = *(_T30 + 8)
    *(_T32 + 8) = _T34
    _T35 = VTBL <_Queue>
    *(_T32 + 0) = _T35
    return _T32
}

FUNCTION(_Main_New) {
memo ''
_Main_New:
    _T36 = 4
    parm _T36
    _T37 =  call _Alloc
    _T38 = VTBL <_Main>
    *(_T37 + 0) = _T38
    return _T37
}

FUNCTION(_Main.COPY) {
memo '_T39:4'
_Main.COPY:
    _T40 = 4
    parm _T40
    _T41 =  call _Alloc
    _T42 = VTBL <_Main>
    *(_T41 + 0) = _T42
    return _T41
}

FUNCTION(_QueueItem.Init) {
memo '_T0:4 _T1:8 _T2:12 _T3:16'
_QueueItem.Init:
    _T43 = *(_T0 + 4)
    *(_T0 + 4) = _T1
    _T44 = *(_T0 + 8)
    *(_T0 + 8) = _T2
    _T45 = *(_T2 + 12)
    *(_T2 + 12) = _T0
    _T46 = *(_T0 + 12)
    *(_T0 + 12) = _T3
    _T47 = *(_T3 + 8)
    *(_T3 + 8) = _T0
}

FUNCTION(_QueueItem.GetData) {
memo '_T4:4'
_QueueItem.GetData:
    _T48 = *(_T4 + 4)
    return _T48
}

FUNCTION(_QueueItem.GetNext) {
memo '_T5:4'
_QueueItem.GetNext:
    _T49 = *(_T5 + 8)
    return _T49
}

FUNCTION(_QueueItem.GetPrev) {
memo '_T6:4'
_QueueItem.GetPrev:
    _T50 = *(_T6 + 12)
    return _T50
}

FUNCTION(_QueueItem.SetNext) {
memo '_T7:4 _T8:8'
_QueueItem.SetNext:
    _T51 = *(_T7 + 8)
    *(_T7 + 8) = _T8
}

FUNCTION(_QueueItem.SetPrev) {
memo '_T9:4 _T10:8'
_QueueItem.SetPrev:
    _T52 = *(_T9 + 12)
    *(_T9 + 12) = _T10
}

FUNCTION(_Queue.Init) {
memo '_T11:4'
_Queue.Init:
    _T53 = *(_T11 + 8)
    _T54 =  call _QueueItem_New
    *(_T11 + 8) = _T54
    _T55 = *(_T11 + 8)
    _T56 = 0
    _T57 = *(_T11 + 8)
    _T58 = *(_T11 + 8)
    parm _T55
    parm _T56
    parm _T57
    parm _T58
    _T59 = *(_T55 + 0)
    _T60 = *(_T59 + 12)
    call _T60
}

FUNCTION(_Queue.EnQueue) {
memo '_T12:4 _T13:8'
_Queue.EnQueue:
    _T62 =  call _QueueItem_New
    _T61 = _T62
    _T63 = *(_T12 + 8)
    parm _T63
    _T64 = *(_T63 + 0)
    _T65 = *(_T64 + 20)
    _T66 =  call _T65
    _T67 = *(_T12 + 8)
    parm _T61
    parm _T13
    parm _T66
    parm _T67
    _T68 = *(_T61 + 0)
    _T69 = *(_T68 + 12)
    call _T69
}

FUNCTION(_Queue.DeQueue) {
memo '_T14:4'
_Queue.DeQueue:
    _T71 = *(_T14 + 8)
    parm _T71
    _T72 = *(_T71 + 0)
    _T73 = *(_T72 + 24)
    _T74 =  call _T73
    _T75 = *(_T14 + 8)
    _T76 = (_T74 == _T75)
    if (_T76 == 0) branch _L24
    _T77 = "Queue Is Empty"
    parm _T77
    call _PrintString
    _T78 = 0
    return _T78
    branch _L25
_L24:
    _T80 = *(_T14 + 8)
    parm _T80
    _T81 = *(_T80 + 0)
    _T82 = *(_T81 + 24)
    _T83 =  call _T82
    _T79 = _T83
    parm _T79
    _T84 = *(_T79 + 0)
    _T85 = *(_T84 + 16)
    _T86 =  call _T85
    _T70 = _T86
    parm _T79
    _T87 = *(_T79 + 0)
    _T88 = *(_T87 + 24)
    _T89 =  call _T88
    parm _T79
    _T90 = *(_T79 + 0)
    _T91 = *(_T90 + 20)
    _T92 =  call _T91
    parm _T89
    parm _T92
    _T93 = *(_T89 + 0)
    _T94 = *(_T93 + 28)
    call _T94
    parm _T79
    _T95 = *(_T79 + 0)
    _T96 = *(_T95 + 20)
    _T97 =  call _T96
    parm _T79
    _T98 = *(_T79 + 0)
    _T99 = *(_T98 + 24)
    _T100 =  call _T99
    parm _T97
    parm _T100
    _T101 = *(_T97 + 0)
    _T102 = *(_T101 + 32)
    call _T102
_L25:
    return _T70
}

FUNCTION(main) {
memo ''
main:
    _T105 =  call _Queue_New
    _T103 = _T105
    parm _T103
    _T106 = *(_T103 + 0)
    _T107 = *(_T106 + 12)
    call _T107
    _T108 = 0
    _T104 = _T108
    branch _L26
_L27:
    _T109 = 1
    _T110 = (_T104 + _T109)
    _T104 = _T110
_L26:
    _T111 = 10
    _T112 = (_T104 < _T111)
    if (_T112 == 0) branch _L28
    parm _T103
    parm _T104
    _T113 = *(_T103 + 0)
    _T114 = *(_T113 + 16)
    call _T114
    branch _L27
_L28:
    _T115 = 0
    _T104 = _T115
    branch _L29
_L30:
    _T116 = 1
    _T117 = (_T104 + _T116)
    _T104 = _T117
_L29:
    _T118 = 4
    _T119 = (_T104 < _T118)
    if (_T119 == 0) branch _L31
    parm _T103
    _T120 = *(_T103 + 0)
    _T121 = *(_T120 + 20)
    _T122 =  call _T121
    parm _T122
    call _PrintInt
    _T123 = " "
    parm _T123
    call _PrintString
    branch _L30
_L31:
    _T124 = "\n"
    parm _T124
    call _PrintString
    _T125 = 0
    _T104 = _T125
    branch _L32
_L33:
    _T126 = 1
    _T127 = (_T104 + _T126)
    _T104 = _T127
_L32:
    _T128 = 10
    _T129 = (_T104 < _T128)
    if (_T129 == 0) branch _L34
    parm _T103
    parm _T104
    _T130 = *(_T103 + 0)
    _T131 = *(_T130 + 16)
    call _T131
    branch _L33
_L34:
    _T132 = 0
    _T104 = _T132
    branch _L35
_L36:
    _T133 = 1
    _T134 = (_T104 + _T133)
    _T104 = _T134
_L35:
    _T135 = 17
    _T136 = (_T104 < _T135)
    if (_T136 == 0) branch _L37
    parm _T103
    _T137 = *(_T103 + 0)
    _T138 = *(_T137 + 20)
    _T139 =  call _T138
    parm _T139
    call _PrintInt
    _T140 = " "
    parm _T140
    call _PrintString
    branch _L36
_L37:
    _T141 = "\n"
    parm _T141
    call _PrintString
}

