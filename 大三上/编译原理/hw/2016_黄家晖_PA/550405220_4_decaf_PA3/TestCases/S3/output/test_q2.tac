VTABLE(_A) {
    <empty>
    A
    _A.COPY;
    _A.setA;
    _A.printA;
    _A.fun;
}

VTABLE(_B) {
    _A
    B
    _B.COPY;
    _A.setA;
    _A.printA;
    _B.fun;
    _B.setB;
    _B.printB;
}

VTABLE(_C) {
    _A
    C
    _C.COPY;
    _A.setA;
    _A.printA;
    _C.fun;
    _C.setC;
    _C.printC;
}

VTABLE(_D) {
    _B
    D
    _D.COPY;
    _A.setA;
    _A.printA;
    _D.fun;
    _B.setB;
    _B.printB;
    _D.setD;
    _D.printD;
}

VTABLE(_E) {
    _C
    E
    _E.COPY;
    _A.setA;
    _A.printA;
    _E.fun;
    _C.setC;
    _C.printC;
    _E.setE;
    _E.printE;
}

VTABLE(_F) {
    _E
    F
    _F.COPY;
    _A.setA;
    _A.printA;
    _F.fun;
    _C.setC;
    _C.printC;
    _E.setE;
    _E.printE;
    _F.setF;
    _F.printF;
}

VTABLE(_G) {
    _C
    G
    _G.COPY;
    _A.setA;
    _A.printA;
    _G.fun;
    _C.setC;
    _C.printC;
    _G.setG;
    _G.printG;
}

VTABLE(_Main) {
    <empty>
    Main
    _Main.COPY;
}

FUNCTION(_A_New) {
memo ''
_A_New:
    _T36 = 12
    parm _T36
    _T37 =  call _Alloc
    _T38 = 0
    *(_T37 + 4) = _T38
    *(_T37 + 8) = _T38
    _T39 = VTBL <_A>
    *(_T37 + 0) = _T39
    return _T37
}

FUNCTION(_A.COPY) {
memo '_T40:4'
_A.COPY:
    _T41 = 12
    parm _T41
    _T42 =  call _Alloc
    _T43 = *(_T40 + 4)
    *(_T42 + 4) = _T43
    _T44 = *(_T40 + 8)
    *(_T42 + 8) = _T44
    _T45 = VTBL <_A>
    *(_T42 + 0) = _T45
    return _T42
}

FUNCTION(_B_New) {
memo ''
_B_New:
    _T46 = 20
    parm _T46
    _T47 =  call _Alloc
    _T48 = 0
    *(_T47 + 4) = _T48
    *(_T47 + 8) = _T48
    *(_T47 + 12) = _T48
    *(_T47 + 16) = _T48
    _T49 = VTBL <_B>
    *(_T47 + 0) = _T49
    return _T47
}

FUNCTION(_B.COPY) {
memo '_T50:4'
_B.COPY:
    _T51 = 20
    parm _T51
    _T52 =  call _Alloc
    _T53 = *(_T50 + 4)
    *(_T52 + 4) = _T53
    _T54 = *(_T50 + 8)
    *(_T52 + 8) = _T54
    _T55 = *(_T50 + 12)
    *(_T52 + 12) = _T55
    _T56 = *(_T50 + 16)
    *(_T52 + 16) = _T56
    _T57 = VTBL <_B>
    *(_T52 + 0) = _T57
    return _T52
}

FUNCTION(_C_New) {
memo ''
_C_New:
    _T58 = 20
    parm _T58
    _T59 =  call _Alloc
    _T60 = 0
    *(_T59 + 4) = _T60
    *(_T59 + 8) = _T60
    *(_T59 + 12) = _T60
    *(_T59 + 16) = _T60
    _T61 = VTBL <_C>
    *(_T59 + 0) = _T61
    return _T59
}

