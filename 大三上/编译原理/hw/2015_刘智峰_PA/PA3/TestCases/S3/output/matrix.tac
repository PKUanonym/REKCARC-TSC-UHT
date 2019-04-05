VTABLE(_Matrix) {
    <empty>
    Matrix
    _Matrix.Init;
    _Matrix.Set;
    _Matrix.Get;
    _Matrix.PrintMatrix;
    _Matrix.SeedMatrix;
}

VTABLE(_DenseMatrix) {
    _Matrix
    DenseMatrix
    _DenseMatrix.Init;
    _DenseMatrix.Set;
    _DenseMatrix.Get;
    _Matrix.PrintMatrix;
    _Matrix.SeedMatrix;
}

VTABLE(_SparseItem) {
    <empty>
    SparseItem
    _SparseItem.Init;
    _SparseItem.GetNext;
    _SparseItem.GetY;
    _SparseItem.GetData;
    _SparseItem.SetData;
}

VTABLE(_SparseMatrix) {
    _Matrix
    SparseMatrix
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
}

FUNCTION(_Matrix_New) {
memo ''
_Matrix_New:
    _T43 = 4
    parm _T43
    _T44 =  call _Alloc
    _T45 = VTBL <_Matrix>
    *(_T44 + 0) = _T45
    return _T44
}

FUNCTION(_DenseMatrix_New) {
memo ''
_DenseMatrix_New:
    _T46 = 8
    parm _T46
    _T47 =  call _Alloc
    _T48 = 0
    *(_T47 + 4) = _T48
    _T49 = VTBL <_DenseMatrix>
    *(_T47 + 0) = _T49
    return _T47
}

FUNCTION(_SparseItem_New) {
memo ''
_SparseItem_New:
    _T50 = 16
    parm _T50
    _T51 =  call _Alloc
    _T52 = 0
    *(_T51 + 4) = _T52
    *(_T51 + 8) = _T52
    *(_T51 + 12) = _T52
    _T53 = VTBL <_SparseItem>
    *(_T51 + 0) = _T53
    return _T51
}

FUNCTION(_SparseMatrix_New) {
memo ''
_SparseMatrix_New:
    _T54 = 8
    parm _T54
    _T55 =  call _Alloc
    _T56 = 0
    *(_T55 + 4) = _T56
    _T57 = VTBL <_SparseMatrix>
    *(_T55 + 0) = _T57
    return _T55
}

FUNCTION(_Main_New) {
memo ''
_Main_New:
    _T58 = 4
    parm _T58
    _T59 =  call _Alloc
    _T60 = VTBL <_Main>
    *(_T59 + 0) = _T60
    return _T59
}

FUNCTION(_Matrix.Init) {
memo '_T5:4'
_Matrix.Init:
}

FUNCTION(_Matrix.Set) {
memo '_T6:4 _T7:8 _T8:12 _T9:16'
_Matrix.Set:
}

FUNCTION(_Matrix.Get) {
memo '_T10:4 _T11:8 _T12:12'
_Matrix.Get:
}

FUNCTION(_Matrix.PrintMatrix) {
memo '_T13:4'
_Matrix.PrintMatrix:
    _T63 = 0
    _T61 = _T63
_L31:
    _T64 = 10
    _T65 = (_T61 < _T64)
    if (_T65 == 0) branch _L32
    _T66 = 0
    _T62 = _T66
_L33:
    _T67 = 10
    _T68 = (_T62 < _T67)
    if (_T68 == 0) branch _L34
    parm _T13
    parm _T61
    parm _T62
    _T69 = *(_T13 + 0)
    _T70 = *(_T69 + 16)
    _T71 =  call _T70
    parm _T71
    call _PrintInt
    _T72 = "\t"
    parm _T72
    call _PrintString
    _T73 = 1
    _T74 = (_T62 + _T73)
    _T62 = _T74
    branch _L33
_L34:
    _T75 = 1
    _T76 = (_T61 + _T75)
    _T61 = _T76
    _T77 = "\n"
    parm _T77
    call _PrintString
    branch _L31
_L32:
}

