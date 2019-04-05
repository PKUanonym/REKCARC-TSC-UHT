VTABLE(_rndModule) {
    <empty>
    rndModule
    _rndModule.Init;
    _rndModule.Random;
    _rndModule.RndInt;
}

VTABLE(_Deck) {
    <empty>
    Deck
    _Deck.Init;
    _Deck.Shuffle;
    _Deck.GetCard;
}

VTABLE(_BJDeck) {
    <empty>
    BJDeck
    _BJDeck.Init;
    _BJDeck.DealCard;
    _BJDeck.Shuffle;
    _BJDeck.NumCardsRemaining;
}

VTABLE(_Player) {
    <empty>
    Player
    _Player.Init;
    _Player.Hit;
    _Player.DoubleDown;
    _Player.TakeTurn;
    _Player.HasMoney;
    _Player.PrintMoney;
    _Player.PlaceBet;
    _Player.GetTotal;
    _Player.Resolve;
    _Player.GetYesOrNo;
}

VTABLE(_Dealer) {
    _Player
    Dealer
    _Dealer.Init;
    _Player.Hit;
    _Player.DoubleDown;
    _Dealer.TakeTurn;
    _Player.HasMoney;
    _Player.PrintMoney;
    _Player.PlaceBet;
    _Player.GetTotal;
    _Player.Resolve;
    _Player.GetYesOrNo;
}

VTABLE(_House) {
    <empty>
    House
    _House.SetupGame;
    _House.SetupPlayers;
    _House.TakeAllBets;
    _House.TakeAllTurns;
    _House.ResolveAllPlayers;
    _House.PrintAllMoney;
    _House.PlayOneGame;
}

VTABLE(_Main) {
    <empty>
    Main
}

FUNCTION(_rndModule_New) {
memo ''
_rndModule_New:
    _T49 = 8
    parm _T49
    _T50 =  call _Alloc
    _T51 = 0
    *(_T50 + 4) = _T51
    _T52 = VTBL <_rndModule>
    *(_T50 + 0) = _T52
    return _T50
}

FUNCTION(_Deck_New) {
memo ''
_Deck_New:
    _T53 = 16
    parm _T53
    _T54 =  call _Alloc
    _T55 = 0
    *(_T54 + 4) = _T55
    *(_T54 + 8) = _T55
    *(_T54 + 12) = _T55
    _T56 = VTBL <_Deck>
    *(_T54 + 0) = _T56
    return _T54
}

FUNCTION(_BJDeck_New) {
memo ''
_BJDeck_New:
    _T57 = 16
    parm _T57
    _T58 =  call _Alloc
    _T59 = 0
    *(_T58 + 4) = _T59
    *(_T58 + 8) = _T59
    *(_T58 + 12) = _T59
    _T60 = VTBL <_BJDeck>
    *(_T58 + 0) = _T60
    return _T58
}

FUNCTION(_Player_New) {
memo ''
_Player_New:
    _T61 = 28
    parm _T61
    _T62 =  call _Alloc
    _T63 = 0
    _T64 = 4
    _T65 = (_T62 + _T61)
_L43:
    _T66 = (_T65 - _T64)
    _T65 = _T66
    _T67 = (_T61 - _T64)
    _T61 = _T67
    if (_T61 == 0) branch _L44
    *(_T65 + 0) = _T63
    branch _L43
_L44:
    _T68 = VTBL <_Player>
    *(_T65 + 0) = _T68
    return _T65
}

FUNCTION(_Dealer_New) {
memo ''
_Dealer_New:
    _T69 = 28
    parm _T69
    _T70 =  call _Alloc
    _T71 = 0
    _T72 = 4
    _T73 = (_T70 + _T69)
_L46:
    _T74 = (_T73 - _T72)
    _T73 = _T74
    _T75 = (_T69 - _T72)
    _T69 = _T75
    if (_T69 == 0) branch _L47
    *(_T73 + 0) = _T71
    branch _L46
_L47:
    _T76 = VTBL <_Dealer>
    *(_T73 + 0) = _T76
    return _T73
}

FUNCTION(_House_New) {
memo ''
_House_New:
    _T77 = 16
    parm _T77
    _T78 =  call _Alloc
    _T79 = 0
    *(_T78 + 4) = _T79
    *(_T78 + 8) = _T79
    *(_T78 + 12) = _T79
    _T80 = VTBL <_House>
    *(_T78 + 0) = _T80
    return _T78
}

FUNCTION(_Main_New) {
memo ''
_Main_New:
    _T81 = 4
    parm _T81
    _T82 =  call _Alloc
    _T83 = VTBL <_Main>
    *(_T82 + 0) = _T83
    return _T82
}

FUNCTION(_rndModule.Init) {
memo '_T7:4 _T8:8'
_rndModule.Init:
    _T84 = *(_T7 + 4)
    *(_T7 + 4) = _T8
}

FUNCTION(_rndModule.Random) {
memo '_T9:4'
_rndModule.Random:
    _T85 = *(_T9 + 4)
    _T86 = 15625
    _T87 = *(_T9 + 4)
    _T88 = 10000
    _T89 = 0
    _T90 = (_T88 == _T89)
    if (_T90 == 0) branch _L50
    _T91 = "Decaf runtime error: Division by zero error.\n"
    parm _T91
    call _PrintString
    call _Halt
_L50:
    _T92 = (_T87 % _T88)
    _T93 = (_T86 * _T92)
    _T94 = 22221
    _T95 = (_T93 + _T94)
    _T96 = 65536
    _T97 = 0
    _T98 = (_T96 == _T97)
    if (_T98 == 0) branch _L51
    _T99 = "Decaf runtime error: Division by zero error.\n"
    parm _T99
    call _PrintString
    call _Halt
_L51:
    _T100 = (_T95 % _T96)
    *(_T9 + 4) = _T100
    _T101 = *(_T9 + 4)
    return _T101
}

