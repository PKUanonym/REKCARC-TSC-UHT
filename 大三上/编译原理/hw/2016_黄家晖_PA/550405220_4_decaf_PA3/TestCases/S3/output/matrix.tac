VTABLE(_Matrix) {
    <empty>
    Matrix
    _Matrix.COPY;
    _Matrix.Init;
    _Matrix.Set;
    _Matrix.Get;
    _Matrix.PrintMatrix;
    _Matrix.SeedMatrix;
}

VTABLE(_DenseMatrix) {
    _Matrix
    DenseMatrix
    _DenseMatrix.COPY;
    _DenseMatrix.Init;
    _DenseMatrix.Set;
    _DenseMatrix.Get;
    _Matrix.PrintMatrix;
    _Matrix.SeedMatrix;
}

VTABLE(_SparseItem) {
    <empty>
    SparseItem
    _SparseItem.COPY;
    _SparseItem.Init;
    _SparseItem.GetNext;
    _SparseItem.GetY;
    _SparseItem.GetData;
    _SparseItem.SetData;
}

VTABLE(_SparseMatrix) {
    _Matrix
    SparseMatrix
    _SparseMatrix.COPY;
    _SparseMatrix.Init;
    _SparseMatrix.Set;
    _SparseMatrix.Get;
    _Matrix.PrintMatrix;
    _Matrix.SeedMatrix;
    _SparseMatrix.Find;
}

VTABLE(_Main) {
    <empty>
    Main
    _Main.COPY;
}

FUNCTION(_Matrix_New) {
memo ''
_Matrix_New:
    _T38 = 4
    parm _T38
    _T39 =  call _Alloc
    _T40 = VTBL <_Matrix>
    *(_T39 + 0) = _T40
    return _T39
}

FUNCTION(_Matrix.COPY) {
memo '_T41:4'
_Matrix.COPY:
    _T42 = 4
    parm _T42
    _T43 =  call _Alloc
    _T44 = VTBL <_Matrix>
    *(_T43 + 0) = _T44
    return _T43
}

FUNCTION(_DenseMatrix_New) {
memo ''
_DenseMatrix_New:
    _T45 = 8
    parm _T45
    _T46 =  call _Alloc
    _T47 = 0
    *(_T46 + 4) = _T47
    _T48 = VTBL <_DenseMatrix>
    *(_T46 + 0) = _T48
    return _T46
}

FUNCTION(_DenseMatrix.COPY) {
memo '_T49:4'
_DenseMatrix.COPY:
    _T50 = 8
    parm _T50
    _T51 =  call _Alloc
    _T52 = *(_T49 + 4)
    *(_T51 + 4) = _T52
    _T53 = VTBL <_DenseMatrix>
    *(_T51 + 0) = _T53
    return _T51
}

FUNCTION(_SparseItem_New) {
memo ''
_SparseItem_New:
    _T54 = 16
    parm _T54
    _T55 =  call _Alloc
    _T56 = 0
    *(_T55 + 4) = _T56
    *(_T55 + 8) = _T56
    *(_T55 + 12) = _T56
    _T57 = VTBL <_SparseItem>
    *(_T55 + 0) = _T57
    return _T55
}

FUNCTION(_SparseItem.COPY) {
memo '_T58:4'
_SparseItem.COPY:
    _T59 = 16
    parm _T59
    _T60 =  call _Alloc
    _T61 = *(_T58 + 4)
    *(_T60 + 4) = _T61
    _T62 = *(_T58 + 8)
    *(_T60 + 8) = _T62
    _T63 = *(_T58 + 12)
    *(_T60 + 12) = _T63
    _T64 = VTBL <_SparseItem>
    *(_T60 + 0) = _T64
    return _T60
}

FUNCTION(_SparseMatrix_New) {
memo ''
_SparseMatrix_New:
    _T65 = 8
    parm _T65
    _T66 =  call _Alloc
    _T67 = 0
    *(_T66 + 4) = _T67
    _T68 = VTBL <_SparseMatrix>
    *(_T66 + 0) = _T68
    return _T66
}

