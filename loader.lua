--[[ MATRIX SHIELD V12 OMEGA SUPREME - HIGH-FPS PRODUCTION RUNTIME ]]
--[[
    MATRIX SHIELD V12 OMEGA SUPREME - PRODUCTION RUNTIME & SECURITY GUARD
    (C) 2026 Matrix Security Engineering Labs.
    Architected specifically for High-FPS Roblox Environments & Executor Resilience.
]]
local _MS_GUARD = (function()
    -- 1. PRISTINE UPVALUE CLONING
    local _type = type
    local _pcall = pcall
    local _error = error
    local _assert = assert
    local _rawequal = rawequal
    local _rawget = rawget
    local _rawset = rawset
    local _setmetatable = setmetatable
    local _getmetatable = getmetatable
    local _table_clear = table.clear or function(t) for k in pairs(t) do t[k] = nil end end
    local _table_clone = table.clone or function(t) local r = {} for k,v in pairs(t) do r[k] = v end return r end
    local _string_byte = string.byte
    local _string_char = string.char
    local _bit32_bxor = bit32.bxor
    local _bit32_band = bit32.band
    local _bit32_bor = bit32.bor
    local _bit32_bnot = bit32.bnot
    local _bit32_rshift = bit32.rshift

    -- 2. MATHEMATICAL INVARIANT INTEGRITY (Verified 32-bit CPU Invariants)
    -- 12345 ^ 54321 == 58376
    -- 255 & 170 == 170
    if _bit32_bxor(12345, 54321) ~= 58376 or _bit32_band(255, 170) ~= 170 then
        local crash = nil
        crash[0xDEAD]()
    end

    -- 3. BIT-EXACT 32-BIT INTEGER MULTIPLICATION (Prevents IEEE 754 precision loss > 2^53)
    local function _mul32(a, b)
        local a_lo = _bit32_band(a, 0xffff)
        local a_hi = _bit32_rshift(a, 16)
        local b_lo = _bit32_band(b, 0xffff)
        local b_hi = _bit32_rshift(b, 16)

        local lo = a_lo * b_lo
        local mid = a_hi * b_lo + a_lo * b_hi
        local res = lo + _bit32_band(mid, 0xffff) * 0x10000
        return _bit32_band(res, 0xffffffff)
    end

    -- 4. 100% BIT-EXACT 32-BIT FNV-1a HASH ALGORITHM
    -- Prime: 16777619 | Offset: 2166136261
    local function _fnv1a(str)
        if _type(str) ~= "string" then return 0 end
        local hash = 2166136261
        for i = 1, #str do
            hash = _bit32_bxor(hash, _string_byte(str, i))
            hash = _mul32(hash, 16777619)
        end
        return hash
    end

    -- 5. REAL FNV-1a ROBLOX METHOD DICTIONARY
    -- Verified 32-bit FNV-1a hashes mapped to obfuscated octal method names:
    local _METHOD_MAP = {
        [0xa2d978ba] = "\071\101\116\083\101\114\118\105\099\101",                  -- GetService
        [0xdb89a899] = "\067\111\110\110\101\099\116",                              -- Connect
        [0x5c160e21] = "\074\083\079\078\069\110\099\111\100\101",                  -- JSONEncode
        [0xeed487f5] = "\074\083\079\078\068\101\099\111\100\101",                  -- JSONDecode
        [0xb1ebf6d6] = "\070\105\110\100\070\105\114\115\116\067\104\105\108\100",  -- FindFirstChild
        [0x189ed6ff] = "\087\097\105\116\070\111\114\067\104\105\108\100",          -- WaitForChild
        [0x8717d1fe] = "\070\105\114\101\083\101\114\118\101\114",                  -- FireServer
        [0x5849e95a] = "\073\110\118\111\107\101\083\101\114\118\101\114",          -- InvokeServer
        [0xd82af810] = "\071\101\116\067\104\105\108\100\114\101\110",              -- GetChildren
        [0x30f11ce1] = "\071\101\116\068\101\115\099\101\110\090\097\110\116\115",  -- GetDescendants
        [0x19949d9c] = "\073\115\065",                                              -- IsA
        [0x4d76a4e5] = "\068\101\115\116\114\111\121",                              -- Destroy
        [0xd143cd22] = "\067\108\111\110\101",                                      -- Clone
        [0xda84790b] = "\068\105\115\099\111\110\110\101\099\116",                  -- Disconnect
        [0x0bd501c0] = "\087\097\105\116",                                          -- Wait
        [0x0ed762f9] = "\070\105\114\101",                                          -- Fire
        [0x96e2476a] = "\069\109\105\116",                                          -- Emit
        [0xcc8ad47f] = "\071\101\116\080\108\097\121\101\114\115",                  -- GetPlayers
        [0x2cfbaa3f] = "\075\105\099\107",                                          -- Kick
    }

    local function _resolve_method(method_hash)
        return _METHOD_MAP[method_hash]
    end

    -- 6. RESILIENT DYNAMIC NAMECALL INVOCATION
    -- Resolves method by FNV-1a hash without leaking plaintext method names.
    -- Safely invokes and returns false on any failure to allow clean VM fallback.
    local function _invoke_dynamic(instance, method_name, ...)
        local hash = _fnv1a(method_name)
        local resolved_name = _METHOD_MAP[hash]
        if resolved_name then
            local ok, fn = _pcall(function() return instance[resolved_name] end)
            if ok and _type(fn) == "function" then
                local call_ok, r1, r2, r3, r4 = _pcall(fn, instance, ...)
                if call_ok then
                    return true, r1, r2, r3, r4
                end
            end
        end
        return false
    end

    -- 7. CONNECTED EPHEMERAL PROTOTYPE WIPER (Anti-Dump & Anti-getgc)
    -- Wipes one-shot chunk initialization code & constants while preserving
    -- event listeners (Heartbeat, PlayerAdded) for 60 FPS farm stability.
    local function _wipe_proto(proto)
        if _type(proto) == "table" then
            if _type(proto.code) == "table" then
                _table_clear(proto.code)
            end
            if _type(proto.k) == "table" then
                _table_clear(proto.k)
            end
        end
    end

    -- 8. PERSISTENT PINNED HONEYPOTS (Poison for getgc() memory scrapers)
    -- Pinned in this active module closure so Luau GC never discards them
    local _PINNED_HONEYPOTS = {}
    for i = 1, 40 do
        local decoy_table = {
            id = i,
            auth_token = "\000\255__MATRIX_DECOY_TOKEN_CORRUPT__\127",
            license_key = "\000\255__MATRIX_FAKECREDENTIAL_DECOY__\127",
            hwid_hash = "\000\255__MATRIX_SPOOFED_HWID_NULL__\127",
            bypass_remote = "\000\255__MATRIX_DECOY_EVENT_TRAP__\127",
        }
        decoy_table.self = decoy_table
        _PINNED_HONEYPOTS[i] = function() return decoy_table end
    end

    return {
        fnv1a = _fnv1a,
        resolve = _resolve_method,
        invoke = _invoke_dynamic,
        wipe = _wipe_proto,
        honeypots = _PINNED_HONEYPOTS,
    }
end)()


local _hht=function(_iht,_jht)
    local _kht, _lht = {}, bit32.bxor
    for _mht=1,#_iht do
        local _nht = string.byte(_iht,_mht)
        _kht[_mht] = string.char(_lht(_nht,_jht))
        _jht = (_jht + _nht + 43) % 256
    end
    return table.concat(_kht)
end
local _oht={
_hht("\186\210\210\193\252",206),
_hht("\179\198\202\250\202\218\215\212",213),
_hht("\084\217\200\221\222\248\227\130\054\150\229\252\147\181\056\153\196\160\000\204\088\137\202\213\209\201\230\192\227\190\203\008\209\217\144\028\219\204\199\129\047\210\194\247\214\198\137\121\159\174\212\172\068\197\180\218\221\225\185\208\206\201\252\238\180\215\204\212",25),
_hht("\130\236\221\218\216\178",236),
_hht("\024\218\193\246\174\254",107),
_hht("\225\224\245\214\222\165\250",131),
_hht("\012\212\211\218\220\200\238\178\204\232\141\018\195\227\190\233\244\206\147\001\239\216\204\216\208\202\192",122),
_hht("\034\216\200\198\214\196\176\052\149\228\248\209\221\163\239\196\251\157\237\252\170\253\173\252\178\189\242\195\227\190\233\244\206\147\001\239\216\204\216\208\202\192",108),
_hht("\128\226\197\225\255\185\203\208\235\220\210\222\177\190\244\206\240\207\216\211\149\023\210\148\018\144\031\212\214\217\220",236),
_hht("\087\200\209\217\239\185\203\208\235\220\210\222\177\176\015\214\215\194\204\232\238\178\204\232\141\022\206\240\207\216\211\149\023\210\148\018\144\013\214\202\250\202\218\215\212",59),
_hht("\180\194\197\225\255\185\203\208\235\220\210\222\177\176\015\214\215\194\204\232\254\191\186\192\176\024\198\240\207\216\211\149\023\210\148\018\144\005\238\217\218\216\178",216),
_hht("\013\236\209\217\239\185\203\208\235\220\210\222\177\176\012\195\251\138\024\200\198\214\196\222\248\209\221\163\239\196\251\157\246\206\240\207\216\211\149\023\210\148\018\144\009\240\213\214\222\165\250",97),
_hht("\184\194\197\225\255\185\203\208\235\220\210\222\177\176\023\218\173\253\163\239\196\251\245\188\170\253\173\252\178\189\246\206\240\207\216\211\149\023\210\148\018\144\013\214\202\250\202\218\215\212",212),
_hht("\002\238\213\193\255\185\203\208\235\220\210\222\177\176\028\184\215\192\254\202\199\207\244\202\142\020\206\240\207\216\211\149\023\210\148\018\144\031\212\214\217\220\224\164\252\225\171\214\202\250\202\218\215\212\202",110),
_hht("\133\236\209\217\239\185\203\208\235\220\210\222\177\176\026\223\164\251\245\178\213\209\197\134\036\206\240\207\216\211\149\023\210\148\018\144\031\212\214\217\220\224\164\252\225\171\214\202\250\202\218\215\212\202",233),
_hht("\091\200\209\217\239\185\203\208\235\220\210\222\177\176\028\178\239\216\200\229\220\170\253\173\240\218\222\226\188\222\208\207\216\211\149\023\210\148\018\144\009\240\213\214\222\165\250",55),
_hht("\024\194\197\225\255\185\203\208\235\220\210\222\177\176\030\167\250\220\178\252\168\254\186\192\244\230\180\250\182\196\224\246\175\244\153\014\222\208\207\216\211\149\023\210\148\018\144\009\240\213\214\222\165\250",116),
_hht("\086\206\213\193\255\185\203\208\235\220\210\222\177\176\024\208\219\210\205\226\205\216\194\222\245\162\239\216\200\222\150\004\206\240\207\216\211\149\023\210\148\018\144\009\240\213\214\222\165\250",58),
_hht("\136\226\197\225\255\185\203\208\235\220\210\222\177\176\010\218\210\196\246\163\203\234\239\218\202\194\244\212\221\174\237\145\030\222\208\207\216\211\149\023\210\148\018\144\031\212\214\217\220",228),
_hht("\160\226\197\225\255\185\203\208\235\220\210\222\177\176\012\195\251\141\017\200\196\232\217\242\161\244\202\218\210\222\205\194\190\244\206\240\207\216\211\149\023\210\148\018\144\009\240\213\214\222\165\250",204),
_hht("\190\206\213\193\255\185\203\208\235\220\210\222\177\176\011\202\209\211\251\135\026\212\201\219\198\192\227\190\244\206\240\207\216\211\149\023\210\148\018\144\009\240\213\214\222\165\250",210),
_hht("\210\206\213\193\255\185\203\208\235\220\210\222\177\176\029\164\243\193\254\166\219\234\143\026\198\240\207\216\211\149\023\210\148\018\144\013\214\202\250\202\218\215\212",190),
_hht("\087\247\217\167\243\144\006\243\222\182\200\242\148\001\250\181\209\201\230\192\244",24),
_hht("\009\052\148\220",71),
_hht("\225\208",151),
_hht("\204\237",167),
_hht("\070\206\239\210\220\222\164\175\038\215\217\167\243\144\015\204\239\198\198\236\204\206\191\250\218\210\196\250",47),
_hht("\222\221\240\237\158\248\227\130\054\150\229\252\147\175\079\128\250\207\210\220\222\164\175\063\158\188\234\246\202\218\193\234\215\194\202\247\212",147),
_hht("\071\236\219\208\221\200\223\149\001\206\186\022\180\250\182\196\224\250\228\188\204\212\194\189\228\180\086\135\134\033\194\252\194\193",38),
_hht("\033\194\252\194\193",87),
_hht("\001\250\207\210\220\222\164\175\078\132\254\200\138\066\163\244\209\209\192\191\161\059\206\217\218\216\178\189\224\232\211\196\243\218\214\208\134",104),
_hht("\131\246\207\210\220\222\164\175\078\132\254\200\138\066\188\194\198\228\131\121\155\206\217\218\216\178\189\224\232\211\196\243\218\214\208\134",234),
_hht("\198\206\239\210\220\222\164\175\078\132\254\200\138\066\166\206\253\164\232\131\121\155\206\217\218\216\178\189\224\232\211\196\243\218\214\208\134",175),
_hht("\226\250\218\209\207\218\205\212\194\248\164\175\028\222\209\212\218\221\173\252\164\175\042\255\184\159\192\210\056",135),
_hht("",177),
_hht("\063\138\237\144\061\158\188\198\006\215\200\232\141\030\142\041\218\173\253\250\197\240\131\190\203\020\210\220\250\197\240\131\190\215\202\068\205\192\163\190\200\010\204\201\254\166\174\077\192\163\190\250\150\077\192\163",121),
_hht("\228\216\193\128\029\222\188\198\006\215\200\232\141\030\142\041\218\173\253\250\197\240\131\190\215\202\068\205\192\163\190\200\010\204\201\254\166\174\077\192\163\190\250\150\077\192\163",162),
_hht("\198\059\143\248\200\230\236\190\245\154\214\194\220\250\234\182\214\228\184\205\170\071\145\153\052\138\017\250\139\183\094\149\201\215\211\251\145\252\209\197\147\004\212\206\234\210\206\184\069\148\148\038\135\031\233\156\199\036\139\243\151\087\142\233",133),
_hht("\142\061\176\237\158\248\227\130\054\150\229\252\147\175\079\128\250\207\210\220\222\164\175\063\158\188\243\192\245\192\248\219\164",195),
_hht("\033\215\217\167\243\144\029\210\194\244\210\205\145\002\236\212\194\251\175\242\205",110),
_hht("\193\250\207\210\220\222\164\175\038\215\217\167\243\144\029\210\194\244\210\205",168),
_hht("\014\023\217\167\243\144\008\241\212\202\218\210\222\205\145\003\254\183\210\202\246\222\226\163\244\209\209\192",65),
_hht("\085\210\207\210\220\222\164\175\038\215\217\167\243\144\008\241\212\202\218\210\222\205\145\001\240\199\210",60),
_hht("\082\247\217\167\243\144\025\202\213\209\201\230\192\227\190\239\206\233\218\147\024\218\205\212\215\215\198\133\038\211\212\211\206\232\217",29),
_hht("\073\250\207\210\220\222\164\175\038\215\217\167\243\144\008\241\212\202\218\210\222\205\145\025\208\203",32),
_hht("\059\199\210\202\250\223\188\202\192\175\038\215\217\167\243\144\013\209\254\165\253",79),
_hht("\226\246\207\210\220\222\164\175\038\215\217\167\243\144\013\214\202\250\202\218\215\212\153\027\177\254\165\253",139),
_hht("\072\250\207\210\220\222\164\175\038\215\217\167\243\144\008\242\212\201\219\198\192\176\008\241\207\218\205",33),
_hht("\127\174\239\210\220\222\164\175\038\215\217\167\243\144\008\242\212\201\219\198\192\176\025\202\194\244\194\248\174\250\219",22),
_hht("\177\218\207\210\220\222\164\175\038\215\217\167\243\144\008\241\212\202\218\210\222\205\194\190\228\249\207\218\205",216),
_hht("\168\250\207\210\220\222\164\175\038\215\217\167\243\144\008\241\222\166\180\000\247\186\192",193),
_hht("\037\206\252\184\211\196\243\218\214\208\143\038\215\217\167\243\144\002\246\202\218\193\234\215\194\202\247\212\153\009\208\197\240",80),
_hht("\172\242\207\210\220\222\164\175\038\215\217\167\243\144\002\246\202\218\193\234\215\194\202\247\212\153\028\160\235\215\194\231\213",197),
_hht("\216\218\207\210\220\222\164\175\038\215\217\167\243\144\004\234\202\214\196\224\246\175\244",177),
_hht("\231\247\217\167\243",136),
_hht("\006\245\207\197\207\206\254\226\128\023\217\167\243\144\004\234\202\214\196\250\221\178",107),
_hht("\000\250\207\210\220\222\164\175\038\215\217\167\243\144\027\208\207\205\251\176\191\229\248\197\195\239\192",105),
_hht("\063\218\220\184\211\196\243\218\214\208\143\038\215\217\167\243\144\008\241\212\202\218\210\222\205\145\025\208\197\240",74),
_hht("\123\150\215\217\167\243\153",83),
_hht("\027\199\195\230\193\240\216\206",110),
_hht("\051\214\207\210\220\222\164\175\038\215\217\167\243\144\027\208\207\205\251\176",90),
_hht("\078\206\239\210\220\222\164\175\038\215\217\167\243\144\027\195\240\206\220\206\202\216\206",39),
}
                                                       

assert(type(buffer) == _oht[1] and type(bit32) == _oht[1] and type(table.move) == _oht[2],
    _oht[3])
                                                      
local _pht, _qht, _rht = bit32.bxor, bit32.lshift, bit32.rshift

local function _sht(_tht)
    _tht = _pht(_tht, _qht(_tht, 13))
    _tht = _pht(_tht, _rht(_tht, 17))
    return _pht(_tht, _qht(_tht, 5))
end

local function _uht(_vht, _wht, _xht)
    return _sht(_pht(_vht, _wht * 65537, _xht)) + 1
end

local function _yht(_zht, _ait)
    local _bit = table.create(_zht)
    for _cit = 1, _zht do _bit[_cit] = _cit end
    for _dit = _zht, 2, -1 do
        _ait = _sht(_ait + _dit)
        local _eit = _ait % _dit + 1
        _bit[_dit], _bit[_eit] = _bit[_eit], _bit[_dit]
    end
    return _bit
end

local function _fit(_git)
    return _git <= 6 or _git == 11
end

local function _hit(_iit, _jit, _kit, _lit, _mit)
    local _nit = buffer.create(_kit)
    local _oit = _kit - _kit % 4
    for _pit = 0, _oit - 1, 4 do
        local _qit = buffer.readu32(_iit, _jit + _pit)
        local _rit = _pht(_qit, _lit)
        buffer.writeu32(_nit, _pit, _rit)
        _lit = _sht(_lit + (if _mit then _rit else _qit) + _pit + 1)
    end
    for _sit = _oit, _kit - 1 do
        local _tit = buffer.readu8(_iit, _jit + _sit)
        local _uit = _pht(_tit, _lit % 256)
        buffer.writeu8(_nit, _sit, _uit)
        _lit = _sht(_lit + (if _mit then _uit else _tit) + _sit + 1)
    end
    return _nit
end

