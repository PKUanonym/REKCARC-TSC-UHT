VTABLE(_TreeNode) {
    <empty>
    TreeNode
    _TreeNode.COPY;
    _TreeNode.init;
    _TreeNode.print;
    _TreeNode.getleft;
    _TreeNode.getright;
}

VTABLE(_Main) {
    <empty>
    Main
    _Main.COPY;
}

FUNCTION(_TreeNode_New) {
memo ''
_TreeNode_New:
    _T11 = 16
    parm _T11
    _T12 =  call _Alloc
    _T13 = 0
    *(_T12 + 4) = _T13
    *(_T12 + 8) = _T13
    *(_T12 + 12) = _T13
    _T14 = VTBL <_TreeNode>
    *(_T12 + 0) = _T14
    return _T12
}

FUNCTION(_TreeNode.COPY) {
memo '_T15:4'
_TreeNode.COPY:
    _T16 = 16
    parm _T16
    _T17 =  call _Alloc
    _T18 = *(_T15 + 4)
    *(_T17 + 4) = _T18
    _T19 = *(_T15 + 8)
    *(_T17 + 8) = _T19
    _T20 = *(_T15 + 12)
    *(_T17 + 12) = _T20
    _T21 = VTBL <_TreeNode>
    *(_T17 + 0) = _T21
    return _T17
}

FUNCTION(_Main_New) {
memo ''
_Main_New:
    _T22 = 4
    parm _T22
    _T23 =  call _Alloc
    _T24 = VTBL <_Main>
    *(_T23 + 0) = _T24
    return _T23
}

FUNCTION(_Main.COPY) {
memo '_T25:4'
_Main.COPY:
    _T26 = 4
    parm _T26
    _T27 =  call _Alloc
    _T28 = VTBL <_Main>
    *(_T27 + 0) = _T28
    return _T27
}

FUNCTION(_TreeNode.init) {
memo '_T0:4 _T1:8 _T2:12 _T3:16'
_TreeNode.init:
    _T29 = *(_T0 + 4)
    *(_T0 + 4) = _T1
    _T30 = *(_T0 + 8)
    *(_T0 + 8) = _T2
    _T31 = *(_T0 + 12)
    *(_T0 + 12) = _T3
}

FUNCTION(_TreeNode.print) {
memo '_T4:4'
_TreeNode.print:
    _T32 = *(_T4 + 12)
    parm _T32
    call _PrintString
    _T33 = "\n"
    parm _T33
    call _PrintString
}

FUNCTION(_TreeNode.getleft) {
memo '_T5:4'
_TreeNode.getleft:
    _T34 = *(_T5 + 4)
    return _T34
}

FUNCTION(_TreeNode.getright) {
memo '_T6:4'
_TreeNode.getright:
    _T35 = *(_T6 + 8)
    return _T35
}

FUNCTION(_Main.lowestCommonAncestor) {
memo '_T7:4 _T8:8 _T9:12 _T10:16'
_Main.lowestCommonAncestor:
    _T36 = (_T7 == _T10)
    if (_T36 == 0) branch _L18
    return _T10
_L18:
    _T37 = (_T7 == _T8)
    _T38 = (_T7 == _T9)
    _T39 = (_T37 || _T38)
    if (_T39 == 0) branch _L19
    return _T7
_L19:
    parm _T7
    _T42 = *(_T7 + 0)
    _T43 = *(_T42 + 20)
    _T44 =  call _T43
    parm _T44
    parm _T8
    parm _T9
    parm _T10
    _T45 =  call _Main.lowestCommonAncestor
    _T40 = _T45
    parm _T7
    _T46 = *(_T7 + 0)
    _T47 = *(_T46 + 24)
    _T48 =  call _T47
    parm _T48
    parm _T8
    parm _T9
    parm _T10
    _T49 =  call _Main.lowestCommonAncestor
    _T41 = _T49
    _T50 = (_T40 == _T10)
    _T51 = (_T41 == _T10)
    _T52 = (_T50 && _T51)
    if (_T52 == 0) branch _L20
    _T53 = 0
    return _T53
_L20:
    _T54 = (_T40 != _T10)
    _T55 = (_T41 != _T10)
    _T56 = (_T54 && _T55)
    if (_T56 == 0) branch _L21
    return _T7
_L21:
    _T58 = (_T40 != _T10)
    if (_T58 == 0) branch _L22
    _T57 = _T40
    branch _L23
_L22:
    _T57 = _T41
_L23:
    return _T57
}