FUNCTION(_rndModule.RndInt) {
memo '_T10:4 _T11:8'
_rndModule.RndInt:
    parm _T10
    _T102 = *(_T10 + 0)
    _T103 = *(_T102 + 12)
    _T104 =  call _T103
    _T105 = 0
    _T106 = (_T11 == _T105)
    if (_T106 == 0) branch _L52
    _T107 = "Decaf runtime error: Division by zero error.\n"
    parm _T107
    call _PrintString
    call _Halt
_L52:
    _T108 = (_T104 % _T11)
    return _T108
}

FUNCTION(_Deck.Init) {
memo '_T12:4 _T13:8'
_Deck.Init:
    _T109 = *(_T12 + 8)
    _T110 = 52
    _T111 = 0
    _T112 = (_T110 < _T111)
    if (_T112 == 0) branch _L53
    _T113 = "Decaf runtime error: Cannot create negative-sized array\n"
    parm _T113
    call _PrintString
    call _Halt
_L53:
    _T114 = 4
    _T115 = (_T114 * _T110)
    _T116 = (_T114 + _T115)
    parm _T116
    _T117 =  call _Alloc
    *(_T117 + 0) = _T110
    _T118 = 0
    _T117 = (_T117 + _T116)
_L54:
    _T116 = (_T116 - _T114)
    if (_T116 == 0) branch _L55
    _T117 = (_T117 - _T114)
    *(_T117 + 0) = _T118
    branch _L54
_L55:
    *(_T12 + 8) = _T117
    _T119 = *(_T12 + 12)
    *(_T12 + 12) = _T13
}

FUNCTION(_Deck.Shuffle) {
memo '_T14:4'
_Deck.Shuffle:
    _T120 = *(_T14 + 4)
    _T121 = 1
    *(_T14 + 4) = _T121
    branch _L56
_L57:
    _T122 = *(_T14 + 4)
    _T123 = *(_T14 + 4)
    _T124 = 1
    _T125 = (_T123 + _T124)
    *(_T14 + 4) = _T125
_L56:
    _T126 = *(_T14 + 4)
    _T127 = 52
    _T128 = (_T126 <= _T127)
    if (_T128 == 0) branch _L58
    _T129 = *(_T14 + 8)
    _T130 = *(_T14 + 4)
    _T131 = 1
    _T132 = (_T130 - _T131)
    _T133 = *(_T129 - 4)
    _T134 = (_T132 < _T133)
    if (_T134 == 0) branch _L59
    _T135 = 0
    _T136 = (_T132 < _T135)
    if (_T136 == 0) branch _L60
_L59:
    _T137 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T137
    call _PrintString
    call _Halt
_L60:
    _T138 = 4
    _T139 = (_T132 * _T138)
    _T140 = (_T129 + _T139)
    _T141 = *(_T140 + 0)
    _T142 = *(_T14 + 4)
    _T143 = 13
    _T144 = 0
    _T145 = (_T143 == _T144)
    if (_T145 == 0) branch _L61
    _T146 = "Decaf runtime error: Division by zero error.\n"
    parm _T146
    call _PrintString
    call _Halt
_L61:
    _T147 = (_T142 % _T143)
    _T148 = 4
    _T149 = (_T132 * _T148)
    _T150 = (_T129 + _T149)
    *(_T150 + 0) = _T147
    branch _L57
_L58:
    _T151 = *(_T14 + 4)
    _T152 = *(_T14 + 4)
    _T153 = 1
    _T154 = (_T152 - _T153)
    *(_T14 + 4) = _T154
_L62:
    _T155 = *(_T14 + 4)
    _T156 = 0
    _T157 = (_T155 > _T156)
    if (_T157 == 0) branch _L63
    _T160 = *(_T14 + 12)
    _T161 = *(_T14 + 4)
    parm _T160
    parm _T161
    _T162 = *(_T160 + 0)
    _T163 = *(_T162 + 16)
    _T164 =  call _T163
    _T158 = _T164
    _T165 = *(_T14 + 4)
    _T166 = *(_T14 + 4)
    _T167 = 1
    _T168 = (_T166 - _T167)
    *(_T14 + 4) = _T168
    _T169 = *(_T14 + 8)
    _T170 = *(_T14 + 4)
    _T171 = *(_T169 - 4)
    _T172 = (_T170 < _T171)
    if (_T172 == 0) branch _L64
    _T173 = 0
    _T174 = (_T170 < _T173)
    if (_T174 == 0) branch _L65
_L64:
    _T175 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T175
    call _PrintString
    call _Halt
_L65:
    _T176 = 4
    _T177 = (_T170 * _T176)
    _T178 = (_T169 + _T177)
    _T179 = *(_T178 + 0)
    _T159 = _T179
    _T180 = *(_T14 + 8)
    _T181 = *(_T14 + 4)
    _T182 = *(_T180 - 4)
    _T183 = (_T181 < _T182)
    if (_T183 == 0) branch _L66
    _T184 = 0
    _T185 = (_T181 < _T184)
    if (_T185 == 0) branch _L67
_L66:
    _T186 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T186
    call _PrintString
    call _Halt
_L67:
    _T187 = 4
    _T188 = (_T181 * _T187)
    _T189 = (_T180 + _T188)
    _T190 = *(_T189 + 0)
    _T191 = *(_T14 + 8)
    _T192 = *(_T191 - 4)
    _T193 = (_T158 < _T192)
    if (_T193 == 0) branch _L68
    _T194 = 0
    _T195 = (_T158 < _T194)
    if (_T195 == 0) branch _L69
_L68:
    _T196 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T196
    call _PrintString
    call _Halt
_L69:
    _T197 = 4
    _T198 = (_T158 * _T197)
    _T199 = (_T191 + _T198)
    _T200 = *(_T199 + 0)
    _T201 = 4
    _T202 = (_T181 * _T201)
    _T203 = (_T180 + _T202)
    *(_T203 + 0) = _T200
    _T204 = *(_T14 + 8)
    _T205 = *(_T204 - 4)
    _T206 = (_T158 < _T205)
    if (_T206 == 0) branch _L70
    _T207 = 0
    _T208 = (_T158 < _T207)
    if (_T208 == 0) branch _L71
_L70:
    _T209 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T209
    call _PrintString
    call _Halt
_L71:
    _T210 = 4
    _T211 = (_T158 * _T210)
    _T212 = (_T204 + _T211)
    _T213 = *(_T212 + 0)
    _T214 = 4
    _T215 = (_T158 * _T214)
    _T216 = (_T204 + _T215)
    *(_T216 + 0) = _T159
    branch _L62
_L63:
}