FUNCTION(_Matrix.SeedMatrix) {
memo '_T14:4'
_Matrix.SeedMatrix:
    _T80 = 0
    _T78 = _T80
_L35:
    _T81 = 5
    _T82 = (_T78 < _T81)
    if (_T82 == 0) branch _L36
    _T83 = 0
    _T79 = _T83
_L37:
    _T84 = 5
    _T85 = (_T79 < _T84)
    if (_T85 == 0) branch _L38
    _T86 = (_T78 + _T79)
    parm _T14
    parm _T78
    parm _T79
    parm _T86
    _T87 = *(_T14 + 0)
    _T88 = *(_T87 + 12)
    call _T88
    _T89 = 1
    _T90 = (_T79 + _T89)
    _T79 = _T90
    branch _L37
_L38:
    _T91 = 1
    _T92 = (_T78 + _T91)
    _T78 = _T92
    branch _L35
_L36:
    _T93 = 2
    _T94 = 3
    _T95 = 4
    parm _T14
    parm _T93
    parm _T94
    parm _T95
    _T96 = *(_T14 + 0)
    _T97 = *(_T96 + 12)
    call _T97
    _T98 = 4
    _T99 = 6
    _T100 = 2
    parm _T14
    parm _T98
    parm _T99
    parm _T100
    _T101 = *(_T14 + 0)
    _T102 = *(_T101 + 12)
    call _T102
    _T103 = 2
    _T104 = 3
    _T105 = 5
    parm _T14
    parm _T103
    parm _T104
    parm _T105
    _T106 = *(_T14 + 0)
    _T107 = *(_T106 + 12)
    call _T107
    _T108 = 0
    _T109 = 0
    _T110 = 1
    parm _T14
    parm _T108
    parm _T109
    parm _T110
    _T111 = *(_T14 + 0)
    _T112 = *(_T111 + 12)
    call _T112
    _T113 = 1
    _T114 = 6
    _T115 = 3
    parm _T14
    parm _T113
    parm _T114
    parm _T115
    _T116 = *(_T14 + 0)
    _T117 = *(_T116 + 12)
    call _T117
    _T118 = 7
    _T119 = 7
    _T120 = 7
    parm _T14
    parm _T118
    parm _T119
    parm _T120
    _T121 = *(_T14 + 0)
    _T122 = *(_T121 + 12)
    call _T122
}

FUNCTION(_DenseMatrix.Init) {
memo '_T15:4'
_DenseMatrix.Init:
    _T125 = 0
    _T123 = _T125
    _T126 = *(_T15 + 4)
    _T127 = 10
    _T128 = 0
    _T129 = (_T127 < _T128)
    if (_T129 == 0) branch _L39
    _T130 = "Decaf runtime error: Cannot create negative-sized array\n"
    parm _T130
    call _PrintString
    call _Halt
_L39:
    _T131 = 4
    _T132 = (_T131 * _T127)
    _T133 = (_T131 + _T132)
    parm _T133
    _T134 =  call _Alloc
    *(_T134 + 0) = _T127
    _T135 = 0
    _T134 = (_T134 + _T133)
_L40:
    _T133 = (_T133 - _T131)
    if (_T133 == 0) branch _L41
    _T134 = (_T134 - _T131)
    *(_T134 + 0) = _T135
    branch _L40
_L41:
    *(_T15 + 4) = _T134
_L42:
    _T136 = 10
    _T137 = (_T123 < _T136)
    if (_T137 == 0) branch _L43
    _T138 = *(_T15 + 4)
    _T139 = *(_T138 - 4)
    _T140 = (_T123 < _T139)
    if (_T140 == 0) branch _L44
    _T141 = 0
    _T142 = (_T123 < _T141)
    if (_T142 == 0) branch _L45
_L44:
    _T143 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T143
    call _PrintString
    call _Halt
_L45:
    _T144 = 4
    _T145 = (_T123 * _T144)
    _T146 = (_T138 + _T145)
    _T147 = *(_T146 + 0)
    _T148 = 10
    _T149 = 0
    _T150 = (_T148 < _T149)
    if (_T150 == 0) branch _L46
    _T151 = "Decaf runtime error: Cannot create negative-sized array\n"
    parm _T151
    call _PrintString
    call _Halt
_L46:
    _T152 = 4
    _T153 = (_T152 * _T148)
    _T154 = (_T152 + _T153)
    parm _T154
    _T155 =  call _Alloc
    *(_T155 + 0) = _T148
    _T156 = 0
    _T155 = (_T155 + _T154)
_L47:
    _T154 = (_T154 - _T152)
    if (_T154 == 0) branch _L48
    _T155 = (_T155 - _T152)
    *(_T155 + 0) = _T156
    branch _L47
_L48:
    _T157 = 4
    _T158 = (_T123 * _T157)
    _T159 = (_T138 + _T158)
    *(_T159 + 0) = _T155
    _T160 = 1
    _T161 = (_T123 + _T160)
    _T123 = _T161
    branch _L42
_L43:
    _T162 = 0
    _T123 = _T162
_L49:
    _T163 = 10
    _T164 = (_T123 < _T163)
    if (_T164 == 0) branch _L50
    _T165 = 0
    _T124 = _T165
_L51:
    _T166 = 10
    _T167 = (_T124 < _T166)
    if (_T167 == 0) branch _L52
    _T168 = *(_T15 + 4)
    _T169 = *(_T168 - 4)
    _T170 = (_T123 < _T169)
    if (_T170 == 0) branch _L53
    _T171 = 0
    _T172 = (_T123 < _T171)
    if (_T172 == 0) branch _L54
_L53:
    _T173 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T173
    call _PrintString
    call _Halt
_L54:
    _T174 = 4
    _T175 = (_T123 * _T174)
    _T176 = (_T168 + _T175)
    _T177 = *(_T176 + 0)
    _T178 = *(_T177 - 4)
    _T179 = (_T124 < _T178)
    if (_T179 == 0) branch _L55
    _T180 = 0
    _T181 = (_T124 < _T180)
    if (_T181 == 0) branch _L56
_L55:
    _T182 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T182
    call _PrintString
    call _Halt
_L56:
    _T183 = 4
    _T184 = (_T124 * _T183)
    _T185 = (_T177 + _T184)
    _T186 = *(_T185 + 0)
    _T187 = 0
    _T188 = 4
    _T189 = (_T124 * _T188)
    _T190 = (_T177 + _T189)
    *(_T190 + 0) = _T187
    _T191 = 1
    _T192 = (_T124 + _T191)
    _T124 = _T192
    branch _L51
_L52:
    _T193 = 1
    _T194 = (_T123 + _T193)
    _T123 = _T194
    branch _L49
_L50:
}