FUNCTION(main) {
memo ''
main:
    _T69 =  call _TreeNode_New
    _T67 = _T69
    _T70 =  call _TreeNode_New
    _T59 = _T70
    _T71 =  call _TreeNode_New
    _T60 = _T71
    _T72 =  call _TreeNode_New
    _T61 = _T72
    _T73 =  call _TreeNode_New
    _T62 = _T73
    _T74 =  call _TreeNode_New
    _T63 = _T74
    _T75 =  call _TreeNode_New
    _T64 = _T75
    _T76 =  call _TreeNode_New
    _T65 = _T76
    _T77 =  call _TreeNode_New
    _T66 = _T77
    _T78 = "A"
    parm _T59
    parm _T60
    parm _T61
    parm _T78
    _T79 = *(_T59 + 0)
    _T80 = *(_T79 + 12)
    call _T80
    _T81 = "B"
    parm _T60
    parm _T63
    parm _T62
    parm _T81
    _T82 = *(_T60 + 0)
    _T83 = *(_T82 + 12)
    call _T83
    _T84 = "C"
    parm _T61
    parm _T64
    parm _T65
    parm _T84
    _T85 = *(_T61 + 0)
    _T86 = *(_T85 + 12)
    call _T86
    _T87 = "D"
    parm _T62
    parm _T66
    parm _T67
    parm _T87
    _T88 = *(_T62 + 0)
    _T89 = *(_T88 + 12)
    call _T89
    _T90 = "E"
    parm _T63
    parm _T67
    parm _T67
    parm _T90
    _T91 = *(_T63 + 0)
    _T92 = *(_T91 + 12)
    call _T92
    _T93 = "F"
    parm _T64
    parm _T67
    parm _T67
    parm _T93
    _T94 = *(_T64 + 0)
    _T95 = *(_T94 + 12)
    call _T95
    _T96 = "G"
    parm _T65
    parm _T67
    parm _T67
    parm _T96
    _T97 = *(_T65 + 0)
    _T98 = *(_T97 + 12)
    call _T98
    _T99 = "H"
    parm _T66
    parm _T67
    parm _T67
    parm _T99
    _T100 = *(_T66 + 0)
    _T101 = *(_T100 + 12)
    call _T101
    parm _T59
    parm _T60
    parm _T62
    parm _T67
    _T102 =  call _Main.lowestCommonAncestor
    _T68 = _T102
    parm _T68
    _T103 = *(_T68 + 0)
    _T104 = *(_T103 + 16)
    call _T104
    parm _T59
    parm _T61
    parm _T62
    parm _T67
    _T105 =  call _Main.lowestCommonAncestor
    _T68 = _T105
    parm _T68
    _T106 = *(_T68 + 0)
    _T107 = *(_T106 + 16)
    call _T107
    parm _T59
    parm _T65
    parm _T64
    parm _T67
    _T108 =  call _Main.lowestCommonAncestor
    _T68 = _T108
    parm _T68
    _T109 = *(_T68 + 0)
    _T110 = *(_T109 + 16)
    call _T110
    parm _T59
    parm _T66
    parm _T63
    parm _T67
    _T111 =  call _Main.lowestCommonAncestor
    _T68 = _T111
    parm _T68
    _T112 = *(_T68 + 0)
    _T113 = *(_T112 + 16)
    call _T113
    parm _T59
    parm _T66
    parm _T65
    parm _T67
    _T114 =  call _Main.lowestCommonAncestor
    _T68 = _T114
    parm _T68
    _T115 = *(_T68 + 0)
    _T116 = *(_T115 + 16)
    call _T116
}