FUNCTION(_Deck.GetCard) {
memo '_T15:4'
_Deck.GetCard:
    _T218 = *(_T15 + 4)
    _T219 = 52
    _T220 = (_T218 >= _T219)
    if (_T220 == 0) branch _L72
    _T221 = 0
    return _T221
_L72:
    _T222 = *(_T15 + 8)
    _T223 = *(_T15 + 4)
    _T224 = *(_T222 - 4)
    _T225 = (_T223 < _T224)
    if (_T225 == 0) branch _L73
    _T226 = 0
    _T227 = (_T223 < _T226)
    if (_T227 == 0) branch _L74
_L73:
    _T228 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T228
    call _PrintString
    call _Halt
_L74:
    _T229 = 4
    _T230 = (_T223 * _T229)
    _T231 = (_T222 + _T230)
    _T232 = *(_T231 + 0)
    _T217 = _T232
    _T233 = *(_T15 + 4)
    _T234 = *(_T15 + 4)
    _T235 = 1
    _T236 = (_T234 + _T235)
    *(_T15 + 4) = _T236
    return _T217
}

FUNCTION(_BJDeck.Init) {
memo '_T16:4 _T17:8'
_BJDeck.Init:
    _T238 = *(_T16 + 4)
    _T239 = 8
    _T240 = 0
    _T241 = (_T239 < _T240)
    if (_T241 == 0) branch _L75
    _T242 = "Decaf runtime error: Cannot create negative-sized array\n"
    parm _T242
    call _PrintString
    call _Halt
_L75:
    _T243 = 4
    _T244 = (_T243 * _T239)
    _T245 = (_T243 + _T244)
    parm _T245
    _T246 =  call _Alloc
    *(_T246 + 0) = _T239
    _T247 = 0
    _T246 = (_T246 + _T245)
_L76:
    _T245 = (_T245 - _T243)
    if (_T245 == 0) branch _L77
    _T246 = (_T246 - _T243)
    *(_T246 + 0) = _T247
    branch _L76
_L77:
    *(_T16 + 4) = _T246
    _T248 = 0
    _T237 = _T248
    branch _L78
_L79:
    _T249 = 1
    _T250 = (_T237 + _T249)
    _T237 = _T250
_L78:
    _T251 = 8
    _T252 = (_T237 < _T251)
    if (_T252 == 0) branch _L80
    _T253 = *(_T16 + 4)
    _T254 = *(_T253 - 4)
    _T255 = (_T237 < _T254)
    if (_T255 == 0) branch _L81
    _T256 = 0
    _T257 = (_T237 < _T256)
    if (_T257 == 0) branch _L82
_L81:
    _T258 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T258
    call _PrintString
    call _Halt
_L82:
    _T259 = 4
    _T260 = (_T237 * _T259)
    _T261 = (_T253 + _T260)
    _T262 = *(_T261 + 0)
    _T263 =  call _Deck_New
    _T264 = 1
    _T1 = (_T1 + _T264)
    _T265 = 4
    _T266 = (_T237 * _T265)
    _T267 = (_T253 + _T266)
    *(_T267 + 0) = _T263
    _T268 = *(_T16 + 4)
    _T269 = *(_T268 - 4)
    _T270 = (_T237 < _T269)
    if (_T270 == 0) branch _L83
    _T271 = 0
    _T272 = (_T237 < _T271)
    if (_T272 == 0) branch _L84
_L83:
    _T273 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T273
    call _PrintString
    call _Halt
_L84:
    _T274 = 4
    _T275 = (_T237 * _T274)
    _T276 = (_T268 + _T275)
    _T277 = *(_T276 + 0)
    parm _T277
    parm _T17
    _T278 = *(_T277 + 0)
    _T279 = *(_T278 + 8)
    call _T279
    branch _L79
_L80:
    _T280 = *(_T16 + 12)
    *(_T16 + 12) = _T17
}

FUNCTION(_BJDeck.DealCard) {
memo '_T18:4'
_BJDeck.DealCard:
    _T282 = 0
    _T281 = _T282
    _T283 = *(_T18 + 8)
    _T284 = 8
    _T285 = 52
    _T286 = (_T284 * _T285)
    _T287 = (_T283 >= _T286)
    if (_T287 == 0) branch _L85
    _T288 = 11
    return _T288
_L85:
_L86:
    _T289 = 0
    _T290 = (_T281 == _T289)
    if (_T290 == 0) branch _L87
    _T292 = *(_T18 + 12)
    _T293 = 8
    parm _T292
    parm _T293
    _T294 = *(_T292 + 0)
    _T295 = *(_T294 + 16)
    _T296 =  call _T295
    _T291 = _T296
    _T297 = *(_T18 + 4)
    _T298 = *(_T297 - 4)
    _T299 = (_T291 < _T298)
    if (_T299 == 0) branch _L88
    _T300 = 0
    _T301 = (_T291 < _T300)
    if (_T301 == 0) branch _L89
_L88:
    _T302 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T302
    call _PrintString
    call _Halt
_L89:
    _T303 = 4
    _T304 = (_T291 * _T303)
    _T305 = (_T297 + _T304)
    _T306 = *(_T305 + 0)
    parm _T306
    _T307 = *(_T306 + 0)
    _T308 = *(_T307 + 16)
    _T309 =  call _T308
    _T281 = _T309
    branch _L86
_L87:
    _T310 = 10
    _T311 = (_T281 > _T310)
    if (_T311 == 0) branch _L90
    _T312 = 10
    _T281 = _T312
    branch _L91
_L90:
    _T313 = 1
    _T314 = (_T281 == _T313)
    if (_T314 == 0) branch _L92
    _T315 = 11
    _T281 = _T315
_L92:
_L91:
    _T316 = *(_T18 + 8)
    _T317 = *(_T18 + 8)
    _T318 = 1
    _T319 = (_T317 + _T318)
    *(_T18 + 8) = _T319
    return _T281
}