FUNCTION(_SparseMatrix.COPY) {
memo '_T69:4'
_SparseMatrix.COPY:
    _T70 = 8
    parm _T70
    _T71 =  call _Alloc
    _T72 = *(_T69 + 4)
    *(_T71 + 4) = _T72
    _T73 = VTBL <_SparseMatrix>
    *(_T71 + 0) = _T73
    return _T71
}

FUNCTION(_Main_New) {
memo ''
_Main_New:
    _T74 = 4
    parm _T74
    _T75 =  call _Alloc
    _T76 = VTBL <_Main>
    *(_T75 + 0) = _T76
    return _T75
}

FUNCTION(_Main.COPY) {
memo '_T77:4'
_Main.COPY:
    _T78 = 4
    parm _T78
    _T79 =  call _Alloc
    _T80 = VTBL <_Main>
    *(_T79 + 0) = _T80
    return _T79
}

FUNCTION(_Matrix.Init) {
memo '_T0:4'
_Matrix.Init:
}

FUNCTION(_Matrix.Set) {
memo '_T1:4 _T2:8 _T3:12 _T4:16'
_Matrix.Set:
}

FUNCTION(_Matrix.Get) {
memo '_T5:4 _T6:8 _T7:12'
_Matrix.Get:
}

FUNCTION(_Matrix.PrintMatrix) {
memo '_T8:4'
_Matrix.PrintMatrix:
    _T83 = 0
    _T81 = _T83
_L36:
    _T84 = 10
    _T85 = (_T81 < _T84)
    if (_T85 == 0) branch _L37
    _T86 = 0
    _T82 = _T86
_L38:
    _T87 = 10
    _T88 = (_T82 < _T87)
    if (_T88 == 0) branch _L39
    parm _T8
    parm _T81
    parm _T82
    _T89 = *(_T8 + 0)
    _T90 = *(_T89 + 20)
    _T91 =  call _T90
    parm _T91
    call _PrintInt
    _T92 = "\t"
    parm _T92
    call _PrintString
    _T93 = 1
    _T94 = (_T82 + _T93)
    _T82 = _T94
    branch _L38
_L39:
    _T95 = 1
    _T96 = (_T81 + _T95)
    _T81 = _T96
    _T97 = "\n"
    parm _T97
    call _PrintString
    branch _L36
_L37:
}

FUNCTION(_Matrix.SeedMatrix) {
memo '_T9:4'
_Matrix.SeedMatrix:
    _T100 = 0
    _T98 = _T100
_L40:
    _T101 = 5
    _T102 = (_T98 < _T101)
    if (_T102 == 0) branch _L41
    _T103 = 0
    _T99 = _T103
_L42:
    _T104 = 5
    _T105 = (_T99 < _T104)
    if (_T105 == 0) branch _L43
    _T106 = (_T98 + _T99)
    parm _T9
    parm _T98
    parm _T99
    parm _T106
    _T107 = *(_T9 + 0)
    _T108 = *(_T107 + 16)
    call _T108
    _T109 = 1
    _T110 = (_T99 + _T109)
    _T99 = _T110
    branch _L42
_L43:
    _T111 = 1
    _T112 = (_T98 + _T111)
    _T98 = _T112
    branch _L40
_L41:
    _T113 = 2
    _T114 = 3
    _T115 = 4
    parm _T9
    parm _T113
    parm _T114
    parm _T115
    _T116 = *(_T9 + 0)
    _T117 = *(_T116 + 16)
    call _T117
    _T118 = 4
    _T119 = 6
    _T120 = 2
    parm _T9
    parm _T118
    parm _T119
    parm _T120
    _T121 = *(_T9 + 0)
    _T122 = *(_T121 + 16)
    call _T122
    _T123 = 2
    _T124 = 3
    _T125 = 5
    parm _T9
    parm _T123
    parm _T124
    parm _T125
    _T126 = *(_T9 + 0)
    _T127 = *(_T126 + 16)
    call _T127
    _T128 = 0
    _T129 = 0
    _T130 = 1
    parm _T9
    parm _T128
    parm _T129
    parm _T130
    _T131 = *(_T9 + 0)
    _T132 = *(_T131 + 16)
    call _T132
    _T133 = 1
    _T134 = 6
    _T135 = 3
    parm _T9
    parm _T133
    parm _T134
    parm _T135
    _T136 = *(_T9 + 0)
    _T137 = *(_T136 + 16)
    call _T137
    _T138 = 7
    _T139 = 7
    _T140 = 7
    parm _T9
    parm _T138
    parm _T139
    parm _T140
    _T141 = *(_T9 + 0)
    _T142 = *(_T141 + 16)
    call _T142
}