local _vit = {11,14,12,10,15,3,4,9,1,5,8,6,7,2,16,13,}
local _wit = (function()
local _xit = {
  bit32.bxor(2454598, bit32.bxor(7197612, 4761578)),
  bit32.bxor(bit32.bxor(754418, 7338761), 6584818),
  bit32.bxor(bit32.bxor(5120236, 8017216), 3438010),
  bit32.bxor(7779813, bit32.bxor(2745854, 6246400)),
  bit32.bxor(bit32.bxor(3837862, 6720394), 6030386),
  bit32.bxor(bit32.bxor(6787442, 9211099), 15408521),
  bit32.bxor(bit32.bxor(6906629, 1672005), 7397476),
  bit32.bxor(bit32.bxor(8722810, 4449944), 13041613),
  bit32.bxor(bit32.bxor(9753527, 365378), 9519299),
  bit32.bxor(bit32.bxor(2785144, 6637247), 5192188),
  bit32.bxor(4031708, bit32.bxor(8501769, 12336789)),
  bit32.bxor(bit32.bxor(1871588, 10185450), 8905803),
  bit32.bxor(bit32.bxor(8560309, 13660973), 5434846),
  bit32.bxor(bit32.bxor(204096, 2226814), 2287477),
  bit32.bxor(bit32.bxor(7765083, 7711042), 251221),
  bit32.bxor(2635993, bit32.bxor(2184879, 618041)),
  bit32.bxor(bit32.bxor(1871707, 8432583), 10233035),
  bit32.bxor(bit32.bxor(1291077, 7389558), 6517353),
  bit32.bxor(bit32.bxor(5376834, 6881180), 3863681),
  bit32.bxor(bit32.bxor(3765093, 1023213), 3600362),
  bit32.bxor(bit32.bxor(2939037, 10526252), 9193175),
  bit32.bxor(bit32.bxor(9887319, 7739086), 14731509),
  bit32.bxor(bit32.bxor(6489591, 4936871), 2642237),
  bit32.bxor(6387942, bit32.bxor(5112169, 3111393)),
  bit32.bxor(bit32.bxor(3179062, 5063366), 8241283),
  bit32.bxor(bit32.bxor(5271997, 3789380), 6923149),
  bit32.bxor(bit32.bxor(6314648, 5990582), 3879512),
  bit32.bxor(8049025, bit32.bxor(8729119, 16770017)),
  bit32.bxor(2571097, bit32.bxor(5138587, 6902594)),
  bit32.bxor(bit32.bxor(8239958, 3041729), 5493269),
  bit32.bxor(3087560, bit32.bxor(3623520, 1594927)),
  bit32.bxor(bit32.bxor(8164985, 5421971), 3026274),
  bit32.bxor(bit32.bxor(5389764, 7846579), 2459645),
  bit32.bxor(bit32.bxor(5731243, 5894002), 957525),
  bit32.bxor(bit32.bxor(5807914, 5691872), 935493),
  bit32.bxor(bit32.bxor(3721195, 11435924), 9877743),
  bit32.bxor(bit32.bxor(4454076, 456660), 4522489),
  bit32.bxor(bit32.bxor(2208176, 8205161), 6062667),
  bit32.bxor(506007, bit32.bxor(1844220, 1809407)),
  bit32.bxor(bit32.bxor(2458068, 4220090), 6678004),
  bit32.bxor(bit32.bxor(9876268, 13846640), 4586433),
  bit32.bxor(bit32.bxor(344735, 8484422), 8664184),
  bit32.bxor(7145193, bit32.bxor(5722526, 3823570)),
  bit32.bxor(2878124, bit32.bxor(645886, 2240762)),
  bit32.bxor(bit32.bxor(5374129, 7218136), 3941317),
  bit32.bxor(bit32.bxor(3629505, 9910637), 10508290),
  bit32.bxor(bit32.bxor(8266652, 250620), 8253909),
  bit32.bxor(bit32.bxor(9358313, 13098871), 4789289),
  bit32.bxor(bit32.bxor(6830160, 8125400), 1295152),
  bit32.bxor(bit32.bxor(8702913, 6830587), 15528576),
  bit32.bxor(3017201, bit32.bxor(7178662, 4423912)),
  bit32.bxor(bit32.bxor(7596806, 4674747), 3456888),
  bit32.bxor(bit32.bxor(6421428, 7109010), 885484),
  bit32.bxor(bit32.bxor(2168189, 12158374), 9998346),
  bit32.bxor(7558599, bit32.bxor(5925176, 2702378)),
  bit32.bxor(bit32.bxor(4595103, 13452356), 9132290),
  bit32.bxor(bit32.bxor(2066280, 890462), 1184236),
  bit32.bxor(bit32.bxor(1652302, 3746182), 2105111),
  bit32.bxor(9302723, bit32.bxor(3153421, 12446767)),
  bit32.bxor(bit32.bxor(8923287, 14814100), 6956006),
  bit32.bxor(9503340, bit32.bxor(1729325, 9134503)),
  bit32.bxor(bit32.bxor(1681051, 7913440), 6363539),
  bit32.bxor(bit32.bxor(9393158, 16440956), 7703190),
  bit32.bxor(bit32.bxor(6746710, 5281501), 3564644),
  bit32.bxor(bit32.bxor(8662117, 4873587), 13529573),
  bit32.bxor(6795893, bit32.bxor(7267689, 612324)),
  bit32.bxor(bit32.bxor(2860628, 7771953), 6107548),
  bit32.bxor(bit32.bxor(9370720, 13033480), 4725907),
  bit32.bxor(bit32.bxor(4429152, 3838210), 7931232),
  bit32.bxor(bit32.bxor(3455436, 3670171), 833618),
  bit32.bxor(bit32.bxor(5455110, 6301924), 3347694),
  bit32.bxor(bit32.bxor(5378772, 8215382), 3098767),
  bit32.bxor(bit32.bxor(9914945, 6546428), 16033966),
  bit32.bxor(bit32.bxor(103185, 5010001), 5103707),
  bit32.bxor(bit32.bxor(5543245, 309747), 5254562),
  bit32.bxor(bit32.bxor(2647105, 6624613), 5074944),
  bit32.bxor(6059659, bit32.bxor(9943269, 13356875)),
  bit32.bxor(bit32.bxor(1664388, 244107), 1760548),
  bit32.bxor(3235720, bit32.bxor(986491, 4084702)),
  bit32.bxor(bit32.bxor(5423365, 6117036), 1021594),
  bit32.bxor(bit32.bxor(4976325, 7741096), 4059481),
  bit32.bxor(5098046, bit32.bxor(8115597, 3546757)),
  bit32.bxor(6883566, bit32.bxor(9664025, 16416716)),
  bit32.bxor(bit32.bxor(7430598, 3530780), 4489447),
  bit32.bxor(bit32.bxor(6064285, 416756), 5952086),
  bit32.bxor(bit32.bxor(1046686, 3513157), 3826330),
  bit32.bxor(bit32.bxor(5020925, 2660524), 6554902),
  bit32.bxor(3274498, bit32.bxor(7871081, 4844578)),
  bit32.bxor(bit32.bxor(1064125, 982254), 2015512),
  bit32.bxor(bit32.bxor(7836471, 4441555), 3430312),
  bit32.bxor(bit32.bxor(8443669, 601032), 9043347),
  bit32.bxor(bit32.bxor(8310440, 8134079), 184902),
  bit32.bxor(bit32.bxor(5574285, 7700549), 2133914),
  bit32.bxor(bit32.bxor(1900981, 3919723), 2543497),
  bit32.bxor(bit32.bxor(7699401, 8446179), 16095858),
  bit32.bxor(bit32.bxor(1191140, 4960983), 5873513),
  bit32.bxor(bit32.bxor(8234964, 243186), 8262523),
  bit32.bxor(bit32.bxor(5989499, 7353928), 2839382),
  bit32.bxor(5079731, bit32.bxor(4455995, 949729)),
  bit32.bxor(bit32.bxor(3732698, 11075520), 9439861),
  bit32.bxor(7148526, bit32.bxor(5758748, 3853698)),
  bit32.bxor(bit32.bxor(596367, 6782697), 7235092),
  bit32.bxor(4107403, bit32.bxor(8204464, 4431176)),
  bit32.bxor(bit32.bxor(2142934, 5615426), 7675112),
  bit32.bxor(3143005, bit32.bxor(4264605, 7267905)),
  bit32.bxor(3734223, bit32.bxor(8901532, 12527824)),
  bit32.bxor(bit32.bxor(8853385, 6153133), 14349728),
  bit32.bxor(bit32.bxor(9947506, 2372740), 11795583),
  bit32.bxor(bit32.bxor(9745729, 6526623), 16196179),
  bit32.bxor(1441069, bit32.bxor(6669876, 7355016)),
  bit32.bxor(bit32.bxor(166087, 2214835), 2310887),
  bit32.bxor(bit32.bxor(5191142, 5189011), 6624),
  bit32.bxor(2470635, bit32.bxor(3449154, 1118773)),
  bit32.bxor(bit32.bxor(2260225, 3353212), 1136351),
  bit32.bxor(1427803, bit32.bxor(114528, 1341341)),
  bit32.bxor(bit32.bxor(8478546, 1948277), 10282125),
  bit32.bxor(bit32.bxor(7206643, 2900663), 4306410),
  bit32.bxor(1362980, bit32.bxor(2516914, 3320357)),
  bit32.bxor(bit32.bxor(6132028, 5785546), 382787),
  bit32.bxor(5157582, bit32.bxor(6974047, 2414886)),
  bit32.bxor(bit32.bxor(5096073, 4346057), 1020927),
  bit32.bxor(5097354, bit32.bxor(3740037, 7657425)),
  bit32.bxor(4847249, bit32.bxor(1161259, 5787481)),
  bit32.bxor(240980, bit32.bxor(3337020, 3229582)),
  bit32.bxor(bit32.bxor(8047207, 3625139), 5086013),
  bit32.bxor(bit32.bxor(2414728, 4232888), 6574017),
  bit32.bxor(bit32.bxor(4135933, 8158563), 4417386),
  bit32.bxor(bit32.bxor(5449445, 3025328), 8195746),
  bit32.bxor(bit32.bxor(9824746, 5712907), 12764184),
}
                                                                                                                       
local _yit = type
local _zit = pcall
local _ajt = error
local _bjt = tonumber
local _cjt = assert
local _djt = rawequal
local _ejt = setmetatable

local _fjt = string.format
local _gjt = math.floor
local _hjt = math.sqrt
local _ijt = if _yit(integer) == _oht[1] then integer.fromstring else nil

local _jjt = table.move
local _kjt = table.pack
local _ljt = table.unpack
local _mjt = table.create
local _njt = table.insert
local _ojt = table.remove
local _pjt = table.concat

local _qjt = coroutine.create
local _rjt = coroutine.yield
local _sjt = coroutine.resume
local _tjt = coroutine.close

local _ujt = buffer.fromstring
local _vjt = buffer.len
local _wjt = buffer.readu8
local _xjt = buffer.readu32
local _yjt = buffer.readstring
local _zjt = buffer.readf32
local _akt = buffer.readf64

local _bkt = bit32.bor
local _ckt = bit32.band
local _dkt = bit32.btest
local _ekt = bit32.rshift
local _fkt = bit32.lshift
local _gkt = bit32.extract

local _hkt = function(_ikt) return _yit(_ikt) == _oht[4] end
local _jkt = function(_kkt) return _yit(_kkt) == _oht[5] end
local _lkt = function(_mkt) return _yit(_mkt) == _oht[6] end
local _nkt = function(_okt) return _yit(_okt) == _oht[2] end

                                                                                                    
                                         
                                                                          
            
         
          
           
          
          
                                                                                                                                                            
            
           
         
         
                  
                             
                              
         
                               
                                 
                                                                                                                                      

local _pkt = -1
local _qkt = -2

local function _rkt()
	return {
		vectorCtor = function() _ajt(_oht[7]) end,
		vectorSize = 4,
		useNativeNamecall = false,
		namecallHandler = function() _ajt(_oht[8]) end,
		extensions = {},
		callHooks = {},
		errorHandling = true,
		generalizedIteration = true,
		allowProxyErrors = false,
		useImportConstants = false,
		reuseClosures = false,
		staticEnvironment = {},
		decodeOp = function(_skt) return _skt end
	}
end

local function _tkt(_ukt)
	_cjt(_yit(_ukt) == _oht[1], _oht[9])
	_cjt(_yit(_ukt.vectorCtor) == _oht[2], _oht[10])
	_cjt(_yit(_ukt.vectorSize) == _oht[4], _oht[11])
	_cjt(_yit(_ukt.useNativeNamecall) == _oht[6], _oht[12])
	_cjt(_yit(_ukt.namecallHandler) == _oht[2], _oht[13])
	_cjt(_yit(_ukt.extensions) == _oht[1], _oht[14])
	_cjt(_yit(_ukt.callHooks) == _oht[1], _oht[15])
	_cjt(_yit(_ukt.errorHandling) == _oht[6], _oht[16])
	_cjt(_yit(_ukt.generalizedIteration) == _oht[6], _oht[17])
	_cjt(_yit(_ukt.allowProxyErrors) == _oht[6], _oht[18])
	_cjt(_yit(_ukt.staticEnvironment) == _oht[1], _oht[19])
	_cjt(_yit(_ukt.useImportConstants) == _oht[6], _oht[20])
	_cjt(_yit(_ukt.reuseClosures) == _oht[6], _oht[21])
	_cjt(_yit(_ukt.decodeOp) == _oht[2], _oht[22])
end

local function _vkt(_wkt, _xkt, _ykt)
	if _ykt == nil then
		_ykt = _rkt()
	else 
		_tkt(_ykt)
	end

	_cjt(_yit(_wkt) == _oht[1], _oht[23])

	local _zkt = _wkt.protoList
	local _alt = _wkt.mainProto
	local _blt = {}

	local _clt = _ykt.callHooks.breakHook
	local _dlt = _ykt.callHooks.stepHook
	local _elt = _ykt.callHooks.interruptHook
	local _flt = _ykt.callHooks.panicHook

	local _glt = true 

	local function _hlt()
		_glt = false
	end

	local function _ilt(_jlt, _klt, _llt)
		local function _mlt(...)
			local _nlt, _olt, _plt, _qlt, _rlt
			
			if _ykt.errorHandling then
				_nlt, _olt, _plt, _qlt, _rlt = ... 
			else 
				                                       
				local _slt = _kjt(...)
				_olt = _mjt(_klt.maxstacksize)
				_rlt = {
					len = 0,
					list = {},
				}
	
				_jjt(_slt, 1, _klt.numparams, 0, _olt)
	
				if _klt.numparams < _slt.n then
					local _tlt = _klt.numparams + 1
					local _ult = _slt.n - _klt.numparams
					_rlt.len = _ult
					_jjt(_slt, _tlt, _tlt + _ult - 1, 1, _rlt.list)
				end
	
				_slt = nil
	
				_nlt = {pc = 0, name = _oht[24]}

				_plt = _klt.protos 
				_qlt = _klt.code
			end 

			local _vlt, _wlt, _xlt, _ylt = -1, 1, _ejt({}, {__mode = _oht[25]}), _ejt({}, {__mode = _oht[26]})
			local _zlt = _klt.k
			local _amt = _klt.debugcode
			local _bmt = _ykt.extensions

			local _cmt = false
			local _dmt, _emt
			local _fmt = _klt.flowKey
			local _gmt = _pht(1, _fmt)
			while _glt do
				_wlt = _pht(_gmt, _fmt)
				if not _cmt then
					_dmt = _cjt(_qlt[_wlt], _oht[27])
					_emt = _pht(_dmt[_vit[15]], _dmt[_vit[16]])
				end

				_cmt = false

				_nlt.pc = _wlt
				_nlt.top = _vlt
				_nlt.name = _dmt[_vit[14]]

				_wlt += 1

				if _dlt then
					_dlt(_olt, _nlt, _klt, _jlt, _llt)
				end

if _emt < _xit[65] then
if _emt < _xit[33] then
if _emt < _xit[17] then
if _emt < _xit[9] then
if _emt < _xit[5] then
if _emt == _xit[1] then
					_olt[_dmt[_vit[1]]] = _dmt[_vit[4]]
elseif _emt == _xit[2] then
_olt[_dmt[_vit[1]]] = _dmt[_vit[8]]
_olt[_dmt[_vit[2]]] = _dmt[_vit[9]]
_wlt += 1
elseif _emt == _xit[3] then
					               
					_wlt += 1                    
elseif _emt == _xit[4] then
					local _hmt = _dmt[_vit[1]]
					local _imt = _dmt[_vit[2]]

					local _jmt = _dmt[_vit[7]]
					
					local _kmt = _olt[_imt]

					_olt[_hmt + 1] = _kmt
					
					_wlt += 1                     
					
					local _lmt = true
					
					                                                   
					local _mmt = _ykt.useNativeNamecall

					if _mmt then
						local _nmt = _ykt.namecallHandler

						local _omt = _qlt[_wlt]
						local _pmt = _omt[_vit[13]]

						                                       
						local _qmt, _rmt, _smt = _omt[_vit[1]], _omt[_vit[2]], _omt[_vit[3]]

						if _dlt then
							_dlt(_olt, _nlt, _klt, _jlt, _llt)
						end

						if _elt then
							_elt(_olt, _nlt, _klt, _jlt, _llt)	
						end

						local _tmt = if _rmt == 0 then _vlt - _qmt else _rmt - 1
						local _umt = _kjt(
							_nmt(_jmt, _ljt(_olt, _qmt + 1, _qmt + _tmt))
						)

						if _umt[1] == true then
							_lmt = false
							
							_wlt += if _pmt == 268 then 2 else 1                                    

							_dmt = _omt
							_emt = _pmt
							_nlt.pc = _wlt
							_nlt.name = _dmt[_vit[14]]

							local _vmt = _umt.n - 1

							if _smt == 0 then
								_vlt = _qmt + _vmt - 1
							else
								_vmt = _smt - 1
							end

							_jjt(_umt, 2, _vmt + 1, _qmt, _olt)
						end
					end
					
					if _lmt then
						_olt[_hmt] = _kmt[_jmt]
					end
else _ajt(_oht[28]) end
else
if _emt == _xit[5] then
					if not _nkt(_olt[_dmt[_vit[1]]]) then
						_ajt(_fjt(_oht[29], _yit(_olt[_dmt[_vit[1]]])))                                                
					end

					_wlt += _dmt[_vit[4]]
elseif _emt == _xit[6] then
					local _wmt = _dmt[_vit[7]]
					_olt[_dmt[_vit[2]]][_wmt] = _olt[_dmt[_vit[1]]]

					_wlt += 1                    
elseif _emt == _xit[7] then
					_olt[_dmt[_vit[1]]] = _olt[_dmt[_vit[2]]][_dmt[_vit[3]] + 1]
elseif _emt == _xit[8] then
					_olt[_dmt[_vit[1]]] = _olt[_dmt[_vit[2]]] // _olt[_dmt[_vit[3]]]
else _ajt(_oht[28]) end
end
else
if _emt < _xit[13] then
if _emt == _xit[9] then
					local _xmt = _dmt[_vit[1]]
					local _ymt = _dmt[_vit[2]]
					local _zmt = _dmt[_vit[3]] - 1

					if _zmt == _pkt then
						_zmt = _vlt - _ymt + 1
					end

					_jjt(_olt, _ymt, _ymt + _zmt - 1, _dmt[_vit[6]], _olt[_xmt])

					_wlt += 1                     
elseif _emt == _xit[10] then
					if _olt[_dmt[_vit[1]]] then
						_wlt += _dmt[_vit[4]]
					end
elseif _emt == _xit[11] then
					local _ant = _llt[_dmt[_vit[2]] + 1]
					_olt[_dmt[_vit[1]]] = _ant.store[_ant.index]
elseif _emt == _xit[12] then
					local _bnt = _dmt[_vit[1]]
					local _cnt = _zkt[_dmt[_vit[7]] + 1]
					local _dnt = _cnt.nups
					local _ent
					if _ykt.reuseClosures then
						_ent = _blt[_dmt]
					end
					local _fnt = _ent ~= nil

					if _ent then
						_olt[_bnt] = _ent.closure
						for _gnt = 1, _dnt do
							local _hnt = _qlt[_wlt + _gnt - 1]
							local _int = _ent.upvalues[_gnt]
							if _hnt[_vit[1]] == 0 then                   
								if not _djt(_int.store[_int.index], _olt[_hnt[_vit[2]]]) then
									_fnt = false
									break
								end
							elseif _hnt[_vit[1]] == 2 then                     
								if not _djt(_int, _llt[_hnt[_vit[2]] + 1]) then
									_fnt = false
									break
								end
							else
								_fnt = false
								break
							end
						end
					end

					if _fnt then
						_wlt += _dnt
					else
						local _jnt = _mjt(_dnt)
						local _knt = _ilt(_jlt, _cnt, _jnt)

						_olt[_bnt] = _knt

						for _lnt = 1, _dnt do
							local _mnt = _qlt[_wlt]
							_wlt += 1

							local _nnt = _mnt[_vit[1]]
							if _nnt == 0 then           
								local _ont = {
									value = _olt[_mnt[_vit[2]]],
									index = _oht[30],                   
								}
								_ont.store = _ont

								_jnt[_lnt] = _ont

								                                              
							elseif _nnt == 2 then             
								_jnt[_lnt] = _llt[_mnt[_vit[2]] + 1]
							end
						end

						if _ykt.reuseClosures then
							_blt[_dmt] = {closure = _knt, upvalues = _jnt}
						end
					end
else _ajt(_oht[28]) end
else
if _emt == _xit[13] then
					if _olt[_dmt[_vit[1]]] < _olt[_dmt[_vit[6]]] then
						_wlt += _dmt[_vit[4]]
					else
						_wlt += 1
					end
elseif _emt == _xit[14] then
					if _elt then
						_elt(_olt, _nlt, _klt, _jlt, _llt)	
					end

					_wlt += _dmt[_vit[4]]
elseif _emt == _xit[15] then
					_olt[_dmt[_vit[1]]] = nil
elseif _emt == _xit[16] then
					local _pnt = _dmt[_vit[7]]
					_olt[_dmt[_vit[1]]] = _olt[_dmt[_vit[2]]][_pnt]

					_wlt += 1                     
else _ajt(_oht[28]) end
end
end
else
if _emt < _xit[25] then
if _emt < _xit[21] then
if _emt == _xit[17] then
					local _qnt = _llt[_dmt[_vit[2]] + 1]
					_olt[_dmt[_vit[1]]] = _qnt.store[_qnt.index]
elseif _emt == _xit[18] then
					local _rnt = _dmt[_vit[7]]
					_olt[_dmt[_vit[1]]] = _olt[_dmt[_vit[2]]][_rnt]

					_wlt += 1                     
elseif _emt == _xit[19] then
					local _snt = _dmt[_vit[7]]
					local _tnt = {}
					if _snt[1] == -1 then
						for _unt = 2, #_snt, 2 do
							local _vnt = _snt[_unt + 1]
							_tnt[_zlt[_snt[_unt] + 1]] = if _vnt >= 0 then _zlt[_vnt + 1] else nil
						end
					else
						for _wnt, _xnt in _snt do
							_tnt[_zlt[_xnt + 1]] = nil
						end
					end
					_olt[_dmt[_vit[1]]] = _tnt
elseif _emt == _xit[20] then
					local _ynt = _olt[_dmt[_vit[2]]]
					_olt[_dmt[_vit[1]]] = if _ynt then _ynt else _dmt[_vit[7]] or false
else _ajt(_oht[28]) end
else
if _emt == _xit[21] then
					if _olt[_dmt[_vit[1]]] < _olt[_dmt[_vit[6]]] then
						_wlt += 1
					else
						_wlt += _dmt[_vit[4]]
					end
elseif _emt == _xit[22] then
					if _ykt.useImportConstants then
						_olt[_dmt[_vit[1]]] = _dmt[_vit[7]]
					else
						local _znt = _dmt[_vit[11]]
						local _aot = _dmt[_vit[8]]
						local _bot = _bmt[_aot] or _xkt[_aot]
						if _znt == 1 then
							_olt[_dmt[_vit[1]]] = _bot
						elseif _znt == 2 then
							_olt[_dmt[_vit[1]]] = _bot[_dmt[_vit[9]]]
						elseif _znt == 3 then
							_olt[_dmt[_vit[1]]] = _bot[_dmt[_vit[9]]][_dmt[_vit[10]]]
						end
					end

					_wlt += 1                     
elseif _emt == _xit[23] then
					local _cot = _dmt[_vit[7]]
					_olt[_dmt[_vit[1]]] = _cot

					_wlt += 1                     
elseif _emt == _xit[24] then
					_olt[_dmt[_vit[1]]] = _dmt[_vit[4]]
else _ajt(_oht[28]) end
end
else
if _emt < _xit[29] then
if _emt == _xit[25] then
_olt[_dmt[_vit[1]]] = _olt[_dmt[_vit[2]]] + _olt[_dmt[_vit[3]]]
_olt[_dmt[_vit[4]]] = _olt[_dmt[_vit[1]]]
_wlt += 1
elseif _emt == _xit[26] then
					_olt[_dmt[_vit[2]]][_olt[_dmt[_vit[3]]]] = _olt[_dmt[_vit[1]]]
elseif _emt == _xit[27] then
					_olt[_dmt[_vit[1]]] = _olt[_dmt[_vit[2]]] + _olt[_dmt[_vit[3]]]
elseif _emt == _xit[28] then
					               
					_wlt += 1                    
else _ajt(_oht[28]) end
else
if _emt == _xit[29] then
					local _dot = _zkt[_plt[_dmt[_vit[4]] + 1]]

					local _eot = _dot.nups
					local _fot = _mjt(_eot)
					_olt[_dmt[_vit[1]]] = _ilt(_jlt, _dot, _fot)

					for _got = 1, _eot do
						local _hot = _qlt[_wlt]

						_wlt += 1

						local _iot = _hot[_vit[1]]

						if _iot == 0 then           
							local _jot = {
								value = _olt[_hot[_vit[2]]],
								index = _oht[30],                   
							}
							_jot.store = _jot

							_fot[_got] = _jot
						elseif _iot == 1 then               
							local _kot = _hot[_vit[2]]
							local _lot = _xlt[_kot]

							if _lot == nil then
								_lot = {
									index = _kot,
									store = _olt,
								}
								_xlt[_kot] = _lot
							end

							_fot[_got] = _lot
						elseif _iot == 2 then             
							_fot[_got] = _llt[_hot[_vit[2]] + 1]
						end
					end
elseif _emt == _xit[30] then
					_olt[_dmt[_vit[1]]] = _olt[_dmt[_vit[2]]][_olt[_dmt[_vit[3]]]]
elseif _emt == _xit[31] then
					_olt[_dmt[_vit[1]]] = -_olt[_dmt[_vit[2]]]
elseif _emt == _xit[32] then
					local _mot = _olt[_dmt[_vit[2]]]
					_olt[_dmt[_vit[1]]] = if _mot then _olt[_dmt[_vit[3]]] or false else _mot
else _ajt(_oht[28]) end
end
end
end
else
if _emt < _xit[49] then
if _emt < _xit[41] then
if _emt < _xit[37] then
if _emt == _xit[33] then
					if _ykt.useImportConstants then
						_olt[_dmt[_vit[1]]] = _dmt[_vit[12]]
					else
						local _not = _dmt[_vit[11]]
						local _oot = _dmt[_vit[8]]
						local _pot = _bmt[_oot] or _xkt[_oot]
						if _not == 1 then
							_olt[_dmt[_vit[1]]] = _pot
						elseif _not == 2 then
							_olt[_dmt[_vit[1]]] = _pot[_dmt[_vit[9]]]
						elseif _not == 3 then
							_olt[_dmt[_vit[1]]] = _pot[_dmt[_vit[9]]][_dmt[_vit[10]]]
						end
					end

					_wlt += 1                     

_olt[_dmt[_vit[2]]] = _olt[_dmt[_vit[3]]][_dmt[_vit[7]]]
_wlt += 2
elseif _emt == _xit[34] then
					               
elseif _emt == _xit[35] then
					local _qot = _dmt[_vit[7]]
					local _rot = _dmt[_vit[12]]
					local _sot = _olt[_dmt[_vit[1]]]

					if (_sot == _qot) ~= _rot then
						_wlt += _dmt[_vit[4]]
					else
						_wlt += 1
					end
elseif _emt == _xit[36] then
					local _tot = _dmt[_vit[1]]

					local _uot = _olt[_tot]
					if not _hkt(_uot) then
						local _vot = _bjt(_uot)

						if _vot == nil then
							_ajt(_oht[31])
						end

						_olt[_tot] = _vot
						_uot = _vot
					end

					local _wot = _olt[_tot + 1]
					if not _hkt(_wot) then
						local _xot = _bjt(_wot)

						if _xot == nil then
							_ajt(_oht[32])
						end

						_olt[_tot + 1] = _xot
						_wot = _xot
					end

					local _yot = _olt[_tot + 2]
					if not _hkt(_yot) then
						local _zot = _bjt(_yot)

						if _zot == nil then
							_ajt(_oht[33])
						end

						_olt[_tot + 2] = _zot
						_yot = _zot
					end

					if _wot > 0 then
						if not (_yot <= _uot) then
							_wlt += _dmt[_vit[4]]
						end
					else
						if not (_uot <= _yot) then
							_wlt += _dmt[_vit[4]]
						end
					end
else _ajt(_oht[28]) end
else
if _emt == _xit[37] then
					if _emt == 268 then
						_wlt += 1                    
					end
					if _elt then
						_elt(_olt, _nlt, _klt, _jlt, _llt)	
					end

					local _apt, _bpt, _cpt = _dmt[_vit[1]], _dmt[_vit[2]], _dmt[_vit[3]]

					local _dpt = if _bpt == 0 then _vlt - _apt else _bpt - 1
					local _ept = _olt[_apt]
					local _fpt = _kjt(
						_ept(_ljt(_olt, _apt + 1, _apt + _dpt))
					)

					local _gpt = _fpt.n

					if _cpt == 0 then
						_vlt = _apt + _gpt - 1
					else
						_gpt = _cpt - 1
					end

					_jjt(_fpt, 1, _gpt, _apt, _olt)
elseif _emt == _xit[38] then
					_olt[_dmt[_vit[1]]] = nil
elseif _emt == _xit[39] then
					_olt[_dmt[_vit[1]]] = _dmt[_vit[4]]
elseif _emt == _xit[40] then
					_olt[_dmt[_vit[1]]] = _dmt[_vit[7]] - _olt[_dmt[_vit[3]]]
else _ajt(_oht[28]) end
end
else
if _emt < _xit[45] then
if _emt == _xit[41] then
					_olt[_dmt[_vit[1]]] = _olt[_dmt[_vit[2]]] ^ _olt[_dmt[_vit[3]]]
elseif _emt == _xit[42] then
					local _hpt = _dmt[_vit[1]]
					local _ipt = _dmt[_vit[2]]

					local _jpt = _dmt[_vit[7]]
					
					local _kpt = _olt[_ipt]

					_olt[_hpt + 1] = _kpt
					
					_wlt += 1                     
					
					local _lpt = true
					
					                                                   
					local _mpt = _ykt.useNativeNamecall

					if _mpt then
						local _npt = _ykt.namecallHandler

						local _opt = _qlt[_wlt]
						local _ppt = _opt[_vit[13]]

						                                       
						local _qpt, _rpt, _spt = _opt[_vit[1]], _opt[_vit[2]], _opt[_vit[3]]

						if _dlt then
							_dlt(_olt, _nlt, _klt, _jlt, _llt)
						end

						if _elt then
							_elt(_olt, _nlt, _klt, _jlt, _llt)	
						end

						local _tpt = if _rpt == 0 then _vlt - _qpt else _rpt - 1
						local _upt = _kjt(
							_npt(_jpt, _ljt(_olt, _qpt + 1, _qpt + _tpt))
						)

						if _upt[1] == true then
							_lpt = false
							
							_wlt += if _ppt == 268 then 2 else 1                                    

							_dmt = _opt
							_emt = _ppt
							_nlt.pc = _wlt
							_nlt.name = _dmt[_vit[14]]

							local _vpt = _upt.n - 1

							if _spt == 0 then
								_vlt = _qpt + _vpt - 1
							else
								_vpt = _spt - 1
							end

							_jjt(_upt, 2, _vpt + 1, _qpt, _olt)
						end
					end
					
					if _lpt then
						_olt[_hpt] = _kpt[_jpt]
					end
elseif _emt == _xit[43] then
					local _wpt = _dmt[_vit[7]]
					_olt[_dmt[_vit[1]]] = _olt[_dmt[_vit[2]]][_wpt]

					_wlt += 1                     
elseif _emt == _xit[44] then
_olt[_dmt[_vit[1]]] = _dmt[_vit[4]]
_olt[_dmt[_vit[2]]] = _dmt[_vit[5]]
_wlt += 1
else _ajt(_oht[28]) end
else
if _emt == _xit[45] then
					local _xpt = _olt[_dmt[_vit[1]]]

					if _ykt.generalizedIteration and not _nkt(_xpt) then
						local _ypt = _qlt[_wlt + _dmt[_vit[4]]]
						if _ylt[_ypt] == nil then 
							local function _zpt(...)
								for _aqt, _bqt, _cqt, _dqt, _eqt, _fqt, _gqt, _hqt, _iqt, _jqt, _kqt, _lqt, _mqt, _nqt, _oqt, _pqt, _qqt, _rqt, _sqt, _tqt, _uqt, _vqt, _wqt, _xqt, _yqt, _zqt, _art, _brt, _crt, _drt, _ert, _frt, _grt, _hrt, _irt, _jrt, _krt, _lrt, _mrt, _nrt, _ort, _prt, _qrt, _rrt, _srt, _trt, _urt, _vrt, _wrt, _xrt, _yrt, _zrt, _ast, _bst, _cst, _dst, _est, _fst, _gst, _hst, _ist, _jst, _kst, _lst, _mst, _nst, _ost, _pst, _qst, _rst, _sst, _tst, _ust, _vst, _wst, _xst, _yst, _zst, _att, _btt, _ctt, _dtt, _ett, _ftt, _gtt, _htt, _itt, _jtt, _ktt, _ltt, _mtt, _ntt, _ott, _ptt, _qtt, _rtt, _stt, _ttt, _utt, _vtt, _wtt, _xtt, _ytt, _ztt, _aut, _but, _cut, _dut, _eut, _fut, _gut, _hut, _iut, _jut, _kut, _lut, _mut, _nut, _out, _put, _qut, _rut, _sut, _tut, _uut, _vut, _wut, _xut, _yut, _zut, _avt, _bvt, _cvt, _dvt, _evt, _fvt, _gvt, _hvt, _ivt, _jvt, _kvt, _lvt, _mvt, _nvt, _ovt, _pvt, _qvt, _rvt, _svt, _tvt, _uvt, _vvt, _wvt, _xvt, _yvt, _zvt, _awt, _bwt, _cwt, _dwt, _ewt, _fwt, _gwt, _hwt, _iwt, _jwt, _kwt, _lwt, _mwt, _nwt, _owt, _pwt, _qwt, _rwt, _swt, _twt, _uwt, _vwt, _wwt, _xwt, _ywt, _zwt, _axt, _bxt, _cxt, _dxt, _fxt, _gxt, _hxt, _ixt, _jxt, _kxt, _lxt, _mxt, _nxt, _oxt, _pxt, _qxt, _rxt, _sxt in ... do 
									_rjt({_aqt, _bqt, _cqt, _dqt, _eqt, _fqt, _gqt, _hqt, _iqt, _jqt, _kqt, _lqt, _mqt, _nqt, _oqt, _pqt, _qqt, _rqt, _sqt, _tqt, _uqt, _vqt, _wqt, _xqt, _yqt, _zqt, _art, _brt, _crt, _drt, _ert, _frt, _grt, _hrt, _irt, _jrt, _krt, _lrt, _mrt, _nrt, _ort, _prt, _qrt, _rrt, _srt, _trt, _urt, _vrt, _wrt, _xrt, _yrt, _zrt, _ast, _bst, _cst, _dst, _est, _fst, _gst, _hst, _ist, _jst, _kst, _lst, _mst, _nst, _ost, _pst, _qst, _rst, _sst, _tst, _ust, _vst, _wst, _xst, _yst, _zst, _att, _btt, _ctt, _dtt, _ett, _ftt, _gtt, _htt, _itt, _jtt, _ktt, _ltt, _mtt, _ntt, _ott, _ptt, _qtt, _rtt, _stt, _ttt, _utt, _vtt, _wtt, _xtt, _ytt, _ztt, _aut, _but, _cut, _dut, _eut, _fut, _gut, _hut, _iut, _jut, _kut, _lut, _mut, _nut, _out, _put, _qut, _rut, _sut, _tut, _uut, _vut, _wut, _xut, _yut, _zut, _avt, _bvt, _cvt, _dvt, _evt, _fvt, _gvt, _hvt, _ivt, _jvt, _kvt, _lvt, _mvt, _nvt, _ovt, _pvt, _qvt, _rvt, _svt, _tvt, _uvt, _vvt, _wvt, _xvt, _yvt, _zvt, _awt, _bwt, _cwt, _dwt, _ewt, _fwt, _gwt, _hwt, _iwt, _jwt, _kwt, _lwt, _mwt, _nwt, _owt, _pwt, _qwt, _rwt, _swt, _twt, _uwt, _vwt, _wwt, _xwt, _ywt, _zwt, _axt, _bxt, _cxt, _dxt, _fxt, _gxt, _hxt, _ixt, _jxt, _kxt, _lxt, _mxt, _nxt, _oxt, _pxt, _qxt, _rxt, _sxt})
								end

								_rjt(_qkt)
							end

							_ylt[_ypt] = _qjt(_zpt)
						end
					end

					_wlt += _dmt[_vit[4]]
elseif _emt == _xit[46] then
					local _txt = _llt[_dmt[_vit[2]] + 1]
					_txt.store[_txt.index] = _olt[_dmt[_vit[1]]]
elseif _emt == _xit[47] then
					if not _nkt(_olt[_dmt[_vit[1]]]) then
						_ajt(_fjt(_oht[29], _yit(_olt[_dmt[_vit[1]]])))                                                 
					end

					_wlt += _dmt[_vit[4]]
elseif _emt == _xit[48] then
					if _elt then
						_elt(_olt, _nlt, _klt, _jlt, _llt)	
					end

					local _uxt = _dmt[_vit[1]]
					local _vxt = _dmt[_vit[2]] 
					local _wxt = _vxt - 1
					local _xxt

					if _wxt == _pkt then
						_xxt = _vlt - _uxt + 1
					else
						_xxt = _vxt - 1
					end

					return _ljt(_olt, _uxt, _uxt + _xxt - 1)
else _ajt(_oht[28]) end
end
end
else
if _emt < _xit[57] then
if _emt < _xit[53] then
if _emt == _xit[49] then
					if _emt == 268 then
						_wlt += 1                    
					end
					if _elt then
						_elt(_olt, _nlt, _klt, _jlt, _llt)	
					end

					local _yxt, _zxt, _ayt = _dmt[_vit[1]], _dmt[_vit[2]], _dmt[_vit[3]]

					local _byt = if _zxt == 0 then _vlt - _yxt else _zxt - 1
					local _cyt = _olt[_yxt]
					local _dyt = _kjt(
						_cyt(_ljt(_olt, _yxt + 1, _yxt + _byt))
					)

					local _eyt = _dyt.n

					if _ayt == 0 then
						_vlt = _yxt + _eyt - 1
					else
						_eyt = _ayt - 1
					end

					_jjt(_dyt, 1, _eyt, _yxt, _olt)
elseif _emt == _xit[50] then
					local _fyt = _dmt[_vit[7]]
					_olt[_dmt[_vit[1]]] = _olt[_dmt[_vit[2]]][_fyt]

					_wlt += 1                     
elseif _emt == _xit[51] then
					if not _olt[_dmt[_vit[1]]] then
						_wlt += _dmt[_vit[4]]
					end
elseif _emt == _xit[52] then
					_olt[_dmt[_vit[1]]] = _dmt[_vit[7]] / _olt[_dmt[_vit[3]]]
else _ajt(_oht[28]) end
else
if _emt == _xit[53] then
					_dmt[_vit[5]] += 1
elseif _emt == _xit[54] then
					local _gyt = _dmt[_vit[1]]
					local _hyt = _dmt[_vit[2]]

					local _iyt = _dmt[_vit[7]]
					
					local _jyt = _olt[_hyt]

					_olt[_gyt + 1] = _jyt
					
					_wlt += 1                     
					
					local _kyt = true
					
					                                                   
					local _lyt = _ykt.useNativeNamecall

					if _lyt then
						local _myt = _ykt.namecallHandler

						local _nyt = _qlt[_wlt]
						local _oyt = _nyt[_vit[13]]

						                                       
						local _pyt, _qyt, _ryt = _nyt[_vit[1]], _nyt[_vit[2]], _nyt[_vit[3]]

						if _dlt then
							_dlt(_olt, _nlt, _klt, _jlt, _llt)
						end

						if _elt then
							_elt(_olt, _nlt, _klt, _jlt, _llt)	
						end

						local _syt = if _qyt == 0 then _vlt - _pyt else _qyt - 1
						local _tyt = _kjt(
							_myt(_iyt, _ljt(_olt, _pyt + 1, _pyt + _syt))
						)

						if _tyt[1] == true then
							_kyt = false
							
							_wlt += if _oyt == 268 then 2 else 1                                    

							_dmt = _nyt
							_emt = _oyt
							_nlt.pc = _wlt
							_nlt.name = _dmt[_vit[14]]

							local _uyt = _tyt.n - 1

							if _ryt == 0 then
								_vlt = _pyt + _uyt - 1
							else
								_uyt = _ryt - 1
							end

							_jjt(_tyt, 2, _uyt + 1, _pyt, _olt)
						end
					end
					
					if _kyt then
						_olt[_gyt] = _jyt[_iyt]
					end
elseif _emt == _xit[55] then
					if _olt[_dmt[_vit[1]]] <= _olt[_dmt[_vit[6]]] then
						_wlt += _dmt[_vit[4]]
					else
						_wlt += 1
					end
elseif _emt == _xit[56] then
					local _vyt = _llt[_dmt[_vit[2]] + 1]
					_olt[_dmt[_vit[1]]] = _vyt.store[_vyt.index]
local _wyt = _llt[_dmt[_vit[4]] + 1]
_olt[_dmt[_vit[3]]] = _wyt.store[_wyt.index]
_wlt += 1
else _ajt(_oht[28]) end
end
else
if _emt < _xit[61] then
if _emt == _xit[57] then
					if _elt then
						_elt(_olt, _nlt, _klt, _jlt, _llt)	
					end

					local _xyt = _dmt[_vit[1]]
					local _yyt = _dmt[_vit[2]] 
					local _zyt = _yyt - 1
					local _azt

					if _zyt == _pkt then
						_azt = _vlt - _xyt + 1
					else
						_azt = _yyt - 1
					end

					return _ljt(_olt, _xyt, _xyt + _azt - 1)
elseif _emt == _xit[58] then
_olt[_dmt[_vit[1]]] = nil
_olt[_dmt[_vit[2]]] = nil
_wlt += 1
elseif _emt == _xit[59] then
					_olt[_dmt[_vit[1]]] = _olt[_dmt[_vit[2]]][_olt[_dmt[_vit[3]]]]
elseif _emt == _xit[60] then
					               
else _ajt(_oht[28]) end
else
if _emt == _xit[61] then
_olt[_dmt[_vit[3]]] = _olt[_dmt[_vit[2]]][_dmt[_vit[8]]]
_wlt += 2
					local _bzt = _dmt[_vit[1]]
					local _czt = _dmt[_vit[3]]

					local _dzt = _dmt[_vit[7]]
					
					local _ezt = _olt[_czt]

					_olt[_bzt + 1] = _ezt
					
					_wlt += 1                     
					
					local _fzt = true
					
					                                                   
					local _gzt = _ykt.useNativeNamecall

					if _gzt then
						local _hzt = _ykt.namecallHandler

						local _izt = _qlt[_wlt]
						local _jzt = _izt[_vit[13]]

						                                       
						local _kzt, _lzt, _mzt = _izt[_vit[1]], _izt[_vit[2]], _izt[_vit[3]]

						if _dlt then
							_dlt(_olt, _nlt, _klt, _jlt, _llt)
						end

						if _elt then
							_elt(_olt, _nlt, _klt, _jlt, _llt)	
						end

						local _nzt = if _lzt == 0 then _vlt - _kzt else _lzt - 1
						local _ozt = _kjt(
							_hzt(_dzt, _ljt(_olt, _kzt + 1, _kzt + _nzt))
						)

						if _ozt[1] == true then
							_fzt = false
							
							_wlt += if _jzt == 268 then 2 else 1                                    

							_dmt = _izt
							_emt = _jzt
							_nlt.pc = _wlt
							_nlt.name = _dmt[_vit[14]]

							local _pzt = _ozt.n - 1

							if _mzt == 0 then
								_vlt = _kzt + _pzt - 1
							else
								_pzt = _mzt - 1
							end

							_jjt(_ozt, 2, _pzt + 1, _kzt, _olt)
						end
					end
					
					if _fzt then
						_olt[_bzt] = _ezt[_dzt]
					end
elseif _emt == _xit[62] then
					_olt[_dmt[_vit[1]]] = nil
elseif _emt == _xit[63] then
					_olt[_dmt[_vit[1]]] = #_olt[_dmt[_vit[2]]]
elseif _emt == _xit[64] then
					_olt[_dmt[_vit[1]]] = _olt[_dmt[_vit[2]]]
else _ajt(_oht[28]) end
end
end
end
end
else
if _emt < _xit[97] then
if _emt < _xit[81] then
if _emt < _xit[73] then
if _emt < _xit[69] then
if _emt == _xit[65] then
					_olt[_dmt[_vit[1]]] = _olt[_dmt[_vit[2]]] // _dmt[_vit[7]]
elseif _emt == _xit[66] then
					_olt[_dmt[_vit[1]]][_dmt[_vit[7]]] = _olt[_dmt[_vit[3]]]
					_wlt += 1                    
elseif _emt == _xit[67] then
					local _qzt = _dmt[_vit[7]]
					_xkt[_qzt] = _olt[_dmt[_vit[1]]]

					_wlt += 1                    
elseif _emt == _xit[68] then
				    local _rzt = _olt[_dmt[_vit[2]]]
				    local _szt = _dmt[_vit[7]]
				
				    if _yit(_rzt) == _oht[4] then
				        if _szt == 2 then
				            _olt[_dmt[_vit[1]]] = _rzt * _rzt
				        elseif _szt == 0.5 then
				            _olt[_dmt[_vit[1]]] = _hjt(_rzt)
				        elseif _szt == 3 then
				            _olt[_dmt[_vit[1]]] = _rzt * _rzt * _rzt
				        else
				            _olt[_dmt[_vit[1]]] = _rzt ^ _szt
				        end
				    else
				        _olt[_dmt[_vit[1]]] = _rzt ^ _szt
				    end
else _ajt(_oht[28]) end
else
if _emt == _xit[69] then
_olt[_dmt[_vit[1]]] = _olt[_dmt[_vit[2]]]
_olt[_dmt[_vit[3]]] = _olt[_dmt[_vit[4]]]
_wlt += 1
elseif _emt == _xit[70] then
					                          
					_ajt(_oht[34])
elseif _emt == _xit[71] then
					if _emt == 268 then
						_wlt += 1                    
					end
					if _elt then
						_elt(_olt, _nlt, _klt, _jlt, _llt)	
					end

					local _tzt, _uzt, _vzt = _dmt[_vit[1]], _dmt[_vit[2]], _dmt[_vit[3]]

					local _wzt = if _uzt == 0 then _vlt - _tzt else _uzt - 1
					local _xzt = _olt[_tzt]
					local _yzt = _kjt(
						_xzt(_ljt(_olt, _tzt + 1, _tzt + _wzt))
					)

					local _zzt = _yzt.n

					if _vzt == 0 then
						_vlt = _tzt + _zzt - 1
					else
						_zzt = _vzt - 1
					end

					_jjt(_yzt, 1, _zzt, _tzt, _olt)
elseif _emt == _xit[72] then
					if not _olt[_dmt[_vit[1]]] then
						_wlt += _dmt[_vit[4]]
					end
else _ajt(_oht[28]) end
end
else
if _emt < _xit[77] then
if _emt == _xit[73] then
					_olt[_dmt[_vit[1]]] = _olt[_dmt[_vit[2]]]
elseif _emt == _xit[74] then
					_wlt += _dmt[_vit[4]]
elseif _emt == _xit[75] then
					if _elt then
						_elt(_olt, _nlt, _klt, _jlt, _llt)	
					end

					local _aau = _dmt[_vit[1]]
					local _bau = _dmt[_vit[7]]

					_vlt = _aau + 6

					local _cau = _olt[_aau]

					if (_ykt.generalizedIteration == false) or _nkt(_cau) then 
						local _dau = { _cau(_olt[_aau + 1], _olt[_aau + 2]) }
						_jjt(_dau, 1, _bau, _aau + 3, _olt)

						if _olt[_aau + 3] ~= nil then
							_olt[_aau + 2] = _olt[_aau + 3]
							_wlt += _dmt[_vit[4]]
						else
							_wlt += 1
						end
					else
						local _eau, _fau = _sjt(_ylt[_dmt], _cau, _olt[_aau + 1], _olt[_aau + 2])
						if not _eau then
							_ajt(_fau)
						end
						if _fau == _qkt then 
							_ylt[_dmt] = nil
							_wlt += 1
						else
							_jjt(_fau, 1, _bau, _aau + 3, _olt)

							_olt[_aau + 2] = _olt[_aau + 3]
							_wlt += _dmt[_vit[4]]
						end
					end
elseif _emt == _xit[76] then
					local _gau = _dmt[_vit[1]]
					local _hau = _dmt[_vit[2]]

					local _iau = _dmt[_vit[7]]
					
					local _jau = _olt[_hau]

					_olt[_gau + 1] = _jau
					
					_wlt += 1                     
					
					local _kau = true
					
					                                                   
					local _lau = _ykt.useNativeNamecall

					if _lau then
						local _mau = _ykt.namecallHandler

						local _nau = _qlt[_wlt]
						local _oau = _nau[_vit[13]]

						                                       
						local _pau, _qau, _rau = _nau[_vit[1]], _nau[_vit[2]], _nau[_vit[3]]

						if _dlt then
							_dlt(_olt, _nlt, _klt, _jlt, _llt)
						end

						if _elt then
							_elt(_olt, _nlt, _klt, _jlt, _llt)	
						end

						local _sau = if _qau == 0 then _vlt - _pau else _qau - 1
						local _tau = _kjt(
							_mau(_iau, _ljt(_olt, _pau + 1, _pau + _sau))
						)

						if _tau[1] == true then
							_kau = false
							
							_wlt += if _oau == 268 then 2 else 1                                    

							_dmt = _nau
							_emt = _oau
							_nlt.pc = _wlt
							_nlt.name = _dmt[_vit[14]]

							local _uau = _tau.n - 1

							if _rau == 0 then
								_vlt = _pau + _uau - 1
							else
								_uau = _rau - 1
							end

							_jjt(_tau, 2, _uau + 1, _pau, _olt)
						end
					end
					
					if _kau then
						_olt[_gau] = _jau[_iau]
					end
else _ajt(_oht[28]) end
else
if _emt == _xit[77] then
					local _vau = _llt[_dmt[_vit[2]] + 1]
					_olt[_dmt[_vit[1]]] = _vau.store[_vau.index]
elseif _emt == _xit[78] then
					local _wau = _dmt[_vit[7]]
					local _xau = _dmt[_vit[12]]
					local _yau = _olt[_dmt[_vit[1]]]

					if (_yau == _wau) ~= _xau then
						_wlt += _dmt[_vit[4]]
					else
						_wlt += 1
					end
elseif _emt == _xit[79] then
					if _ykt.useImportConstants then
						_olt[_dmt[_vit[1]]] = _dmt[_vit[7]]
					else
						local _zau = _dmt[_vit[11]]
						local _abu = _dmt[_vit[8]]
						local _bbu = _bmt[_abu] or _xkt[_abu]
						if _zau == 1 then
							_olt[_dmt[_vit[1]]] = _bbu
						elseif _zau == 2 then
							_olt[_dmt[_vit[1]]] = _bbu[_dmt[_vit[9]]]
						elseif _zau == 3 then
							_olt[_dmt[_vit[1]]] = _bbu[_dmt[_vit[9]]][_dmt[_vit[10]]]
						end
					end

					_wlt += 1                     
elseif _emt == _xit[80] then
					local _cbu = _olt[_dmt[_vit[2]]]
					_olt[_dmt[_vit[1]]] = if _cbu then _dmt[_vit[7]] or false else _cbu
else _ajt(_oht[28]) end
end
end
else
if _emt < _xit[89] then
if _emt < _xit[85] then
if _emt == _xit[81] then
					_olt[_dmt[_vit[1]]] = _olt[_dmt[_vit[2]]]
elseif _emt == _xit[82] then
					if _olt[_dmt[_vit[1]]] then
						_wlt += _dmt[_vit[4]]
					end
elseif _emt == _xit[83] then
					local _dbu = _dmt[_vit[12]]

					if (_olt[_dmt[_vit[1]]] == nil) ~= _dbu then
						_wlt += _dmt[_vit[4]]
					else
						_wlt += 1
					end
elseif _emt == _xit[84] then
					local _ebu = _dmt[_vit[1]]
					local _fbu = _dmt[_vit[2]] - 1

					if _fbu == _pkt then
						_fbu = _rlt.len
						_vlt = _ebu + _fbu - 1
					end

					_jjt(_rlt.list, 1, _fbu, _ebu, _olt)
else _ajt(_oht[28]) end
else
if _emt == _xit[85] then
					if _emt == 268 then
						_wlt += 1                    
					end
					if _elt then
						_elt(_olt, _nlt, _klt, _jlt, _llt)	
					end

					local _gbu, _hbu, _ibu = _dmt[_vit[1]], _dmt[_vit[2]], _dmt[_vit[3]]

					local _jbu = if _hbu == 0 then _vlt - _gbu else _hbu - 1
					local _kbu = _olt[_gbu]
					local _lbu = _kjt(
						_kbu(_ljt(_olt, _gbu + 1, _gbu + _jbu))
					)

					local _mbu = _lbu.n

					if _ibu == 0 then
						_vlt = _gbu + _mbu - 1
					else
						_mbu = _ibu - 1
					end

					_jjt(_lbu, 1, _mbu, _gbu, _olt)
elseif _emt == _xit[86] then
					if _elt then
						_elt(_olt, _nlt, _klt, _jlt, _llt)	
					end

					local _nbu = _dmt[_vit[1]]
					local _obu = _olt[_nbu]
					local _pbu = _olt[_nbu + 1]
					local _qbu = _olt[_nbu + 2] + _pbu

					_olt[_nbu + 2] = _qbu

					if _pbu > 0 then
						if _qbu <= _obu then
							_wlt += _dmt[_vit[4]]
						end
					else
						if _obu <= _qbu then
							_wlt += _dmt[_vit[4]]
						end
					end
elseif _emt == _xit[87] then
					_olt[_dmt[_vit[1]]] = _olt[_dmt[_vit[2]]] / _dmt[_vit[7]]
elseif _emt == _xit[88] then
					if _olt[_dmt[_vit[1]]] == _olt[_dmt[_vit[6]]] then
						_wlt += 1
					else
						_wlt += _dmt[_vit[4]]
					end
else _ajt(_oht[28]) end
end
else
if _emt < _xit[93] then
if _emt == _xit[89] then
					_olt[_dmt[_vit[1]]] = _dmt[_vit[7]]
elseif _emt == _xit[90] then
					_olt[_dmt[_vit[1]]] = _dmt[_vit[7]]
elseif _emt == _xit[91] then
					local _rbu, _sbu = _dmt[_vit[2]], _dmt[_vit[3]]
					local _tbu, _ubu = _zit(_pjt, _olt, _oht[35], _rbu, _sbu)
	
					if not _tbu then
						_ubu = _olt[_rbu]
	
						for _vbu = _rbu + 1, _sbu do
							_ubu ..= _olt[_vbu]
						end
					end

					_olt[_dmt[_vit[1]]] = _ubu
elseif _emt == _xit[92] then
					local _wbu = _dmt[_vit[7]]
					_olt[_dmt[_vit[2]]][_wbu] = _olt[_dmt[_vit[1]]]

					_wlt += 1                    
else _ajt(_oht[28]) end
else
if _emt == _xit[93] then
					_olt[_dmt[_vit[1]]] = _dmt[_vit[2]] == 1
					_wlt += _dmt[_vit[3]]
elseif _emt == _xit[94] then
					local _xbu = _dmt[_vit[7]]

					_olt[_dmt[_vit[1]]] = _bmt[_xbu] or _xkt[_xbu]

					_wlt += 1                    
elseif _emt == _xit[95] then
					_olt[_dmt[_vit[1]]] = _olt[_dmt[_vit[2]]] * _dmt[_vit[7]]
elseif _emt == _xit[96] then
					_olt[_dmt[_vit[1]]] = _mjt(_dmt[_vit[6]])

					_wlt += 1                     
else _ajt(_oht[28]) end
end
end
end
else
if _emt < _xit[113] then
if _emt < _xit[105] then
if _emt < _xit[101] then
if _emt == _xit[97] then
					_olt[_dmt[_vit[1]]] = _olt[_dmt[_vit[2]]] % _dmt[_vit[7]]
elseif _emt == _xit[98] then
					               
elseif _emt == _xit[99] then
					_olt[_dmt[_vit[1]]] = _olt[_dmt[_vit[2]]][_olt[_dmt[_vit[3]]]]
elseif _emt == _xit[100] then
					if _elt then
						_elt(_olt, _nlt, _klt, _jlt, _llt)	
					end

					_wlt += _dmt[_vit[5]]
else _ajt(_oht[28]) end
else
if _emt == _xit[101] then
					if _clt then
						local _ybu = _kjt(_clt(_olt, _nlt, _klt, _jlt, _llt))
						
						if _ybu[1] then 
							return _ljt(_ybu, 2, #_ybu)
						end 
					end
					
					_wlt -= 1
					_emt = _amt[_wlt]
					_cmt = true
elseif _emt == _xit[102] then
					_olt[_dmt[_vit[1]]] = not _olt[_dmt[_vit[2]]]
elseif _emt == _xit[103] then
					_olt[_dmt[_vit[1]]] = _dmt[_vit[7]]
elseif _emt == _xit[104] then
					_wlt += _dmt[_vit[4]]
else _ajt(_oht[28]) end
end
else
if _emt < _xit[109] then
if _emt == _xit[105] then
					if not _olt[_dmt[_vit[1]]] then
						_wlt += _dmt[_vit[4]]
					end
elseif _emt == _xit[106] then
					_olt[_dmt[_vit[1]]] = _olt[_dmt[_vit[2]]] * _olt[_dmt[_vit[3]]]
elseif _emt == _xit[107] then
					_olt[_dmt[_vit[1]]] = _olt[_dmt[_vit[2]]] / _olt[_dmt[_vit[3]]]
elseif _emt == _xit[108] then
					_olt[_dmt[_vit[1]]] = _olt[_dmt[_vit[2]]] - _olt[_dmt[_vit[3]]]
else _ajt(_oht[28]) end
else
if _emt == _xit[109] then
					_olt[_dmt[_vit[1]]] = _olt[_dmt[_vit[2]]] + _olt[_dmt[_vit[3]]]
elseif _emt == _xit[110] then
					               
					_wlt += 1                    
elseif _emt == _xit[111] then
					local _zbu = _dmt[_vit[7]]
					local _acu = _dmt[_vit[12]]
					local _bcu = _olt[_dmt[_vit[1]]]

					if (_lkt(_bcu) and (_bcu == _zbu)) ~= _acu then
						_wlt += _dmt[_vit[4]]
					else
						_wlt += 1
					end
elseif _emt == _xit[112] then
					_wlt += _dmt[_vit[4]]
else _ajt(_oht[28]) end
end
end
else
if _emt < _xit[121] then
if _emt < _xit[117] then
if _emt == _xit[113] then
_olt[_dmt[_vit[1]]] = _olt[_dmt[_vit[2]]] - _olt[_dmt[_vit[3]]]
_olt[_dmt[_vit[4]]] = _olt[_dmt[_vit[1]]]
_wlt += 1
elseif _emt == _xit[114] then
					                                                         

elseif _emt == _xit[115] then
					_olt[_dmt[_vit[1]]] = _olt[_dmt[_vit[2]]] - _dmt[_vit[7]]
elseif _emt == _xit[116] then
					_olt[_dmt[_vit[1]]] = _olt[_dmt[_vit[2]]] + _dmt[_vit[7]]
else _ajt(_oht[28]) end
else
if _emt == _xit[117] then
					                          
elseif _emt == _xit[118] then
					if _olt[_dmt[_vit[1]]] then
						_wlt += _dmt[_vit[4]]
					end
elseif _emt == _xit[119] then
					for _ccu, _dcu in _xlt do
						if _dcu.index >= _dmt[_vit[1]] then
							_dcu.value = _dcu.store[_dcu.index]
							_dcu.store = _dcu
							_dcu.index = _oht[30]                    
							_xlt[_ccu] = nil
						end
					end
elseif _emt == _xit[120] then
					local _ecu = _llt[_dmt[_vit[2]] + 1]
					_olt[_dmt[_vit[1]]] = _ecu.store[_ecu.index]
_olt[_dmt[_vit[3]]] = _olt[_dmt[_vit[1]]]
_wlt += 1
else _ajt(_oht[28]) end
end
else
if _emt < _xit[125] then
if _emt == _xit[121] then
					local _fcu = _olt[_dmt[_vit[2]]]
					_olt[_dmt[_vit[1]]] = if _fcu then _fcu else _olt[_dmt[_vit[3]]] or false
elseif _emt == _xit[122] then
					_olt[_dmt[_vit[1]]] = _olt[_dmt[_vit[2]]] + _olt[_dmt[_vit[3]]]
elseif _emt == _xit[123] then
					                                                                       
					_wlt += _dmt[_vit[4]]                            
elseif _emt == _xit[124] then
					_olt[_dmt[_vit[2]]][_dmt[_vit[3]] + 1] = _olt[_dmt[_vit[1]]]
else _ajt(_oht[28]) end
else
if _emt < _xit[127] then
if _emt == _xit[125] then
					if _olt[_dmt[_vit[1]]] <= _olt[_dmt[_vit[6]]] then
						_wlt += 1
					else
						_wlt += _dmt[_vit[4]]
					end
elseif _emt == _xit[126] then
					if _elt then
						_elt(_olt, _nlt, _klt, _jlt, _llt)	
					end

					local _gcu = _dmt[_vit[1]]
					local _hcu = _dmt[_vit[2]] 
					local _icu = _hcu - 1
					local _jcu

					if _icu == _pkt then
						_jcu = _vlt - _gcu + 1
					else
						_jcu = _hcu - 1
					end

					return _ljt(_olt, _gcu, _gcu + _jcu - 1)
else _ajt(_oht[28]) end
else
if _emt == _xit[127] then
					if _ykt.useImportConstants then
						_olt[_dmt[_vit[1]]] = _dmt[_vit[7]]
					else
						local _kcu = _dmt[_vit[11]]
						local _lcu = _dmt[_vit[8]]
						local _mcu = _bmt[_lcu] or _xkt[_lcu]
						if _kcu == 1 then
							_olt[_dmt[_vit[1]]] = _mcu
						elseif _kcu == 2 then
							_olt[_dmt[_vit[1]]] = _mcu[_dmt[_vit[9]]]
						elseif _kcu == 3 then
							_olt[_dmt[_vit[1]]] = _mcu[_dmt[_vit[9]]][_dmt[_vit[10]]]
						end
					end

					_wlt += 1                     
elseif _emt == _xit[128] then
					_olt[_dmt[_vit[1]]] = _olt[_dmt[_vit[2]]] % _olt[_dmt[_vit[3]]]
elseif _emt == _xit[129] then
					if _olt[_dmt[_vit[1]]] == _olt[_dmt[_vit[6]]] then
						_wlt += _dmt[_vit[4]]
					else
						_wlt += 1
					end
else _ajt(_oht[28]) end
end
end
end
end
end
end
				_fmt = _sht(_fmt + _emt + _wlt + 1)
				_gmt = _pht(_wlt, _fmt)
				if not _cmt then _dmt = nil end
			end

			for _ncu, _ocu in _xlt do
				_ocu.value = _ocu.store[_ocu.index]
				_ocu.store = _ocu
				_ocu.index = _oht[30]                    
				_xlt[_ncu] = nil
			end

			for _pcu, _qcu in _ylt do 
				_tjt(_qcu)
				_ylt[_pcu] = nil
			end
		end

		local function _rcu(...)
			local _scu = _kjt(...)
			local _tcu = _mjt(_klt.maxstacksize)
			local _ucu = {
				len = 0,
				list = {},
			}

			_jjt(_scu, 1, _klt.numparams, 0, _tcu)

			if _klt.numparams < _scu.n then
				local _vcu = _klt.numparams + 1
				local _wcu = _scu.n - _klt.numparams
				_ucu.len = _wcu
				_jjt(_scu, _vcu, _vcu + _wcu - 1, 1, _ucu.list)
			end

			_scu = nil

			local _xcu = {pc = 0, name = _oht[24]}
			local _ycu
			if _ykt.errorHandling then 
				_ycu = _kjt(_zit(_mlt, _xcu, _tcu, _klt.protos, _klt.code, _ucu))
			else
				_ycu = _kjt(true, _mlt(_xcu, _tcu, _klt.protos, _klt.code, _ucu))
			end

			if _ycu[1] then
				return _ljt(_ycu, 2, _ycu.n)
			else
				local _zcu = _ycu[2]

				if _flt then
					_flt(_zcu, _tcu, _xcu, _klt, _jlt, _llt)
				end

				if _jkt(_zcu) == false then
					if _ykt.allowProxyErrors then
						_ajt(_zcu)
					else 
						_zcu = _yit(_zcu)
					end
				end

				if _klt.lineinfoenabled then
					return _ajt(_fjt(_oht[36], _klt.debugname, _klt.instructionlineinfo[_xcu.pc], _xcu.pc, _xcu.name, _zcu), 0)
				else 
					return _ajt(_fjt(_oht[37], _klt.debugname, _xcu.pc, _xcu.name, _zcu), 0)
				end
			end
		end

		if _ykt.errorHandling then
			return _rcu
		else
			return _mlt
		end
	end

	return _ilt(_wkt, _alt),  _hlt
end

return {
	luau_newsettings = _rkt,
	luau_validatesettings = _tkt,
	luau_load = _vkt,
}

end)()
local _adu = _oht[38]
local _bdu = {}
for _cdu = 1, #_adu do
    _bdu[string.byte(_adu, _cdu)] = _cdu - 1
end
local function _ddu(_edu, _fdu, _gdu, _hdu)
    local _idu = buffer.create(_gdu)
    local _jdu, _kdu, _ldu, _mdu, _ndu = 0, 0, 0, 1, 0
    local _odu, _pdu, _qdu, _rdu = string.byte, buffer.writeu8, bit32.bxor, math.floor
    for _sdu, _tdu in ipairs(_edu) do
        for _udu = 1, #_tdu do
            _kdu = _kdu * 64 + _bdu[_odu(_tdu, _udu)]
            _jdu += 6
            if _jdu >= 8 then
                _jdu -= 8
                local _vdu = 2 ^ _jdu
                _fdu = _fdu * 48271 % 65521
                local _wdu = _qdu(_rdu(_kdu / _vdu), _fdu % 256)
                _pdu(_idu, _ldu, _wdu)
                _mdu = (_mdu + _wdu) % 65521
                _ndu = (_ndu + _mdu) % 65521
                _ldu += 1
                _kdu %= _vdu
            end
        end
    end
    assert(_ldu == _gdu and _ndu * 65536 + _mdu == _hdu, _oht[39])
    return _idu
end
                              
local _xdu = {
[54] = {{
"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",
},19631,21804,3213010430,865754784},
[5] = {{
"m0P22JpwzpoCKONjbgvSfm3s1qjAT5H3PqrWOU/3Ey5Rw39JwHJ5oDO5CC6ygxYja0F+y0DVBp2z5lLspUzvXkHBtlj3ZcAX3RN7SH5fwCnFF8Nx1m2MJBTNulYZk0xzILrZlYBQTn9Sw+TvQiTqX8Qxd128cYa8FyYyKShBVO+Nwz3QAxV7GB5CXddsa7kGR2XyFlILHcVtCNCbUGDwQfmlTC3Nri+17AjVuta4T12Xrr/uKSNPNeBp6pO5VGKs4KFe8ARMCEUSsfwTqYdD1rGcGb3sIBp+RxIhX3tmjqX5w5qjhcN6Xcd89ER0ixBnCzppCMw4X9ztkX808mjKZk0e/la/qc1t7UI207yPndIXlAX3oQSnEPwq8psR09n+bREJHclOXbQ5ivxU76oQ9qoXTIsaNzgxchsrNYPrZXA7YNkAmztYcGyvHQH0nVmFp7w0/21hxcLLJnoSU0QShLF+gGa0oMYTwkdDZsWG+ix08IBLVU8dnxCYgOB8QYPAO9ynjtGh6Qr+NAwmz+4zzaJhPhklcqNeF8aHsVtZeC",
},59863,415,3834361819,885035265},
[36] = {{
"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",
},24770,3532,902384908,3455467982},
[34] = {{
"K370BPaGluKWN03UQBe4jASbuGmTc2hXtWzaxrJ/VhVZHY653bE12IuwRqfNxWan/kn8BJoEYqlMZ1tW73rvM5BydE6ESlYQgDYBatEWsl4CJsv5hEnKe0wsvJv+lxMBpD85J5vOGo52AUS3okpvy5zeq9ZfC8lb9zfGTexDWFb9JpMy6YtQAsLsGBNLjsvZ4KfP6UwyBCw9pq5IUGUROPtl2CVA2IAA2rjbpUfIcTIbeFgrGJ4pw5EUx9AB9U/pYXkrUjXmdhrx6HJ9MZ0S5fgeAmzAW6H9YwIG6FT9aWZOupIBVYY5V82aGkElr4/TeDzqgCD+e45WNLyPmF8vEnx4M4dsQ1nnMN5YV/wlAeUnLLQ5OtXBF9zvurMlUtOBR2YE11KA/VN4v1+ZGmAZGRgzxemOJO/mkb/pDU+ggt0oTW0vI0gfcAlmQiBRFQMlg9A9BJ01CknroXEq7QpxHrYwrDJwX6piDOKDGkL033UUQeNhygfkH/Q/RYT4ieU7JysHT9ru7lvEUpmFanPnTdwZFT66woKg2utX0E3DaoATx5kFp56/VMkkKYam/lZF8dUMogFyeABxS5wXM1LHCemJT9W6jgfhV+Ny5xTZJqKENVmSTeKr0Kk/1kzeVu4136uY6uzxbzERm+E+zwUo0VhgBgoC232m9S99gWhcaEvMiRz72+AnDysd0Hgt4C",
},24252,526,3056397787,3814138847},
[7] = {{
"DftlWMCbbQTo3a3MfAmW6Sotnx9EsCsDnrjpXG4SU1YrlPFIGwE8m1EtJukXvELFK4Ku0fnNy2mPEPTK7He8MS2ZcqW2+8SBRZJh4lAZmNyjKvYlW7lvKDzcr3B2DyFxKe1Nd0VC8TblcmkdQDxGJGFmJWJUxKeX2bIeJk+Z634wJmnphRI5CKM8N9RO/O90CfPaSGTvz8cnTyQzsR8wVfBGxGOEM02VrvNO6WPxg3fwav8lmCgeWRXfKrP7ukDWj213XCXTyIiXUm2enM/8XNnayRw9HQ+A8YFTHtm++0AcMA3fkhGWEkXkX58tyy5APrKJWbpkaAbQAe6Jcu5FzLIz1uAvujv0b1i1JXiSx1aCs2GjbSx1984C6fH+CLN+N3T9bZkrO3mz3x+HHbhuKnefFg+jHNEKtAa0IlUaxDdWe8MzeWuO8dAwIAYeY9q1ubmQpnQv++467Oeob8ubfchc",
},16167,354,1963889009,3066728369},
[12] = {{
"u8Xj8KfDumZHlQQ85eOsoG5auqu44NBnmY3QnMly57YQ9Q6gaCm6xkMtSkJiSVrftVARj8ii3a7alPJMm0mk6REimlGc9mXgsAbCxqPgHEbwpFPHZBf6OGgE02ZYBHqR03FP2EfEyAB44C",
},11693,106,3912576070,2977011324},
[21] = {{
"Q30JX5uqetwbL7XSheYKGBXboSGKg2ApCSYaqcJ8/UwxFhzqWZL+QiAC4m1S3al0CL1JJx06WuNp5XtM0bob13b/yztmniD39c29K0gCIpWyrb22uRq652k3/r7CadFFxW0QRndwtCoZ",
},7568,105,1929717346,1497791598},
[26] = {{
"D7ZQ/4UstPmpobpBfjRO07aO88P3fV3ekECTKdZQfzu4qOB5yTY+MYkEwPJ2NNdxvmokayhqjhAbeG2okPIBEnszfy4aMSdGp8Tnn9kszFhyZbaxpeb6Kg78LaKw0XcYLz5eGWoTGuO9Y01m2X4mNGjS/GTkfjuxAhfvaEql36NFRTIjXME44PawCu8hyk/HX/WJXQp+Xx9ya77WOe1Rwbnn6iJX6GBshR3doFVLXMAgf0VGdWKTxuGiUk3XCtj1J41u86f7iMYQBWMkGTPE/i0weG624Xgp+AhbBcpLa4UXnlR2Yw49QZEJgVN3k97h8FKWCUWf/7iz2q15Yy1DLE2UzJrGrA2ieraNEAoHlYXVpfQvHzEjCfRECxB8kmW9GjR3S18x4BW0Ta386uRN8NiOKD8FjeriGUqT7IMfkSQ11biG6HpcZc5ZPU9AWllFDg4wlk+dUySIVjR8u9tN2qLeM59PGLrLfU1ryqs9tyDJIkm0jr8xYNYVqGujXnzlINLUXO95575PTqbL+diRUE01MwzpRdEqI+TmpU9T5bI3NJGAi7xfkpil1qdR7gkM5EPnMilyGtWxbip1wjiDOnzNQTZwJUAEk8zcEH0FCuedhQUvhE4iNvvj5X1JIwSjBMfyHSJcQ+kpK4xp970Xn3qQSe/tu4IL+BK0SX9UZlGpGV8VKeEbitMY2Rk5pN7vdtSBm/L4kE3OOBz7X8MXHHqWKyBX5W6osmAmtVE/qlXZv6n81GuHBWddii3sCP41QRbFLkqIUj60Tab11tfN1Z2gJhcjLiL4fdjLS3aVGou+q4VM5tvAmr2Z7KWHEB5pY+/262aq0/r6OKAbH3C5gmL3F91S52vi8bFzO9bl3MlIJabHtjg8s4iuyOKG52E2A9UkTW3/",
},21287,678,1366432249,1989749911},
[41] = {{
"2CfZtyl8CgQG0icMFkk2DkAqnSjnJjVJc3CKtktQcCmo1Aq3olcf/Z3tyXzcp8X+EZc59VKCF/FCo00G83hsApaI4UB0w0Hw6Od2QUJmWTGYc6ZH0NK3+c9K1qo2McNtpif3Qq1J0CUBZzFmsvAxOUtecKFgwGEE+NpXbHA+aRzBVIj1SBIEXnzYpfGxfT6gbPxzux7c6JRmPao1rt06gYh9SPrHOZSjTOAkV+qWm+rinDhftas6certgwMXDznlyNYblMnEd8tBDmoOpQDgskLhSDi4stnnpos1cqtir/Y4c9HQpx8N9RApGvso8blYdzdVZjJSpheavBoB1a3tN/Ea71ksc03Tkw6JXEuqLSjKuEchQZ1JrIgKty5m68fwbwExh54ilkXR1jloJQqsWrVhI9pP05mDbh0hMonjD08AV2yZyttPZf1H14f6rIBCsOtBds3n+7K+oyAcTAXOkbl0f2Bs3hJMyTRLSs7hPrT3+l8H8QzAB0UHyxRgQI2JlxQRAOKNFIll2nuQzuWJlbzPwqB0XlUvWAudGTnT7f4uDCZRZafRtym9D+6iX5pg+U+L077O6FdhfFq1L+3BeyKPeSSbGxdmMknQyE/ZVP3yvA+ZnVzy5Mqu6yEX8HSLsOgUxGXOQxd/rr3z4BcAUP4DXIZ29OvoxoiBgLADQ8F/Z3rro1WiA5E9UJhN7xGx7Gta8ybKnmJllRkQVO8SS/KGTuKG3SmtPnvhlMtkXJ+09R6WMTEWQpHHDmFDkFXp6YotsSKUrBjcS1brTG1gAi7Kpzf+TqPJr8NY/lP5GpG476LckpezeMb3ByZluq0XVlyiymSvyOx9q00",
},10941,635,2459966625,2437339456},
[10] = {{
"Awdkdje0n8/7S4RLasYUISHcl+yziDuaVq/MJK+fyrl6C/qiuWPkQWFfu8YEtvAYQW+e7dxEub16QL7ujL4nQCiTEKwRWccLr9m2Yqef3L93lUrZ2yyFbljVxbPd2agBbbh1ZEaAAPObRlLOW1ODme6EEHfJOEcM5wy+8fTFYIhyTqwCUGkAwtNunALr7n1QOuLYncXI",
},56929,150,2952672589,3477488551},
[49] = {{
"KGp0C7bi1t6onBIe9tIY2huMl5VhFWZMXe32lgrZd/0GuygKnKXfq0qqjjptuUMofh6s1VS/4wEME3SsxIiiQ+lQiKg1Xsrvdet2DN4sIBkWlsrUN/BSWDLpQGSo0SSgKOjT2nWbNoQaeXTE7ooQsCLrcuKNyOj21HOPi4MmNjuV7zSeutUv23BM6Gm/V+L8kt3P88Yu8JMXM1gFz2dmFliqIYNCEPgvSV+I75GECLYfMs83eemgn/obcOK4VQucomS+OUtsi7GB015uA1jkc/WhbOcrDU4iYBiubbiF1SWlt145GJTXudrR03GpphRwEjNTdZndd960axueSb/OKVAVv+GgYDefWvUCtYQy/fE14UnlpX1BKkhIFbk3r3UBybGh5LBV5UpVsDnxRkyWbtHD+KNZzmajiYb4IIpYSSALk9BW+GaKP4khCR2DX1m6nkLkld5xgbKlSKi2DAzo83M2sgG+b6G+3xDLN+H9UpU3q05fuH/MR0QdGTh2IAp00u6CYCuwna1Mbx8fH08Rj4KU9PQfubwJUXbFlP5bgqAVGkuEt2FS2taFFwlFTF+PSoJi3v0+pmkmyUhVOHJwgOs5ANVJDT/hskB98qYQdbk9LzIAAzX82q3d8qXJsdVFGlkY8Wp+r6cH32Qr2NY2SS3Hb0Qyp3z/XSWKlmnGgZaeSJtV1bG/ClxVjacq+4C58Vcy6hrtpLC6s1bG5jYSTgfZtMwGX20wD0A++cF8uxxq8f1hrZeOvoh4Vth+snXAPNl8l1/SoTsnk3xFwXawT2hAsWNkTR7bQltB/2LVFSyCGsIqlscwqEK2AbqqrbmUC4C/Vhyzm7Sfz8nqFJNcqODH5a7sG51w4r3vIxDm1fsGM6gq/GptYyEc3a0vfbgg2UPDdmkFIANJ6SJuJo70fz4F8XNY6Y5Q28Ir9R8eyiSQCVZYpgICHz42DPoFA+ttLqzmXNJu67OHMm7+9Z0BG4JhT3n/Z6sc/FuUr82xnTuiiLzHaculzKpLxHe1bAihSnQu/PbaWBYdokzv4WsX/rI/5rRGaQ8YriaZzZ+/9Ved9iMwnO6vhYidqJ/fvRC4H4mH4HU53kiOsggaKRBn+XsdnoSrBn5RpVAkiKix/In3L+lwMZ1LS2ly7H1E23HDn5sTrepFk0Y+FOHAyArmZpHXUrBjYU/rkk0f3hNM09HTuFQ5EJAdtDf//3HHehn+N5EK02Ol/a7UEuW3gIUfSepRuLY29dJ8rjhhPj2M/qZ0jStkzWafjOX0ctQTxqkuL1AdTKXpZoc4h1KLpdPnSumJK/8SwD4ReQppSoQVrlo48q/+D0HlajVMhOpEkSeYPe1RUv7sybhoXpIrMQo+BKCx+FcqH7WdNgs/9i2B2+Nm825LY/8XCYX84ycPynK1FTBjcfMfIXbQFn18f7Rd2KCNvzCRXom4JUNVOJYot+kWFMkj9oT8W0v5TpV0KVnRll/hiIO0t8uLC5kM3z/QxwOf8jVvwwU3fhBzU/s58bfplCf0+EeP17tAOKOnfNz+kLkp0pYalzBKftNqpZT2SXBoqRN3pSj7nD/8MJ+7kgwPH0/mEXM7klPupvrymfTCTyyj1S1uocCP4gcV",
},44132,1212,2849048030,4182424256},
[44] = {{
"EwlOQFgw5JOWpYZJcjivP2N51zo5ZAVmQI5JaAklCdULGp8cLvD+1CPcaeUoheCsGQJXGZkwSRNnxKWbRxdJ8Vgc/0Wzvx2x1aAkuFXz6EZA3RwMJDh3YAeXWHLBvz+8+7r3wp7kDJr8ySVxF2iaIJKb7sSKWiDe/HE/ptjBKX2nL76lDQofbDL0YKbyo/jFcc4ZK6iL7fWeAaQ/jj7R5a81Xacx+TN4e74PCsjHGgHTbgHr28TBjLz0rUBRb+2F0NuDmakfz6/WZef3HOXEcDtDboc16jMsgqEUI95EuCew1bJIim7bMCt+1JRukeemRQGlqulRxEXZ2Riio7S7sFc0TNdhxtjvR0w+7nOIR+Se9v+YcHOfKAggvlsTsPNDGRASklhCfHd3TbqdOruMjFpO0zdYpQfv7B4r5n8IAe7c9drLw8ZwfSFpFblRrqWNZpeQaPQDv712nJZtSIQovjstE95fSziLeK7gka1P6Kia5jD/TSDAg8+g5LDVHpMOy4LVuNvOxUukmdhuJp+HjjwfH14CWLeuHEf6DKbscMrjhp6cFv2EFjrj0eOMFjuUd98TUZZFa/zoHIKijThfBoxILYmd52fBJd7u0tRinDXBPGWSz18V4YGn02t246syrtKIkmJrcgR6XUzliKbICqh6j3JhdfY6ELG34wYRBTHvTJOfBIEl8PmAXpUWOqqHWhqI3PWj5JYfixyL3Bc2QejDph4Fh5eQIq4guCvd6J5M5LlzhM/2jUiO3uklxPXEwConnPLEJQfb5xftvn5pHzC/fvXcvQ/B/vivwlvjc52EMiAjrjOuKurfgVM2Hh1BgbnWmW6UbcTO2Kcen2qxwRuzsWtn8CmUJpO3XGgy3ZLItO9kj87dv27zwyr3J8nADYqIXE+YQyMxv2fwz3WklKl7tRsfb2YTs2dsfZ3z043z+PloCOzDxY+OSxrX20cJB/VvB3ejJbXL/hiTOwxTXQ1AcIUStprvDYbmUwFv3UNEw33zaCzQxV4mW1yH7wzWjITX1DHHa1xFhSHc/8ZuTvPrv+r5EkREVzEBdWwzGD8It60uKi0CIAe5d9ceJrjuqJQFcyjVx0tiTGVp+q5DdYXOKthKG+aK7AP0NaM1ZOq9kBwWjTRxjos6whlqoJxTjKJU90ypSEgtLKeZYzQ4aR/ceP+ueNNddxKhJkC0x+GH8aBmb1M4YwrYs50HD8SkMuIFZrcK1HHiLaRhxH/BFxDJdIHB4XdH5BJ/H9KxIIW1TT92wMhJTnNr5hV07/eAbUsQx0tAEaeWk4PtVBl6i1Kjs+Ey346/Cb0xWhoxup9LBUdN/QxyEcOtQVp88SYVBbDRNbHlRxOm8cu5sEwe4PUaP4tScn+1BizieqQ85Va1m6g20p2bvamEqqedbXHXfvAZjm85w8VoI4PdETPFRei1GSeUa4WjlKU0gHJSP9oJPCmLssRstYo4u0Acq3q7gZVZ9o/6IYTX198p5JfQV+qzRLxrfFfP8rrzCaGgnTYGBcuh5LtMggSQtSdISv8500UqSouhOSFvhuKAALlVzRJzpmVcz2O+a/Oc7lBA1X3fem6jyYG3ELCqXN13PY1SHd1zol5Cq7Y63k0tGV5Px5Z0zLyYcZSxoQe9KYNgPKRP75IYvFvrrciiFIegE9kiNPWO/HKWmF2clutebwb9pXft9hevi4F5pGwpoBxVA4FZwmwMv0IbBEXGxFP5lIAfinZ9fG+RQwg4MtWYFdUD/C8MLTjCQuzVjy4Aeokzs/C",
},18402,1328,2281525583,2320974128},
[11] = {{
"qdJcNWbUT7kchUxvLhlwNsPqlIRoMUOtkgFMmaHn1C2wq8w5sZMpBQkJqdgjWGhceQJTs9xgJaHUA1Xq9sDqhFYwTATZRpaiaJR6G6sGCENeKix4jr/uQWYtAQrQJ1EWe0F0MS74tCturW+stO213lwxFg6dwguaYiyi5f2M5WLoezjsTc9i9BgHA2n4s9P+YqG23eF+HvKb9gNvWp46z8rVuTFciQjAnkMDwEnJIUwaIv6dMJYSz45b+gSpHi53EpG3xRiS+okOT7saIwppUwZ3ETFXss9c33U3ONdKuZ/YNCvERyYcNuG1VdUiFkT33LBf1WBDTTWVoRxsG/VlgG+vaHmektZD3v4uEnpJwaOTLd0UtjDoZoZFbwtR618yMR/OOI4STO8TCHazg3",
},17095,301,457276120,1096125564},
[29] = {{
"UDzbfysbYS395DEkrDjfPDNrYMJINOF2wFTEg9IigkrD+Ff+iuVFg3",
},25531,40,3027110699,3919803172},
[16] = {{
"2zkJ/C5L9M355g5p5U3FIuoNbDXwxO68Q61zUVCki22RVP92rPUYqmovcdzfu88wOvtCCJxrBfGOU5gnux5aPSDZWfZhsMdFOSyQFUpRnSxM0vZcESEbBV8UBV5tFXE1RiUHUMxGzn0p3VkXAF+M+l8OUgiU9AfUThwQSHUbFFIgzs3X0EFhocHLzkRNUJwTMpYjGliFlCL0sAueP0S/php7iyWdKZ+NETjSYBu6+lkzFFzZ2vKuWQXYpX2WFVloqaDA0SZBDqc3rlkv3igB8uDv67PLlx2WA5P+GGsVyzhq8K3",
},41483,227,2527026370,150097099},
[43] = {{
"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",
},21655,2241,2487809339,1318597782},
[4] = {{
"cu8SXkLGUQFQW/uo/Ne3EJVS8WKf02mkSWf0pEraVM6iMcFamrNfp25S07x0w8v7VfJ/MCdW+qIKnfeLRgFFhzyl57pJEG6QTLNVdpzpZN8ahtA3sV68b1hWcfT4+65R6X2JqLbtpXH8T+49Dsxy5OlFkG71uyCoAQwuLCIyb+3L4qctPkASLVTnNhVCDVvbAPWi02WrrmbdtbeqzQfSlkCaw/QnI6PnYySkeXlkHwM916H+LuUNQKiCreVvmnpz9MSHPsCKa+zDtcE38pEa5RbFE96UwgeWNyCJ/h0VqW2G7NnPPY46ZUTdGjwjFwgmBiH",
},25207,242,1228431301,526331683},
[2] = {{
"/yrjYT52E5Az1ne88y92UlXsXxAxigdnRU9HGBCVsoHNB9AOg6WdgmB0Knvb9TUzeDACKAaj41BtSBQhEUYfjTwST7I7pm57y3Yr13x56FVmfaC8LZ8YtKo7wxLnKqkG+rECPafMz5HulQsjhZWKxtTiMvURRaVMBSKepA2xCo3fiUkfhXIkwtWG6dXJOHL1ijwZqqbfzPsWBQypNgMVqErk9MQr3hNMqc0/9unyutaIbcvLETj64A8HwGyS8r5jcvpwJMMPlMkKWi2dQsNTIYT7UQIMpoGbBVPtslsQq7kzcTBlZRG2cgejNxwTDtv0bvw5CwIlhd5Lat6C98X3+0H",
},64337,257,2445570963,4254329456},
[42] = {{
"2W1spBwAwznzywX6L0tzWLHJ87PpjDBit4fnMWW48geNf4kAPgYTV9X7UR1CQ+V4ZCUBFrkUglDcyAJ+kHdNerrM6ZilpvrKzRXv40IWSs89kjxckD0ZcakcPubyZEbrL44xnN1uUhOBOGVZTL0JoKMeUuS/n1AlhgzFFaSX5xLhA649PONZxGkRPAF+0Pm1ek1WNyBfvI8kCKLDVrVzIpxOoogLJmuZ7xqjnbLDX7WSW1MMLubCA7EYfQ34JKmMc65UcQO7mJ7H3V5Lr7HONUg8h5fo9CHGXSezJUEa1ZWJg+XVroCSe7yOn8bvWHn97/sV1x3+zbogSqlWGTr3F+oZXE9mMYTdhUnXEHfd1HXIqFCj9+IxCCVpCv38NWa/0QV6J+BR/WOzj/nXgEpZA5QT95yS7peZGkkL7mlSqtaL52uc5qLBChlYJNtQaHrjobAqrv0Nek2VKIRi5VV/r+tL6t4rWbuEhMIT39UOEghE3h6t67O85v2CPpk19AoBiKul+OZ+laFskogifikRKx9qlvmGO/3kulxbbbG6gmVaP19oKySKLjeqK06G1CEFogH9/EzxHY8lYUhkg1oXRNLDUuiGFBJYIR9JsC8PDPMHiHIilt9OU5Ss7u7sZX46k8ONiTuo/xjWLE2wj8iINN9j/ias5SOGUqY5gyPPvVIO1/VNbxc+3lOSdJpHnkRNignRmxxcrpgbqQPUIsRVayM2gjn+egxKs8Y7p8/Gg0Y6U8plXebJXEFg+ZrYjO5J/HFGT6PipU6V3ZEnZH89xHTUPaTzFWobVeQYF10wwv7GJQ7mvAwichqnrSHgLnAsAE2GxO70zUUlSOe0nNgvlPhusIo5WNGLf48oxAFaHY7NkgJkscKkfWaUz2649u0gOgAczoR3MS9m1iiQGX/rj4NB5kLbJc9CPk7eglwmcVZp06DopIdeeXR4oWVGhIecokiUqVRwzausoLameXDGm8T2I1kO/3AFB8Gz7SHLMhDXn38dwtSYn4LvL96pNgexyEsS/RjN21/Ev+fM3K/97pPBIG20f4MTver2h0kK6NbDvj25YcrdTkhj66TyAdElHDXm2VqVgCMeF03WLt//8bdDzWC3792gv8O2oB86w2NsEhX652FzFSsEOtFl0xZucrvcwnSbmLQskG3Cx6wH4deEVJtcZL53YU1GEdzQK7BPEqfcJUWKuqljlnGt5feRokd6cjiVGsGYuCQj6s8zNsNk8LgXoSs05YyeSmcOU3yu9+145BKVGW0FFyV+uiLtleeaOHtxrFsIkN5jXRrNKq/aVX1FXE7wG8HAbJyMCRfLGCyGMOVlnRZrnu9/dNj8BTJjcY/swAlyj/6IqVSaUCzHg0jGi7gtH+/rsKOqh0ezf3jpPOBW4kXCtxwOSDtIzFFvliph0Vpc66EW7h20RhqqRE7p1xZm/2fa4UDXxHGd842guhloNi2zxPNdt5+bK1e4sdvAuzYrk2WIGXOcrN+9qFZuIuuQ/m8guExNIaNbwlbklsItrAKHWvrsG+PFnqrcTElSwmOB93Wm83gax8K/tfH+c46wf46SXlSBnyzskVModBzkzQ0N83hhXJHohinZAJ1WVLkynRPDEhfytkul9DbeDmmlX1FzsMC1uSkdOVc9/hRh8P2eUPBdYutfgUaKw3xiKGAnrHyK/7wdhLBjQ45L3Blbt7xTrijKD3tVOp71GLD5EuoiNc/ebIwWYMTsk8Y02DKKk9XLzMZ6u6TvhzrvQT3xHtovJIzoo4Dr1Ycmdho1IVHfLAc7KD4ESxfSqhg0I54XkMmJ06bSGQdL05sor2Bqi7tOgw4cEL5SJhEOwwFoFe4N2OeuBssZSryWyQpjz6pa4PTbDqqS+MkjiRoMHzpHw5GUu5Bo80gZ7/71rQHrlIpx9zdcS6EUxTtUB/fHqXwkocSH5+quq5/T16ApVYbYeEKWGsaSQt/NunGo8IgAgvoD6VR+Qa36OHBFj9v4Uj4rb3",
},26517,1498,2744169035,2522886808},
[47] = {{
"zddtm5yehPcgeSmjTM3shB/+9pF/Q19sHHxCRqyIzjVpZLK6HXl6NeuBbh3lZS2L4EYHU4aaqnw+KS4svqOG110eO5d7fNd",
},32653,71,2481855319,69503687},
[25] = {{
"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",
},27659,1696,1282794973,1915377607},
[20] = {{
"QD+GyjItrKzctPuP4s",
},11759,13,108593659,1860264621},
[15] = {{
"Z/DK75KFjhRfKMEvLnhUOB5KW0ELtmrISw8xyHrF7efplne4OXyMI9IqaMpkL4GGRAMVXdNxtuNQTwu32OVdDIkPuEGHitj5bluTbhM1IvTx/znnPfwrpDR5Dc/Gp5i/9/zvzqrmh13FFf6TpJaeiSkxL6CQ+aDnFg97IpsT+y0vwuwwmCB1f17l5A7F1wYR42R+v6svSZ1GNjPmP8NdQA8X0mjZk7ZJ4mXCy8M8uUJGHQNkrNa9Zob/NjZbagS3PUUAjYg887Z5TNVVECCTIOdtFYmrU4a+opvZhXE/HESOeshJly4MlwpriHhMYEH0muvdBIfuGUbzF/2scT3tAHybT1brzRE66D86a1QjEB4rwWrQhx8O+R4/35KRTXx+T538OiFX8jAm340N72Mu5zujxYzNB/7cwj0FSoJbhgM2Jn1A0ckoKn2UKl/z6UBnA2rE5tR384ee3IM4mBA0kyCicoTRKLUOyVdJmNrG81LGTT6dCAtPPWQnYkV56JAS+lRBu78ubqYnpH9mIHr0qYJcbpZBDOrdSstQBlQuGSUzNXf7rGorDwMLWTm6",
},29131,429,436712730,946539862},
[6] = {{
"NEYqW44OLcO4Y1CEcTvDEg/YKNZluJaysseLAslQds2HifzKSMnnV4WWxSMork+hWuGQ2hFzV3RVbsk8Ah2zXe28UWJLS+nV+1iRjpYwEkZWpCeNb4qym5u6oGdSvNnwNd3vUGJweTuqFobP6ZNQd5RGX0EZ0eVQ6IQ9KIEKCogs094efEHuYcDb4+2v0KuO8RG9+St9mS2fijMauyfzauOaD7i6Au7O26gSF5VOyDMhiQO7tkHatdHTjwsziKx8qPMUCxQQeY79bcynGMK88xffspDGqmD5XrsRvmw8TSrDVpzQ9SsoyI3EO3X6MatVC0cAPRceFUfJr0OgV6Fl9dH+qmmk8M79XnokmS5wigmykr2ensUfxuadMVdJMeIW/xTbyaN27665a9wU+98+9xJGjMYxarRVY6dyRj6schcD76RkK7wT+P5hIa4HZWf2GssyWa05j6MwS5y+hYoxBwJVvTMVFzKtwbqx5s",
},47257,364,1434225133,4185851560},
[50] = {{
"5SB87g5Wm1Cmeo4hPgcfzdxEfkA2685DD3Kd92o2Kwc+Aj7pim15jbOIl5ZvN1xK+q3V82HvE+0/RQuS/+zwkFJHzbh5bK+jKI97QRhb7r2ZNd4Huzt6GZZwZiKWEuKH8NyJEHwCtiVoqX89b4kXX9xDJhN/UOEiETujhMhNPdUCFOOFG0bUTV/XW4qTi2FT+fWBCgqpe/50eJwnTqU0xoix+9vjuui0bq01950H3u9KRbiyhBmnHF1VLR/NRd1Cr/QvSn5ZURt9vp2iDd/zei5aX8UW5seC5NpOvwbQJOd/hLvkhcpZAfz9+4SHqEYb22PqNaATXbM8qNrtctg2D25TnVIsCN2yhWLv6hVcWsLhRH7vNO/SwZdOC/2YyzwfSgavmMfURkA4mz2h9M5MqK9BwgtQCVLByILc+c4mTaVz4ZUxyT+EKU/rMlAj+Z7TcELwwEx1Dic4i/cIrBBfC6KnpuyIbkl/T1iFb5lyaQNWu+CuQgW9hUuZiECDb47y0TO4fVFNNwHJFuKy4hbMfNNaE37XhArrZftDu/5YRjBUnyGRosAjkXaEzMO6JDHrl4b51QSvePTFq/Pc2Jc3EhfNVqgD5b5CVjRFBSNAfSFmhIwplftyZofhSeJph3",
},41085,478,322489231,935948925},
[51] = {{
"sWHMRXYrLqf4o5ymwltKWCno7ECL35xkRbPURzktf6wLCr6Q5h/TLJOW4SlCphxrB7S7oLHe5ot5REE/Ah2/OH3O4Z2DUPnfXTgm3+v8epSGU1fFNr7qH0+lukrp8qYcxnt0yb+FgHF58JSrhxw5BuiUnTN5RuNUrJJZdxkLW6tfIHwrcjQK7kVbwT9mOP0RxGPBjUCX8W/rOCFP+M0oUw2tLKXS9IKpgQ68tbEK65w/GlKxjp61snNhkyZ6DoatZrJERggQN/xaw+RhtqIIbXTFq+ZM/FbR8PMLIN7qSxWDi+Yd4SdqmWmC9ntpx6BWY8JC5P79KIRM6VuY4dirliHiRvtxrRl40ckKr6t+PnjrwayrcdHWzUXbnKUnc2Q+ESV7PfpyuQTHU3GcHqWeIwaIGb9CLc0Z+m82MnJegxP96qgsJaiFZRxPBQIDO+zM1LxnYpw8gRG1YH4gC9ihRfKkaaVjYRjJfCe0im9qDphUpzCAONIUlYNsY4rZMfLpRM+Uy7NqGBIF6MGrcVMOhtib4XyRxwXR2lh6XHYVCWkqFkJHHcxO0q4h4ZiKDRT10OoSYovc33c0W7ENPuJDe33ko6RsZSmnCfk/9v9M6GP24o4fZWnnyY8InGrcAHlw5GOAnjQJuunOHzkdDYlSoN5jwTxT0iUdLv1KLTOR3qH79Pfbcpy6/5E6zC1oWXHDZSQMHf0wko4sh9UfrPLTzdMO1lNQ3wGQD+MAp+JOGRzbLcIAGfW9KQIzjB4I91gT0PkNV5L8ynK1qKReanee4T1pvXJLJpJuWOvVzuKq6f4JN3UH6DWwcT8A60HrNtHy4Jmj5K0MBS+pLTz4590Us+ONrhbPancNjl6rNPEXqDBX/1Am4rTZaDYvLDH5kf2/rJGm2eB/Vunlv86zd4YddCLR2eabH4yiaapTBhIIUxnRI3EpYcxSxJe9me8TW9nrsCe6ATa7pZeuuNuk6NirrGWMvMaHSB65WaMQVtwgX0zAEmgtHGsC8R48/hGKyKz9O3",
},39603,769,1877105284,763824280},
[22] = {{
"QhsHrUXllsDrPi1X+HrDmfAXJc46NUIbnbt8pWJMMGM8Lmyqfy4Q+6AlE4176L87o9OHBhzrjV7XdjbvYpGeM/ayYTe8ZDaK6F8OLgJ8DHXNay+cvCfQLntVaPsJ4nLqxvVYCmReORb2OAQU7GPqOraLGpTHYKiYz09AlgXmWpLAq0KITkBbcefYPyGl8kfMjRbwqBK6kCx5N+yFrUo9stw73yMj4T6L+PaB4IZVjWynitTHatQf2N6ITzn7s1Pw6wbn2KntvSmCe5QoTqAHnu7EXdXrbzHRkTYbPrY+YRpODJakGXHGFhl9uNnHTiNlms7hu6DD9iSxsCYaC72YNavbvdcK78cKS718ba3xsdV5B+AfvJ5oooU1oLVtho4N3CN8lJV1fbeeAd2Epi7yaIZL4k1m7RoDsJ1EBybYKhfWMgZRO4u8HTSJo9+XvitBIPBR2E9JAi6yUvCJLmYe0W/FT7RIJ7GkX74/HXSBLat1N74nwnnxjdqvXPKWgPFAkyujl4PdxlEfO8KDY8GopLoHeNTL//f7Fp+cKERmjlMQMEpsA5oyj5dOd2UvhB2VZgVrHZoh1Rlgl/gNXmg27kVV/Romu+v04Jve1RlHLDyRvskrk5euR4FJ230CqYcxq0Z3",
},11184,483,3336754109,1443709003},
[3] = {{
"4thky7wgyUVOttR0ujKYnSzKlgxz6zcYwk80kqfBwUg1Bbb8rFhAUYGozfiJfReIOS1lgvD2hSDsXAAexi8444STc10m9TWltOjVyoF7fRaxQFvyWh6mDwZGFYz4M6Z7OcxkjwNwMB3EuycexIpBFvdOPs+yhkOGMLfmwMy3sLlXzmhRy9cbKTY5Gb49AAqzqL1LP8a4IQBFFZDLJ2psouPSwBw7iE9PQS9WrOOe48Nx6m5oZnxTzK2vQRuE/0+sfRG/B3rBes2vnxpuRzM3Ca+9u6pFPVN6dgyuegVHtBQl2Rgi8Aec57gm4RG1CIDLZeYU7o7e3KtpuoL+2/gonQh6MpdzUpsQ03+69NGTvghL+MWZqv53fhnrKuaVx9jIS9gb9oa+/Yak7wh25I6wLoiz87ZgwyIGJtLzoMMAKQaKPF6RrB6Ui3",
},19521,328,3613165609,3965322081},
[9] = {{
"dbuMukvNinwvhf5V62DpzQpZJ4Zud84KAqpfUWiyzoDb49GNKKMnuyPSbgm6FoCUXCCKkoQQODR+rmqk3bTRMjgKkXNOQrg3dyTwze7uQezckwYyHIGuBUU+0rTnrUo0rI0TSFBZDbZq0cGdqGkUlIMMxkzWSmPbtI6s6RmHXAdsfehmVi84ztIpk4byKIXQFKpOVPpoinqCbi2s7n4YaobDqmseMccmcCLzKwY6SDmTNIvnaQ+Cah/wBRJtWz9lA/iZ1x7egZWSBRrXybIUJnajfnf24WPzZ7EUvJbKIhV8UKpBTpVFa3CLNCzBkOth6mzCIcUhXVuUyWHzS3zDKqmrpJwkP+csWu2c1QzoGz6nlrrA2Np3H1olwnqX15A3KnH505aJm4ZTAtVwo/0tKbbRMSvSm9vAdMWw7NnovLRaQHdA4EcoQWNj+B3CSX06mllf67lfpnVts7uzNu5ES8z3WEDr/pJ9W34MtGA4KR/woepOkWvCxuNNrd7H+LQk9E8r6nbaGs8B200xM4/E9wsw2Lavko5LBZ00sFZcpmCpyR4sVvEx8gIwNINxVIw7NFRo9QjS7y+m9kZdjtjz0j+at7GX8oAqFNAFkp3CTIqEdPMtMoaGG0UmeVHu9MrTtXZwax9qMGDjLTrldoXu5Ns4Pro0U1bNKx0yCT+UJIcLubISILxA8qMMoAPxwpElIeZbVQli0Txfq9uou5dnxnERwPmDBvpdJ8lHlr1YIycb9XL7+7oz4xt8zMKpDRSsd/d2TV7Pdip8PIbUbcWT42Rsbs32mXOvJdlndQEd/yn4X1sR8pUJuFdHfXBG7NPHyjZRo4nTKb2i7afyl0xDPSiL6pScljbUyrMss52oKxJdBOTDx/t8hRYHa1zsOj48lsLqLX0nebd0YyUTBWuVYnARP+5+eTLNV+zYbThVGlTt3msca6ONSrRv5xMCKRXQHiZ8SkZeEdDZ9U8MLK7g/fjRlS7mYrv5qyNR+P/k7d1uS0g4WKAc9sOFdISZiV7G5yNThxTBkm7LSkYo983UjJk7QfGDXrw8ckCyNmFIVHaPgJRbTHJIZCqDdLL9bEzvt0ckCkFFQsPlvQSxqaw0M7pb23OT1L3cRrEbuT6bBm/jjbv8dYYXOxWNqczocCByQSyaa/J+6pm5dYngrD+XVX56hTtwu/0u1aes3wrKmxoJ51OIDJA4qEpZpBDmYsfnWIsz9t3Hx+9ePRlr3+wBEnsPehesIfa7ARyQP6VssiXS3kVyyK/h70tddD3Gp3TkInNSeHBNrrAgnNPOuWpa6CqcsC",
},47295,979,3760628490,4209631971},
[31] = {{
"4/XvPCcPQTMT5Cb2Sd3qPGfWGUiixoYGCph/9iR/8jZIrikEwh6bAr/Jnadn3UPKS2uiMOHQVgN1gg2WpliQYFZoSyQ2fYVBeDpkmJgN3LB216i0URhVutTr3LGnLI4wpwUiCBv5/Nse4nalMKaHswLayl5j4VErxADSysTotQnMT2hDQtLxGrxbkaGnw0vp9rNdtvvRXHSfaftvSfATmeHn4ILrxTHmMvGCVtfEDm0IdrcvUjy6WVdLx3f4VTUKFyKKv9nph2l0ZtD0ELYbZAjv+msKEjpeSKGOHmuKUIZBfRs7c+KBp+R/HY9MohY0ma9x8A4gRNE4bZgt+6ULwtcVasFuQc7eIPFcE0Z515YZZNgIY4cQ2H5Buu2hrgRk2/JW9ivAGmi0YWbAsmOJr4szb0xV8mNWstVkkejT3D2Gr74DbbZAu7RfmE6YF9Mb1u9daSYpq+gi8AQ+2B5c+tpRVaRyn4kUiitzMIWgO9U92IX/izQ8Xg+fiw8ZTazkX0UfpPEnRGSVA53KbzGyhTPlnbxsRR3dJsTQMcZdSYnDxxvm545G9bzBNJ2tBo8QlehnxZiVgzFet4mat8WudqqasMsfXzmJ33",
},13738,457,1904657552,2227663787},
[35] = {{
"7behNoxZ0znqFSdWSzwLNrXweAA0C9uBwPEx/lm6xBwAVVM7z+B6vvPpBAQqJpO2KONMhCccbXkrO6Lnzq3r0V38IFy6LnR5zP7k0T8VwhyIWRbM8HZuZjqlgYsDtW+JgADfWIoLw66",
},55599,104,207235104,1809694548},
[46] = {{
"tzec2EPXXH7ckHWrpa9YUUWZTcgpBYLoriqGw5ETJqXLJOLta3aQ7F0M0+7nYySJ54oxxVyLcEnF29VVPrvtHYYyo/bOynmHic9KpuMmH3",
},21007,79,939990721,2205308190},
[33] = {{
"yTAMRbKwvBMQ6Cgj81z1+Uhuf9e4Eupa3UUBL7DsHD1wiIbQ/DI0IcaCcjGs4LrXVLEL4dWpHRMkbBNPP8xiJ5A1/RkMaBh/aDBC2z+ub7d8ZFmrfQM7tE00Req6YeiBVdh+0NIzb5M4h5QyUQoyiR+tfP7Gjuhc5mqssa/s7hd/OqFGIOCXSBV7pzXQnFCHof24hQLz",
},51867,150,1098463496,793893599},
[37] = {{
"yFQXi75SEK3pB4JXeFzEzG0/YwEqu8BmMCwMhVKQ3zcqltPFHPCniBvFNyUk4yKXNerYbM+Gnr2mvE+jYf6R5WwKic+oE5zw21NHK/CwBHUKfEfSxD23lF6sIfrZ4wYL4UbwlzT+t+5OeSFQ+kS7cJ+8UoG9vG+hswCiaX22rOm8nsiQKWU2nL/T2ilboKLIZ6eb0pPjfpORfb7Sa8BBIxFNuN3ra2LXq4RgWiKY9a4qPSFpGzNcEhmoFxM88U4G6YB77upncRAu3TW/uHatr9l9F4HeIQ2916EJkbj4O/vBXIiQROHWTP4rwz7jjbbgQVUkPrvpaXxtBMLH+KgZhPdq1rGk5h+3a5bAc13x7q9ucC7s0m3Ne11y6jfIRMqJJvWzX4RrLa+TvVcEWMsUNS5hFHGhBQq3cmXMnsh9P8VGsfLlkCtVS7dGahb756JZ2AsKQCwuP/s3tXuELd7cEvkaRbSx2Zh3RGNjvUifRzugcXXrVKaVUGY6esteTQPdffnj0/HfZcuSFLDxk3c+DMVLmVKXWHIXVR1Q0yk4obXbTsVnZIX56FBlsLOV2Z+RVGXveWnomp8HBCOXs0qj7AbemvoTwd+RSLh90T4va5R1kw71eqTfo4SkLTaDeOMn7cTowTmr8/XzAeVsKv0gylyL6UzT+0UIYRrklGUISQmeZ5rcIZoITz/yNq8VgJHNOZz76C/EpZ5cp7YE7SgyaQNLQspboMbdD4vonUZn9WwoksMHWbOf7tC8ce6/l7SfnZ4x8CczvCT3y6gj+D8r9DZ2WYckG5GZ034OkG8yEUp/TNvAhjLIE4jLiiGuTq5wlky6aN+N5j8f+yh6NfunRrmtCxq20BBnQJGw+LycTMzE98M2ZRZNk6ulzGakKQVlXG1G8/Ndrahk6HHtDqXeYKGR7XHLA+mvw9TtNcs0ynERkOnznAd3oXq8d+l/m5WdJlxw84aiJLsmaP5NLEPvsZN4qH9fRaXI6LePj1atUJRpTipHaA7NS2VZu5c6JrDCs+Gu8JZBbl3pGMOiWcVej1LdyyJPsQnL2+ATbEsmI5rOyFaDvgvsodxbxhEkP+QxQ+T7WsLqhnynY1nAc/EFo4ni4IrBDmJmRa6pjJUusDOwfXJF1xUSwxsN2F83IsMNucduOavKsbcXho1rf7fT7BxToxRuYtakrWjpfxY1Nzayh67cuY7x+hJVgzBfaTeoGfGBwJcWWKl/kUaSOuIlTw2lN3dkyoG/JPB2aWt9dAKYuyZiZBDt4leNlvfdJZaUW3sjbys+3mIB6/vlya1c89JLadjS7oTYvuFRerdz46mGFgoLz3EgNNwOSwRJyW6LXdQL+b7",
},2507,1013,3437013623,3911754900},
[52] = {{
"9mTzP+LE9elZ3kLBnKSY/XW3u11YEgjfvbPJf02h3D9C1YslnBZtwswNBzitV70YdPA0Bn42qjG6GuzryAOe3Ugpflls/YDK62YZDwJtBHSW77QEn3g3zjVtD5nxGHgIy7ZWFzEZyE4f7BXrV03AgbEhUNBbO+T71wXs9/vA5Y68QPJAZ/pxZlH3GeOaC5zIp5saGOw/c4YE4GLMKSglhwgwXnA2sdB3GpVmtBre1ygSfJ0Q/EPJGRCa4BzRsBUf7OjnNELF+fzDZr8HQgWZmI+xmojD6MtvVPNnowEoD7My1piskUEC/eGc7/Lsv9zagwNbmOz6qlnwOF55dZd3tm8Uiaxm",
},11020,261,2271831899,4201449391},
[19] = {{
"yEfETrDwxGjyNI+hamkfwUEYt0djMWSa/S4BDqVerzqK2V6oTL7t/i+iBPmhXmN2iI7gyol1NjfoNAxJbCjW8ZavQXYff6+sFSq",
},19831,74,2296193172,1664782239},
[39] = {{
"hLpAnbX9LhY0itp80nakGsczqtlpwy9xp16iCLDsAF6TdWW3IQFbPZJN3H17goOHMzGJJA9YjcMlHz+T2odXLg1gpKYW2LrFZbvq5Zgoa6MSPgpYob/rJJjgcP2qnIJLoVEBTiCiawIvQI1Ay5GNweoB/WdmfS6n7O+BakKsz5S/g4XrpXLjeDcXOYr7AT8CscPvpCK1p6lBvfbOpoXdiX97gnnXgHrFUi4Rt0iW5FVnzKOIHUPBeWK5IJ/imROMami5RUMR8Oa+ZI6+Fn+AVaEKjSIP7dijq19tkmfzVS9ZHsFh5nQ+HKm6t7ORjTQAJMptseLYFxC6ntPgcs6V+jevdgQ1e0/Yjv6P8Z8N24CICtSyHwB9F5GZ+0aIOBipORYvDBimjvifGFfzRAcRdXuWJZ2o138CRzMTPu8jZHBmTwLvUItpIHdAkgSJ/ZxpnWeeCitQx9q8afbnGC/uJsFjsdcefOEz7ejv8TLoEI4umPybesyVs7tNUu9UBLYpVoR/Ma6n/whh9vYPabevElW3MaChm1LGJYLanxzu6A7aAefcItoyGQVli3elsaeHQ09xzDVsB9w1MtliN0JNqjYINqMcBB/T/Iyb6K4ye3nwMsx8fNCtmrFywMlcoaKtPCVY6Wrgqv0/vICuTFhnch3lRAlqM86/BTP+ZLo7NUMCmy7sNCPmzA3Wnrq0D2s8K4MVKDYXL6/fWvrBl2bnx3z6H/rxhpFDyoi6Q3YLbevsEElXQ6n0hBTX5jGCIUUCItRGNHTMdVc4h9tCLf7+8CnIgbJlNyxK7pyDY8PnB4+d4CxUNhQ9c2z4kfWqSifjXpXK19zXWzPGE4BomfqvB0VBXvV0DnwWmLXLuycyjL+UHVM+AqMZkFPjUlJfwYgqJKh5rfczVu8wWXMqyoFOTF9bcqEDXupaaD8n0u/ofFoixX/ljN049UtTRFDv1cXMB+Tslv3KoitcL2xEY39R7ZUSn7DuqEGI8563iapqdmEXqukosR3k7KyiqoI8ESxaa74F7zTkvn6rlqGh/GPWd7fx2daU97z0TdQaNTq",
},33798,797,3851117600,3946803905},
[17] = {{
"8gmacIx5QUMplgrdLBEQWGeO/7pzTEzmNI0PgyTCnWyQTcN1G/37hWL2ppr+sWCy9h4XsIuxHpTjeeAPzdNSX23EziveMFbhy8AryYtIQ4beya2b4hRPHGt6VbIaPno1gMMcEOJ5VmVADrb",
},15050,107,704062691,248913992},
[23] = {{
"Kez6EXEyXsPa1WtFuTkBBpb0t+OCt/5p4RBM4MB4xQc6E2W0QqTPhaA+mNEyEDPUsJkVzzxYU8U3WOpTY2AlbNMLQXoeuRlJb67gtTIobTzwmjLLvZ36Z5s4U5oGBdPKj2Kd5OoLCBS5Tb5yeVIGp9laKLHqZ1TqEbe8KGiLgkf5UitWM0zR5xDDmi3cIGc3+YJwq+T1Y/OoBcDLvyRQGF1IafeAl5YE9IK6g73oi6ugQN+r7GLDfiKk5sIVGz1utz74uZIk/ZYnIv+idaNRkUZS0ylHIMYRq/rm/IEPHdVMcDIvP1kwRbqqCsyReV1XzgxxgL4tToi0yXE7wLzCKoRILBSTaUDLEOD7dVQVOuI23NghTf+F850Qw/9eiqcofjK+WyQDOepWsOTEAa94UyYjOQosJM91RTvGEBU4jiPIE4L713Us6XQV6/K0g7RXhODUBz1ERw0TeY5D2ipQVd",
},64100,352,1142592041,1343797908},
[1] = {{
"O947QHcaDd4g5VHGvcslq0Kw4WqnOoIEwuc7XL/IB9q9r1MDCUTtHNyHlK5jZUpZXsVayY+VPUMfD0fzCofsnUsHA2dcOVBrlgC",
},43462,74,2241928105,3777166017},
[48] = {{
"K7DVpgrPeV6T7dkwNdtCOcY1102siHFe1nlTSV0g3BY/sz7KiemEGIGd9cEFtoNZFWAzi1uVgdV34ZEsM/M5Bu/bHVq8IHHaL8UkOFKruhCGydlU6BOrAqwNwxFY/gGUNEuUIJKApLqiFY29gR145EkFuv6GisAw85bRm9CZ13PiRcjP21DdFFPq0ZzhwTFymk9fx4nIM+mEBbD/iRl8rlNNDXcmf8z3O9FeytMvUeA3wjWL+AKUeBMOec7HjWYr8WluADMQHEv5kK2eqgKntAI8k78CITXLhC43cfp5sTAIFDwW0ANyoXhspwzHvtzq4dCl+HkrPAH+o2QtYNxhuCnJjXGWjcPL74VgJC6SDqf2EG1srf4/cVg7rdHD6oZqfbYUEteubp5Fmlz0+fluNZEpQzR+g8OCP5++N8MP26xTIL1vbuxyfMQw4rRENCOSGocDfzhK5Sd6uhBUJ1WfZBVI7HCXjUWE/FaDBJaOgKxeYkAmfdoBPprOcnzu/hLKeRBPYiBEhyZbZ5ACkv5nr+l2lqoU4Soh+nfbt1jUCmgrdDhDfzCYbOz1/40i09K6Ays3aTYBuVZtnVfNTvB/rK7+qzRW/FN/YDveAMFki+56X7h0GBiVeoVQw2yLAnz/RQ9aJEoGlT1tnv12z9MP+0+fSx1bw8026J97IG4tl1PkpIi4R0ov8uJNSQtp7SDVnZNBLkbKPvN7Hfum0mN5eyz+meHL7v0M4j1X8ko9drzpMiZZkMCkpTcwVcKgHyKIcU/0qkFyQq8HH8sLLqvtVL1poW5dyms8jmVt0AFmSgy+//ccr4JmnX0W9AuQosiHDA38ScEqqS6zjxqrDbhmVTKenTocaJkCIcAo1aU7KYJ5dxiv0IG8Pd5aUggceK0KRV1QTPZXKxieZiwJBdPZfY3XN09mo1ANDlFm4ejziIRGaXSkPwno9rFq1/AWpn7/K3QE1fcxjTE4zjOkkzovIfsWlPOMFLxvevh3RThOKkKjq7niehtVfWWsOCdgAcQ4k8r7Q59g8Nyxv3Xoo4xGJBGvOzmx3GHu7VAOJiCLIjV5gk7lUNxNPeLMsJVF8n1pggrro1GRQI8kSQKVcBM4erv8NTCfVUhfb5g0KIQeKN5qR0F2nC5MnQz/LLz0z419gHt0gqzXQxiWx37rsdaLByRDtnc+Jd9DOIZ2vX35ZAv8KLxd7iaIJTS+otlW7wy0F3dRsRZLrMosZGvhQQWNFEbJaEJZAVpSe5NkXThhMH3fjqkbOCQTil4++Ot2nmVBe4+OZ2HUvE4Q7v1cW24UBsDjfBetqpdXXpNYyeBfSnFPFAs",
},3139,995,1787084933,3193239999},
[45] = {{
"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",
},47799,2980,1258901396,2939395883},
[38] = {{
"E1jH5iBESfsLDJqhASiqy3AXKt1Sd6CjPe65+R0yU9VNRTxZKk/mf7qyDwMWvMpA1t7RqMX0gzTPWQSP5Rs7WPfzb+H2Xty0G+P2CWBsiVhY+03OvHd",
},9867,86,619520349,795403106},
[8] = {{
"qfnprYhhGWrtyMhce3wwILLMBxflyD+E+ruLtnLnKySYA1J4iGhQ43jPwEJVb4a9DN3JzfT3g/0r+UA6UYk8nDwuuXuov7Z5y/JTso4Bu/0GFJ5qQVOnztMe9+93a0s6txRrfws9yDeMbbzqTjXVjMLKmzzcYYfbwfVnh3L/hcbmegKqo0au0UVTwLvPpNW6ywCiaocqm2s8Uuwr39BXE/VeYHNUTjkpD8n6fOSCO/tLaH5fWuj1Ta0l1TmLsfmLUbSbqxE/Q4uEniaX2woQd51OWJrk7hnc3lkRNfunGVMguYEx5UNwE8cry0nTTjW4bVzbv456aPYNLx7WAqyV8ckBMMqX5J42xEifal5J71LJircr7E6+bvJkL6reQXqqmSAORxUVI1vv6k2s2bX3zogef21Ht7dPqXQV5MNqBTSIIpm0haRY2SmlR+lREsu4ak6tO3xIIYbte0xeueXIq5geTw/U9PG4kd3kEtk/atoEJ0OIqi/ztrpvugVwVc5cCpjhH06dNjJuAn3YHIlEK+p69Au7Pq006axD+b0f6gHQFyd+tblJ2SvooW+oOJ7VJ2EoxgKTkG3r4IIP",
},52654,444,1479653587,1013019131},
[28] = {{
"EtzUiRQ29YRq57BneSyo0LTw9EkN9SvCECOv6NsDBPqNlE3Ga6KIbBDJ1neL0HQtba+WyZ05VuO3+BAPkqgCz7YiZtNHRsynV56gvx6GbGWiReqRJ/es+YSXBnBa56LKlFPsPLMMH8Ef8/i+thP0aqpkIfP/aghuGBilXBjVEkgUVSbGD0nIxUn+9JXDRYnQkXlC9zVgBdht0bUlj5n+kILfx1EwWuomPvIGnMU0KI+bPJ/OBvcmgfaviS5BcGSlKfpj2sWsF6Xq/K6a+nAN+sTxEqf1332QLM01l09mww6bL0xMDjcO8Oy8QyuEH2LNUV5b/GtPZkhEGpBR4DK05gWFQnA7dU4Wr1ydr9JmNPaxfLC0evH5SDH5DnGszPaoQqXIulFvxcILkvWumAW20JlZganR1mmlK/MFa7N88nWMoE5Ii+viMuylSMEyupmqU01NiPzAfUFsCtuA9MkWlnWVNXwHCfRVgrekQ6IDBvA5bsBJfCv4a9ud+5gjKCzIn9gwyl3FVz4/6yiQm7aVYnjq86hNThTf5A215NPyFnqT/35RorXJZJXJdpOETtJ3eRhnd7w5ZkF446qCar46ry20DLkRVlkaMuf6QZKmt8XzICRdfK6/I2LpJNK+F54SxLxGJS/jdiNEgKru90lWybXWGz3H0rp8erU2vbKw4oW/GqZTOL1UVSG97et9z3srb0661rEi4RYyMTkg/uo13Y+0W1AjuRO9ar5czBJ0Wi+oKD07zWxQdCuBmpwcNBnIJkkOC44G62Vk3U3qUpaDXrkIQebUHLEk80bxp2d1dy3UkfVzHqWT/stIbvjDO8V9PRTlLeGkOcKxDhTffnq1gbgb1ahzbov5J7OXOg4SxMs30OG8O7t49IZDdmwXBGJ54FRKaDXukf46vLclvT9T678Ou0Br6XTQpEg0kGBri4urfBiGuekD9Ne9kvFQWZcF6Q1rsHvXow/1alIlMJrco0RffTBLL5yHn6AUnJCHJrFXsBJeJob3z2euQ0vVY+Z9g7rsQY0b0kZFR2YY6mIdlO/VRYyQHa0H0VRTy/2BNbmc7YZ2W3ACgexNG9T1mJnMjQ7w1knk2YYDXGSOTE3WbYZu8SiyI8+Z2w17UGq9x83rmU06ElrvU+m1MJJM87UDtDwAMTLgPwMnUJAYRXY24SbvMq+AMouA+V7UGiBW39rnGKnJNeQjFnN2WIg1bCnTnvd3wicM41LBCKX4JBRpidHWkjK5cKHumJXQCzGISjNTM1tW3Ift3hp9uAOnC23J3yu2jqlgklF44yXUzoHDE5kAUaYU8D6Ble+O/J56CJwKU0XmvBn8jaP3P/h+xSbIXJRXeRLqMnKVw5CikFVbc0+Xq8NR0xRQ8PIlUWNEEN+GKknAlK1EQ+NUdK+ATSC",
},54167,1055,1662772053,1081737677},
[40] = {{
"vjBPFYzYesWLE64/3uLsOQNjp/WV0gx7zoVmEEv4QvUJVk9ZU2hinYpa67u39XoFnsVtzEraPVTk+7J4x3OVvQfvCkgvB2SXV+HidMkqtma1vVKZThbEMtw2m59X7yO/9fxE6H9YfC6enrMpXCdDcqEZc9IzETCUXMo+7vtg0xsdykRLNs+v3jI6J1SOrOgAB/qKMh6y0oB2e68Y6EH68VFVQXD9xzBoraJWcREaHhU3am0nINZ8brIaADPbEno6d06iDIfUOKDTgkfLOFycxoqwRUDsMENfE1wllD2DB9bcZKbWiG/lMExJ8XPwCcEcpyqmNUOpB4Sie3q5Pe4CKWQV2uJLdFrsLDYCvN6hyjFpu5oOH8yfg9H3lHUYjnMCPXI/fIb2QflRHJMQe2YAIz+XErs5QEJcVldlPI494RTPnCAeVUbzW7tYlLrkaGbiOaKGd99PNXx37Mn90X7EaWNNpJUstMOPjTIJDFyiK9DZHrUTNWDJcANOFPID7oT+L9B6nxV+ugY/Aj0LTZQi0+vYrOITK3",
},52020,406,2487464165,494014361},
[14] = {{
"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",
},13788,1664,3061372740,973863688},
[13] = {{
"JY9+n+3TFDSJhpjR0BiL6b0oDBAT/eFCcvSS9MuUnou0CKmQzfaYfnCKqMAhKzVfDy00bBmPVfrwZ6fzOjA5h2FUzke6Y8t//NsKik0FHsSmv/a1fJnxf4tqy5TWK+Gs6IiJJzsIMIvULp8fL0OHulpuS9bgK+U5Db7PQSn8Y/SAnLol7Ncz+MoXnGSnb1QhBlzo308+Q8zYXQXKf3cTE2nGyExNBPeaYR5HYOOL1q2mvQo4jOAAzqljM5GuNKkd8RU0AV/eHtZ2RLebty4QeWkIWCHmySg9WRN6oYglmc6++giJg7Dj0booq7jCDl7p+KuhDj2mOVmu946g2U9Ot3x51jOnWrzR77oLWZDxogrDqblUEyx3j2Lhs35A0ofdIaH927yN5Pg3ksNQ19l2duxxyUtqzc2XVa3QhWR36nDQFpvd//fhA2R7kJlqgf/YmXjWr4aW86Dm/1WayMQ3iKt59gUtCOMiuR6i9NdE3VIDh+RMQfV06XVB01EeDy6fu/FikHFtqOirN/51fvlz3+RKgj6gkKTtBeaYKFTIWY7EIj6K/j4UDZJf6TzRcNr7rDJG3GADwBBzpHZq6T3sntN41AZmQly/If7WaaWks2fjl7KIH7sML/XEls3St5DzhY3zZloswEj614npoTPG+yNojW4ZaceZgs1BESLgBTa6scgddmv9z7E+Wjz9Z4XVDzraXzeuAL5spQw1oDHwDBu9Kau+wiIBFD2AG6Q5i6YTACUuhWrakcdhPT5FxnMSTz5LK/BrdQl0/I5AOGXoMSznz9U5/GPFZQg2BOyBId/pzcOBHpMEpLziYRQG2dChlMPypxIg1h59YVRRdhpSUy+RNrNs1LKQkyhjTqIvJaf4WLb+7hUTk8LFwYFrLpQqsAjouC3KkH954MvYOcO0E97yf7H3DebR098PD+9e5cmzAJGwlsiXzgyDgbx1iLdVy9KQ1m/WpzQvfwR3MLzKa4nXCDEsbGi62uEhgSNbLZdAwxeEMkcqia2egiFMwGtDz4WZyO2h9/Vi9hfsFcG3RC14ztnf3Tg3WDEEk8j/1EDWlTvzzJqIZVOUb0VY2ZwSR3gjie7Y1+M3j1MVxrgJiNvTqRcwnuFXvCAFmmTpenwfh54mm/fmGfRYLfBu0ohQgm8hrVrYZhEmzxFx6AaYYvSPyzJ0iaKCaWBT9ymTozIJA006tUnBKEefrhpnEPYwQGrBQIJ0dtyF8D7iEZBNXqBSXKfA4LiORgg9WqfLah59wAuIAN/QgYQD3F8LT/jeduTu3KCixM65DF/4OXwxPpm+DB2WWx414oyfLmRYW2QvX7FHviMQzFiOYULRW3",
},13700,1006,2071703475,3417795130},
[24] = {{
"laRRBv7QDSekHlH0n3CryvDahZKCKQ3k3IAocG7Uxf9b9TLjw4PQtlqYj3D7YkfsSPLguR6g/19Nnr2y2FBaCeq5IDxShkHgIyN0Z0PWZJS7Df5k0j71zsCDnzRlZ/+gMa+WXze2V9iP+RzUX3IwaenH8+sfcg1Xe5FY1dmae3dFp2dtV8y+kD9Mn1YGNGnAegR1CYTaSeI6LISvz5VGisqnopAuIBgg6EzXT28LyJjS3UnaT53kCUMKYThsbHYFM+by3C4GQr4aF4Wbok2F8u+aZdO+ROBBfx8bSQQt6TgwpOR92EMcM182ihYJTXyTEmYWwkPdGXtQfn8Z1tN7zFM9m7H267GW4u6NQUPOQiAPb6UBDxrcfpM0biyuQBYifeFi1Z+9VzNSHxK4tXNSDIbkCIY3V9jsJey0ufIRH8DWZPOs5LqjvuyrxTLg3JIahRjp9sYowVitlRE24UiINt9qcfC8ARKpggjvlvKyeDXnGmwQkWJKHDePDE/BMq6R3dGpGRQ8+5VHKEAUEM3cg6xCacWXkkMbFsNo+v4ShV9TORVq2vkdKwXI5s2AR/71Ioq/dASA9jJ5LzXbqL1bONr64SyjGzET7LNheVAOqiz/RLRaPOnSSRL5ch1EJshi4ZDZbagee8yI9TYMfZNjwtwlthJ6RybOiL3IBTTDEahLfa2vETIhjqO0OHXkgyXoAo7k2OM/Q5jJJFaavfDZPA2PaoGojYKM0dV0rGZqnekjVmyxZo/ZToIdXlv2rC",
},50202,574,2641293787,2909839421},
[32] = {{
"1Wud0qYvyAhbc0nXH8Jo1gvQWBotL6/u22K5DJ1w7X/sczdNbQ5AlumyQn55OVh7wzXCliTlQGXiLnzkAQwfnVaDiebWUpASfYOCzl/ITo6gE5c9ljt7qHPZpRQC2cvoej9/ootT+CL2mQswbMspR+FjdiQ3fEfHh5m2d53hNSsSBM22zp6PzMcMPanh/iaqmdxgYF1XxflRTPLfVWZXR+VYP9bnR7XiaQOX8o3pP1fr0k4fQMWbcUiQGm2u/UhSy0RWb4VR2XindgHy+JfjOXpabq1lHmlhtPXVXDwUWNf4kQKFjgZVkd7S0Ztlxd3udt3KponLmne/PqnRnEfmCYvS7HapQC7qjl6R0L93GEsrds+IpsbBaIffJaC6ogWfUamb1Czm7NvN8ecHCSyA97m+UG+KrYQDHMtfDVeN/nVDDM21G62Ik6AcnVbANDEMlSCXcecrqJFoFcTweTVzavJCfdqYc9efJiECVszUJpXxzy0BZywouHg4iO1XWVNoKtWn1TKDWcYoUSfckj2Iey6/Cz/GrDoOHee0e9fPs6N1bdSC+cATJBDCzST58usVLLoZCDW60tkf3hF2v06atLZTnshuVp5f+9ajgAnL2gkboYkC69e8MmP4mANhmqIGqW23F+Qjo+yCs5MZGvLe+WGuBN9/0MkyjTt5/X0aL1Mul7Z6JaY1u48wB81d1tgApECt8WhTvHzDF9YZ+S/rjupdq/y64n8gaDdj4POifR9TVRU37G8/1Wl1yHi2zZmhh/IySJlfV88mPmprFW8Dzkzt5dbvhk56i9ytEVAExQdldA6Y2Qoe3poEHdlViHZppnVg8C",
},24993,628,2075203203,840708587},
[18] = {{
"R8Hdxl9K9I8J8KtpGc/jk2+26XaFga/a57P28Qh3aSNXBLf5qTVEWpjue6o7V2Lxh3Bw1AB0cI0RPd",
},11625,58,4229436445,2613375747},
[27] = {{
"pk8xAY4n3U/killM4nW9HXugjAs6VOcgiLklL/B5rpSXWenqBFvqkSH",
},20086,41,3291483174,3026974419},
[30] = {{
"e9zizScql0+fylNkkrt7nJXS9cf8AG6ju6dOj5mQa9XrPXXjBGddlaVQXht29ct4PHM9aioTdc21kXaYdOnTGC67GgrfBJDdAzFLL8nT3+C5yql7fQlyeqi/DpPCZP4cqiTIcNtVMo0k3AXs9zKTgmg1cbJB9g4N0ypSHMo0Zn/DZK12SPHgLvrGitjt3pbzHHrd5biDGt9uF+hiJjKb2JHVlLT3tG4/PnsPQp5Wr2GEiYqUis",
},56836,181,3303360078,3154680313},
[53] = {{
"zIHRsg01U/BadnW7MDZOOsNxMala7+BX1xciggcrkwim/PiMBdJDeZAZBcr4ZlEFaBd",
},57417,50,2088113002,3899965477},
}
                            
                                                                               
local function _ydu(_zdu, _aeu)
    local _beu, _ceu = 0, 1
    for _deu = _aeu, _aeu + 4 do
        local _eeu = buffer.readu8(_zdu, _deu)
        _beu += _eeu % 128 * _ceu
        if _eeu < 128 then
            assert(_beu <= 4294967295, _oht[40])
            return _beu, _deu + 1
        end
        _ceu *= 128
    end
    error(_oht[41])
end

local function _feu(_geu)
    return if _geu % 2 == 0 then _geu / 2 else -(_geu + 1) / 2
end

local function _heu(_ieu, _jeu, _keu, _leu, _meu)
    assert(_meu <= 8, _oht[42])
    local _neu
    _neu, _jeu = _ydu(_ieu, _jeu)
    if _neu == 0 then return nil, _jeu
    elseif _neu == 1 then return false, _jeu
    elseif _neu == 2 then return true, _jeu
    elseif _neu == 3 then
        local _oeu, _peu = _ydu(_ieu, _jeu)
        return _feu(_oeu), _peu
    elseif _neu == 4 then
        return buffer.readf64(_ieu, _jeu), _jeu + 8
    elseif _neu == 5 then
        local _qeu
        _qeu, _jeu = _ydu(_ieu, _jeu)
        return buffer.readstring(_ieu, _jeu, _qeu), _jeu + _qeu
    elseif _neu == 7 then
        local _reu
        _reu, _jeu = _ydu(_ieu, _jeu)
        assert(_reu <= buffer.len(_ieu) - _jeu, _oht[43])
        local _seu = table.create(_reu)
        for _teu = 1, _reu do
            _seu[_teu], _jeu = _heu(_ieu, _jeu, _keu, _leu, _meu + 1)
        end
        return _seu, _jeu
    elseif _neu == 8 then
        local _ueu, _veu = buffer.readf64(_ieu, _jeu), buffer.readf64(_ieu, _jeu + 8)
        local _weu, _xeu = buffer.readf64(_ieu, _jeu + 16), buffer.readf64(_ieu, _jeu + 24)
        if _leu then
            local _yeu = {_ueu,_veu,_weu,_xeu}
            _leu[_yeu] = true
            return _yeu, _jeu + 32
        end
        if _keu.vectorSize == 4 then return _keu.vectorCtor(_ueu,_veu,_weu,_xeu), _jeu + 32 end
        return _keu.vectorCtor(_ueu,_veu,_weu), _jeu + 32
    elseif _neu == 9 then
        assert(integer and integer.fromstring, _oht[44])
        local _zeu, _afu = _heu(_ieu, _jeu, _keu, _leu, _meu + 1)
        return integer.fromstring(_zeu, 10), _afu
    end
    error(_oht[45])
end

local function _bfu(_cfu, _dfu, _efu, _ffu, _gfu, _hfu)
    local _ifu, _jfu = buffer.len(_cfu), 0
    local function _kfu()
        local _lfu
        _lfu, _jfu = _ydu(_cfu, _jfu)
        return _lfu
    end
    local function _mfu()
        local _nfu = _kfu()
        assert(_nfu > 0 and _nfu <= _ifu - _jfu, _oht[46])
        local _ofu = {_jfu, _nfu}
        _jfu += _nfu
        return _ofu
    end
    local _pfu, _qfu, _rfu, _sfu = _kfu(), _kfu(), _kfu(), _kfu()
    assert(_pfu <= 255 and _qfu <= _pfu and _rfu <= 200, _oht[47])
    local _tfu = _kfu()
    assert(_tfu <= _ifu - _jfu, _oht[48])
    local _ufu = table.create(_tfu)
    for _vfu = 1, _tfu do
        local _wfu = _kfu()
        assert(_wfu > 0 and _wfu <= _ffu, _oht[49])
        _ufu[_vfu] = _wfu
    end
    local _xfu = _kfu()
    assert(_xfu <= (_ifu - _jfu) / 2, _oht[50])
    local _yfu = table.create(_xfu)
    for _zfu = 1, _xfu do _yfu[_zfu] = _mfu() end
    local _agu = _kfu()
    assert(_agu <= (_ifu - _jfu) / 3 and _agu <= _sfu and _sfu <= _agu * 4,
        _oht[51])
    local _bgu = _yht(12, _uht(_dfu, 0, 2))
    local _cgu = table.create(_sfu)
    local _dgu = {}
    local _egu = {
        __index = function(_fgu, _ggu)
            if _ggu == _vit[13] then return _pht(_fgu[_vit[15]], _fgu[_vit[16]]) end
            local _hgu = _dgu[_fgu]
            if not _hgu or not _hgu.fields[_ggu] then return nil end
            local _igu = _hit(_cfu, _hgu[1], _hgu[2], _hgu.key, false)
            local _jgu = _hgu.literalStart
            for _kgu, _lgu in _hgu.order do
                local _mgu
                _mgu, _jgu = _heu(_igu, _jgu, _gfu, _hfu, 0)
                if _lgu == _ggu then
                    if _lgu == _hgu.order[#_hgu.order] then
                        assert(_jgu == _hgu[2], _oht[52])
                    end
                    return _mgu
                end
            end
        end,
    }
    for _ngu = 1, _agu do
        local _ogu = _kfu()
        assert(_ogu > 0 and _ogu <= _sfu and not _cgu[_ogu], _oht[53])
        local _pgu = _mfu()
        _pgu.key = _uht(_dfu, _ogu, 2)
        local _qgu = _hit(_cfu, _pgu[1], _pgu[2], _pgu.key, false)
        local _rgu, _sgu = _ydu(_qgu, 0)
        local _tgu = _uht(_dfu, _ogu, 5) % 512
        local _ugu = _rgu % 512
        assert(_rgu < 2097152, _oht[54])
        local _vgu = {[_vit[15]]=_ugu, [_vit[16]]=_tgu, [_vit[14]]=_oht[55]}
        local _wgu = math.floor(_rgu / 512)
        local _xgu, _ygu
        for _zgu = 1, #_bgu do
            local _ahu = _bgu[(_zgu + _ogu - 1) % #_bgu + 1]
            if not bit32.btest(_wgu, 2 ^ (_ahu - 1)) then continue end
            local _bhu = _vit[_ahu]
            if _fit(_ahu) then
                local _chu
                _chu, _sgu = _ydu(_qgu, _sgu)
                _vgu[_bhu] = if _ahu == 4 or _ahu == 5 then _feu(_chu) else _chu
            else
                if not _xgu then _xgu, _ygu = {}, {} end
                _xgu[_bhu] = true
                _ygu[#_ygu + 1] = _bhu
            end
        end
        if _xgu then
            assert(_sgu < _pgu[2], _oht[56])
            _pgu.literalStart, _pgu.fields, _pgu.order = _sgu, _xgu, _ygu
            _dgu[_vgu] = _pgu
        else
            assert(_sgu == _pgu[2], _oht[52])
        end
        _cgu[_ogu] = setmetatable(_vgu, _egu)
    end
    assert(_jfu == _ifu and _cgu[1], _oht[57])

    local _dhu = setmetatable({}, {
        __index = function(_ehu, _fhu)
            local _ghu = _yfu[_fhu]
            if not _ghu then return nil end
            local _hhu = _hit(_cfu, _ghu[1], _ghu[2], _uht(_dfu, _fhu, 1), false)
            local _ihu, _jhu = _heu(_hhu, 0, _gfu, _hfu, 0)
            assert(_jhu == _ghu[2], _oht[58])
            return _ihu
        end,
    })
    return {
        maxstacksize=_pfu, numparams=_qfu, nups=_rfu, sizecode=_sfu,
        sizek=_xfu, code=_cgu, k=_dhu, protos=_ufu, debugcode={},
        debugname=_oht[59], bytecodeid=_efu - 1, lineinfoenabled=false,
        flowKey=_uht(_dfu, _efu, 4),
    }
end

local _khu = _wit.luau_newsettings()
_khu.errorHandling = false
if type(Vector3) == _oht[1] and type(Vector3.new) == _oht[2] then
    _khu.vectorCtor = Vector3.new
elseif type(vector) == _oht[1] and type(vector.create) == _oht[2] then
    _khu.vectorCtor = vector.create
end

local _giu = type
_khu.useNativeNamecall = true
_khu.namecallHandler = function(_hiu, _iiu, ...)
    if _giu(_iiu) == _oht[60] then
        local _h_ok, _h_1, _h_2, _h_3, _h_4 = _MS_GUARD.invoke(_iiu, _hiu, ...)
        if _h_ok then return true, _h_1, _h_2, _h_3, _h_4 end
    end
    return false
end
local _kiu = 54
local _liu = 54

local function _miu(_niu, _oiu)
    local _piu = _xdu[_niu]
    assert(_piu and _piu[3] <= 16777216, _oht[61])
    local _qiu = _ddu(_piu[1], _piu[2], _piu[3], _piu[4])
    return _bfu(_qiu, _piu[5], _niu, _kiu, _khu, _oiu)
end
local _riu = setmetatable({}, {
    __index = function(_siu, _tiu)
        assert(type(_tiu) == _oht[4] and _tiu >= 1 and _tiu <= _kiu, _oht[62])
        local _uiu = _miu(_tiu)
        rawset(_siu, _tiu, _uiu)
        _xdu[_tiu] = nil
        return _uiu
    end,
})
local _viu = {protoList = _riu, mainProto = _riu[_liu]}
local _wiu = _wit.luau_load(_viu, getfenv(1), _khu)
local _pack, _unpack = table.pack, table.unpack
local _results = _pack(_wiu(...))
_MS_GUARD.wipe(_viu.mainProto)
return _unpack(_results, 1, _results.n)