FUNCTION(_C.COPY) {
memo '_T62:4'
_C.COPY:
    _T63 = 20
    parm _T63
    _T64 =  call _Alloc
    _T65 = *(_T62 + 4)
    *(_T64 + 4) = _T65
    _T66 = *(_T62 + 8)
    *(_T64 + 8) = _T66
    _T67 = *(_T62 + 12)
    *(_T64 + 12) = _T67
    _T68 = *(_T62 + 16)
    *(_T64 + 16) = _T68
    _T69 = VTBL <_C>
    *(_T64 + 0) = _T69
    return _T64
}

FUNCTION(_D_New) {
memo ''
_D_New:
    _T70 = 28
    parm _T70
    _T71 =  call _Alloc
    _T72 = 0
    _T73 = 4
    _T74 = (_T71 + _T70)
_L38:
    _T75 = (_T74 - _T73)
    _T74 = _T75
    _T76 = (_T70 - _T73)
    _T70 = _T76
    if (_T70 == 0) branch _L39
    *(_T74 + 0) = _T72
    branch _L38
_L39:
    _T77 = VTBL <_D>
    *(_T74 + 0) = _T77
    return _T74
}

FUNCTION(_D.COPY) {
memo '_T78:4'
_D.COPY:
    _T79 = 28
    parm _T79
    _T80 =  call _Alloc
    _T81 = *(_T78 + 4)
    *(_T80 + 4) = _T81
    _T82 = *(_T78 + 8)
    *(_T80 + 8) = _T82
    _T83 = *(_T78 + 12)
    *(_T80 + 12) = _T83
    _T84 = *(_T78 + 16)
    *(_T80 + 16) = _T84
    _T85 = *(_T78 + 20)
    *(_T80 + 20) = _T85
    _T86 = *(_T78 + 24)
    *(_T80 + 24) = _T86
    _T87 = VTBL <_D>
    *(_T80 + 0) = _T87
    return _T80
}

FUNCTION(_E_New) {
memo ''
_E_New:
    _T88 = 28
    parm _T88
    _T89 =  call _Alloc
    _T90 = 0
    _T91 = 4
    _T92 = (_T89 + _T88)
_L42:
    _T93 = (_T92 - _T91)
    _T92 = _T93
    _T94 = (_T88 - _T91)
    _T88 = _T94
    if (_T88 == 0) branch _L43
    *(_T92 + 0) = _T90
    branch _L42
_L43:
    _T95 = VTBL <_E>
    *(_T92 + 0) = _T95
    return _T92
}

FUNCTION(_E.COPY) {
memo '_T96:4'
_E.COPY:
    _T97 = 28
    parm _T97
    _T98 =  call _Alloc
    _T99 = *(_T96 + 4)
    *(_T98 + 4) = _T99
    _T100 = *(_T96 + 8)
    *(_T98 + 8) = _T100
    _T101 = *(_T96 + 12)
    *(_T98 + 12) = _T101
    _T102 = *(_T96 + 16)
    *(_T98 + 16) = _T102
    _T103 = *(_T96 + 20)
    *(_T98 + 20) = _T103
    _T104 = *(_T96 + 24)
    *(_T98 + 24) = _T104
    _T105 = VTBL <_E>
    *(_T98 + 0) = _T105
    return _T98
}

FUNCTION(_F_New) {
memo ''
_F_New:
    _T106 = 36
    parm _T106
    _T107 =  call _Alloc
    _T108 = 0
    _T109 = 4
    _T110 = (_T107 + _T106)
_L46:
    _T111 = (_T110 - _T109)
    _T110 = _T111
    _T112 = (_T106 - _T109)
    _T106 = _T112
    if (_T106 == 0) branch _L47
    *(_T110 + 0) = _T108
    branch _L46
_L47:
    _T113 = VTBL <_F>
    *(_T110 + 0) = _T113
    return _T110
}