FUNCTION(_BJDeck.Shuffle) {
memo '_T19:4'
_BJDeck.Shuffle:
    _T321 = "Shuffling..."
    parm _T321
    call _PrintString
    _T322 = 0
    _T320 = _T322
    branch _L93
_L94:
    _T323 = 1
    _T324 = (_T320 + _T323)
    _T320 = _T324
_L93:
    _T325 = 8
    _T326 = (_T320 < _T325)
    if (_T326 == 0) branch _L95
    _T327 = *(_T19 + 4)
    _T328 = *(_T327 - 4)
    _T329 = (_T320 < _T328)
    if (_T329 == 0) branch _L96
    _T330 = 0
    _T331 = (_T320 < _T330)
    if (_T331 == 0) branch _L97
_L96:
    _T332 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T332
    call _PrintString
    call _Halt
_L97:
    _T333 = 4
    _T334 = (_T320 * _T333)
    _T335 = (_T327 + _T334)
    _T336 = *(_T335 + 0)
    parm _T336
    _T337 = *(_T336 + 0)
    _T338 = *(_T337 + 12)
    call _T338
    branch _L94
_L95:
    _T339 = *(_T19 + 8)
    _T340 = 0
    *(_T19 + 8) = _T340
    _T341 = "done.\n"
    parm _T341
    call _PrintString
}

FUNCTION(_BJDeck.NumCardsRemaining) {
memo '_T20:4'
_BJDeck.NumCardsRemaining:
    _T342 = 8
    _T343 = 52
    _T344 = (_T342 * _T343)
    _T345 = *(_T20 + 8)
    _T346 = (_T344 - _T345)
    return _T346
}

FUNCTION(_Player.Init) {
memo '_T21:4 _T22:8'
_Player.Init:
    _T347 = *(_T21 + 20)
    _T348 = 1000
    *(_T21 + 20) = _T348
    _T349 = "What is the name of player #"
    parm _T349
    call _PrintString
    parm _T22
    call _PrintInt
    _T350 = "? "
    parm _T350
    call _PrintString
    _T351 = *(_T21 + 24)
    _T352 =  call _ReadLine
    *(_T21 + 24) = _T352
}

FUNCTION(_Player.Hit) {
memo '_T23:4 _T24:8'
_Player.Hit:
    parm _T24
    _T354 = *(_T24 + 0)
    _T355 = *(_T354 + 12)
    _T356 =  call _T355
    _T353 = _T356
    _T357 = *(_T23 + 24)
    parm _T357
    call _PrintString
    _T358 = " was dealt a "
    parm _T358
    call _PrintString
    parm _T353
    call _PrintInt
    _T359 = ".\n"
    parm _T359
    call _PrintString
    _T360 = *(_T23 + 4)
    _T361 = *(_T23 + 4)
    _T362 = (_T361 + _T353)
    *(_T23 + 4) = _T362
    _T363 = *(_T23 + 12)
    _T364 = *(_T23 + 12)
    _T365 = 1
    _T366 = (_T364 + _T365)
    *(_T23 + 12) = _T366
    _T367 = 11
    _T368 = (_T353 == _T367)
    if (_T368 == 0) branch _L98
    _T369 = *(_T23 + 8)
    _T370 = *(_T23 + 8)
    _T371 = 1
    _T372 = (_T370 + _T371)
    *(_T23 + 8) = _T372
_L98:
_L99:
    _T373 = *(_T23 + 4)
    _T374 = 21
    _T375 = (_T373 > _T374)
    _T376 = *(_T23 + 8)
    _T377 = 0
    _T378 = (_T376 > _T377)
    _T379 = (_T375 && _T378)
    if (_T379 == 0) branch _L100
    _T380 = *(_T23 + 4)
    _T381 = *(_T23 + 4)
    _T382 = 10
    _T383 = (_T381 - _T382)
    *(_T23 + 4) = _T383
    _T384 = *(_T23 + 8)
    _T385 = *(_T23 + 8)
    _T386 = 1
    _T387 = (_T385 - _T386)
    *(_T23 + 8) = _T387
    branch _L99
_L100:
}

FUNCTION(_Player.DoubleDown) {
memo '_T25:4 _T26:8'
_Player.DoubleDown:
    _T389 = *(_T25 + 4)
    _T390 = 10
    _T391 = (_T389 != _T390)
    _T392 = *(_T25 + 4)
    _T393 = 11
    _T394 = (_T392 != _T393)
    _T395 = (_T391 && _T394)
    if (_T395 == 0) branch _L101
    _T396 = 0
    return _T396
_L101:
    _T397 = "Would you like to double down?"
    parm _T25
    parm _T397
    _T398 = *(_T25 + 0)
    _T399 = *(_T398 + 44)
    _T400 =  call _T399
    if (_T400 == 0) branch _L102
    _T401 = *(_T25 + 16)
    _T402 = *(_T25 + 16)
    _T403 = 2
    _T404 = (_T402 * _T403)
    *(_T25 + 16) = _T404
    parm _T25
    parm _T26
    _T405 = *(_T25 + 0)
    _T406 = *(_T405 + 12)
    call _T406
    _T407 = *(_T25 + 24)
    parm _T407
    call _PrintString
    _T408 = ", your total is "
    parm _T408
    call _PrintString
    _T409 = *(_T25 + 4)
    parm _T409
    call _PrintInt
    _T410 = ".\n"
    parm _T410
    call _PrintString
    _T411 = 1
    return _T411
    branch _L103
_L102:
    _T412 = 0
    return _T412
_L103:
}