FUNCTION(_DenseMatrix.Set) {
memo '_T16:4 _T17:8 _T18:12 _T19:16'
_DenseMatrix.Set:
    _T195 = *(_T16 + 4)
    _T196 = *(_T195 - 4)
    _T197 = (_T17 < _T196)
    if (_T197 == 0) branch _L57
    _T198 = 0
    _T199 = (_T17 < _T198)
    if (_T199 == 0) branch _L58
_L57:
    _T200 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T200
    call _PrintString
    call _Halt
_L58:
    _T201 = 4
    _T202 = (_T17 * _T201)
    _T203 = (_T195 + _T202)
    _T204 = *(_T203 + 0)
    _T205 = *(_T204 - 4)
    _T206 = (_T18 < _T205)
    if (_T206 == 0) branch _L59
    _T207 = 0
    _T208 = (_T18 < _T207)
    if (_T208 == 0) branch _L60
_L59:
    _T209 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T209
    call _PrintString
    call _Halt
_L60:
    _T210 = 4
    _T211 = (_T18 * _T210)
    _T212 = (_T204 + _T211)
    _T213 = *(_T212 + 0)
    _T214 = 4
    _T215 = (_T18 * _T214)
    _T216 = (_T204 + _T215)
    *(_T216 + 0) = _T19
}

FUNCTION(_DenseMatrix.Get) {
memo '_T20:4 _T21:8 _T22:12'
_DenseMatrix.Get:
    _T217 = *(_T20 + 4)
    _T218 = *(_T217 - 4)
    _T219 = (_T21 < _T218)
    if (_T219 == 0) branch _L61
    _T220 = 0
    _T221 = (_T21 < _T220)
    if (_T221 == 0) branch _L62
_L61:
    _T222 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T222
    call _PrintString
    call _Halt
_L62:
    _T223 = 4
    _T224 = (_T21 * _T223)
    _T225 = (_T217 + _T224)
    _T226 = *(_T225 + 0)
    _T227 = *(_T226 - 4)
    _T228 = (_T22 < _T227)
    if (_T228 == 0) branch _L63
    _T229 = 0
    _T230 = (_T22 < _T229)
    if (_T230 == 0) branch _L64
_L63:
    _T231 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T231
    call _PrintString
    call _Halt
_L64:
    _T232 = 4
    _T233 = (_T22 * _T232)
    _T234 = (_T226 + _T233)
    _T235 = *(_T234 + 0)
    return _T235
}