FUNCTION(_F.COPY) {
memo '_T114:4'
_F.COPY:
    _T115 = 36
    parm _T115
    _T116 =  call _Alloc
    _T117 = *(_T114 + 4)
    *(_T116 + 4) = _T117
    _T118 = *(_T114 + 8)
    *(_T116 + 8) = _T118
    _T119 = *(_T114 + 12)
    *(_T116 + 12) = _T119
    _T120 = *(_T114 + 16)
    *(_T116 + 16) = _T120
    _T121 = *(_T114 + 20)
    *(_T116 + 20) = _T121
    _T122 = *(_T114 + 24)
    *(_T116 + 24) = _T122
    _T123 = *(_T114 + 28)
    *(_T116 + 28) = _T123
    _T124 = *(_T114 + 32)
    *(_T116 + 32) = _T124
    _T125 = VTBL <_F>
    *(_T116 + 0) = _T125
    return _T116
}

FUNCTION(_G_New) {
memo ''
_G_New:
    _T126 = 24
    parm _T126
    _T127 =  call _Alloc
    _T128 = 0
    _T129 = 4
    _T130 = (_T127 + _T126)
_L50:
    _T131 = (_T130 - _T129)
    _T130 = _T131
    _T132 = (_T126 - _T129)
    _T126 = _T132
    if (_T126 == 0) branch _L51
    *(_T130 + 0) = _T128
    branch _L50
_L51:
    _T133 = VTBL <_G>
    *(_T130 + 0) = _T133
    return _T130
}

FUNCTION(_G.COPY) {
memo '_T134:4'
_G.COPY:
    _T135 = 24
    parm _T135
    _T136 =  call _Alloc
    _T137 = *(_T134 + 4)
    *(_T136 + 4) = _T137
    _T138 = *(_T134 + 8)
    *(_T136 + 8) = _T138
    _T139 = *(_T134 + 12)
    *(_T136 + 12) = _T139
    _T140 = *(_T134 + 16)
    *(_T136 + 16) = _T140
    _T141 = *(_T134 + 20)
    *(_T136 + 20) = _T141
    _T142 = VTBL <_G>
    *(_T136 + 0) = _T142
    return _T136
}

FUNCTION(_Main_New) {
memo ''
_Main_New:
    _T143 = 4
    parm _T143
    _T144 =  call _Alloc
    _T145 = VTBL <_Main>
    *(_T144 + 0) = _T145
    return _T144
}

FUNCTION(_Main.COPY) {
memo '_T146:4'
_Main.COPY:
    _T147 = 4
    parm _T147
    _T148 =  call _Alloc
    _T149 = VTBL <_Main>
    *(_T148 + 0) = _T149
    return _T148
}

FUNCTION(_A.setA) {
memo '_T0:4 _T1:8 _T2:12'
_A.setA:
    _T150 = *(_T0 + 4)
    *(_T0 + 4) = _T1
    _T151 = *(_T0 + 8)
    *(_T0 + 8) = _T2
}

FUNCTION(_A.printA) {
memo '_T3:4'
_A.printA:
    _T152 = " a="
    parm _T152
    call _PrintString
    _T153 = *(_T3 + 4)
    parm _T153
    call _PrintInt
    _T154 = " a1="
    parm _T154
    call _PrintString
    _T155 = *(_T3 + 8)
    parm _T155
    call _PrintInt
    _T156 = " "
    parm _T156
    call _PrintString
}

FUNCTION(_A.fun) {
memo '_T4:4'
_A.fun:
    _T157 = "A"
    parm _T157
    call _PrintString
    parm _T4
    _T158 = *(_T4 + 0)
    _T159 = *(_T158 + 16)
    call _T159
    _T160 = "\n"
    parm _T160
    call _PrintString
}

FUNCTION(_B.setB) {
memo '_T5:4 _T6:8 _T7:12'
_B.setB:
    _T161 = *(_T5 + 12)
    *(_T5 + 12) = _T6
    _T162 = *(_T5 + 16)
    *(_T5 + 16) = _T7
}

FUNCTION(_B.printB) {
memo '_T8:4'
_B.printB:
    _T163 = " b="
    parm _T163
    call _PrintString
    _T164 = *(_T8 + 12)
    parm _T164
    call _PrintInt
    _T165 = " b1="
    parm _T165
    call _PrintString
    _T166 = *(_T8 + 16)
    parm _T166
    call _PrintInt
    _T167 = " "
    parm _T167
    call _PrintString
}