FUNCTION(_Player.TakeTurn) {
memo '_T27:4 _T28:8'
_Player.TakeTurn:
    _T414 = "\n"
    parm _T414
    call _PrintString
    _T415 = *(_T27 + 24)
    parm _T415
    call _PrintString
    _T416 = "'s turn.\n"
    parm _T416
    call _PrintString
    _T417 = *(_T27 + 4)
    _T418 = 0
    *(_T27 + 4) = _T418
    _T419 = *(_T27 + 8)
    _T420 = 0
    *(_T27 + 8) = _T420
    _T421 = *(_T27 + 12)
    _T422 = 0
    *(_T27 + 12) = _T422
    parm _T27
    parm _T28
    _T423 = *(_T27 + 0)
    _T424 = *(_T423 + 12)
    call _T424
    parm _T27
    parm _T28
    _T425 = *(_T27 + 0)
    _T426 = *(_T425 + 12)
    call _T426
    parm _T27
    parm _T28
    _T427 = *(_T27 + 0)
    _T428 = *(_T427 + 16)
    _T429 =  call _T428
    _T430 = ! _T429
    if (_T430 == 0) branch _L104
    _T431 = 1
    _T413 = _T431
_L105:
    _T432 = *(_T27 + 4)
    _T433 = 21
    _T434 = (_T432 <= _T433)
    _T435 = (_T434 && _T413)
    if (_T435 == 0) branch _L106
    _T436 = *(_T27 + 24)
    parm _T436
    call _PrintString
    _T437 = ", your total is "
    parm _T437
    call _PrintString
    _T438 = *(_T27 + 4)
    parm _T438
    call _PrintInt
    _T439 = ".\n"
    parm _T439
    call _PrintString
    _T440 = "Would you like a hit?"
    parm _T27
    parm _T440
    _T441 = *(_T27 + 0)
    _T442 = *(_T441 + 44)
    _T443 =  call _T442
    _T413 = _T443
    if (_T413 == 0) branch _L107
    parm _T27
    parm _T28
    _T444 = *(_T27 + 0)
    _T445 = *(_T444 + 12)
    call _T445
_L107:
    branch _L105
_L106:
_L104:
    _T446 = *(_T27 + 4)
    _T447 = 21
    _T448 = (_T446 > _T447)
    if (_T448 == 0) branch _L108
    _T449 = *(_T27 + 24)
    parm _T449
    call _PrintString
    _T450 = " busts with the big "
    parm _T450
    call _PrintString
    _T451 = *(_T27 + 4)
    parm _T451
    call _PrintInt
    _T452 = "!\n"
    parm _T452
    call _PrintString
    branch _L109
_L108:
    _T453 = *(_T27 + 24)
    parm _T453
    call _PrintString
    _T454 = " stays at "
    parm _T454
    call _PrintString
    _T455 = *(_T27 + 4)
    parm _T455
    call _PrintInt
    _T456 = ".\n"
    parm _T456
    call _PrintString
_L109:
}

FUNCTION(_Player.HasMoney) {
memo '_T29:4'
_Player.HasMoney:
    _T457 = *(_T29 + 20)
    _T458 = 0
    _T459 = (_T457 > _T458)
    return _T459
}

FUNCTION(_Player.PrintMoney) {
memo '_T30:4'
_Player.PrintMoney:
    _T460 = *(_T30 + 24)
    parm _T460
    call _PrintString
    _T461 = ", you have $"
    parm _T461
    call _PrintString
    _T462 = *(_T30 + 20)
    parm _T462
    call _PrintInt
    _T463 = ".\n"
    parm _T463
    call _PrintString
}

FUNCTION(_Player.PlaceBet) {
memo '_T31:4'
_Player.PlaceBet:
    _T464 = *(_T31 + 16)
    _T465 = 0
    *(_T31 + 16) = _T465
    parm _T31
    _T466 = *(_T31 + 0)
    _T467 = *(_T466 + 28)
    call _T467
_L110:
    _T468 = *(_T31 + 16)
    _T469 = 0
    _T470 = (_T468 <= _T469)
    _T471 = *(_T31 + 16)
    _T472 = *(_T31 + 20)
    _T473 = (_T471 > _T472)
    _T474 = (_T470 || _T473)
    if (_T474 == 0) branch _L111
    _T475 = "How much would you like to bet? "
    parm _T475
    call _PrintString
    _T476 = *(_T31 + 16)
    _T477 =  call _ReadInteger
    *(_T31 + 16) = _T477
    branch _L110
_L111:
}

FUNCTION(_Player.GetTotal) {
memo '_T32:4'
_Player.GetTotal:
    _T478 = *(_T32 + 4)
    return _T478
}

FUNCTION(_Player.Resolve) {
memo '_T33:4 _T34:8'
_Player.Resolve:
    _T481 = 0
    _T479 = _T481
    _T482 = 0
    _T480 = _T482
    _T483 = *(_T33 + 4)
    _T484 = 21
    _T485 = (_T483 == _T484)
    _T486 = *(_T33 + 12)
    _T487 = 2
    _T488 = (_T486 == _T487)
    _T489 = (_T485 && _T488)
    if (_T489 == 0) branch _L112
    _T490 = 2
    _T479 = _T490
    branch _L113
_L112:
    _T491 = *(_T33 + 4)
    _T492 = 21
    _T493 = (_T491 > _T492)
    if (_T493 == 0) branch _L114
    _T494 = 1
    _T480 = _T494
    branch _L115
_L114:
    _T495 = 21
    _T496 = (_T34 > _T495)
    if (_T496 == 0) branch _L116
    _T497 = 1
    _T479 = _T497
    branch _L117
_L116:
    _T498 = *(_T33 + 4)
    _T499 = (_T498 > _T34)
    if (_T499 == 0) branch _L118
    _T500 = 1
    _T479 = _T500
    branch _L119
_L118:
    _T501 = *(_T33 + 4)
    _T502 = (_T34 > _T501)
    if (_T502 == 0) branch _L120
    _T503 = 1
    _T480 = _T503
_L120:
_L119:
_L117:
_L115:
_L113:
    _T504 = 1
    _T505 = (_T479 >= _T504)
    if (_T505 == 0) branch _L121
    _T506 = *(_T33 + 24)
    parm _T506
    call _PrintString
    _T507 = ", you won $"
    parm _T507
    call _PrintString
    _T508 = *(_T33 + 16)
    parm _T508
    call _PrintInt
    _T509 = ".\n"
    parm _T509
    call _PrintString
    branch _L122
_L121:
    _T510 = 1
    _T511 = (_T480 >= _T510)
    if (_T511 == 0) branch _L123
    _T512 = *(_T33 + 24)
    parm _T512
    call _PrintString
    _T513 = ", you lost $"
    parm _T513
    call _PrintString
    _T514 = *(_T33 + 16)
    parm _T514
    call _PrintInt
    _T515 = ".\n"
    parm _T515
    call _PrintString
    branch _L124
_L123:
    _T516 = *(_T33 + 24)
    parm _T516
    call _PrintString
    _T517 = ", you push!\n"
    parm _T517
    call _PrintString
_L124:
_L122:
    _T518 = *(_T33 + 16)
    _T519 = (_T479 * _T518)
    _T479 = _T519
    _T520 = *(_T33 + 16)
    _T521 = (_T480 * _T520)
    _T480 = _T521
    _T522 = *(_T33 + 20)
    _T523 = *(_T33 + 20)
    _T524 = (_T523 + _T479)
    _T525 = (_T524 - _T480)
    *(_T33 + 20) = _T525
}