FUNCTION(_DenseMatrix.Init) {
memo '_T10:4'
_DenseMatrix.Init:
    _T145 = 0
    _T143 = _T145
    _T146 = *(_T10 + 4)
    _T147 = 10
    _T148 = 0
    _T149 = (_T147 < _T148)
    if (_T149 == 0) branch _L44
    _T150 = "Decaf runtime error: Cannot create negative-sized array\n"
    parm _T150
    call _PrintString
    call _Halt
_L44:
    _T151 = 4
    _T152 = (_T151 * _T147)
    _T153 = (_T151 + _T152)
    parm _T153
    _T154 =  call _Alloc
    *(_T154 + 0) = _T147
    _T155 = 0
    _T154 = (_T154 + _T153)
_L45:
    _T153 = (_T153 - _T151)
    if (_T153 == 0) branch _L46
    _T154 = (_T154 - _T151)
    *(_T154 + 0) = _T155
    branch _L45
_L46:
    *(_T10 + 4) = _T154
_L47:
    _T156 = 10
    _T157 = (_T143 < _T156)
    if (_T157 == 0) branch _L48
    _T158 = *(_T10 + 4)
    _T159 = *(_T158 - 4)
    _T160 = (_T143 < _T159)
    if (_T160 == 0) branch _L49
    _T161 = 0
    _T162 = (_T143 < _T161)
    if (_T162 == 0) branch _L50
_L49:
    _T163 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T163
    call _PrintString
    call _Halt
_L50:
    _T164 = 4
    _T165 = (_T143 * _T164)
    _T166 = (_T158 + _T165)
    _T167 = *(_T166 + 0)
    _T168 = 10
    _T169 = 0
    _T170 = (_T168 < _T169)
    if (_T170 == 0) branch _L51
    _T171 = "Decaf runtime error: Cannot create negative-sized array\n"
    parm _T171
    call _PrintString
    call _Halt
_L51:
    _T172 = 4
    _T173 = (_T172 * _T168)
    _T174 = (_T172 + _T173)
    parm _T174
    _T175 =  call _Alloc
    *(_T175 + 0) = _T168
    _T176 = 0
    _T175 = (_T175 + _T174)
_L52:
    _T174 = (_T174 - _T172)
    if (_T174 == 0) branch _L53
    _T175 = (_T175 - _T172)
    *(_T175 + 0) = _T176
    branch _L52
_L53:
    _T177 = 4
    _T178 = (_T143 * _T177)
    _T179 = (_T158 + _T178)
    *(_T179 + 0) = _T175
    _T180 = 1
    _T181 = (_T143 + _T180)
    _T143 = _T181
    branch _L47
_L48:
    _T182 = 0
    _T143 = _T182
_L54:
    _T183 = 10
    _T184 = (_T143 < _T183)
    if (_T184 == 0) branch _L55
    _T185 = 0
    _T144 = _T185
_L56:
    _T186 = 10
    _T187 = (_T144 < _T186)
    if (_T187 == 0) branch _L57
    _T188 = *(_T10 + 4)
    _T189 = *(_T188 - 4)
    _T190 = (_T143 < _T189)
    if (_T190 == 0) branch _L58
    _T191 = 0
    _T192 = (_T143 < _T191)
    if (_T192 == 0) branch _L59
_L58:
    _T193 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T193
    call _PrintString
    call _Halt
_L59:
    _T194 = 4
    _T195 = (_T143 * _T194)
    _T196 = (_T188 + _T195)
    _T197 = *(_T196 + 0)
    _T198 = *(_T197 - 4)
    _T199 = (_T144 < _T198)
    if (_T199 == 0) branch _L60
    _T200 = 0
    _T201 = (_T144 < _T200)
    if (_T201 == 0) branch _L61
_L60:
    _T202 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T202
    call _PrintString
    call _Halt
_L61:
    _T203 = 4
    _T204 = (_T144 * _T203)
    _T205 = (_T197 + _T204)
    _T206 = *(_T205 + 0)
    _T207 = 0
    _T208 = 4
    _T209 = (_T144 * _T208)
    _T210 = (_T197 + _T209)
    *(_T210 + 0) = _T207
    _T211 = 1
    _T212 = (_T144 + _T211)
    _T144 = _T212
    branch _L56
_L57:
    _T213 = 1
    _T214 = (_T143 + _T213)
    _T143 = _T214
    branch _L54
_L55:
}