FUNCTION(_SparseItem.Init) {
memo '_T23:4 _T24:8 _T25:12 _T26:16'
_SparseItem.Init:
    _T236 = *(_T23 + 4)
    *(_T23 + 4) = _T24
    _T237 = *(_T23 + 8)
    *(_T23 + 8) = _T25
    _T238 = *(_T23 + 12)
    *(_T23 + 12) = _T26
}

FUNCTION(_SparseItem.GetNext) {
memo '_T27:4'
_SparseItem.GetNext:
    _T239 = *(_T27 + 12)
    return _T239
}

FUNCTION(_SparseItem.GetY) {
memo '_T28:4'
_SparseItem.GetY:
    _T240 = *(_T28 + 8)
    return _T240
}

FUNCTION(_SparseItem.GetData) {
memo '_T29:4'
_SparseItem.GetData:
    _T241 = *(_T29 + 4)
    return _T241
}

FUNCTION(_SparseItem.SetData) {
memo '_T30:4 _T31:8'
_SparseItem.SetData:
    _T242 = *(_T30 + 4)
    *(_T30 + 4) = _T31
}

FUNCTION(_SparseMatrix.Init) {
memo '_T32:4'
_SparseMatrix.Init:
    _T244 = 0
    _T243 = _T244
    _T245 = *(_T32 + 4)
    _T246 = 10
    _T247 = 0
    _T248 = (_T246 < _T247)
    if (_T248 == 0) branch _L65
    _T249 = "Decaf runtime error: Cannot create negative-sized array\n"
    parm _T249
    call _PrintString
    call _Halt
_L65:
    _T250 = 4
    _T251 = (_T250 * _T246)
    _T252 = (_T250 + _T251)
    parm _T252
    _T253 =  call _Alloc
    *(_T253 + 0) = _T246
    _T254 = 0
    _T253 = (_T253 + _T252)
_L66:
    _T252 = (_T252 - _T250)
    if (_T252 == 0) branch _L67
    _T253 = (_T253 - _T250)
    *(_T253 + 0) = _T254
    branch _L66
_L67:
    *(_T32 + 4) = _T253
_L68:
    _T255 = 10
    _T256 = (_T243 < _T255)
    if (_T256 == 0) branch _L69
    _T257 = *(_T32 + 4)
    _T258 = *(_T257 - 4)
    _T259 = (_T243 < _T258)
    if (_T259 == 0) branch _L70
    _T260 = 0
    _T261 = (_T243 < _T260)
    if (_T261 == 0) branch _L71
_L70:
    _T262 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T262
    call _PrintString
    call _Halt
_L71:
    _T263 = 4
    _T264 = (_T243 * _T263)
    _T265 = (_T257 + _T264)
    _T266 = *(_T265 + 0)
    _T267 = 0
    _T268 = 4
    _T269 = (_T243 * _T268)
    _T270 = (_T257 + _T269)
    *(_T270 + 0) = _T267
    _T271 = 1
    _T272 = (_T243 + _T271)
    _T243 = _T272
    branch _L68
_L69:
}

FUNCTION(_SparseMatrix.Find) {
memo '_T33:4 _T34:8 _T35:12'
_SparseMatrix.Find:
    _T274 = *(_T33 + 4)
    _T275 = *(_T274 - 4)
    _T276 = (_T34 < _T275)
    if (_T276 == 0) branch _L72
    _T277 = 0
    _T278 = (_T34 < _T277)
    if (_T278 == 0) branch _L73
_L72:
    _T279 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T279
    call _PrintString
    call _Halt
_L73:
    _T280 = 4
    _T281 = (_T34 * _T280)
    _T282 = (_T274 + _T281)
    _T283 = *(_T282 + 0)
    _T273 = _T283
_L74:
    _T284 = 0
    _T285 = (_T273 != _T284)
    if (_T285 == 0) branch _L75
    parm _T273
    _T286 = *(_T273 + 0)
    _T287 = *(_T286 + 16)
    _T288 =  call _T287
    _T289 = (_T288 == _T35)
    if (_T289 == 0) branch _L76
    return _T273
_L76:
    parm _T273
    _T290 = *(_T273 + 0)
    _T291 = *(_T290 + 12)
    _T292 =  call _T291
    _T273 = _T292
    branch _L74
_L75:
    _T293 = 0
    return _T293
}