FUNCTION(_Player.GetYesOrNo) {
memo '_T35:4 _T36:8'
_Player.GetYesOrNo:
    parm _T36
    call _PrintString
    _T526 = " (0=No/1=Yes) "
    parm _T526
    call _PrintString
    _T527 =  call _ReadInteger
    _T528 = 0
    _T529 = (_T527 != _T528)
    return _T529
}

FUNCTION(_Dealer.Init) {
memo '_T37:4 _T38:8'
_Dealer.Init:
    _T531 = *(_T37 + 4)
    _T532 = 0
    *(_T37 + 4) = _T532
    _T533 = *(_T37 + 8)
    _T534 = 0
    *(_T37 + 8) = _T534
    _T535 = *(_T37 + 12)
    _T536 = 0
    *(_T37 + 12) = _T536
    _T537 = "Dealer"
    _T530 = _T537
    _T538 = *(_T37 + 24)
    *(_T37 + 24) = _T530
}

FUNCTION(_Dealer.TakeTurn) {
memo '_T39:4 _T40:8'
_Dealer.TakeTurn:
    _T539 = "\n"
    parm _T539
    call _PrintString
    _T540 = *(_T39 + 24)
    parm _T540
    call _PrintString
    _T541 = "'s turn.\n"
    parm _T541
    call _PrintString
_L125:
    _T542 = *(_T39 + 4)
    _T543 = 16
    _T544 = (_T542 <= _T543)
    if (_T544 == 0) branch _L126
    parm _T39
    parm _T40
    _T545 = *(_T39 + 0)
    _T546 = *(_T545 + 12)
    call _T546
    branch _L125
_L126:
    _T547 = *(_T39 + 4)
    _T548 = 21
    _T549 = (_T547 > _T548)
    if (_T549 == 0) branch _L127
    _T550 = *(_T39 + 24)
    parm _T550
    call _PrintString
    _T551 = " busts with the big "
    parm _T551
    call _PrintString
    _T552 = *(_T39 + 4)
    parm _T552
    call _PrintInt
    _T553 = "!\n"
    parm _T553
    call _PrintString
    branch _L128
_L127:
    _T554 = *(_T39 + 24)
    parm _T554
    call _PrintString
    _T555 = " stays at "
    parm _T555
    call _PrintString
    _T556 = *(_T39 + 4)
    parm _T556
    call _PrintInt
    _T557 = ".\n"
    parm _T557
    call _PrintString
_L128:
}

FUNCTION(_House.SetupGame) {
memo '_T41:4'
_House.SetupGame:
    _T558 = "\nWelcome to CS143 BlackJack!\n"
    parm _T558
    call _PrintString
    _T559 = "---------------------------\n"
    parm _T559
    call _PrintString
    _T561 =  call _rndModule_New
    _T562 = 1
    _T0 = (_T0 + _T562)
    _T560 = _T561
    _T563 = "Please enter a random number seed: "
    parm _T563
    call _PrintString
    _T564 =  call _ReadInteger
    parm _T560
    parm _T564
    _T565 = *(_T560 + 0)
    _T566 = *(_T565 + 8)
    call _T566
    _T567 = *(_T41 + 12)
    _T568 =  call _BJDeck_New
    _T569 = 1
    _T2 = (_T2 + _T569)
    *(_T41 + 12) = _T568
    _T570 = *(_T41 + 8)
    _T571 =  call _Dealer_New
    _T572 = 1
    _T4 = (_T4 + _T572)
    *(_T41 + 8) = _T571
    _T573 = *(_T41 + 12)
    parm _T573
    parm _T560
    _T574 = *(_T573 + 0)
    _T575 = *(_T574 + 8)
    call _T575
    _T576 = *(_T41 + 12)
    parm _T576
    _T577 = *(_T576 + 0)
    _T578 = *(_T577 + 16)
    call _T578
}

