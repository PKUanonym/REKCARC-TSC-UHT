VTABLE(_Hanoi) {
    <empty>
    Hanoi
    _Hanoi.init;
    _Hanoi.move;
}

VTABLE(_Main) {
    <empty>
    Main
}

FUNCTION(_Hanoi_New) {
memo ''
_Hanoi_New:
    _T8 = 8
    parm _T8
    _T9 =  call _Alloc
    _T10 = 0
    *(_T9 + 4) = _T10
    _T11 = VTBL <_Hanoi>
    *(_T9 + 0) = _T11
    return _T9
}

FUNCTION(_Main_New) {
memo ''
_Main_New:
    _T12 = 4
    parm _T12
    _T13 =  call _Alloc
    _T14 = VTBL <_Main>
    *(_T13 + 0) = _T14
    return _T13
}

FUNCTION(_Hanoi.init) {
memo '_T2:4'
_Hanoi.init:
    _T15 = *(_T2 + 4)
    _T16 = 0
    *(_T2 + 4) = _T16
}

FUNCTION(_Hanoi.move) {
memo '_T3:4 _T4:8 _T5:12 _T6:16 _T7:20'
_Hanoi.move:
    _T18 = 0
    _T19 = (_T4 == _T18)
    if (_T19 == 0) branch _L13
    return <empty>
_L13:
    _T20 = 1
    _T21 = (_T4 - _T20)
    parm _T3
    parm _T21
    parm _T5
    parm _T7
    parm _T6
    _T22 = *(_T3 + 0)
    _T23 = *(_T22 + 12)
    call _T23
    _T24 = *(_T3 + 4)
    _T17 = _T24
    _T25 = "#"
    parm _T25
    call _PrintString
    _T26 = 0
    _T27 = (_T17 + _T26)
    _T28 = 1
    _T29 = (_T17 + _T28)
    _T17 = _T29
    parm _T27
    call _PrintInt
    _T30 = ": move "
    parm _T30
    call _PrintString
    parm _T4
    call _PrintInt
    _T31 = " from "
    parm _T31
    call _PrintString
    parm _T5
    call _PrintString
    _T32 = " to "
    parm _T32
    call _PrintString
    parm _T6
    call _PrintString
    _T33 = "\n"
    parm _T33
    call _PrintString
    _T34 = *(_T3 + 4)
    *(_T3 + 4) = _T17
    _T35 = 1
    _T36 = (_T4 - _T35)
    parm _T3
    parm _T36
    parm _T7
    parm _T6
    parm _T5
    _T37 = *(_T3 + 0)
    _T38 = *(_T37 + 12)
    call _T38
}

FUNCTION(main) {
memo ''
main:
    _T40 = 5
    _T39 = _T40
    _T41 = "number of disks is "
    parm _T41
    call _PrintString
    parm _T39
    call _PrintInt
    _T42 = "\n"
    parm _T42
    call _PrintString
    _T44 =  call _Hanoi_New
    _T45 = 1
    _T0 = (_T0 + _T45)
    _T43 = _T44
    parm _T43
    _T46 = *(_T43 + 0)
    _T47 = *(_T46 + 8)
    call _T47
    _T48 = "A"
    _T49 = "C"
    _T50 = "B"
    parm _T43
    parm _T39
    parm _T48
    parm _T49
    parm _T50
    _T51 = *(_T43 + 0)
    _T52 = *(_T51 + 12)
    call _T52
}