FUNCTION(_B.fun) {
memo '_T9:4'
_B.fun:
    _T168 = "B"
    parm _T168
    call _PrintString
    parm _T9
    _T169 = *(_T9 + 0)
    _T170 = *(_T169 + 16)
    call _T170
    parm _T9
    _T171 = *(_T9 + 0)
    _T172 = *(_T171 + 28)
    call _T172
    _T173 = "\n"
    parm _T173
    call _PrintString
}

FUNCTION(_C.setC) {
memo '_T10:4 _T11:8 _T12:12'
_C.setC:
    _T174 = *(_T10 + 12)
    *(_T10 + 12) = _T11
    _T175 = *(_T10 + 16)
    *(_T10 + 16) = _T12
}

FUNCTION(_C.printC) {
memo '_T13:4'
_C.printC:
    _T176 = " c="
    parm _T176
    call _PrintString
    _T177 = *(_T13 + 12)
    parm _T177
    call _PrintInt
    _T178 = " c1="
    parm _T178
    call _PrintString
    _T179 = *(_T13 + 16)
    parm _T179
    call _PrintInt
    _T180 = " "
    parm _T180
    call _PrintString
}

FUNCTION(_C.fun) {
memo '_T14:4'
_C.fun:
    _T181 = "C"
    parm _T181
    call _PrintString
    parm _T14
    _T182 = *(_T14 + 0)
    _T183 = *(_T182 + 16)
    call _T183
    parm _T14
    _T184 = *(_T14 + 0)
    _T185 = *(_T184 + 28)
    call _T185
    _T186 = "\n"
    parm _T186
    call _PrintString
}

FUNCTION(_D.setD) {
memo '_T15:4 _T16:8 _T17:12'
_D.setD:
    _T187 = *(_T15 + 20)
    *(_T15 + 20) = _T16
    _T188 = *(_T15 + 24)
    *(_T15 + 24) = _T17
}

FUNCTION(_D.printD) {
memo '_T18:4'
_D.printD:
    _T189 = " d="
    parm _T189
    call _PrintString
    _T190 = *(_T18 + 20)
    parm _T190
    call _PrintInt
    _T191 = " d1="
    parm _T191
    call _PrintString
    _T192 = *(_T18 + 24)
    parm _T192
    call _PrintInt
    _T193 = " "
    parm _T193
    call _PrintString
}

FUNCTION(_D.fun) {
memo '_T19:4'
_D.fun:
    _T194 = "D"
    parm _T194
    call _PrintString
    parm _T19
    _T195 = *(_T19 + 0)
    _T196 = *(_T195 + 16)
    call _T196
    parm _T19
    _T197 = *(_T19 + 0)
    _T198 = *(_T197 + 28)
    call _T198
    parm _T19
    _T199 = *(_T19 + 0)
    _T200 = *(_T199 + 36)
    call _T200
    _T201 = "\n"
    parm _T201
    call _PrintString
}

FUNCTION(_E.setE) {
memo '_T20:4 _T21:8 _T22:12'
_E.setE:
    _T202 = *(_T20 + 20)
    *(_T20 + 20) = _T21
    _T203 = *(_T20 + 24)
    *(_T20 + 24) = _T22
}

FUNCTION(_E.printE) {
memo '_T23:4'
_E.printE:
    _T204 = " e="
    parm _T204
    call _PrintString
    _T205 = *(_T23 + 20)
    parm _T205
    call _PrintInt
    _T206 = " e1="
    parm _T206
    call _PrintString
    _T207 = *(_T23 + 24)
    parm _T207
    call _PrintInt
    _T208 = " "
    parm _T208
    call _PrintString
}