FUNCTION(_DenseMatrix.Set) {
memo '_T11:4 _T12:8 _T13:12 _T14:16'
_DenseMatrix.Set:
    _T215 = *(_T11 + 4)
    _T216 = *(_T215 - 4)
    _T217 = (_T12 < _T216)
    if (_T217 == 0) branch _L62
    _T218 = 0
    _T219 = (_T12 < _T218)
    if (_T219 == 0) branch _L63
_L62:
    _T220 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T220
    call _PrintString
    call _Halt
_L63:
    _T221 = 4
    _T222 = (_T12 * _T221)
    _T223 = (_T215 + _T222)
    _T224 = *(_T223 + 0)
    _T225 = *(_T224 - 4)
    _T226 = (_T13 < _T225)
    if (_T226 == 0) branch _L64
    _T227 = 0
    _T228 = (_T13 < _T227)
    if (_T228 == 0) branch _L65
_L64:
    _T229 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T229
    call _PrintString
    call _Halt
_L65:
    _T230 = 4
    _T231 = (_T13 * _T230)
    _T232 = (_T224 + _T231)
    _T233 = *(_T232 + 0)
    _T234 = 4
    _T235 = (_T13 * _T234)
    _T236 = (_T224 + _T235)
    *(_T236 + 0) = _T14
}

FUNCTION(_DenseMatrix.Get) {
memo '_T15:4 _T16:8 _T17:12'
_DenseMatrix.Get:
    _T237 = *(_T15 + 4)
    _T238 = *(_T237 - 4)
    _T239 = (_T16 < _T238)
    if (_T239 == 0) branch _L66
    _T240 = 0
    _T241 = (_T16 < _T240)
    if (_T241 == 0) branch _L67
_L66:
    _T242 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T242
    call _PrintString
    call _Halt
_L67:
    _T243 = 4
    _T244 = (_T16 * _T243)
    _T245 = (_T237 + _T244)
    _T246 = *(_T245 + 0)
    _T247 = *(_T246 - 4)
    _T248 = (_T17 < _T247)
    if (_T248 == 0) branch _L68
    _T249 = 0
    _T250 = (_T17 < _T249)
    if (_T250 == 0) branch _L69
_L68:
    _T251 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T251
    call _PrintString
    call _Halt
_L69:
    _T252 = 4
    _T253 = (_T17 * _T252)
    _T254 = (_T246 + _T253)
    _T255 = *(_T254 + 0)
    return _T255
}

FUNCTION(_SparseItem.Init) {
memo '_T18:4 _T19:8 _T20:12 _T21:16'
_SparseItem.Init:
    _T256 = *(_T18 + 4)
    *(_T18 + 4) = _T19
    _T257 = *(_T18 + 8)
    *(_T18 + 8) = _T20
    _T258 = *(_T18 + 12)
    *(_T18 + 12) = _T21
}