FUNCTION(_SparseMatrix.Set) {
memo '_T36:4 _T37:8 _T38:12 _T39:16'
_SparseMatrix.Set:
    parm _T36
    parm _T37
    parm _T38
    _T295 = *(_T36 + 0)
    _T296 = *(_T295 + 28)
    _T297 =  call _T296
    _T294 = _T297
    _T298 = 0
    _T299 = (_T294 != _T298)
    if (_T299 == 0) branch _L77
    parm _T294
    parm _T39
    _T300 = *(_T294 + 0)
    _T301 = *(_T300 + 24)
    call _T301
    branch _L78
_L77:
    _T302 =  call _SparseItem_New
    _T303 = 1
    _T2 = (_T2 + _T303)
    _T294 = _T302
    _T304 = *(_T36 + 4)
    _T305 = *(_T304 - 4)
    _T306 = (_T37 < _T305)
    if (_T306 == 0) branch _L79
    _T307 = 0
    _T308 = (_T37 < _T307)
    if (_T308 == 0) branch _L80
_L79:
    _T309 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T309
    call _PrintString
    call _Halt
_L80:
    _T310 = 4
    _T311 = (_T37 * _T310)
    _T312 = (_T304 + _T311)
    _T313 = *(_T312 + 0)
    parm _T294
    parm _T39
    parm _T38
    parm _T313
    _T314 = *(_T294 + 0)
    _T315 = *(_T314 + 8)
    call _T315
    _T316 = *(_T36 + 4)
    _T317 = *(_T316 - 4)
    _T318 = (_T37 < _T317)
    if (_T318 == 0) branch _L81
    _T319 = 0
    _T320 = (_T37 < _T319)
    if (_T320 == 0) branch _L82
_L81:
    _T321 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T321
    call _PrintString
    call _Halt
_L82:
    _T322 = 4
    _T323 = (_T37 * _T322)
    _T324 = (_T316 + _T323)
    _T325 = *(_T324 + 0)
    _T326 = 4
    _T327 = (_T37 * _T326)
    _T328 = (_T316 + _T327)
    *(_T328 + 0) = _T294
_L78:
}

FUNCTION(_SparseMatrix.Get) {
memo '_T40:4 _T41:8 _T42:12'
_SparseMatrix.Get:
    parm _T40
    parm _T41
    parm _T42
    _T330 = *(_T40 + 0)
    _T331 = *(_T330 + 28)
    _T332 =  call _T331
    _T329 = _T332
    _T333 = 0
    _T334 = (_T329 != _T333)
    if (_T334 == 0) branch _L83
    parm _T329
    _T335 = *(_T329 + 0)
    _T336 = *(_T335 + 20)
    _T337 =  call _T336
    return _T337
    branch _L84
_L83:
    _T338 = 0
    return _T338
_L84:
}

FUNCTION(main) {
memo ''
main:
    _T340 = "Dense Rep \n"
    parm _T340
    call _PrintString
    _T341 =  call _DenseMatrix_New
    _T342 = 1
    _T1 = (_T1 + _T342)
    _T339 = _T341
    parm _T339
    _T343 = *(_T339 + 0)
    _T344 = *(_T343 + 8)
    call _T344
    parm _T339
    _T345 = *(_T339 + 0)
    _T346 = *(_T345 + 24)
    call _T346
    parm _T339
    _T347 = *(_T339 + 0)
    _T348 = *(_T347 + 20)
    call _T348
    _T349 = "Sparse Rep \n"
    parm _T349
    call _PrintString
    _T350 =  call _SparseMatrix_New
    _T351 = 1
    _T3 = (_T3 + _T351)
    _T339 = _T350
    parm _T339
    _T352 = *(_T339 + 0)
    _T353 = *(_T352 + 8)
    call _T353
    parm _T339
    _T354 = *(_T339 + 0)
    _T355 = *(_T354 + 24)
    call _T355
    parm _T339
    _T356 = *(_T339 + 0)
    _T357 = *(_T356 + 20)
    call _T357
}