FUNCTION(_E.fun) {
memo '_T24:4'
_E.fun:
    _T209 = "E"
    parm _T209
    call _PrintString
    parm _T24
    _T210 = *(_T24 + 0)
    _T211 = *(_T210 + 16)
    call _T211
    parm _T24
    _T212 = *(_T24 + 0)
    _T213 = *(_T212 + 28)
    call _T213
    parm _T24
    _T214 = *(_T24 + 0)
    _T215 = *(_T214 + 36)
    call _T215
    _T216 = "\n"
    parm _T216
    call _PrintString
}

FUNCTION(_F.setF) {
memo '_T25:4 _T26:8 _T27:12'
_F.setF:
    _T217 = *(_T25 + 28)
    *(_T25 + 28) = _T26
    _T218 = *(_T25 + 32)
    *(_T25 + 32) = _T27
}

FUNCTION(_F.printF) {
memo '_T28:4'
_F.printF:
    _T219 = " f="
    parm _T219
    call _PrintString
    _T220 = *(_T28 + 28)
    parm _T220
    call _PrintInt
    _T221 = " f1="
    parm _T221
    call _PrintString
    _T222 = *(_T28 + 32)
    parm _T222
    call _PrintInt
    _T223 = " "
    parm _T223
    call _PrintString
}

FUNCTION(_F.fun) {
memo '_T29:4'
_F.fun:
    _T224 = "F"
    parm _T224
    call _PrintString
    parm _T29
    _T225 = *(_T29 + 0)
    _T226 = *(_T225 + 16)
    call _T226
    parm _T29
    _T227 = *(_T29 + 0)
    _T228 = *(_T227 + 28)
    call _T228
    parm _T29
    _T229 = *(_T29 + 0)
    _T230 = *(_T229 + 36)
    call _T230
    parm _T29
    _T231 = *(_T29 + 0)
    _T232 = *(_T231 + 44)
    call _T232
    _T233 = "\n"
    parm _T233
    call _PrintString
}

FUNCTION(_G.setG) {
memo '_T30:4 _T31:8'
_G.setG:
    _T234 = *(_T30 + 20)
    *(_T30 + 20) = _T31
}

FUNCTION(_G.printG) {
memo '_T32:4'
_G.printG:
    _T235 = " g="
    parm _T235
    call _PrintString
    _T236 = *(_T32 + 20)
    parm _T236
    call _PrintInt
}

FUNCTION(_G.fun) {
memo '_T33:4'
_G.fun:
    _T237 = "G"
    parm _T237
    call _PrintString
    parm _T33
    _T238 = *(_T33 + 0)
    _T239 = *(_T238 + 16)
    call _T239
    parm _T33
    _T240 = *(_T33 + 0)
    _T241 = *(_T240 + 28)
    call _T241
    parm _T33
    _T242 = *(_T33 + 0)
    _T243 = *(_T242 + 36)
    call _T243
    _T244 = "\n"
    parm _T244
    call _PrintString
}

FUNCTION(_Main.test) {
memo '_T34:4 _T35:8'
_Main.test:
    _T246 = _T34
    _T247 = _T35
_L56:
    _T248 = (_T246 == _T247)
    if (_T248 != 0) branch _L55
    _T249 = *(_T247 + 0)
    _T247 = _T249
    if (_T247 != 0) branch _L56
    _T250 = *(_T246 + 0)
    _T246 = _T250
    _T247 = _T35
    branch _L56
_L55:
    parm _T34
    _T251 = *(_T246 + 8)
    _T252 =  call _T251
    _T245 = _T252
    parm _T245
    _T253 = *(_T245 + 0)
    _T254 = *(_T253 + 20)
    call _T254
}