FUNCTION(_SparseItem.GetNext) {
memo '_T22:4'
_SparseItem.GetNext:
    _T259 = *(_T22 + 12)
    return _T259
}

FUNCTION(_SparseItem.GetY) {
memo '_T23:4'
_SparseItem.GetY:
    _T260 = *(_T23 + 8)
    return _T260
}

FUNCTION(_SparseItem.GetData) {
memo '_T24:4'
_SparseItem.GetData:
    _T261 = *(_T24 + 4)
    return _T261
}

FUNCTION(_SparseItem.SetData) {
memo '_T25:4 _T26:8'
_SparseItem.SetData:
    _T262 = *(_T25 + 4)
    *(_T25 + 4) = _T26
}

FUNCTION(_SparseMatrix.Init) {
memo '_T27:4'
_SparseMatrix.Init:
    _T264 = 0
    _T263 = _T264
    _T265 = *(_T27 + 4)
    _T266 = 10
    _T267 = 0
    _T268 = (_T266 < _T267)
    if (_T268 == 0) branch _L70
    _T269 = "Decaf runtime error: Cannot create negative-sized array\n"
    parm _T269
    call _PrintString
    call _Halt
_L70:
    _T270 = 4
    _T271 = (_T270 * _T266)
    _T272 = (_T270 + _T271)
    parm _T272
    _T273 =  call _Alloc
    *(_T273 + 0) = _T266
    _T274 = 0
    _T273 = (_T273 + _T272)
_L71:
    _T272 = (_T272 - _T270)
    if (_T272 == 0) branch _L72
    _T273 = (_T273 - _T270)
    *(_T273 + 0) = _T274
    branch _L71
_L72:
    *(_T27 + 4) = _T273
_L73:
    _T275 = 10
    _T276 = (_T263 < _T275)
    if (_T276 == 0) branch _L74
    _T277 = *(_T27 + 4)
    _T278 = *(_T277 - 4)
    _T279 = (_T263 < _T278)
    if (_T279 == 0) branch _L75
    _T280 = 0
    _T281 = (_T263 < _T280)
    if (_T281 == 0) branch _L76
_L75:
    _T282 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T282
    call _PrintString
    call _Halt
_L76:
    _T283 = 4
    _T284 = (_T263 * _T283)
    _T285 = (_T277 + _T284)
    _T286 = *(_T285 + 0)
    _T287 = 0
    _T288 = 4
    _T289 = (_T263 * _T288)
    _T290 = (_T277 + _T289)
    *(_T290 + 0) = _T287
    _T291 = 1
    _T292 = (_T263 + _T291)
    _T263 = _T292
    branch _L73
_L74:
}

FUNCTION(_SparseMatrix.Find) {
memo '_T28:4 _T29:8 _T30:12'
_SparseMatrix.Find:
    _T294 = *(_T28 + 4)
    _T295 = *(_T294 - 4)
    _T296 = (_T29 < _T295)
    if (_T296 == 0) branch _L77
    _T297 = 0
    _T298 = (_T29 < _T297)
    if (_T298 == 0) branch _L78
_L77:
    _T299 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T299
    call _PrintString
    call _Halt
_L78:
    _T300 = 4
    _T301 = (_T29 * _T300)
    _T302 = (_T294 + _T301)
    _T303 = *(_T302 + 0)
    _T293 = _T303
_L79:
    _T304 = 0
    _T305 = (_T293 != _T304)
    if (_T305 == 0) branch _L80
    parm _T293
    _T306 = *(_T293 + 0)
    _T307 = *(_T306 + 20)
    _T308 =  call _T307
    _T309 = (_T308 == _T30)
    if (_T309 == 0) branch _L81
    return _T293
_L81:
    parm _T293
    _T310 = *(_T293 + 0)
    _T311 = *(_T310 + 16)
    _T312 =  call _T311
    _T293 = _T312
    branch _L79
_L80:
    _T313 = 0
    return _T313
}