FUNCTION(_House.SetupPlayers) {
memo '_T42:4'
_House.SetupPlayers:
    _T581 = "How many players do we have today? "
    parm _T581
    call _PrintString
    _T582 =  call _ReadInteger
    _T580 = _T582
    _T583 = *(_T42 + 4)
    _T584 = 0
    _T585 = (_T580 < _T584)
    if (_T585 == 0) branch _L129
    _T586 = "Decaf runtime error: Cannot create negative-sized array\n"
    parm _T586
    call _PrintString
    call _Halt
_L129:
    _T587 = 4
    _T588 = (_T587 * _T580)
    _T589 = (_T587 + _T588)
    parm _T589
    _T590 =  call _Alloc
    *(_T590 + 0) = _T580
    _T591 = 0
    _T590 = (_T590 + _T589)
_L130:
    _T589 = (_T589 - _T587)
    if (_T589 == 0) branch _L131
    _T590 = (_T590 - _T587)
    *(_T590 + 0) = _T591
    branch _L130
_L131:
    *(_T42 + 4) = _T590
    _T592 = 0
    _T579 = _T592
    branch _L132
_L133:
    _T593 = 1
    _T594 = (_T579 + _T593)
    _T579 = _T594
_L132:
    _T595 = *(_T42 + 4)
    _T596 = *(_T595 - 4)
    _T597 = (_T579 < _T596)
    if (_T597 == 0) branch _L134
    _T598 = *(_T42 + 4)
    _T599 = *(_T598 - 4)
    _T600 = (_T579 < _T599)
    if (_T600 == 0) branch _L135
    _T601 = 0
    _T602 = (_T579 < _T601)
    if (_T602 == 0) branch _L136
_L135:
    _T603 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T603
    call _PrintString
    call _Halt
_L136:
    _T604 = 4
    _T605 = (_T579 * _T604)
    _T606 = (_T598 + _T605)
    _T607 = *(_T606 + 0)
    _T608 =  call _Player_New
    _T609 = 1
    _T3 = (_T3 + _T609)
    _T610 = 4
    _T611 = (_T579 * _T610)
    _T612 = (_T598 + _T611)
    *(_T612 + 0) = _T608
    _T613 = *(_T42 + 4)
    _T614 = *(_T613 - 4)
    _T615 = (_T579 < _T614)
    if (_T615 == 0) branch _L137
    _T616 = 0
    _T617 = (_T579 < _T616)
    if (_T617 == 0) branch _L138
_L137:
    _T618 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T618
    call _PrintString
    call _Halt
_L138:
    _T619 = 4
    _T620 = (_T579 * _T619)
    _T621 = (_T613 + _T620)
    _T622 = *(_T621 + 0)
    _T623 = 1
    _T624 = (_T579 + _T623)
    parm _T622
    parm _T624
    _T625 = *(_T622 + 0)
    _T626 = *(_T625 + 8)
    call _T626
    branch _L133
_L134:
}

FUNCTION(_House.TakeAllBets) {
memo '_T43:4'
_House.TakeAllBets:
    _T628 = "\nFirst, let's take bets.\n"
    parm _T628
    call _PrintString
    _T629 = 0
    _T627 = _T629
    branch _L139
_L140:
    _T630 = 1
    _T631 = (_T627 + _T630)
    _T627 = _T631
_L139:
    _T632 = *(_T43 + 4)
    _T633 = *(_T632 - 4)
    _T634 = (_T627 < _T633)
    if (_T634 == 0) branch _L141
    _T635 = *(_T43 + 4)
    _T636 = *(_T635 - 4)
    _T637 = (_T627 < _T636)
    if (_T637 == 0) branch _L142
    _T638 = 0
    _T639 = (_T627 < _T638)
    if (_T639 == 0) branch _L143
_L142:
    _T640 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T640
    call _PrintString
    call _Halt
_L143:
    _T641 = 4
    _T642 = (_T627 * _T641)
    _T643 = (_T635 + _T642)
    _T644 = *(_T643 + 0)
    parm _T644
    _T645 = *(_T644 + 0)
    _T646 = *(_T645 + 24)
    _T647 =  call _T646
    if (_T647 == 0) branch _L144
    _T648 = *(_T43 + 4)
    _T649 = *(_T648 - 4)
    _T650 = (_T627 < _T649)
    if (_T650 == 0) branch _L145
    _T651 = 0
    _T652 = (_T627 < _T651)
    if (_T652 == 0) branch _L146
_L145:
    _T653 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T653
    call _PrintString
    call _Halt
_L146:
    _T654 = 4
    _T655 = (_T627 * _T654)
    _T656 = (_T648 + _T655)
    _T657 = *(_T656 + 0)
    parm _T657
    _T658 = *(_T657 + 0)
    _T659 = *(_T658 + 32)
    call _T659
_L144:
    branch _L140
_L141:
}

FUNCTION(_House.TakeAllTurns) {
memo '_T44:4'
_House.TakeAllTurns:
    _T661 = 0
    _T660 = _T661
    branch _L147
_L148:
    _T662 = 1
    _T663 = (_T660 + _T662)
    _T660 = _T663
_L147:
    _T664 = *(_T44 + 4)
    _T665 = *(_T664 - 4)
    _T666 = (_T660 < _T665)
    if (_T666 == 0) branch _L149
    _T667 = *(_T44 + 4)
    _T668 = *(_T667 - 4)
    _T669 = (_T660 < _T668)
    if (_T669 == 0) branch _L150
    _T670 = 0
    _T671 = (_T660 < _T670)
    if (_T671 == 0) branch _L151
_L150:
    _T672 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T672
    call _PrintString
    call _Halt
_L151:
    _T673 = 4
    _T674 = (_T660 * _T673)
    _T675 = (_T667 + _T674)
    _T676 = *(_T675 + 0)
    parm _T676
    _T677 = *(_T676 + 0)
    _T678 = *(_T677 + 24)
    _T679 =  call _T678
    if (_T679 == 0) branch _L152
    _T680 = *(_T44 + 4)
    _T681 = *(_T680 - 4)
    _T682 = (_T660 < _T681)
    if (_T682 == 0) branch _L153
    _T683 = 0
    _T684 = (_T660 < _T683)
    if (_T684 == 0) branch _L154
_L153:
    _T685 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T685
    call _PrintString
    call _Halt
_L154:
    _T686 = 4
    _T687 = (_T660 * _T686)
    _T688 = (_T680 + _T687)
    _T689 = *(_T688 + 0)
    _T690 = *(_T44 + 12)
    parm _T689
    parm _T690
    _T691 = *(_T689 + 0)
    _T692 = *(_T691 + 20)
    call _T692
_L152:
    branch _L148
_L149:
}