FUNCTION(main) {
memo ''
main:
    _T263 =  call _A_New
    _T255 = _T263
    _T264 =  call _B_New
    _T257 = _T264
    _T265 =  call _C_New
    _T258 = _T265
    _T266 =  call _D_New
    _T259 = _T266
    _T267 =  call _E_New
    _T260 = _T267
    _T268 =  call _F_New
    _T261 = _T268
    _T269 =  call _G_New
    _T262 = _T269
    _T270 = 10
    _T271 = 11
    parm _T255
    parm _T270
    parm _T271
    _T272 = *(_T255 + 0)
    _T273 = *(_T272 + 12)
    call _T273
    _T274 = 20
    _T275 = 21
    parm _T257
    parm _T274
    parm _T275
    _T276 = *(_T257 + 0)
    _T277 = *(_T276 + 12)
    call _T277
    _T278 = 22
    _T279 = 23
    parm _T257
    parm _T278
    parm _T279
    _T280 = *(_T257 + 0)
    _T281 = *(_T280 + 24)
    call _T281
    _T282 = 30
    _T283 = 31
    parm _T258
    parm _T282
    parm _T283
    _T284 = *(_T258 + 0)
    _T285 = *(_T284 + 12)
    call _T285
    _T286 = 32
    _T287 = 33
    parm _T258
    parm _T286
    parm _T287
    _T288 = *(_T258 + 0)
    _T289 = *(_T288 + 24)
    call _T289
    _T290 = 40
    _T291 = 41
    parm _T259
    parm _T290
    parm _T291
    _T292 = *(_T259 + 0)
    _T293 = *(_T292 + 12)
    call _T293
    _T294 = 42
    _T295 = 43
    parm _T259
    parm _T294
    parm _T295
    _T296 = *(_T259 + 0)
    _T297 = *(_T296 + 24)
    call _T297
    _T298 = 44
    _T299 = 45
    parm _T259
    parm _T298
    parm _T299
    _T300 = *(_T259 + 0)
    _T301 = *(_T300 + 32)
    call _T301
    _T302 = 50
    _T303 = 51
    parm _T260
    parm _T302
    parm _T303
    _T304 = *(_T260 + 0)
    _T305 = *(_T304 + 12)
    call _T305
    _T306 = 52
    _T307 = 53
    parm _T260
    parm _T306
    parm _T307
    _T308 = *(_T260 + 0)
    _T309 = *(_T308 + 24)
    call _T309
    _T310 = 54
    _T311 = 55
    parm _T260
    parm _T310
    parm _T311
    _T312 = *(_T260 + 0)
    _T313 = *(_T312 + 32)
    call _T313
    _T314 = 60
    _T315 = 61
    parm _T261
    parm _T314
    parm _T315
    _T316 = *(_T261 + 0)
    _T317 = *(_T316 + 12)
    call _T317
    _T318 = 62
    _T319 = 63
    parm _T261
    parm _T318
    parm _T319
    _T320 = *(_T261 + 0)
    _T321 = *(_T320 + 24)
    call _T321
    _T322 = 64
    _T323 = 65
    parm _T261
    parm _T322
    parm _T323
    _T324 = *(_T261 + 0)
    _T325 = *(_T324 + 32)
    call _T325
    _T326 = 66
    _T327 = 67
    parm _T261
    parm _T326
    parm _T327
    _T328 = *(_T261 + 0)
    _T329 = *(_T328 + 40)
    call _T329
    _T330 = 70
    _T331 = 71
    parm _T262
    parm _T330
    parm _T331
    _T332 = *(_T262 + 0)
    _T333 = *(_T332 + 12)
    call _T333
    _T334 = 72
    _T335 = 73
    parm _T262
    parm _T334
    parm _T335
    _T336 = *(_T262 + 0)
    _T337 = *(_T336 + 24)
    call _T337
    _T338 = 74
    parm _T262
    parm _T338
    _T339 = *(_T262 + 0)
    _T340 = *(_T339 + 32)
    call _T340
    parm _T255
    parm _T257
    call _Main.test
    parm _T257
    parm _T255
    call _Main.test
    parm _T257
    parm _T258
    call _Main.test
    parm _T258
    parm _T257
    call _Main.test
    parm _T257
    parm _T260
    call _Main.test
    parm _T260
    parm _T257
    call _Main.test
    parm _T255
    parm _T261
    call _Main.test
    parm _T261
    parm _T255
    call _Main.test
    parm _T260
    parm _T261
    call _Main.test
    parm _T261
    parm _T260
    call _Main.test
    parm _T259
    parm _T257
    call _Main.test
    parm _T257
    parm _T259
    call _Main.test
    parm _T259
    parm _T257
    call _Main.test
    parm _T259
    parm _T261
    call _Main.test
    parm _T261
    parm _T259
    call _Main.test
    parm _T261
    parm _T262
    call _Main.test
    parm _T262
    parm _T261
    call _Main.test
    _T341 = "other test\n"
    parm _T341
    call _PrintString
    _T342 = _T261
    _T343 = _T260
_L58:
    _T344 = (_T342 == _T343)
    if (_T344 != 0) branch _L57
    _T345 = *(_T343 + 0)
    _T343 = _T345
    if (_T343 != 0) branch _L58
    _T346 = *(_T342 + 0)
    _T342 = _T346
    _T343 = _T260
    branch _L58
_L57:
    parm _T261
    _T347 = *(_T342 + 8)
    _T348 =  call _T347
    _T349 = _T348
    _T350 = _T259
_L60:
    _T351 = (_T349 == _T350)
    if (_T351 != 0) branch _L59
    _T352 = *(_T350 + 0)
    _T350 = _T352
    if (_T350 != 0) branch _L60
    _T353 = *(_T349 + 0)
    _T349 = _T353
    _T350 = _T259
    branch _L60
_L59:
    parm _T348
    _T354 = *(_T349 + 8)
    _T355 =  call _T354
    _T255 = _T355
    parm _T255
    _T356 = *(_T255 + 0)
    _T357 = *(_T356 + 20)
    call _T357
    _T358 = _T257
    _T359 = _T258
_L62:
    _T360 = (_T358 == _T359)
    if (_T360 != 0) branch _L61
    _T361 = *(_T359 + 0)
    _T359 = _T361
    if (_T359 != 0) branch _L62
    _T362 = *(_T358 + 0)
    _T358 = _T362
    _T359 = _T258
    branch _L62
_L61:
    parm _T257
    _T363 = *(_T358 + 8)
    _T364 =  call _T363
    _T255 = _T364
    _T365 = _T258
    _T366 = _T257
_L64:
    _T367 = (_T365 == _T366)
    if (_T367 != 0) branch _L63
    _T368 = *(_T366 + 0)
    _T366 = _T368
    if (_T366 != 0) branch _L64
    _T369 = *(_T365 + 0)
    _T365 = _T369
    _T366 = _T257
    branch _L64
_L63:
    parm _T258
    _T370 = *(_T365 + 8)
    _T371 =  call _T370
    _T256 = _T371
    parm _T257
    _T372 = *(_T257 + 0)
    _T373 = *(_T372 + 20)
    call _T373
    parm _T258
    _T374 = *(_T258 + 0)
    _T375 = *(_T374 + 20)
    call _T375
    parm _T255
    _T376 = *(_T255 + 0)
    _T377 = *(_T376 + 20)
    call _T377
    parm _T256
    _T378 = *(_T256 + 0)
    _T379 = *(_T378 + 20)
    call _T379
    _T380 = 987
    _T381 = 345
    parm _T257
    parm _T380
    parm _T381
    _T382 = *(_T257 + 0)
    _T383 = *(_T382 + 12)
    call _T383
    _T384 = 789
    _T385 = 333
    parm _T258
    parm _T384
    parm _T385
    _T386 = *(_T258 + 0)
    _T387 = *(_T386 + 12)
    call _T387
    parm _T257
    _T388 = *(_T257 + 0)
    _T389 = *(_T388 + 20)
    call _T389
    parm _T258
    _T390 = *(_T258 + 0)
    _T391 = *(_T390 + 20)
    call _T391
    parm _T255
    _T392 = *(_T255 + 0)
    _T393 = *(_T392 + 20)
    call _T393
    parm _T256
    _T394 = *(_T256 + 0)
    _T395 = *(_T394 + 20)
    call _T395
    _T396 = _T259
    _T397 = _T257
_L66:
    _T398 = (_T396 == _T397)
    if (_T398 != 0) branch _L65
    _T399 = *(_T397 + 0)
    _T397 = _T399
    if (_T397 != 0) branch _L66
    _T400 = *(_T396 + 0)
    _T396 = _T400
    _T397 = _T257
    branch _L66
_L65:
    parm _T259
    _T401 = *(_T396 + 8)
    _T402 =  call _T401
    _T255 = _T402
    _T404 = VTBL <_B>
    _T405 = *(_T255 + 0)
_L67:
    _T403 = (_T404 == _T405)
    if (_T403 != 0) branch _L68
    _T405 = *(_T405 + 0)
    if (_T405 != 0) branch _L67
    _T403 = 0
_L68:
    _T406 = 1
    _T407 = (_T403 == _T406)
    if (_T407 == 0) branch _L69
    _T408 = "good"
    parm _T408
    call _PrintString
_L69:
    _T409 = _T262
    _T410 = _T261
_L71:
    _T411 = (_T409 == _T410)
    if (_T411 != 0) branch _L70
    _T412 = *(_T410 + 0)
    _T410 = _T412
    if (_T410 != 0) branch _L71
    _T413 = *(_T409 + 0)
    _T409 = _T413
    _T410 = _T261
    branch _L71
_L70:
    parm _T262
    _T414 = *(_T409 + 8)
    _T415 =  call _T414
    _T255 = _T415
    _T417 = VTBL <_C>
    _T418 = *(_T255 + 0)
_L72:
    _T416 = (_T417 == _T418)
    if (_T416 != 0) branch _L73
    _T418 = *(_T418 + 0)
    if (_T418 != 0) branch _L72
    _T416 = 0
_L73:
    _T419 = 1
    _T420 = (_T416 == _T419)
    if (_T420 == 0) branch _L74
    _T421 = "good1"
    parm _T421
    call _PrintString
_L74:
    _T422 = _T261
    _T423 = _T262
_L76:
    _T424 = (_T422 == _T423)
    if (_T424 != 0) branch _L75
    _T425 = *(_T423 + 0)
    _T423 = _T425
    if (_T423 != 0) branch _L76
    _T426 = *(_T422 + 0)
    _T422 = _T426
    _T423 = _T262
    branch _L76
_L75:
    parm _T261
    _T427 = *(_T422 + 8)
    _T428 =  call _T427
    _T255 = _T428
    _T430 = VTBL <_C>
    _T431 = *(_T255 + 0)
_L77:
    _T429 = (_T430 == _T431)
    if (_T429 != 0) branch _L78
    _T431 = *(_T431 + 0)
    if (_T431 != 0) branch _L77
    _T429 = 0
_L78:
    _T432 = 1
    _T433 = (_T429 == _T432)
    if (_T433 == 0) branch _L79
    _T434 = "good2"
    parm _T434
    call _PrintString
_L79:
    _T435 = _T259
    _T436 = _T262
_L81:
    _T437 = (_T435 == _T436)
    if (_T437 != 0) branch _L80
    _T438 = *(_T436 + 0)
    _T436 = _T438
    if (_T436 != 0) branch _L81
    _T439 = *(_T435 + 0)
    _T435 = _T439
    _T436 = _T262
    branch _L81
_L80:
    parm _T259
    _T440 = *(_T435 + 8)
    _T441 =  call _T440
    _T255 = _T441
    _T443 = VTBL <_A>
    _T444 = *(_T255 + 0)
_L82:
    _T442 = (_T443 == _T444)
    if (_T442 != 0) branch _L83
    _T444 = *(_T444 + 0)
    if (_T444 != 0) branch _L82
    _T442 = 0
_L83:
    _T445 = 1
    _T446 = (_T442 == _T445)
    if (_T446 == 0) branch _L84
    _T447 = "good3"
    parm _T447
    call _PrintString
_L84:
}