FUNCTION(_SparseMatrix.Set) {
memo '_T31:4 _T32:8 _T33:12 _T34:16'
_SparseMatrix.Set:
    parm _T31
    parm _T32
    parm _T33
    _T315 = *(_T31 + 0)
    _T316 = *(_T315 + 32)
    _T317 =  call _T316
    _T314 = _T317
    _T318 = 0
    _T319 = (_T314 != _T318)
    if (_T319 == 0) branch _L82
    parm _T314
    parm _T34
    _T320 = *(_T314 + 0)
    _T321 = *(_T320 + 28)
    call _T321
    branch _L83
_L82:
    _T322 =  call _SparseItem_New
    _T314 = _T322
    _T323 = *(_T31 + 4)
    _T324 = *(_T323 - 4)
    _T325 = (_T32 < _T324)
    if (_T325 == 0) branch _L84
    _T326 = 0
    _T327 = (_T32 < _T326)
    if (_T327 == 0) branch _L85
_L84:
    _T328 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T328
    call _PrintString
    call _Halt
_L85:
    _T329 = 4
    _T330 = (_T32 * _T329)
    _T331 = (_T323 + _T330)
    _T332 = *(_T331 + 0)
    parm _T314
    parm _T34
    parm _T33
    parm _T332
    _T333 = *(_T314 + 0)
    _T334 = *(_T333 + 12)
    call _T334
    _T335 = *(_T31 + 4)
    _T336 = *(_T335 - 4)
    _T337 = (_T32 < _T336)
    if (_T337 == 0) branch _L86
    _T338 = 0
    _T339 = (_T32 < _T338)
    if (_T339 == 0) branch _L87
_L86:
    _T340 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T340
    call _PrintString
    call _Halt
_L87:
    _T341 = 4
    _T342 = (_T32 * _T341)
    _T343 = (_T335 + _T342)
    _T344 = *(_T343 + 0)
    _T345 = 4
    _T346 = (_T32 * _T345)
    _T347 = (_T335 + _T346)
    *(_T347 + 0) = _T314
_L83:
}

FUNCTION(_SparseMatrix.Get) {
memo '_T35:4 _T36:8 _T37:12'
_SparseMatrix.Get:
    parm _T35
    parm _T36
    parm _T37
    _T349 = *(_T35 + 0)
    _T350 = *(_T349 + 32)
    _T351 =  call _T350
    _T348 = _T351
    _T352 = 0
    _T353 = (_T348 != _T352)
    if (_T353 == 0) branch _L88
    parm _T348
    _T354 = *(_T348 + 0)
    _T355 = *(_T354 + 24)
    _T356 =  call _T355
    return _T356
    branch _L89
_L88:
    _T357 = 0
    return _T357
_L89:
}

FUNCTION(main) {
memo ''
main:
    _T359 = "Dense Rep \n"
    parm _T359
    call _PrintString
    _T360 =  call _DenseMatrix_New
    _T358 = _T360
    parm _T358
    _T361 = *(_T358 + 0)
    _T362 = *(_T361 + 12)
    call _T362
    parm _T358
    _T363 = *(_T358 + 0)
    _T364 = *(_T363 + 28)
    call _T364
    parm _T358
    _T365 = *(_T358 + 0)
    _T366 = *(_T365 + 24)
    call _T366
    _T367 = "Sparse Rep \n"
    parm _T367
    call _PrintString
    _T368 =  call _SparseMatrix_New
    _T358 = _T368
    parm _T358
    _T369 = *(_T358 + 0)
    _T370 = *(_T369 + 12)
    call _T370
    parm _T358
    _T371 = *(_T358 + 0)
    _T372 = *(_T371 + 28)
    call _T372
    parm _T358
    _T373 = *(_T358 + 0)
    _T374 = *(_T373 + 24)
    call _T374
}