FUNCTION(_House.ResolveAllPlayers) {
memo '_T45:4'
_House.ResolveAllPlayers:
    _T694 = "\nTime to resolve bets.\n"
    parm _T694
    call _PrintString
    _T695 = 0
    _T693 = _T695
    branch _L155
_L156:
    _T696 = 1
    _T697 = (_T693 + _T696)
    _T693 = _T697
_L155:
    _T698 = *(_T45 + 4)
    _T699 = *(_T698 - 4)
    _T700 = (_T693 < _T699)
    if (_T700 == 0) branch _L157
    _T701 = *(_T45 + 4)
    _T702 = *(_T701 - 4)
    _T703 = (_T693 < _T702)
    if (_T703 == 0) branch _L158
    _T704 = 0
    _T705 = (_T693 < _T704)
    if (_T705 == 0) branch _L159
_L158:
    _T706 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T706
    call _PrintString
    call _Halt
_L159:
    _T707 = 4
    _T708 = (_T693 * _T707)
    _T709 = (_T701 + _T708)
    _T710 = *(_T709 + 0)
    parm _T710
    _T711 = *(_T710 + 0)
    _T712 = *(_T711 + 24)
    _T713 =  call _T712
    if (_T713 == 0) branch _L160
    _T714 = *(_T45 + 4)
    _T715 = *(_T714 - 4)
    _T716 = (_T693 < _T715)
    if (_T716 == 0) branch _L161
    _T717 = 0
    _T718 = (_T693 < _T717)
    if (_T718 == 0) branch _L162
_L161:
    _T719 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T719
    call _PrintString
    call _Halt
_L162:
    _T720 = 4
    _T721 = (_T693 * _T720)
    _T722 = (_T714 + _T721)
    _T723 = *(_T722 + 0)
    _T724 = *(_T45 + 8)
    parm _T724
    _T725 = *(_T724 + 0)
    _T726 = *(_T725 + 36)
    _T727 =  call _T726
    parm _T723
    parm _T727
    _T728 = *(_T723 + 0)
    _T729 = *(_T728 + 40)
    call _T729
_L160:
    branch _L156
_L157:
}

FUNCTION(_House.PrintAllMoney) {
memo '_T46:4'
_House.PrintAllMoney:
    _T731 = 0
    _T730 = _T731
    branch _L163
_L164:
    _T732 = 1
    _T733 = (_T730 + _T732)
    _T730 = _T733
_L163:
    _T734 = *(_T46 + 4)
    _T735 = *(_T734 - 4)
    _T736 = (_T730 < _T735)
    if (_T736 == 0) branch _L165
    _T737 = *(_T46 + 4)
    _T738 = *(_T737 - 4)
    _T739 = (_T730 < _T738)
    if (_T739 == 0) branch _L166
    _T740 = 0
    _T741 = (_T730 < _T740)
    if (_T741 == 0) branch _L167
_L166:
    _T742 = "Decaf runtime error: Array subscript out of bounds\n"
    parm _T742
    call _PrintString
    call _Halt
_L167:
    _T743 = 4
    _T744 = (_T730 * _T743)
    _T745 = (_T737 + _T744)
    _T746 = *(_T745 + 0)
    parm _T746
    _T747 = *(_T746 + 0)
    _T748 = *(_T747 + 28)
    call _T748
    branch _L164
_L165:
}

FUNCTION(_House.PlayOneGame) {
memo '_T47:4'
_House.PlayOneGame:
    _T749 = *(_T47 + 12)
    parm _T749
    _T750 = *(_T749 + 0)
    _T751 = *(_T750 + 20)
    _T752 =  call _T751
    _T753 = 26
    _T754 = (_T752 < _T753)
    if (_T754 == 0) branch _L168
    _T755 = *(_T47 + 12)
    parm _T755
    _T756 = *(_T755 + 0)
    _T757 = *(_T756 + 16)
    call _T757
_L168:
    parm _T47
    _T758 = *(_T47 + 0)
    _T759 = *(_T758 + 16)
    call _T759
    _T760 = "\nDealer starts. "
    parm _T760
    call _PrintString
    _T761 = *(_T47 + 8)
    _T762 = 0
    parm _T761
    parm _T762
    _T763 = *(_T761 + 0)
    _T764 = *(_T763 + 8)
    call _T764
    _T765 = *(_T47 + 8)
    _T766 = *(_T47 + 12)
    parm _T765
    parm _T766
    _T767 = *(_T765 + 0)
    _T768 = *(_T767 + 12)
    call _T768
    parm _T47
    _T769 = *(_T47 + 0)
    _T770 = *(_T769 + 20)
    call _T770
    _T771 = *(_T47 + 8)
    _T772 = *(_T47 + 12)
    parm _T771
    parm _T772
    _T773 = *(_T771 + 0)
    _T774 = *(_T773 + 20)
    call _T774
    parm _T47
    _T775 = *(_T47 + 0)
    _T776 = *(_T775 + 24)
    call _T776
}

FUNCTION(main) {
memo ''
main:
    _T778 = 1
    _T777 = _T778
    _T780 =  call _House_New
    _T781 = 1
    _T5 = (_T5 + _T781)
    _T779 = _T780
    parm _T779
    _T782 = *(_T779 + 0)
    _T783 = *(_T782 + 8)
    call _T783
    parm _T779
    _T784 = *(_T779 + 0)
    _T785 = *(_T784 + 12)
    call _T785
_L169:
    if (_T777 == 0) branch _L170
    parm _T779
    _T786 = *(_T779 + 0)
    _T787 = *(_T786 + 32)
    call _T787
    _T788 = "\nDo you want to play another hand?"
    parm _T788
    _T789 =  call _Main.GetYesOrNo
    _T777 = _T789
    branch _L169
_L170:
    parm _T779
    _T790 = *(_T779 + 0)
    _T791 = *(_T790 + 28)
    call _T791
    _T792 = "Thank you for playing...come again soon.\n"
    parm _T792
    call _PrintString
    _T793 = "\nCS143 BlackJack Copyright (c) 1999 by Peter Mork.\n"
    parm _T793
    call _PrintString
    _T794 = "(2001 mods by jdz)\n"
    parm _T794
    call _PrintString
}

FUNCTION(_Main.GetYesOrNo) {
memo '_T48:4'
_Main.GetYesOrNo:
    parm _T48
    call _PrintString
    _T795 = " (0=No/1=Yes) "
    parm _T795
    call _PrintString
    _T796 =  call _ReadInteger
    _T797 = 0
    _T798 = (_T796 != _T797)
    return _T798
}

