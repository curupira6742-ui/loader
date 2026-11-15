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


local _jef=function(_kef,_lef)
    local _mef, _nef = {}, bit32.bxor
    for _oef=1,#_kef do
        local _pef = string.byte(_kef,_oef)
        _mef[_oef] = string.char(_nef(_pef,_lef))
        _lef = (_lef + _pef + 43) % 256
    end
    return table.concat(_mef)
end
local _qef={
_jef("\037\192\238\201\252",81),
_jef("\052\196\206\250\202\218\215\212",82),
_jef("\087\221\240\237\158\248\227\130\054\150\229\252\147\181\056\153\196\160\000\204\088\137\202\213\209\201\230\192\227\190\203\008\209\217\144\028\219\204\199\129\047\210\194\247\214\198\137\121\159\174\212\172\068\197\180\218\221\225\185\208\206\201\252\238\180\215\204\212",26),
_jef("\043\238\217\218\216\178",69),
_jef("\107\218\193\246\174\254",24),
_jef("\176\194\245\214\222\165\250",210),
_jef("\253\214\215\194\204\232\238\178\204\232\141\018\195\227\190\233\244\206\147\001\239\216\204\216\208\202\192",139),
_jef("\121\186\180\246\182\196\176\052\149\228\248\209\221\163\239\196\251\157\237\252\170\253\173\252\178\189\242\195\227\190\233\244\206\147\001\239\216\204\216\208\202\192",55),
_jef("\245\204\209\217\239\185\203\208\235\220\210\222\177\190\244\206\240\207\216\211\149\023\210\148\018\144\031\212\214\217\220",153),
_jef("\138\238\213\193\255\185\203\208\235\220\210\222\177\176\015\214\215\194\204\232\238\178\204\232\141\022\206\240\207\216\211\149\023\210\148\018\144\013\214\202\250\202\218\215\212",230),
_jef("\069\236\209\217\239\185\203\208\235\220\210\222\177\176\015\214\215\194\204\232\254\191\186\192\176\024\198\240\207\216\211\149\023\210\148\018\144\005\238\217\218\216\178",41),
_jef("\034\238\213\193\255\185\203\208\235\220\210\222\177\176\012\195\251\138\024\200\198\214\196\222\248\209\221\163\239\196\251\157\246\206\240\207\216\211\149\023\210\148\018\144\009\240\213\214\222\165\250",78),
_jef("\127\200\209\217\239\185\203\208\235\220\210\222\177\176\023\218\173\253\163\239\196\251\245\188\170\253\173\252\178\189\246\206\240\207\216\211\149\023\210\148\018\144\013\214\202\250\202\218\215\212",19),
_jef("\209\204\209\217\239\185\203\208\235\220\210\222\177\176\028\184\215\192\254\202\199\207\244\202\142\020\206\240\207\216\211\149\023\210\148\018\144\031\212\214\217\220\224\164\252\225\171\214\202\250\202\218\215\212\202",189),
_jef("\238\238\213\193\255\185\203\208\235\220\210\222\177\176\026\223\164\251\245\178\213\209\197\134\036\206\240\207\216\211\149\023\210\148\018\144\031\212\214\217\220\224\164\252\225\171\214\202\250\202\218\215\212\202",130),
_jef("\060\194\197\225\255\185\203\208\235\220\210\222\177\176\028\178\239\216\200\229\220\170\253\173\240\218\222\226\188\222\208\207\216\211\149\023\210\148\018\144\009\240\213\214\222\165\250",80),
_jef("\161\236\209\217\239\185\203\208\235\220\210\222\177\176\030\167\250\220\178\252\168\254\186\192\244\230\180\250\182\196\224\246\175\244\153\014\222\208\207\216\211\149\023\210\148\018\144\009\240\213\214\222\165\250",205),
_jef("\093\204\209\217\239\185\203\208\235\220\210\222\177\176\024\208\219\210\205\226\205\216\194\222\245\162\239\216\200\222\150\004\206\240\207\216\211\149\023\210\148\018\144\009\240\213\214\222\165\250",49),
_jef("\177\204\209\217\239\185\203\208\235\220\210\222\177\176\010\218\210\196\246\163\203\234\239\218\202\194\244\212\221\174\237\145\030\222\208\207\216\211\149\023\210\148\018\144\031\212\214\217\220",221),
_jef("\219\200\209\217\239\185\203\208\235\220\210\222\177\176\012\195\251\141\017\200\196\232\217\242\161\244\202\218\210\222\205\194\190\244\206\240\207\216\211\149\023\210\148\018\144\009\240\213\214\222\165\250",183),
_jef("\073\236\209\217\239\185\203\208\235\220\210\222\177\176\011\202\209\211\251\135\026\212\201\219\198\192\227\190\244\206\240\207\216\211\149\023\210\148\018\144\009\240\213\214\222\165\250",37),
_jef("\161\236\209\217\239\185\203\208\235\220\210\222\177\176\029\164\243\193\254\166\219\234\143\026\198\240\207\216\211\149\023\210\148\018\144\013\214\202\250\202\218\215\212",205),
_jef("\036\215\217\167\243\144\006\243\222\182\200\242\148\001\250\181\209\201\230\192\244",107),
_jef("\044\246\148\220",98),
_jef("\236\194",154),
_jef("\049\197",90),
_jef("\193\250\207\210\220\222\164\175\038\215\217\167\243\144\015\204\239\198\198\236\204\206\191\250\218\210\196\250",168),
_jef("\017\217\200\221\222\248\227\130\054\150\229\252\147\175\079\128\250\207\210\220\222\164\175\063\158\188\234\246\202\218\193\234\215\194\202\247\212",92),
_jef("\200\208\192\226\193",190),
_jef("\026\180\235\208\221\200\223\149\001\206\186\022\180\250\182\196\224\250\228\188\204\212\194\189\228\180\086\135\134\033\194\252\194\193",123),
_jef("\010\246\207\210\220\222\164\175\078\132\254\200\138\066\163\244\209\209\192\191\161\059\206\217\218\216\178\189\224\232\211\196\243\218\214\208\134",99),
_jef("\024\218\207\210\220\222\164\175\078\132\254\200\138\066\188\194\198\228\131\121\155\206\217\218\216\178\189\224\232\211\196\243\218\214\208\134",113),
_jef("\055\174\239\210\220\222\164\175\078\132\254\200\138\066\166\206\253\164\232\131\121\155\206\217\218\216\178\189\224\232\211\196\243\218\214\208\134",94),
_jef("\189\174\250\209\207\218\205\212\194\248\164\175\028\222\209\212\218\221\173\252\164\175\042\255\184\159\192\210\056",216),
_jef("",116),
_jef("\130\024\193\128\029\222\188\198\006\215\200\232\141\030\142\041\218\173\253\250\197\240\131\190\203\020\210\220\250\197\240\131\190\215\202\068\205\192\163\190\200\010\204\201\254\166\174\077\192\163\190\250\150\077\192\163",196),
_jef("\161\218\205\144\061\158\188\198\006\215\200\232\141\030\142\041\218\173\253\250\197\240\131\190\215\202\068\205\192\163\190\200\010\204\201\254\166\174\077\192\163\190\250\150\077\192\163",231),
_jef("\007\063\132\023\234\140\254\255\172\207\211\222\224\144\079\191\219\216\175\143\019\215\232\224\235\166\135\032\183\199\246\142\033\194\216\233\136\057\158\249\146\235\248\140\034\240\136\202\198\011\192\229\231\209\209\217\194\233\216\219\142\030\243\245",52),
_jef("\039\253\176\237\158\248\227\130\054\150\229\252\147\175\079\128\250\207\210\220\222\164\175\063\158\188\243\192\245\192\248\219\164",106),
_jef("\020\247\217\167\243\144\029\210\194\244\210\205\145\002\236\212\194\251\175\242\205",91),
_jef("\178\214\207\210\220\222\164\175\038\215\217\167\243\144\029\210\194\244\210\205",219),
_jef("\047\215\217\167\243\144\008\241\212\202\218\210\222\205\145\003\254\183\210\202\246\222\226\163\244\209\209\192",96),
_jef("\094\174\239\210\220\222\164\175\038\215\217\167\243\144\008\241\212\202\218\210\222\205\145\001\240\199\210",55),
_jef("\247\183\217\167\243\144\025\202\213\209\201\230\192\227\190\239\206\233\218\147\024\218\205\212\215\215\198\133\038\211\212\211\206\232\217",184),
_jef("\118\174\239\210\220\222\164\175\038\215\217\167\243\144\008\241\212\202\218\210\222\205\145\025\208\203",31),
_jef("\166\209\234\218\218\223\188\202\192\175\038\215\217\167\243\144\013\209\254\165\253",210),
_jef("\129\250\207\210\220\222\164\175\038\215\217\167\243\144\013\214\202\250\202\218\215\212\153\027\177\254\165\253",232),
_jef("\039\206\239\210\220\222\164\175\038\215\217\167\243\144\008\242\212\201\219\198\192\176\008\241\207\218\205",78),
_jef("\026\214\207\210\220\222\164\175\038\215\217\167\243\144\008\242\212\201\219\198\192\176\025\202\194\244\194\248\174\250\219",115),
_jef("\032\250\207\210\220\222\164\175\038\215\217\167\243\144\008\241\212\202\218\210\222\205\194\190\228\249\207\218\205",73),
_jef("\141\242\207\210\220\222\164\175\038\215\217\167\243\144\008\241\222\166\180\000\247\186\192",228),
_jef("\040\222\220\184\211\196\243\218\214\208\143\038\215\217\167\243\144\002\246\202\218\193\234\215\194\202\247\212\153\009\208\197\240",93),
_jef("\017\218\207\210\220\222\164\175\038\215\217\167\243\144\002\246\202\218\193\234\215\194\202\247\212\153\028\160\235\215\194\231\213",120),
_jef("\079\206\239\210\220\222\164\175\038\215\217\167\243\144\004\234\202\214\196\224\246\175\244",38),
_jef("\044\247\217\167\243",67),
_jef("\039\245\207\197\207\206\254\226\128\023\217\167\243\144\004\234\202\214\196\250\221\178",74),
_jef("\017\218\207\210\220\222\164\175\038\215\217\167\243\144\027\208\207\205\251\176\191\229\248\197\195\239\192",120),
_jef("\172\222\220\184\211\196\243\218\214\208\143\038\215\217\167\243\144\008\241\212\202\218\210\222\205\145\025\208\197\240",217),
_jef("\182\016\215\217\167\243\153",158),
_jef("\078\199\195\230\193\240\216\206",59),
_jef("\222\174\239\210\220\222\164\175\038\215\217\167\243\144\027\208\207\205\251\176",183),
_jef("\183\174\239\210\220\222\164\175\038\215\217\167\243\144\027\195\240\206\220\206\202\216\206",222),
}
                                                       

assert(type(buffer) == _qef[1] and type(bit32) == _qef[1] and type(table.move) == _qef[2],
    _qef[3])
                                                      
local _ref, _sef, _tef = bit32.bxor, bit32.lshift, bit32.rshift

local function _uef(_vef)
    _vef = _ref(_vef, _sef(_vef, 13))
    _vef = _ref(_vef, _tef(_vef, 17))
    return _ref(_vef, _sef(_vef, 5))
end

local function _wef(_xef, _yef, _zef)
    return _uef(_ref(_xef, _yef * 65537, _zef)) + 1
end

local function _aff(_bff, _cff)
    local _dff = table.create(_bff)
    for _eff = 1, _bff do _dff[_eff] = _eff end
    for _fff = _bff, 2, -1 do
        _cff = _uef(_cff + _fff)
        local _gff = _cff % _fff + 1
        _dff[_fff], _dff[_gff] = _dff[_gff], _dff[_fff]
    end
    return _dff
end

local function _hff(_iff)
    return _iff <= 6 or _iff == 11
end

local function _jff(_kff, _lff, _mff, _nff, _off)
    local _pff = buffer.create(_mff)
    local _qff = _mff - _mff % 4
    for _rff = 0, _qff - 1, 4 do
        local _sff = buffer.readu32(_kff, _lff + _rff)
        local _tff = _ref(_sff, _nff)
        buffer.writeu32(_pff, _rff, _tff)
        _nff = _uef(_nff + (if _off then _tff else _sff) + _rff + 1)
    end
    for _uff = _qff, _mff - 1 do
        local _vff = buffer.readu8(_kff, _lff + _uff)
        local _wff = _ref(_vff, _nff % 256)
        buffer.writeu8(_pff, _uff, _wff)
        _nff = _uef(_nff + (if _off then _wff else _vff) + _uff + 1)
    end
    return _pff
end

local _xff = {10,8,7,2,12,4,16,1,14,15,6,13,9,5,11,3,}
local _yff = (function()
local _zff = {
  bit32.bxor(4699062, bit32.bxor(691072, 5060660)),
  bit32.bxor(bit32.bxor(364355, 6092670), 5863481),
  bit32.bxor(bit32.bxor(2333368, 2518236), 390755),
  bit32.bxor(bit32.bxor(2113381, 4882017), 6963470),
  bit32.bxor(7499624, bit32.bxor(8022340, 525858)),
  bit32.bxor(6264349, bit32.bxor(557025, 5761518)),
  bit32.bxor(bit32.bxor(7356824, 9140145), 16463418),
  bit32.bxor(bit32.bxor(4897436, 2937467), 6711539),
  bit32.bxor(bit32.bxor(6368260, 4079266), 6230716),
  bit32.bxor(2090124, bit32.bxor(7508435, 7173444)),
  bit32.bxor(bit32.bxor(1051937, 959340), 2010707),
  bit32.bxor(bit32.bxor(3332758, 8307338), 4986942),
  bit32.bxor(bit32.bxor(1722513, 1970174), 280395),
  bit32.bxor(bit32.bxor(6622510, 15654107), 9163229),
  bit32.bxor(8699853, bit32.bxor(8206545, 16353068)),
  bit32.bxor(bit32.bxor(6284336, 7271367), 3217345),
  bit32.bxor(bit32.bxor(6958312, 429885), 7119852),
  bit32.bxor(bit32.bxor(8715234, 2232897), 10938783),
  bit32.bxor(bit32.bxor(7784344, 5142667), 3718995),
  bit32.bxor(bit32.bxor(1914277, 5165567), 5497883),
  bit32.bxor(bit32.bxor(5630106, 7100714), 3781106),
  bit32.bxor(2700222, bit32.bxor(5220329, 6722579)),
  bit32.bxor(bit32.bxor(5699405, 6079902), 668313),
  bit32.bxor(bit32.bxor(4443436, 4251795), 208369),
  bit32.bxor(bit32.bxor(6975222, 5802753), 3335593),
  bit32.bxor(6540955, bit32.bxor(2239452, 4318511)),
  bit32.bxor(4344522, bit32.bxor(3667439, 7716695)),
  bit32.bxor(bit32.bxor(3008908, 2452504), 558560),
  bit32.bxor(bit32.bxor(1336426, 4336034), 5655998),
  bit32.bxor(bit32.bxor(4553669, 13318741), 9322983),
  bit32.bxor(8700199, bit32.bxor(1054375, 9754617)),
  bit32.bxor(bit32.bxor(7257929, 14936437), 9262663),
  bit32.bxor(bit32.bxor(6584990, 4415862), 2562964),
  bit32.bxor(bit32.bxor(1275047, 9516862), 8537063),
  bit32.bxor(bit32.bxor(8458545, 4222329), 12680392),
  bit32.bxor(6587100, bit32.bxor(1223681, 7745116)),
  bit32.bxor(bit32.bxor(6776559, 196848), 6579866),
  bit32.bxor(bit32.bxor(1630869, 573905), 1057741),
  bit32.bxor(bit32.bxor(935529, 7570556), 8241797),
  bit32.bxor(bit32.bxor(5525258, 3568573), 6437924),
  bit32.bxor(bit32.bxor(1406464, 638368), 1886981),
  bit32.bxor(bit32.bxor(2070313, 4634076), 5841503),
  bit32.bxor(5122724, bit32.bxor(224316, 5064243)),
  bit32.bxor(bit32.bxor(7402112, 9541277), 14771379),
  bit32.bxor(bit32.bxor(3823939, 9920291), 11339477),
  bit32.bxor(332103, bit32.bxor(7293532, 6970285)),
  bit32.bxor(bit32.bxor(9540001, 2463792), 11798824),
  bit32.bxor(bit32.bxor(9514171, 16356104), 6864652),
  bit32.bxor(bit32.bxor(5289988, 2420413), 7624313),
  bit32.bxor(bit32.bxor(8597721, 2828779), 11016689),
  bit32.bxor(bit32.bxor(8573505, 16158261), 7625904),
  bit32.bxor(bit32.bxor(7348068, 9238661), 16574244),
  bit32.bxor(8118180, bit32.bxor(819241, 7823179)),
  bit32.bxor(bit32.bxor(8407008, 586917), 8958877),
  bit32.bxor(2954084, bit32.bxor(5216190, 6456321)),
  bit32.bxor(bit32.bxor(947284, 6364963), 7302056),
  bit32.bxor(bit32.bxor(8661253, 13709464), 5577077),
  bit32.bxor(5074296, bit32.bxor(1359273, 5886008)),
  bit32.bxor(1729249, bit32.bxor(9195551, 9843219)),
  bit32.bxor(bit32.bxor(5535029, 2365189), 7365319),
  bit32.bxor(bit32.bxor(5187020, 5637780), 1647521),
  bit32.bxor(bit32.bxor(2619864, 11106169), 9342557),
  bit32.bxor(690231, bit32.bxor(1066144, 1756266)),
  bit32.bxor(bit32.bxor(3232848, 2613945), 1488407),
  bit32.bxor(bit32.bxor(6021384, 7172336), 3576061),
  bit32.bxor(bit32.bxor(1890459, 6488070), 8378769),
  bit32.bxor(bit32.bxor(7259700, 3354817), 6158309),
  bit32.bxor(bit32.bxor(1115318, 3008190), 3990297),
  bit32.bxor(8444033, bit32.bxor(6473479, 14818963)),
  bit32.bxor(8335220, bit32.bxor(2021419, 6420038)),
  bit32.bxor(9589312, bit32.bxor(9180871, 1983899)),
  bit32.bxor(1153967, bit32.bxor(3176159, 2223184)),
  bit32.bxor(8645448, bit32.bxor(1209149, 9541974)),
  bit32.bxor(bit32.bxor(3599758, 2554060), 1053796),
  bit32.bxor(bit32.bxor(4739709, 1921242), 5571465),
  bit32.bxor(bit32.bxor(2251565, 4672505), 6623718),
  bit32.bxor(bit32.bxor(8832532, 7969422), 16735661),
  bit32.bxor(9586023, bit32.bxor(5278418, 12766964)),
  bit32.bxor(3998755, bit32.bxor(8566505, 12563343)),
  bit32.bxor(bit32.bxor(604444, 7046911), 6471332),
  bit32.bxor(7245970, bit32.bxor(6242581, 3264719)),
  bit32.bxor(bit32.bxor(7174010, 3335885), 6263014),
  bit32.bxor(6682663, bit32.bxor(8585133, 15140569)),
  bit32.bxor(bit32.bxor(4600429, 4083630), 7896215),
  bit32.bxor(bit32.bxor(2896658, 1676771), 3516327),
  bit32.bxor(4082244, bit32.bxor(1620166, 2552795)),
  bit32.bxor(bit32.bxor(3799055, 6501641), 5950557),
  bit32.bxor(bit32.bxor(8110714, 2279739), 5835293),
  bit32.bxor(7002373, bit32.bxor(2979968, 4694232)),
  bit32.bxor(bit32.bxor(6406086, 15141464), 8828157),
  bit32.bxor(bit32.bxor(1601628, 1589049), 19969),
  bit32.bxor(bit32.bxor(2190697, 4452177), 6456159),
  bit32.bxor(bit32.bxor(1798534, 1889320), 500932),
  bit32.bxor(bit32.bxor(4010289, 1500498), 2872584),
  bit32.bxor(9024848, bit32.bxor(7944515, 15764863)),
  bit32.bxor(bit32.bxor(4858767, 4205067), 657642),
  bit32.bxor(3162300, bit32.bxor(3725479, 563561)),
  bit32.bxor(6917156, bit32.bxor(7678911, 1877741)),
  bit32.bxor(bit32.bxor(455617, 7612248), 7525861),
  bit32.bxor(bit32.bxor(8627043, 7644171), 16188949),
  bit32.bxor(bit32.bxor(6893165, 5433597), 3917586),
  bit32.bxor(bit32.bxor(6912922, 2456045), 4981746),
  bit32.bxor(bit32.bxor(4204193, 13364277), 9161491),
  bit32.bxor(2799122, bit32.bxor(8044958, 5273095)),
  bit32.bxor(bit32.bxor(5370405, 14240852), 8962017),
  bit32.bxor(bit32.bxor(9121887, 754188), 8434631),
  bit32.bxor(bit32.bxor(6739178, 1259293), 7725675),
  bit32.bxor(8481968, bit32.bxor(3310844, 11790830)),
  bit32.bxor(bit32.bxor(3757781, 1766357), 2335912),
  bit32.bxor(bit32.bxor(4680542, 2361065), 6515739),
  bit32.bxor(bit32.bxor(7274507, 5199913), 2120076),
  bit32.bxor(bit32.bxor(2452526, 8281518), 5976112),
  bit32.bxor(bit32.bxor(3723599, 2473287), 1928638),
  bit32.bxor(bit32.bxor(2083994, 10395047), 8474752),
  bit32.bxor(bit32.bxor(3510459, 6059982), 6940363),
  bit32.bxor(bit32.bxor(854830, 3643784), 3838818),
  bit32.bxor(bit32.bxor(2206264, 2668924), 594561),
  bit32.bxor(bit32.bxor(6857631, 601958), 6393150),
  bit32.bxor(bit32.bxor(8664125, 13900388), 5255059),
  bit32.bxor(bit32.bxor(7389823, 7213086), 2020271),
  bit32.bxor(8009837, bit32.bxor(8814714, 16562648)),
  bit32.bxor(bit32.bxor(3652127, 3186428), 468272),
  bit32.bxor(bit32.bxor(610415, 5537196), 6106134),
  bit32.bxor(bit32.bxor(6686837, 5668415), 3176338),
  bit32.bxor(bit32.bxor(9214381, 595547), 8752662),
  bit32.bxor(bit32.bxor(846043, 6142552), 5329762),
  bit32.bxor(bit32.bxor(2188793, 10994601), 8824739),
  bit32.bxor(bit32.bxor(2853314, 4110591), 1388747),
  bit32.bxor(766470, bit32.bxor(4206310, 4955420)),
}
                                                                                                                       
local _agf = type
local _bgf = pcall
local _cgf = error
local _dgf = tonumber
local _egf = assert
local _fgf = rawequal
local _ggf = setmetatable

local _hgf = string.format
local _igf = math.floor
local _jgf = math.sqrt
local _kgf = if _agf(integer) == _qef[1] then integer.fromstring else nil

local _lgf = table.move
local _mgf = table.pack
local _ngf = table.unpack
local _ogf = table.create
local _pgf = table.insert
local _qgf = table.remove
local _rgf = table.concat

local _sgf = coroutine.create
local _tgf = coroutine.yield
local _ugf = coroutine.resume
local _vgf = coroutine.close

local _wgf = buffer.fromstring
local _xgf = buffer.len
local _ygf = buffer.readu8
local _zgf = buffer.readu32
local _ahf = buffer.readstring
local _bhf = buffer.readf32
local _chf = buffer.readf64

local _dhf = bit32.bor
local _ehf = bit32.band
local _fhf = bit32.btest
local _ghf = bit32.rshift
local _hhf = bit32.lshift
local _ihf = bit32.extract

local _jhf = function(_khf) return _agf(_khf) == _qef[4] end
local _lhf = function(_mhf) return _agf(_mhf) == _qef[5] end
local _nhf = function(_ohf) return _agf(_ohf) == _qef[6] end
local _phf = function(_qhf) return _agf(_qhf) == _qef[2] end

                                                                                                    
                                         
                                                                          
            
         
          
           
          
          
                                                                                                                                                            
            
           
         
         
                  
                             
                              
         
                               
                                 
                                                                                                                                      

local _rhf = -1
local _shf = -2

local function _thf()
	return {
		vectorCtor = function() _cgf(_qef[7]) end,
		vectorSize = 4,
		useNativeNamecall = false,
		namecallHandler = function() _cgf(_qef[8]) end,
		extensions = {},
		callHooks = {},
		errorHandling = true,
		generalizedIteration = true,
		allowProxyErrors = false,
		useImportConstants = false,
		reuseClosures = false,
		staticEnvironment = {},
		decodeOp = function(_uhf) return _uhf end
	}
end

local function _vhf(_whf)
	_egf(_agf(_whf) == _qef[1], _qef[9])
	_egf(_agf(_whf.vectorCtor) == _qef[2], _qef[10])
	_egf(_agf(_whf.vectorSize) == _qef[4], _qef[11])
	_egf(_agf(_whf.useNativeNamecall) == _qef[6], _qef[12])
	_egf(_agf(_whf.namecallHandler) == _qef[2], _qef[13])
	_egf(_agf(_whf.extensions) == _qef[1], _qef[14])
	_egf(_agf(_whf.callHooks) == _qef[1], _qef[15])
	_egf(_agf(_whf.errorHandling) == _qef[6], _qef[16])
	_egf(_agf(_whf.generalizedIteration) == _qef[6], _qef[17])
	_egf(_agf(_whf.allowProxyErrors) == _qef[6], _qef[18])
	_egf(_agf(_whf.staticEnvironment) == _qef[1], _qef[19])
	_egf(_agf(_whf.useImportConstants) == _qef[6], _qef[20])
	_egf(_agf(_whf.reuseClosures) == _qef[6], _qef[21])
	_egf(_agf(_whf.decodeOp) == _qef[2], _qef[22])
end

local function _xhf(_yhf, _zhf, _aif)
	if _aif == nil then
		_aif = _thf()
	else 
		_vhf(_aif)
	end

	_egf(_agf(_yhf) == _qef[1], _qef[23])

	local _bif = _yhf.protoList
	local _cif = _yhf.mainProto
	local _dif = {}

	local _eif = _aif.callHooks.breakHook
	local _fif = _aif.callHooks.stepHook
	local _gif = _aif.callHooks.interruptHook
	local _hif = _aif.callHooks.panicHook

	local _iif = true 

	local function _jif()
		_iif = false
	end

	local function _kif(_lif, _mif, _nif)
		local function _oif(...)
			local _pif, _qif, _rif, _sif, _tif
			
			if _aif.errorHandling then
				_pif, _qif, _rif, _sif, _tif = ... 
			else 
				                                       
				local _uif = _mgf(...)
				_qif = _ogf(_mif.maxstacksize)
				_tif = {
					len = 0,
					list = {},
				}
	
				_lgf(_uif, 1, _mif.numparams, 0, _qif)
	
				if _mif.numparams < _uif.n then
					local _vif = _mif.numparams + 1
					local _wif = _uif.n - _mif.numparams
					_tif.len = _wif
					_lgf(_uif, _vif, _vif + _wif - 1, 1, _tif.list)
				end
	
				_uif = nil
	
				_pif = {pc = 0, name = _qef[24]}

				_rif = _mif.protos 
				_sif = _mif.code
			end 

			local _xif, _yif, _zif, _ajf = -1, 1, _ggf({}, {__mode = _qef[25]}), _ggf({}, {__mode = _qef[26]})
			local _bjf = _mif.k
			local _cjf = _mif.debugcode
			local _djf = _aif.extensions

			local _ejf = false
			local _fjf, _gjf
			local _hjf = _mif.flowKey
			local _ijf = _ref(1, _hjf)
			while _iif do
				_yif = _ref(_ijf, _hjf)
				if not _ejf then
					_fjf = _egf(_sif[_yif], _qef[27])
					_gjf = _ref(_fjf[_xff[15]], _fjf[_xff[16]])
				end

				_ejf = false

				_pif.pc = _yif
				_pif.top = _xif
				_pif.name = _fjf[_xff[14]]

				_yif += 1

				if _fif then
					_fif(_qif, _pif, _mif, _lif, _nif)
				end

if _gjf < _zff[65] then
if _gjf < _zff[33] then
if _gjf < _zff[17] then
if _gjf < _zff[9] then
if _gjf < _zff[5] then
if _gjf == _zff[1] then
					local _jjf = _fjf[_xff[7]]

					_qif[_fjf[_xff[1]]] = _djf[_jjf] or _zhf[_jjf]

					_yif += 1                    
elseif _gjf == _zff[2] then
					_qif[_fjf[_xff[1]]] = _fjf[_xff[7]]
elseif _gjf == _zff[3] then
					local _kjf = _fjf[_xff[7]]
					_qif[_fjf[_xff[1]]] = _qif[_fjf[_xff[2]]][_kjf]

					_yif += 1                     
elseif _gjf == _zff[4] then
					_qif[_fjf[_xff[1]]] = _fjf[_xff[7]]
else _cgf(_qef[28]) end
else
if _gjf == _zff[5] then
					if _eif then
						local _ljf = _mgf(_eif(_qif, _pif, _mif, _lif, _nif))
						
						if _ljf[1] then 
							return _ngf(_ljf, 2, #_ljf)
						end 
					end
					
					_yif -= 1
					_gjf = _cjf[_yif]
					_ejf = true
elseif _gjf == _zff[6] then
					_qif[_fjf[_xff[1]]] = nil
elseif _gjf == _zff[7] then
					_fjf[_xff[5]] += 1
elseif _gjf == _zff[8] then
					               
					_yif += 1                    
else _cgf(_qef[28]) end
end
else
if _gjf < _zff[13] then
if _gjf == _zff[9] then
_qif[_fjf[_xff[3]]] = _qif[_fjf[_xff[2]]][_fjf[_xff[8]]]
_yif += 2
					local _mjf = _fjf[_xff[1]]
					local _njf = _fjf[_xff[3]]

					local _ojf = _fjf[_xff[7]]
					
					local _pjf = _qif[_njf]

					_qif[_mjf + 1] = _pjf
					
					_yif += 1                     
					
					local _qjf = true
					
					                                                   
					local _rjf = _aif.useNativeNamecall

					if _rjf then
						local _sjf = _aif.namecallHandler

						local _tjf = _sif[_yif]
						local _ujf = _tjf[_xff[13]]

						                                       
						local _vjf, _wjf, _xjf = _tjf[_xff[1]], _tjf[_xff[2]], _tjf[_xff[3]]

						if _fif then
							_fif(_qif, _pif, _mif, _lif, _nif)
						end

						if _gif then
							_gif(_qif, _pif, _mif, _lif, _nif)	
						end

						local _yjf = if _wjf == 0 then _xif - _vjf else _wjf - 1
						local _zjf = _mgf(
							_sjf(_ojf, _ngf(_qif, _vjf + 1, _vjf + _yjf))
						)

						if _zjf[1] == true then
							_qjf = false
							
							_yif += if _ujf == 469 then 2 else 1                                    

							_fjf = _tjf
							_gjf = _ujf
							_pif.pc = _yif
							_pif.name = _fjf[_xff[14]]

							local _akf = _zjf.n - 1

							if _xjf == 0 then
								_xif = _vjf + _akf - 1
							else
								_akf = _xjf - 1
							end

							_lgf(_zjf, 2, _akf + 1, _vjf, _qif)
						end
					end
					
					if _qjf then
						_qif[_mjf] = _pjf[_ojf]
					end
elseif _gjf == _zff[10] then
					local _bkf = _fjf[_xff[1]]
					local _ckf = _fjf[_xff[2]]

					local _dkf = _fjf[_xff[7]]
					
					local _ekf = _qif[_ckf]

					_qif[_bkf + 1] = _ekf
					
					_yif += 1                     
					
					local _fkf = true
					
					                                                   
					local _gkf = _aif.useNativeNamecall

					if _gkf then
						local _hkf = _aif.namecallHandler

						local _ikf = _sif[_yif]
						local _jkf = _ikf[_xff[13]]

						                                       
						local _kkf, _lkf, _mkf = _ikf[_xff[1]], _ikf[_xff[2]], _ikf[_xff[3]]

						if _fif then
							_fif(_qif, _pif, _mif, _lif, _nif)
						end

						if _gif then
							_gif(_qif, _pif, _mif, _lif, _nif)	
						end

						local _nkf = if _lkf == 0 then _xif - _kkf else _lkf - 1
						local _okf = _mgf(
							_hkf(_dkf, _ngf(_qif, _kkf + 1, _kkf + _nkf))
						)

						if _okf[1] == true then
							_fkf = false
							
							_yif += if _jkf == 469 then 2 else 1                                    

							_fjf = _ikf
							_gjf = _jkf
							_pif.pc = _yif
							_pif.name = _fjf[_xff[14]]

							local _pkf = _okf.n - 1

							if _mkf == 0 then
								_xif = _kkf + _pkf - 1
							else
								_pkf = _mkf - 1
							end

							_lgf(_okf, 2, _pkf + 1, _kkf, _qif)
						end
					end
					
					if _fkf then
						_qif[_bkf] = _ekf[_dkf]
					end
elseif _gjf == _zff[11] then
					local _qkf = _fjf[_xff[1]]
					local _rkf = _fjf[_xff[2]] - 1

					if _rkf == _rhf then
						_rkf = _tif.len
						_xif = _qkf + _rkf - 1
					end

					_lgf(_tif.list, 1, _rkf, _qkf, _qif)
elseif _gjf == _zff[12] then
					_qif[_fjf[_xff[1]]] = _fjf[_xff[4]]
else _cgf(_qef[28]) end
else
if _gjf == _zff[13] then
					local _skf = _fjf[_xff[1]]
					local _tkf = _bif[_fjf[_xff[7]] + 1]
					local _ukf = _tkf.nups
					local _vkf
					if _aif.reuseClosures then
						_vkf = _dif[_fjf]
					end
					local _wkf = _vkf ~= nil

					if _vkf then
						_qif[_skf] = _vkf.closure
						for _xkf = 1, _ukf do
							local _ykf = _sif[_yif + _xkf - 1]
							local _zkf = _vkf.upvalues[_xkf]
							if _ykf[_xff[1]] == 0 then                   
								if not _fgf(_zkf.store[_zkf.index], _qif[_ykf[_xff[2]]]) then
									_wkf = false
									break
								end
							elseif _ykf[_xff[1]] == 2 then                     
								if not _fgf(_zkf, _nif[_ykf[_xff[2]] + 1]) then
									_wkf = false
									break
								end
							else
								_wkf = false
								break
							end
						end
					end

					if _wkf then
						_yif += _ukf
					else
						local _alf = _ogf(_ukf)
						local _blf = _kif(_lif, _tkf, _alf)

						_qif[_skf] = _blf

						for _clf = 1, _ukf do
							local _dlf = _sif[_yif]
							_yif += 1

							local _elf = _dlf[_xff[1]]
							if _elf == 0 then           
								local _flf = {
									value = _qif[_dlf[_xff[2]]],
									index = _qef[29],                   
								}
								_flf.store = _flf

								_alf[_clf] = _flf

								                                              
							elseif _elf == 2 then             
								_alf[_clf] = _nif[_dlf[_xff[2]] + 1]
							end
						end

						if _aif.reuseClosures then
							_dif[_fjf] = {closure = _blf, upvalues = _alf}
						end
					end
elseif _gjf == _zff[14] then
					_qif[_fjf[_xff[1]]] = _fjf[_xff[7]] - _qif[_fjf[_xff[3]]]
elseif _gjf == _zff[15] then
					_qif[_fjf[_xff[2]]][_fjf[_xff[3]] + 1] = _qif[_fjf[_xff[1]]]
elseif _gjf == _zff[16] then
_qif[_fjf[_xff[1]]] = _qif[_fjf[_xff[2]]] - _qif[_fjf[_xff[3]]]
_qif[_fjf[_xff[4]]] = _qif[_fjf[_xff[1]]]
_yif += 1
else _cgf(_qef[28]) end
end
end
else
if _gjf < _zff[25] then
if _gjf < _zff[21] then
if _gjf == _zff[17] then
					if not _phf(_qif[_fjf[_xff[1]]]) then
						_cgf(_hgf(_qef[30], _agf(_qif[_fjf[_xff[1]]])))                                                
					end

					_yif += _fjf[_xff[4]]
elseif _gjf == _zff[18] then
					local _glf = _nif[_fjf[_xff[2]] + 1]
					_qif[_fjf[_xff[1]]] = _glf.store[_glf.index]
elseif _gjf == _zff[19] then
					               
					_yif += 1                    
elseif _gjf == _zff[20] then
					_qif[_fjf[_xff[1]]] = _qif[_fjf[_xff[2]]] // _fjf[_xff[7]]
else _cgf(_qef[28]) end
else
if _gjf == _zff[21] then
					local _hlf = _fjf[_xff[1]]
					local _ilf = _fjf[_xff[2]]
					local _jlf = _fjf[_xff[3]] - 1

					if _jlf == _rhf then
						_jlf = _xif - _ilf + 1
					end

					_lgf(_qif, _ilf, _ilf + _jlf - 1, _fjf[_xff[6]], _qif[_hlf])

					_yif += 1                     
elseif _gjf == _zff[22] then
					_qif[_fjf[_xff[1]]] = _qif[_fjf[_xff[2]]] % _fjf[_xff[7]]
elseif _gjf == _zff[23] then
					_qif[_fjf[_xff[1]]] = _qif[_fjf[_xff[2]]] / _qif[_fjf[_xff[3]]]
elseif _gjf == _zff[24] then
					_qif[_fjf[_xff[1]]] = _ogf(_fjf[_xff[6]])

					_yif += 1                     
else _cgf(_qef[28]) end
end
else
if _gjf < _zff[29] then
if _gjf == _zff[25] then
					if _qif[_fjf[_xff[1]]] then
						_yif += _fjf[_xff[4]]
					end
elseif _gjf == _zff[26] then
					local _klf = _qif[_fjf[_xff[1]]]

					if _aif.generalizedIteration and not _phf(_klf) then
						local _llf = _sif[_yif + _fjf[_xff[4]]]
						if _ajf[_llf] == nil then 
							local function _mlf(...)
								for _nlf, _olf, _plf, _qlf, _rlf, _slf, _tlf, _ulf, _vlf, _wlf, _xlf, _ylf, _zlf, _amf, _bmf, _cmf, _dmf, _emf, _fmf, _gmf, _hmf, _imf, _jmf, _kmf, _lmf, _mmf, _nmf, _omf, _pmf, _qmf, _rmf, _smf, _tmf, _umf, _vmf, _wmf, _xmf, _ymf, _zmf, _anf, _bnf, _cnf, _dnf, _enf, _fnf, _gnf, _hnf, _inf, _jnf, _knf, _lnf, _mnf, _nnf, _onf, _pnf, _qnf, _rnf, _snf, _tnf, _unf, _vnf, _wnf, _xnf, _ynf, _znf, _aof, _bof, _cof, _dof, _eof, _fof, _gof, _hof, _iof, _jof, _kof, _lof, _mof, _nof, _oof, _pof, _qof, _rof, _sof, _tof, _uof, _vof, _wof, _xof, _yof, _zof, _apf, _bpf, _cpf, _dpf, _epf, _fpf, _gpf, _hpf, _ipf, _jpf, _kpf, _lpf, _mpf, _npf, _opf, _ppf, _qpf, _rpf, _spf, _tpf, _upf, _vpf, _wpf, _xpf, _ypf, _zpf, _aqf, _bqf, _cqf, _dqf, _eqf, _fqf, _gqf, _hqf, _iqf, _jqf, _kqf, _lqf, _mqf, _nqf, _oqf, _pqf, _qqf, _rqf, _sqf, _tqf, _uqf, _vqf, _wqf, _xqf, _yqf, _zqf, _arf, _brf, _crf, _drf, _erf, _frf, _grf, _hrf, _irf, _jrf, _krf, _lrf, _mrf, _nrf, _orf, _prf, _qrf, _rrf, _srf, _trf, _urf, _vrf, _wrf, _xrf, _yrf, _zrf, _asf, _bsf, _csf, _dsf, _esf, _fsf, _gsf, _hsf, _isf, _jsf, _ksf, _lsf, _msf, _nsf, _osf, _psf, _qsf, _rsf, _ssf, _tsf, _usf, _vsf, _wsf, _xsf, _ysf, _zsf, _atf, _btf, _ctf, _dtf, _etf in ... do 
									_tgf({_nlf, _olf, _plf, _qlf, _rlf, _slf, _tlf, _ulf, _vlf, _wlf, _xlf, _ylf, _zlf, _amf, _bmf, _cmf, _dmf, _emf, _fmf, _gmf, _hmf, _imf, _jmf, _kmf, _lmf, _mmf, _nmf, _omf, _pmf, _qmf, _rmf, _smf, _tmf, _umf, _vmf, _wmf, _xmf, _ymf, _zmf, _anf, _bnf, _cnf, _dnf, _enf, _fnf, _gnf, _hnf, _inf, _jnf, _knf, _lnf, _mnf, _nnf, _onf, _pnf, _qnf, _rnf, _snf, _tnf, _unf, _vnf, _wnf, _xnf, _ynf, _znf, _aof, _bof, _cof, _dof, _eof, _fof, _gof, _hof, _iof, _jof, _kof, _lof, _mof, _nof, _oof, _pof, _qof, _rof, _sof, _tof, _uof, _vof, _wof, _xof, _yof, _zof, _apf, _bpf, _cpf, _dpf, _epf, _fpf, _gpf, _hpf, _ipf, _jpf, _kpf, _lpf, _mpf, _npf, _opf, _ppf, _qpf, _rpf, _spf, _tpf, _upf, _vpf, _wpf, _xpf, _ypf, _zpf, _aqf, _bqf, _cqf, _dqf, _eqf, _fqf, _gqf, _hqf, _iqf, _jqf, _kqf, _lqf, _mqf, _nqf, _oqf, _pqf, _qqf, _rqf, _sqf, _tqf, _uqf, _vqf, _wqf, _xqf, _yqf, _zqf, _arf, _brf, _crf, _drf, _erf, _frf, _grf, _hrf, _irf, _jrf, _krf, _lrf, _mrf, _nrf, _orf, _prf, _qrf, _rrf, _srf, _trf, _urf, _vrf, _wrf, _xrf, _yrf, _zrf, _asf, _bsf, _csf, _dsf, _esf, _fsf, _gsf, _hsf, _isf, _jsf, _ksf, _lsf, _msf, _nsf, _osf, _psf, _qsf, _rsf, _ssf, _tsf, _usf, _vsf, _wsf, _xsf, _ysf, _zsf, _atf, _btf, _ctf, _dtf, _etf})
								end

								_tgf(_shf)
							end

							_ajf[_llf] = _sgf(_mlf)
						end
					end

					_yif += _fjf[_xff[4]]
elseif _gjf == _zff[27] then
					if _qif[_fjf[_xff[1]]] < _qif[_fjf[_xff[6]]] then
						_yif += _fjf[_xff[4]]
					else
						_yif += 1
					end
elseif _gjf == _zff[28] then
					local _ftf = _fjf[_xff[7]]
					_qif[_fjf[_xff[1]]] = _qif[_fjf[_xff[2]]][_ftf]

					_yif += 1                     
else _cgf(_qef[28]) end
else
if _gjf == _zff[29] then
					local _gtf = _nif[_fjf[_xff[2]] + 1]
					_qif[_fjf[_xff[1]]] = _gtf.store[_gtf.index]
elseif _gjf == _zff[30] then
_qif[_fjf[_xff[1]]] = _qif[_fjf[_xff[2]]]
_qif[_fjf[_xff[3]]] = _qif[_fjf[_xff[4]]]
_yif += 1
elseif _gjf == _zff[31] then
					local _htf = _qif[_fjf[_xff[2]]]
					_qif[_fjf[_xff[1]]] = if _htf then _fjf[_xff[7]] or false else _htf
elseif _gjf == _zff[32] then
					if not _qif[_fjf[_xff[1]]] then
						_yif += _fjf[_xff[4]]
					end
else _cgf(_qef[28]) end
end
end
end
else
if _gjf < _zff[49] then
if _gjf < _zff[41] then
if _gjf < _zff[37] then
if _gjf == _zff[33] then
					if _qif[_fjf[_xff[1]]] == _qif[_fjf[_xff[6]]] then
						_yif += _fjf[_xff[4]]
					else
						_yif += 1
					end
elseif _gjf == _zff[34] then
					                                                         

elseif _gjf == _zff[35] then
					_qif[_fjf[_xff[1]]][_fjf[_xff[7]]] = _qif[_fjf[_xff[3]]]
					_yif += 1                    
elseif _gjf == _zff[36] then
					local _itf = _fjf[_xff[7]]
					local _jtf = _fjf[_xff[12]]
					local _ktf = _qif[_fjf[_xff[1]]]

					if (_nhf(_ktf) and (_ktf == _itf)) ~= _jtf then
						_yif += _fjf[_xff[4]]
					else
						_yif += 1
					end
else _cgf(_qef[28]) end
else
if _gjf == _zff[37] then
					               
elseif _gjf == _zff[38] then
					_qif[_fjf[_xff[1]]] = _qif[_fjf[_xff[2]]] * _fjf[_xff[7]]
elseif _gjf == _zff[39] then
					_qif[_fjf[_xff[1]]] = _qif[_fjf[_xff[2]]][_qif[_fjf[_xff[3]]]]
elseif _gjf == _zff[40] then
					local _ltf = _fjf[_xff[1]]

					local _mtf = _qif[_ltf]
					if not _jhf(_mtf) then
						local _ntf = _dgf(_mtf)

						if _ntf == nil then
							_cgf(_qef[31])
						end

						_qif[_ltf] = _ntf
						_mtf = _ntf
					end

					local _otf = _qif[_ltf + 1]
					if not _jhf(_otf) then
						local _ptf = _dgf(_otf)

						if _ptf == nil then
							_cgf(_qef[32])
						end

						_qif[_ltf + 1] = _ptf
						_otf = _ptf
					end

					local _qtf = _qif[_ltf + 2]
					if not _jhf(_qtf) then
						local _rtf = _dgf(_qtf)

						if _rtf == nil then
							_cgf(_qef[33])
						end

						_qif[_ltf + 2] = _rtf
						_qtf = _rtf
					end

					if _otf > 0 then
						if not (_qtf <= _mtf) then
							_yif += _fjf[_xff[4]]
						end
					else
						if not (_mtf <= _qtf) then
							_yif += _fjf[_xff[4]]
						end
					end
else _cgf(_qef[28]) end
end
else
if _gjf < _zff[45] then
if _gjf == _zff[41] then
					local _stf = _qif[_fjf[_xff[2]]]
					_qif[_fjf[_xff[1]]] = if _stf then _stf else _fjf[_xff[7]] or false
elseif _gjf == _zff[42] then
					local _ttf = _fjf[_xff[7]]
					_qif[_fjf[_xff[1]]] = _qif[_fjf[_xff[2]]][_ttf]

					_yif += 1                     
elseif _gjf == _zff[43] then
					                          
					_cgf(_qef[34])
elseif _gjf == _zff[44] then
					local _utf = _fjf[_xff[7]]
					_qif[_fjf[_xff[2]]][_utf] = _qif[_fjf[_xff[1]]]

					_yif += 1                    
else _cgf(_qef[28]) end
else
if _gjf == _zff[45] then
					if _gif then
						_gif(_qif, _pif, _mif, _lif, _nif)	
					end

					local _vtf = _fjf[_xff[1]]
					local _wtf = _fjf[_xff[2]] 
					local _xtf = _wtf - 1
					local _ytf

					if _xtf == _rhf then
						_ytf = _xif - _vtf + 1
					else
						_ytf = _wtf - 1
					end

					return _ngf(_qif, _vtf, _vtf + _ytf - 1)
elseif _gjf == _zff[46] then
					if _qif[_fjf[_xff[1]]] <= _qif[_fjf[_xff[6]]] then
						_yif += _fjf[_xff[4]]
					else
						_yif += 1
					end
elseif _gjf == _zff[47] then
					local _ztf = _fjf[_xff[7]]
					_qif[_fjf[_xff[1]]] = _ztf

					_yif += 1                     
elseif _gjf == _zff[48] then
					local _auf = _nif[_fjf[_xff[2]] + 1]
					_qif[_fjf[_xff[1]]] = _auf.store[_auf.index]
else _cgf(_qef[28]) end
end
end
else
if _gjf < _zff[57] then
if _gjf < _zff[53] then
if _gjf == _zff[49] then
					               
elseif _gjf == _zff[50] then
					if _qif[_fjf[_xff[1]]] <= _qif[_fjf[_xff[6]]] then
						_yif += 1
					else
						_yif += _fjf[_xff[4]]
					end
elseif _gjf == _zff[51] then
					local _buf = _fjf[_xff[7]]
					local _cuf = _fjf[_xff[12]]
					local _duf = _qif[_fjf[_xff[1]]]

					if (_duf == _buf) ~= _cuf then
						_yif += _fjf[_xff[4]]
					else
						_yif += 1
					end
elseif _gjf == _zff[52] then
					_qif[_fjf[_xff[2]]][_qif[_fjf[_xff[3]]]] = _qif[_fjf[_xff[1]]]
else _cgf(_qef[28]) end
else
if _gjf == _zff[53] then
					_qif[_fjf[_xff[1]]] = not _qif[_fjf[_xff[2]]]
elseif _gjf == _zff[54] then
					if _qif[_fjf[_xff[1]]] then
						_yif += _fjf[_xff[4]]
					end
elseif _gjf == _zff[55] then
					_qif[_fjf[_xff[1]]] = _qif[_fjf[_xff[2]]][_qif[_fjf[_xff[3]]]]
elseif _gjf == _zff[56] then
					_qif[_fjf[_xff[1]]] = _qif[_fjf[_xff[2]]] + _qif[_fjf[_xff[3]]]
else _cgf(_qef[28]) end
end
else
if _gjf < _zff[61] then
if _gjf == _zff[57] then
					local _euf = _fjf[_xff[7]]
					local _fuf = _fjf[_xff[12]]
					local _guf = _qif[_fjf[_xff[1]]]

					if (_guf == _euf) ~= _fuf then
						_yif += _fjf[_xff[4]]
					else
						_yif += 1
					end
elseif _gjf == _zff[58] then
					if _gif then
						_gif(_qif, _pif, _mif, _lif, _nif)	
					end

					_yif += _fjf[_xff[5]]
elseif _gjf == _zff[59] then
					for _huf, _iuf in _zif do
						if _iuf.index >= _fjf[_xff[1]] then
							_iuf.value = _iuf.store[_iuf.index]
							_iuf.store = _iuf
							_iuf.index = _qef[29]                    
							_zif[_huf] = nil
						end
					end
elseif _gjf == _zff[60] then
					local _juf = _fjf[_xff[1]]
					local _kuf = _fjf[_xff[2]]

					local _luf = _fjf[_xff[7]]
					
					local _muf = _qif[_kuf]

					_qif[_juf + 1] = _muf
					
					_yif += 1                     
					
					local _nuf = true
					
					                                                   
					local _ouf = _aif.useNativeNamecall

					if _ouf then
						local _puf = _aif.namecallHandler

						local _quf = _sif[_yif]
						local _ruf = _quf[_xff[13]]

						                                       
						local _suf, _tuf, _uuf = _quf[_xff[1]], _quf[_xff[2]], _quf[_xff[3]]

						if _fif then
							_fif(_qif, _pif, _mif, _lif, _nif)
						end

						if _gif then
							_gif(_qif, _pif, _mif, _lif, _nif)	
						end

						local _vuf = if _tuf == 0 then _xif - _suf else _tuf - 1
						local _wuf = _mgf(
							_puf(_luf, _ngf(_qif, _suf + 1, _suf + _vuf))
						)

						if _wuf[1] == true then
							_nuf = false
							
							_yif += if _ruf == 469 then 2 else 1                                    

							_fjf = _quf
							_gjf = _ruf
							_pif.pc = _yif
							_pif.name = _fjf[_xff[14]]

							local _xuf = _wuf.n - 1

							if _uuf == 0 then
								_xif = _suf + _xuf - 1
							else
								_xuf = _uuf - 1
							end

							_lgf(_wuf, 2, _xuf + 1, _suf, _qif)
						end
					end
					
					if _nuf then
						_qif[_juf] = _muf[_luf]
					end
else _cgf(_qef[28]) end
else
if _gjf == _zff[61] then
					local _yuf = _qif[_fjf[_xff[2]]]
					_qif[_fjf[_xff[1]]] = if _yuf then _yuf else _qif[_fjf[_xff[3]]] or false
elseif _gjf == _zff[62] then
					               
elseif _gjf == _zff[63] then
					_qif[_fjf[_xff[1]]] = _qif[_fjf[_xff[2]]]
elseif _gjf == _zff[64] then
					local _zuf, _avf = _fjf[_xff[2]], _fjf[_xff[3]]
					local _bvf, _cvf = _bgf(_rgf, _qif, _qef[35], _zuf, _avf)
	
					if not _bvf then
						_cvf = _qif[_zuf]
	
						for _dvf = _zuf + 1, _avf do
							_cvf ..= _qif[_dvf]
						end
					end

					_qif[_fjf[_xff[1]]] = _cvf
else _cgf(_qef[28]) end
end
end
end
end
else
if _gjf < _zff[97] then
if _gjf < _zff[81] then
if _gjf < _zff[73] then
if _gjf < _zff[69] then
if _gjf == _zff[65] then
					                                                                       
					_yif += _fjf[_xff[4]]                            
elseif _gjf == _zff[66] then
					_qif[_fjf[_xff[1]]] = _fjf[_xff[7]]
elseif _gjf == _zff[67] then
					local _evf = _fjf[_xff[7]]
					_zhf[_evf] = _qif[_fjf[_xff[1]]]

					_yif += 1                    
elseif _gjf == _zff[68] then
					if _qif[_fjf[_xff[1]]] == _qif[_fjf[_xff[6]]] then
						_yif += 1
					else
						_yif += _fjf[_xff[4]]
					end
else _cgf(_qef[28]) end
else
if _gjf == _zff[69] then
					_yif += _fjf[_xff[4]]
elseif _gjf == _zff[70] then
					if not _qif[_fjf[_xff[1]]] then
						_yif += _fjf[_xff[4]]
					end
elseif _gjf == _zff[71] then
					local _fvf = _nif[_fjf[_xff[2]] + 1]
					_qif[_fjf[_xff[1]]] = _fvf.store[_fvf.index]
_qif[_fjf[_xff[3]]] = _qif[_fjf[_xff[1]]]
_yif += 1
elseif _gjf == _zff[72] then
					local _gvf = _fjf[_xff[1]]
					local _hvf = _fjf[_xff[2]]

					local _ivf = _fjf[_xff[7]]
					
					local _jvf = _qif[_hvf]

					_qif[_gvf + 1] = _jvf
					
					_yif += 1                     
					
					local _kvf = true
					
					                                                   
					local _lvf = _aif.useNativeNamecall

					if _lvf then
						local _mvf = _aif.namecallHandler

						local _nvf = _sif[_yif]
						local _ovf = _nvf[_xff[13]]

						                                       
						local _pvf, _qvf, _rvf = _nvf[_xff[1]], _nvf[_xff[2]], _nvf[_xff[3]]

						if _fif then
							_fif(_qif, _pif, _mif, _lif, _nif)
						end

						if _gif then
							_gif(_qif, _pif, _mif, _lif, _nif)	
						end

						local _svf = if _qvf == 0 then _xif - _pvf else _qvf - 1
						local _tvf = _mgf(
							_mvf(_ivf, _ngf(_qif, _pvf + 1, _pvf + _svf))
						)

						if _tvf[1] == true then
							_kvf = false
							
							_yif += if _ovf == 469 then 2 else 1                                    

							_fjf = _nvf
							_gjf = _ovf
							_pif.pc = _yif
							_pif.name = _fjf[_xff[14]]

							local _uvf = _tvf.n - 1

							if _rvf == 0 then
								_xif = _pvf + _uvf - 1
							else
								_uvf = _rvf - 1
							end

							_lgf(_tvf, 2, _uvf + 1, _pvf, _qif)
						end
					end
					
					if _kvf then
						_qif[_gvf] = _jvf[_ivf]
					end
else _cgf(_qef[28]) end
end
else
if _gjf < _zff[77] then
if _gjf == _zff[73] then
					local _vvf = _nif[_fjf[_xff[2]] + 1]
					_vvf.store[_vvf.index] = _qif[_fjf[_xff[1]]]
elseif _gjf == _zff[74] then
					_qif[_fjf[_xff[1]]] = _qif[_fjf[_xff[2]]] + _qif[_fjf[_xff[3]]]
elseif _gjf == _zff[75] then
_qif[_fjf[_xff[1]]] = _qif[_fjf[_xff[2]]] + _qif[_fjf[_xff[3]]]
_qif[_fjf[_xff[4]]] = _qif[_fjf[_xff[1]]]
_yif += 1
elseif _gjf == _zff[76] then
					local _wvf = _bif[_rif[_fjf[_xff[4]] + 1]]

					local _xvf = _wvf.nups
					local _yvf = _ogf(_xvf)
					_qif[_fjf[_xff[1]]] = _kif(_lif, _wvf, _yvf)

					for _zvf = 1, _xvf do
						local _awf = _sif[_yif]

						_yif += 1

						local _bwf = _awf[_xff[1]]

						if _bwf == 0 then           
							local _cwf = {
								value = _qif[_awf[_xff[2]]],
								index = _qef[29],                   
							}
							_cwf.store = _cwf

							_yvf[_zvf] = _cwf
						elseif _bwf == 1 then               
							local _dwf = _awf[_xff[2]]
							local _ewf = _zif[_dwf]

							if _ewf == nil then
								_ewf = {
									index = _dwf,
									store = _qif,
								}
								_zif[_dwf] = _ewf
							end

							_yvf[_zvf] = _ewf
						elseif _bwf == 2 then             
							_yvf[_zvf] = _nif[_awf[_xff[2]] + 1]
						end
					end
else _cgf(_qef[28]) end
else
if _gjf == _zff[77] then
					_qif[_fjf[_xff[1]]] = nil
elseif _gjf == _zff[78] then
					_qif[_fjf[_xff[1]]] = _fjf[_xff[4]]
elseif _gjf == _zff[79] then
					if _gif then
						_gif(_qif, _pif, _mif, _lif, _nif)	
					end

					local _fwf = _fjf[_xff[1]]
					local _gwf = _qif[_fwf]
					local _hwf = _qif[_fwf + 1]
					local _iwf = _qif[_fwf + 2] + _hwf

					_qif[_fwf + 2] = _iwf

					if _hwf > 0 then
						if _iwf <= _gwf then
							_yif += _fjf[_xff[4]]
						end
					else
						if _gwf <= _iwf then
							_yif += _fjf[_xff[4]]
						end
					end
elseif _gjf == _zff[80] then
					_qif[_fjf[_xff[1]]] = _qif[_fjf[_xff[2]]][_fjf[_xff[3]] + 1]
else _cgf(_qef[28]) end
end
end
else
if _gjf < _zff[89] then
if _gjf < _zff[85] then
if _gjf == _zff[81] then
					_qif[_fjf[_xff[1]]] = _qif[_fjf[_xff[2]]] - _fjf[_xff[7]]
elseif _gjf == _zff[82] then
					_qif[_fjf[_xff[1]]] = #_qif[_fjf[_xff[2]]]
elseif _gjf == _zff[83] then
					if _aif.useImportConstants then
						_qif[_fjf[_xff[1]]] = _fjf[_xff[7]]
					else
						local _jwf = _fjf[_xff[11]]
						local _kwf = _fjf[_xff[8]]
						local _lwf = _djf[_kwf] or _zhf[_kwf]
						if _jwf == 1 then
							_qif[_fjf[_xff[1]]] = _lwf
						elseif _jwf == 2 then
							_qif[_fjf[_xff[1]]] = _lwf[_fjf[_xff[9]]]
						elseif _jwf == 3 then
							_qif[_fjf[_xff[1]]] = _lwf[_fjf[_xff[9]]][_fjf[_xff[10]]]
						end
					end

					_yif += 1                     
elseif _gjf == _zff[84] then
					_qif[_fjf[_xff[1]]] = nil
else _cgf(_qef[28]) end
else
if _gjf == _zff[85] then
					local _mwf = _fjf[_xff[1]]
					local _nwf = _fjf[_xff[2]]

					local _owf = _fjf[_xff[7]]
					
					local _pwf = _qif[_nwf]

					_qif[_mwf + 1] = _pwf
					
					_yif += 1                     
					
					local _qwf = true
					
					                                                   
					local _rwf = _aif.useNativeNamecall

					if _rwf then
						local _swf = _aif.namecallHandler

						local _twf = _sif[_yif]
						local _uwf = _twf[_xff[13]]

						                                       
						local _vwf, _wwf, _xwf = _twf[_xff[1]], _twf[_xff[2]], _twf[_xff[3]]

						if _fif then
							_fif(_qif, _pif, _mif, _lif, _nif)
						end

						if _gif then
							_gif(_qif, _pif, _mif, _lif, _nif)	
						end

						local _ywf = if _wwf == 0 then _xif - _vwf else _wwf - 1
						local _zwf = _mgf(
							_swf(_owf, _ngf(_qif, _vwf + 1, _vwf + _ywf))
						)

						if _zwf[1] == true then
							_qwf = false
							
							_yif += if _uwf == 469 then 2 else 1                                    

							_fjf = _twf
							_gjf = _uwf
							_pif.pc = _yif
							_pif.name = _fjf[_xff[14]]

							local _axf = _zwf.n - 1

							if _xwf == 0 then
								_xif = _vwf + _axf - 1
							else
								_axf = _xwf - 1
							end

							_lgf(_zwf, 2, _axf + 1, _vwf, _qif)
						end
					end
					
					if _qwf then
						_qif[_mwf] = _pwf[_owf]
					end
elseif _gjf == _zff[86] then
					local _bxf = _nif[_fjf[_xff[2]] + 1]
					_qif[_fjf[_xff[1]]] = _bxf.store[_bxf.index]
local _cxf = _nif[_fjf[_xff[4]] + 1]
_qif[_fjf[_xff[3]]] = _cxf.store[_cxf.index]
_yif += 1
elseif _gjf == _zff[87] then
					local _dxf = _fjf[_xff[12]]

					if (_qif[_fjf[_xff[1]]] == nil) ~= _dxf then
						_yif += _fjf[_xff[4]]
					else
						_yif += 1
					end
elseif _gjf == _zff[88] then
					if _gjf == 469 then
						_yif += 1                    
					end
					if _gif then
						_gif(_qif, _pif, _mif, _lif, _nif)	
					end

					local _exf, _fxf, _gxf = _fjf[_xff[1]], _fjf[_xff[2]], _fjf[_xff[3]]

					local _hxf = if _fxf == 0 then _xif - _exf else _fxf - 1
					local _ixf = _qif[_exf]
					local _jxf = _mgf(
						_ixf(_ngf(_qif, _exf + 1, _exf + _hxf))
					)

					local _kxf = _jxf.n

					if _gxf == 0 then
						_xif = _exf + _kxf - 1
					else
						_kxf = _gxf - 1
					end

					_lgf(_jxf, 1, _kxf, _exf, _qif)
else _cgf(_qef[28]) end
end
else
if _gjf < _zff[93] then
if _gjf == _zff[89] then
					local _lxf = _qif[_fjf[_xff[2]]]
					_qif[_fjf[_xff[1]]] = if _lxf then _qif[_fjf[_xff[3]]] or false else _lxf
elseif _gjf == _zff[90] then
					if _aif.useImportConstants then
						_qif[_fjf[_xff[1]]] = _fjf[_xff[7]]
					else
						local _mxf = _fjf[_xff[11]]
						local _nxf = _fjf[_xff[8]]
						local _oxf = _djf[_nxf] or _zhf[_nxf]
						if _mxf == 1 then
							_qif[_fjf[_xff[1]]] = _oxf
						elseif _mxf == 2 then
							_qif[_fjf[_xff[1]]] = _oxf[_fjf[_xff[9]]]
						elseif _mxf == 3 then
							_qif[_fjf[_xff[1]]] = _oxf[_fjf[_xff[9]]][_fjf[_xff[10]]]
						end
					end

					_yif += 1                     
elseif _gjf == _zff[91] then
					if not _phf(_qif[_fjf[_xff[1]]]) then
						_cgf(_hgf(_qef[30], _agf(_qif[_fjf[_xff[1]]])))                                                 
					end

					_yif += _fjf[_xff[4]]
elseif _gjf == _zff[92] then
					_qif[_fjf[_xff[1]]] = _qif[_fjf[_xff[2]]] % _qif[_fjf[_xff[3]]]
else _cgf(_qef[28]) end
else
if _gjf == _zff[93] then
					_qif[_fjf[_xff[1]]] = _fjf[_xff[4]]
elseif _gjf == _zff[94] then
					               
					_yif += 1                    
elseif _gjf == _zff[95] then
					_qif[_fjf[_xff[1]]] = _qif[_fjf[_xff[2]]]
elseif _gjf == _zff[96] then
					                          
else _cgf(_qef[28]) end
end
end
end
else
if _gjf < _zff[113] then
if _gjf < _zff[105] then
if _gjf < _zff[101] then
if _gjf == _zff[97] then
					_qif[_fjf[_xff[1]]] = _qif[_fjf[_xff[2]]] - _qif[_fjf[_xff[3]]]
elseif _gjf == _zff[98] then
					_qif[_fjf[_xff[1]]] = _fjf[_xff[2]] == 1
					_yif += _fjf[_xff[3]]
elseif _gjf == _zff[99] then
					if _gif then
						_gif(_qif, _pif, _mif, _lif, _nif)	
					end

					local _pxf = _fjf[_xff[1]]
					local _qxf = _fjf[_xff[7]]

					_xif = _pxf + 6

					local _rxf = _qif[_pxf]

					if (_aif.generalizedIteration == false) or _phf(_rxf) then 
						local _sxf = { _rxf(_qif[_pxf + 1], _qif[_pxf + 2]) }
						_lgf(_sxf, 1, _qxf, _pxf + 3, _qif)

						if _qif[_pxf + 3] ~= nil then
							_qif[_pxf + 2] = _qif[_pxf + 3]
							_yif += _fjf[_xff[4]]
						else
							_yif += 1
						end
					else
						local _txf, _uxf = _ugf(_ajf[_fjf], _rxf, _qif[_pxf + 1], _qif[_pxf + 2])
						if not _txf then
							_cgf(_uxf)
						end
						if _uxf == _shf then 
							_ajf[_fjf] = nil
							_yif += 1
						else
							_lgf(_uxf, 1, _qxf, _pxf + 3, _qif)

							_qif[_pxf + 2] = _qif[_pxf + 3]
							_yif += _fjf[_xff[4]]
						end
					end
elseif _gjf == _zff[100] then
					if _gjf == 469 then
						_yif += 1                    
					end
					if _gif then
						_gif(_qif, _pif, _mif, _lif, _nif)	
					end

					local _vxf, _wxf, _xxf = _fjf[_xff[1]], _fjf[_xff[2]], _fjf[_xff[3]]

					local _yxf = if _wxf == 0 then _xif - _vxf else _wxf - 1
					local _zxf = _qif[_vxf]
					local _ayf = _mgf(
						_zxf(_ngf(_qif, _vxf + 1, _vxf + _yxf))
					)

					local _byf = _ayf.n

					if _xxf == 0 then
						_xif = _vxf + _byf - 1
					else
						_byf = _xxf - 1
					end

					_lgf(_ayf, 1, _byf, _vxf, _qif)
else _cgf(_qef[28]) end
else
if _gjf == _zff[101] then
					local _cyf = _fjf[_xff[7]]
					_qif[_fjf[_xff[2]]][_cyf] = _qif[_fjf[_xff[1]]]

					_yif += 1                    
elseif _gjf == _zff[102] then
					_qif[_fjf[_xff[1]]] = _fjf[_xff[7]] / _qif[_fjf[_xff[3]]]
elseif _gjf == _zff[103] then
					_yif += _fjf[_xff[4]]
elseif _gjf == _zff[104] then
					_qif[_fjf[_xff[1]]] = _qif[_fjf[_xff[2]]] + _fjf[_xff[7]]
else _cgf(_qef[28]) end
end
else
if _gjf < _zff[109] then
if _gjf == _zff[105] then
					if not _qif[_fjf[_xff[1]]] then
						_yif += _fjf[_xff[4]]
					end
elseif _gjf == _zff[106] then
					_qif[_fjf[_xff[1]]] = _qif[_fjf[_xff[2]]] * _qif[_fjf[_xff[3]]]
elseif _gjf == _zff[107] then
					_qif[_fjf[_xff[1]]] = _qif[_fjf[_xff[2]]] + _qif[_fjf[_xff[3]]]
elseif _gjf == _zff[108] then
					if _gif then
						_gif(_qif, _pif, _mif, _lif, _nif)	
					end

					local _dyf = _fjf[_xff[1]]
					local _eyf = _fjf[_xff[2]] 
					local _fyf = _eyf - 1
					local _gyf

					if _fyf == _rhf then
						_gyf = _xif - _dyf + 1
					else
						_gyf = _eyf - 1
					end

					return _ngf(_qif, _dyf, _dyf + _gyf - 1)
else _cgf(_qef[28]) end
else
if _gjf == _zff[109] then
					if _qif[_fjf[_xff[1]]] then
						_yif += _fjf[_xff[4]]
					end
elseif _gjf == _zff[110] then
_qif[_fjf[_xff[1]]] = nil
_qif[_fjf[_xff[2]]] = nil
_yif += 1
elseif _gjf == _zff[111] then
					_qif[_fjf[_xff[1]]] = _qif[_fjf[_xff[2]]] // _qif[_fjf[_xff[3]]]
elseif _gjf == _zff[112] then
					if _gif then
						_gif(_qif, _pif, _mif, _lif, _nif)	
					end

					_yif += _fjf[_xff[4]]
else _cgf(_qef[28]) end
end
end
else
if _gjf < _zff[121] then
if _gjf < _zff[117] then
if _gjf == _zff[113] then
					if _qif[_fjf[_xff[1]]] < _qif[_fjf[_xff[6]]] then
						_yif += 1
					else
						_yif += _fjf[_xff[4]]
					end
elseif _gjf == _zff[114] then
					local _hyf = _fjf[_xff[7]]
					_qif[_fjf[_xff[1]]] = _qif[_fjf[_xff[2]]][_hyf]

					_yif += 1                     
elseif _gjf == _zff[115] then
					if _aif.useImportConstants then
						_qif[_fjf[_xff[1]]] = _fjf[_xff[7]]
					else
						local _iyf = _fjf[_xff[11]]
						local _jyf = _fjf[_xff[8]]
						local _kyf = _djf[_jyf] or _zhf[_jyf]
						if _iyf == 1 then
							_qif[_fjf[_xff[1]]] = _kyf
						elseif _iyf == 2 then
							_qif[_fjf[_xff[1]]] = _kyf[_fjf[_xff[9]]]
						elseif _iyf == 3 then
							_qif[_fjf[_xff[1]]] = _kyf[_fjf[_xff[9]]][_fjf[_xff[10]]]
						end
					end

					_yif += 1                     
elseif _gjf == _zff[116] then
					_qif[_fjf[_xff[1]]] = _qif[_fjf[_xff[2]]][_qif[_fjf[_xff[3]]]]
else _cgf(_qef[28]) end
else
if _gjf == _zff[117] then
					_qif[_fjf[_xff[1]]] = -_qif[_fjf[_xff[2]]]
elseif _gjf == _zff[118] then
					_qif[_fjf[_xff[1]]] = _qif[_fjf[_xff[2]]] ^ _qif[_fjf[_xff[3]]]
elseif _gjf == _zff[119] then
_qif[_fjf[_xff[1]]] = _fjf[_xff[4]]
_qif[_fjf[_xff[2]]] = _fjf[_xff[5]]
_yif += 1
elseif _gjf == _zff[120] then
					_qif[_fjf[_xff[1]]] = _qif[_fjf[_xff[2]]]
else _cgf(_qef[28]) end
end
else
if _gjf < _zff[125] then
if _gjf == _zff[121] then
					_qif[_fjf[_xff[1]]] = _qif[_fjf[_xff[2]]] / _fjf[_xff[7]]
elseif _gjf == _zff[122] then
_qif[_fjf[_xff[1]]] = _fjf[_xff[8]]
_qif[_fjf[_xff[2]]] = _fjf[_xff[9]]
_yif += 1
elseif _gjf == _zff[123] then
					if _gjf == 469 then
						_yif += 1                    
					end
					if _gif then
						_gif(_qif, _pif, _mif, _lif, _nif)	
					end

					local _lyf, _myf, _nyf = _fjf[_xff[1]], _fjf[_xff[2]], _fjf[_xff[3]]

					local _oyf = if _myf == 0 then _xif - _lyf else _myf - 1
					local _pyf = _qif[_lyf]
					local _qyf = _mgf(
						_pyf(_ngf(_qif, _lyf + 1, _lyf + _oyf))
					)

					local _ryf = _qyf.n

					if _nyf == 0 then
						_xif = _lyf + _ryf - 1
					else
						_ryf = _nyf - 1
					end

					_lgf(_qyf, 1, _ryf, _lyf, _qif)
elseif _gjf == _zff[124] then
					if _gif then
						_gif(_qif, _pif, _mif, _lif, _nif)	
					end

					local _syf = _fjf[_xff[1]]
					local _tyf = _fjf[_xff[2]] 
					local _uyf = _tyf - 1
					local _vyf

					if _uyf == _rhf then
						_vyf = _xif - _syf + 1
					else
						_vyf = _tyf - 1
					end

					return _ngf(_qif, _syf, _syf + _vyf - 1)
else _cgf(_qef[28]) end
else
if _gjf < _zff[127] then
if _gjf == _zff[125] then
					if _gjf == 469 then
						_yif += 1                    
					end
					if _gif then
						_gif(_qif, _pif, _mif, _lif, _nif)	
					end

					local _wyf, _xyf, _yyf = _fjf[_xff[1]], _fjf[_xff[2]], _fjf[_xff[3]]

					local _zyf = if _xyf == 0 then _xif - _wyf else _xyf - 1
					local _azf = _qif[_wyf]
					local _bzf = _mgf(
						_azf(_ngf(_qif, _wyf + 1, _wyf + _zyf))
					)

					local _czf = _bzf.n

					if _yyf == 0 then
						_xif = _wyf + _czf - 1
					else
						_czf = _yyf - 1
					end

					_lgf(_bzf, 1, _czf, _wyf, _qif)
elseif _gjf == _zff[126] then
					local _dzf = _fjf[_xff[7]]
					local _ezf = {}
					if _dzf[1] == -1 then
						for _fzf = 2, #_dzf, 2 do
							local _gzf = _dzf[_fzf + 1]
							_ezf[_bjf[_dzf[_fzf] + 1]] = if _gzf >= 0 then _bjf[_gzf + 1] else nil
						end
					else
						for _hzf, _izf in _dzf do
							_ezf[_bjf[_izf + 1]] = nil
						end
					end
					_qif[_fjf[_xff[1]]] = _ezf
else _cgf(_qef[28]) end
else
if _gjf == _zff[127] then
				    local _jzf = _qif[_fjf[_xff[2]]]
				    local _kzf = _fjf[_xff[7]]
				
				    if _agf(_jzf) == _qef[4] then
				        if _kzf == 2 then
				            _qif[_fjf[_xff[1]]] = _jzf * _jzf
				        elseif _kzf == 0.5 then
				            _qif[_fjf[_xff[1]]] = _jgf(_jzf)
				        elseif _kzf == 3 then
				            _qif[_fjf[_xff[1]]] = _jzf * _jzf * _jzf
				        else
				            _qif[_fjf[_xff[1]]] = _jzf ^ _kzf
				        end
				    else
				        _qif[_fjf[_xff[1]]] = _jzf ^ _kzf
				    end
elseif _gjf == _zff[128] then
					_yif += _fjf[_xff[4]]
elseif _gjf == _zff[129] then
					if _aif.useImportConstants then
						_qif[_fjf[_xff[1]]] = _fjf[_xff[12]]
					else
						local _lzf = _fjf[_xff[11]]
						local _mzf = _fjf[_xff[8]]
						local _nzf = _djf[_mzf] or _zhf[_mzf]
						if _lzf == 1 then
							_qif[_fjf[_xff[1]]] = _nzf
						elseif _lzf == 2 then
							_qif[_fjf[_xff[1]]] = _nzf[_fjf[_xff[9]]]
						elseif _lzf == 3 then
							_qif[_fjf[_xff[1]]] = _nzf[_fjf[_xff[9]]][_fjf[_xff[10]]]
						end
					end

					_yif += 1                     

_qif[_fjf[_xff[2]]] = _qif[_fjf[_xff[3]]][_fjf[_xff[7]]]
_yif += 2
else _cgf(_qef[28]) end
end
end
end
end
end
end
				_hjf = _uef(_hjf + _gjf + _yif + 1)
				_ijf = _ref(_yif, _hjf)
				if not _ejf then _fjf = nil end
			end

			for _ozf, _pzf in _zif do
				_pzf.value = _pzf.store[_pzf.index]
				_pzf.store = _pzf
				_pzf.index = _qef[29]                    
				_zif[_ozf] = nil
			end

			for _qzf, _rzf in _ajf do 
				_vgf(_rzf)
				_ajf[_qzf] = nil
			end
		end

		local function _szf(...)
			local _tzf = _mgf(...)
			local _uzf = _ogf(_mif.maxstacksize)
			local _vzf = {
				len = 0,
				list = {},
			}

			_lgf(_tzf, 1, _mif.numparams, 0, _uzf)

			if _mif.numparams < _tzf.n then
				local _wzf = _mif.numparams + 1
				local _xzf = _tzf.n - _mif.numparams
				_vzf.len = _xzf
				_lgf(_tzf, _wzf, _wzf + _xzf - 1, 1, _vzf.list)
			end

			_tzf = nil

			local _yzf = {pc = 0, name = _qef[24]}
			local _zzf
			if _aif.errorHandling then 
				_zzf = _mgf(_bgf(_oif, _yzf, _uzf, _mif.protos, _mif.code, _vzf))
			else
				_zzf = _mgf(true, _oif(_yzf, _uzf, _mif.protos, _mif.code, _vzf))
			end

			if _zzf[1] then
				return _ngf(_zzf, 2, _zzf.n)
			else
				local _aag = _zzf[2]

				if _hif then
					_hif(_aag, _uzf, _yzf, _mif, _lif, _nif)
				end

				if _lhf(_aag) == false then
					if _aif.allowProxyErrors then
						_cgf(_aag)
					else 
						_aag = _agf(_aag)
					end
				end

				if _mif.lineinfoenabled then
					return _cgf(_hgf(_qef[36], _mif.debugname, _mif.instructionlineinfo[_yzf.pc], _yzf.pc, _yzf.name, _aag), 0)
				else 
					return _cgf(_hgf(_qef[37], _mif.debugname, _yzf.pc, _yzf.name, _aag), 0)
				end
			end
		end

		if _aif.errorHandling then
			return _szf
		else
			return _oif
		end
	end

	return _kif(_yhf, _cif),  _jif
end

return {
	luau_newsettings = _thf,
	luau_validatesettings = _vhf,
	luau_load = _xhf,
}

end)()
local _bag = _qef[38]
local _cag = {}
for _dag = 1, #_bag do
    _cag[string.byte(_bag, _dag)] = _dag - 1
end
local function _eag(_fag, _gag, _hag, _iag)
    local _jag = buffer.create(_hag)
    local _kag, _lag, _mag, _nag, _oag = 0, 0, 0, 1, 0
    local _pag, _qag, _rag, _sag = string.byte, buffer.writeu8, bit32.bxor, math.floor
    for _tag, _uag in ipairs(_fag) do
        for _vag = 1, #_uag do
            _lag = _lag * 64 + _cag[_pag(_uag, _vag)]
            _kag += 6
            if _kag >= 8 then
                _kag -= 8
                local _wag = 2 ^ _kag
                _gag = _gag * 48271 % 65521
                local _xag = _rag(_sag(_lag / _wag), _gag % 256)
                _qag(_jag, _mag, _xag)
                _nag = (_nag + _xag) % 65521
                _oag = (_oag + _nag) % 65521
                _mag += 1
                _lag %= _wag
            end
        end
    end
    assert(_mag == _hag and _oag * 65536 + _nag == _iag, _qef[39])
    return _jag
end
                              
local _yag = {
[53] = {{
"TXtA1p8hAy5MP4Q4WvHgKuY25ZCRDg8hnj+S7eClAsDALJPM82fZmvF47VYSpfJTK7aAraypNsxgNmMRO8juvRpcUL3y/rk8iihtAiZbDbJ0t1QMnEyMsnJWLLn187Flyka+TZq+5c/smFY/8HSL/EfEp8DlfLKyfLoCR54Yr3cyXjTj3KKqN0/rsGz5FPAHhEbVBYjRcYInhUjUC+JrN8Cn5amACRbGtJ2/4/75znhck3VcpsLeRheATeZIPzEmeP1W3BVeYZbatR7Euu5HMHVFevECfoVcAUYbMMfVqNu1afQNKFkSdWBX/utnzkB1NNrJBflrzE7YPkLjdV6Q+NYoF2k4",
},31373,261,3334237041,2228846266},
[22] = {{
"OD87ZuN2oL/0d4F76sC+8YlOv/gJrdb0W7lnVgR7ggvx5TZ8ue9fvOGvSmrv6UElzXk+uUKzbPyCBn11jN1SIY9VxO7WhW3KGTMvk+tAJ3ZR0/f4FIq4x5q988GSWNk67MiiIAyJFDkl",
},63580,105,4193395866,673224935},
[17] = {{
"D5p8b9ws8q5ij2HVJHu4nyLHz1KX2kUfCKHPe/Fcuj+d0qFHXqb39EJ31GBIzogqmA3g29RTbW1DS/xGJuOTYWDNmrZ8VeUywwGHJzA03NuDBoIj4B3ye8jP56e7DUm9ArxzyuymudexLPrArAY+KCXuT/hLPf5TqoiEZhubw2whg9h5JACLEzzZzG0DbZQNGWGj3R/2uMGquAll1/Q4Qg3TbIofw/vgFEmmfqvFMyVvzRJAUvWveH5J3Sx2ix6kCRYB75VPmIUg8jnrjHbIt3jm3Bz5M/qitEI7TDW9x34VKFF",
},4607,227,3445052308,288276551},
[44] = {{
"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",
},34781,2064,2722866499,3697169357},
[25] = {{
"v/b8bXVd115Kwvrbz9BN9gIcN+MPgJ3c3urTxi7zxPLmw3IN67Kf6EZN6KEjH/Q99w8+qLNw5a6QamacJnlssZtAI/J6UOjmvoaa1DL1ZarQtZy+TXC5p+NSDjvSlI9oOkxl8K2yeY/gop5tssWmuJ5PdlLJ0XCvWQxtvVKatWe3YdSD9JUHdt7XpMhun07rp+/RMEB5KUZYOWa2eg+o1Lo04UnzyeLhIBZyKl4Ev1AXS6eEwAFMbS10IPTcfA+/s3lt0lStZP3sp4ZBpanqhKW6IA4SsJFKJJ2Duep71y09/vdhCC2tbbd5PQaP7N0twPeJ/75OGSVxbzHqwy7LEPDb+QR66piMD69lj8CM7r9W1BSgwQjYCCHUx5t9f3VK1Rh6SZjl5j4jtsMkmnDLkOHKdiNnvYtul0IGfDyRX1VRgXMP/rCuYpJqorazZouHKbqm+lP8JX6Kmw9JRsrJArVQO7jNUduZBmgMeUn6QL+qDhMZNEJJl8mQ0JhGTuZIWEH/fGU4MnH54IDY3PajbeLUBAPCtujwet0LMBjy2FXFdCgXVdrpOLLfbYwXN4P/5u+QFry58f1dUQMxMk0ZtAvgojyKwYBGROyBxM2BCz8r6PW/7HVE5FS3y08vL4oaApNwaggnvvwoD+1YikvcNQpB0z+ZQ/pourR711kWMDLcDXUG3mln3khKTE1OdSngn/CBBUzJgqYQOscSWxgOb/iioW10HFA9Q52m7Qb3FfoOhr/Rm8VmZ8N5gEW7cN",
},17674,574,2210264557,2673752213},
[16] = {{
"hjTSxsY6pv3ZxUlb5q7hMtGWePDuvlkqLoT8qZFp+Ik6phTMYZStZHbgh15Oib4ofm70wnH8lkCSTRCABdQwfGUVb3LpxLwkUX79SDW7zwk8ns6OwEVxLNwmOf4U4OpZXhMG7jQbbuea0Q4fu35TbYCFcSpt0wu9FcjKi8L+oVzJ9880tOoxGt3MDgpmepa8MMHWI9wrvrv0cLM9Rrw1HRs3MJ8PskE4ITlsIVw+DpMW60LOcwLvAyhH0zvRWtDgCwBus0nJQdzgxZOgUHUsvJngfbByogSktZinOojWxYojTPHEQ6oaKCIA3ZAKqNMvKPGJKVI2/a8t0uYA4zq0Chtxxp0pQFWalKwyPmDySsQWDH9iQrUUNsZhWwpHX4SR2S4O/0SNA8e3kQBrvoRrGK8sfhR5eWEPwBLZVkUyyrZybrufBQX1+Ol5FNtFFJNz9et0MB8cVXYEe5eyZ3BZA1xJuL7+3KC8fon9ORUbHNGd2U8ZvWmbnpLUcPje3bZsHUf8CocCl6i30LzJ0NhAtq/IWgqKprZQWxdB2FjhZiK99FzK4ppu/tYA0AJH",
},50334,429,2645604194,87982307},
[8] = {{
"P1wBUhG4IUzzMrRKvUfLNdx5HRIcpaKkjTf53PdYKvPZCr0OuX8SD4jsZ37BuXahExyhRVNyY7lboCXRd5JWi8Dj2s0LDUAjQcJCE44EsOJU+rfSId5SIGuO/RQi+sDjETW/YXRhpZ2/ihnektbeQ184tHSTr+tfgDRRffcguiU3MmvT885BL1JLmYCaj73tNqOWXgAj9CGj/D92AoMKP3+0fWDvaDaTQnM6ow3IIClL+Ibq7A+LtDi4qGV078wmfs5kySzOZQGzGFVCRIbAuAwMmO+ZmKUBL1+n2qr18P+In5iHaCFJcfBh9+5CyLanIQtlnKYW2OVz9YH+e2Pr7VSJeJtf4YjZ1H6fhI48M+vW19mazlCRjWKdb1FNWO5SJveYg2Lf30y2PsN3KdB4NQVFUBC//OrMfXmDe3w0EUPpZ3rg1BHKWrZHVWhHYsRaXr4WOV2FUhxDrnB6WatxnYaH2RBJEg9CrQrJkoflAz/x7U20xQu71hzf/98eulumMGHCxvaXwu98qPewEyCHI+N9/J+waxL+3GygrUnl6KDUoTeRS7uNdiCHvw82M8TL8ORV2jOyzXV8BDf8",
},61504,444,644660481,4100543011},
[37] = {{
"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",
},28030,3532,1072057615,4139765832},
[9] = {{
"6qYBGPauXICHdhf2Vj7VIa78rf82JxkoTr8uj0RX1Joiis+eA1tkTdHfYWMpjAuvg4E5m+CAqOOce8QLGfrEK9nthH3pp9G5t3oqO9lj9FXoD53R/yfCL+Lbhu5M9uarehhXf2enpbNsu0lB4648wvibW8UoEbnfUegUevQ4lW7Igs142wOkuqdwDkydwK3WKShvESMl/yd3Nw3fwi2zk/vidWynId7rhoTMqf/LIltnZSUcbxil9GlyS2jTS3metZodTXNSiy+6GZ1b8qWQ+O8moCCq4kl5m1AbIIO9FUM6ty8iql3/yDQ9SXYe/SP6X6mg91oh2Ch3DUQpgi4h9NO2u+mX/YD2UYFX/PAV8uZQUU664rTFmfvwkvbIX5RU9C0MAL+JEI8HjrHuNAdmLnsm0KKrN3",
},51920,310,2830205283,256745987},
[20] = {{
"i+htTWAq8hiI/ye8eu3VL4fuCgVwWxCRRTZghjxUh7BcpuIFTUfjd22aR3DV9Y8Bb9MRMOJARNafMEt5btRdWcLMuDjrVyaCyF+",
},15408,74,2943491309,976209651},
[42] = {{
"s91eIEkJsu6wmDjiFMlwcWayhE+nv606CyEQlnUqUMEnwKHghMSSzqfc63X+ElLPg2cXVv1e+7U5MfmVBJaS/Ynyr+Y+88jfywvyGmAhWqcylHhQGBsrUfLNyJjPMFyv1qWQgOIPZIST5v/DcBK1hmwWkdl/YKJAMcYkNBJv3r47ANvk79cpW0W5Oc0DzPyuDO4efitLc8URbaEATiyeeZ/KPGv4tzqF5bMMfwlXsMr/DE5mqbzMzC/D5tl6miKJHx90rIr6+pi+s3e7NUprBSsV+mCjvp0s8qVmjVyliE+ZukX9VuvKF770l98KDM2x1n9rEWQvaW/vz1z9SXxEJ5DRPnx7UOsxnGfPuufDVphOzUZb/6Zhy/sQEKh9QG8BgL260NyePPpGD4KSNlNwt/ri3lQhBKXZNp7bLlZIguhUQxfAX9898EcP1tpOuweFf3h3OdOyGQ2IIUtJWpfnqlDB/L7CIxFwKIZv6xTy0QPzJpqtACVk4mtvj1gQ6UUjr9eOa/WLXsi6kCKlr1+UKk5KpvSmmuVfUnWhAhLxaAjFrEpujMYlJXsguGFDpW5GUT4CS3qHEgL1apHmLgkJDG/UniE5TnSpv5epzbIvALxXSzQ5/yymSgF1T460Oug/IZFr1ytdGOMw/jpqCDgoEcSZv1JypWr/HPeglBdhNk/EXIyaB94SICoamML4rLcNKg249vOiFEQvkPvOW4aSfdkuKgPuLACdlA3xh+keJGNZ/DfPT5SAtiYTQNOeAdcjd1DVWhg+F1chsUw56nwCjIhNncRiHj/poX8tXWk60eClN8r5LH+/QM4N4d/oEYlfZsINaDJ1chukLn9",
},34494,635,183704466,4281935330},
[18] = {{
"/Vf2a46clNEvhkhpjsFx+JqPyWmLPMPjIPIKsA8pJxUVL5kpawFGVH2g/NqHen01uokQ/tGjvJCX2GoLefUGq5upbyhwdYByPL7qyHgyOYZdi2He/ZQ3YdPANbU2lDA+zBSTukts8yf8wd4",
},38271,107,3368952596,3002918979},
[10] = {{
"KwwHHbAT/EP5E1SQMd+25CMCSDzMb3wsrTTwr7Xio0pEptq4Q9yEqL8QYBzX+P1r/WqFmG0RrI5kC0Hpw4KtxnmZDTY0PH8UsZhmv84z6SgNuDOtNWYPmlVqCEUAXJ93u7FMWScCwyf5EUySy4Y48SCcYyKB0vaTwdqohY5gr1VgTjGlzQt+WRx0c8xvuauR1FeAOYR1Bokk+5emRaLqXGndULoC24mInrq1i4zy+X7cTi3h6Gl8G2fFVnnNuuaO8l+gl+QO1UnarA48xsVavpHLgL/4gSUQx4nHITYkVynZ8jpiHzqFN2pctL03alP653mBn2s/TOsyGnXG691UsXtAOgb7tU8SbjkFkk/AFVl295yFFH0IlCNdeaB9kWnnX26YAhIT1k/5xNN7sTQJvbm3Jpwf+yTfOySn2+vBkppgnLB+vrMqDLXq6iF+0ubLJq6VJVt8EPW7AmkAg8JhkkdU46s1LvNjgK27cpe8Z+hb0q7lA6ValmT8OGvXJF/hljys2OM4POcH64aQ/Ro6Fw9arwhzn7sOQSGHOBO88xPxTrR4dwFFqfgA4nS8kjLkkolm+cpv9Iae38IMhb0t9LnrXt/zgdpMRBQw1lvpzWuie+9IS+6cJLsqHcNcxdoTuNVAGPy2yR5+i4WCsqVeH2wk7uPPwwPpgEGgvZ7DNW7c1j3A8l/AB9yr6EabHykh0RnLwv0bJfUEqZKfpbCEnPdobXHOidkBKEmkJ7aE4r0GyOjAESHSLqxvhlGtvvSs7uqxMcP5jc3o8LPO72ExZBjWiS/q8jPzhPO1PKiTo9yid3GZuyX0eWOvVuen6Zcm7wgn9YBk+2Kz7LyiER4cRztIaWmWGH+Ps3jdPsmU0Z83ZF+aDHM8oNNMu01hWSeA/OPUuYUS0XaQ3L6L2j8i3oLzDviaWlJwO5DVuVEJSHHJuGUK6Meu0j8BBHmfWYoDe3Jm99kqJt/l/ihqk5yfWtYUyrP+VyZf4kvmGIfAW2Jt3uyoaBiBKpDAMs3G1Foymaoa9V86i+7NGXVr9nmnJFs5KpYKyB6IJog0ecKz3zArGdV6wygL17UsO0wuNCn7OkI/IE4Ocd/ZDT2GH0+kXMH1Qv5oGeZoz9",
},30327,841,4163591238,413900714},
[21] = {{
"eegGiQ80ABRkPqiQW9",
},8214,13,77136238,3770042894},
[40] = {{
"OggbyS0+sn0fl/8BKb++jV//UxhVmyIbXyPZ5f/k986qYuB2johPvpP3VFtMxmTP3eeIg7YWVS0mKvgSTubLTYuqpej/ygLqyRc/EB4GlyQe4k91DpUC6HadxmhbeODVmJXmFqxJhZBFjY24unmwylAOHs3T+bEQ0+Aft88Sjh/cAFFt1K1f8dR5F/pzd43DmrFG/RpE5QgefwMJmqOlWnD/RLtsp4zeuVPM3KM6oPglQrLzJT+uwAwifyf34WZYEw9UgnUVd537Q/K+u0PM59R0Ial7SC+EdeIOaTWJMAU7pk4hTK1Y9jap2jEm2rpT8yTYSCWjJGNg4zTcc4eKO9zZsfreeqESJplFswsK0uB5y5YmYBG2YW9LNoeFfgKt+Dg744JWM6HnTOZt3yqDUGebTnigOkUj7+LNGxFQz8iPo5DRtoiceyrrzP+NZEeo+X400oUl1QKtYc7B2RA6w9LJ4p5UbSXL15ZpvW1+o2sotuA4WVOgPXNgxYX+HyWdIfSaYl8UKq4smfvg3p254sLMXeBNd1QRPq/q6nJy1pxrUJFxI+dwRGx7bzc+LwtW1c9kSKfEvt4/WhXI0cR3ekQQ/THstGkDnXDzdNnxTtTMYjXZyQKI8ev7M4xgnv920C6NpJ6dklHe+QcbKl7YXgay1i8tObp5w/9y+u5xY25YeSfLHRSKJP8Vmq/7sU4x5lCqwU0vYqCCfy2AJKf9TCFDEY9/kLTJzT8b1fBp5rAq+vqkyPyFWkB1kmxHx9cyB0gf94neRjBWYh3/x9CVpkEXgTr5MEA/Exf+Z91K6iCYLS3Yw1h1VkY1XfzBbwgs9FTqzPzPs27/tnEYXUUhh8RV7TX1hhfv70U1SBfzpKlkL8EP6w7cBC52Cs0ruIVW5qxiGlsQI5xkJwXuB+F8or43K0vuas3mPs6ej0J3/LhYBiagGu+P2xQXVQ7ktLkFITbJtVY6EiUealSULxosZLnADhcq0BHGh5ElLFwTCkLv+pOjlJOKqvjQU7RMbENzswnlovHNOVQ5qqy4qkvQFMA8HPu2H1prxOvgbO4",
},9296,797,3376304050,2759666963},
[47] = {{
"uO1184tTRYD7wsb/ApoyajtJHzlv+HuLXaQG0B8nq/BuNy14E9EwrCtkf2PHEcDQf7hhlfcP11j+YVTvunWJiyRZSvQoBtVhMMwGF3RGF3",
},20704,79,3107135390,1420258257},
[31] = {{
"a8pOrrCvujyr1gtWwMVi7Q2n6CyOpG/Quqwkm9Qra5qe3pe/b3QszqO0gaourAuPTyg216HUr7xe/GXEErjIXT7YYGDogTO4MvzCqijGhpLpRp4hi1innRUDv7iVxeNAuf6CcKvbaqF6EsM/yxEWnQoTl6H+M4WQtbdCxlyhyRaSo47t7+9niOspoO3dv5+FV+fvu4jkUgXp9MzUbxBQixLdNn5LeOpvSQMnkK9RHd7yoXayx3",
},62601,181,483150991,408564119},
[49] = {{
"kv1eYB9nTixg1HuzkM6oMWgvRYEqthCOo2f3ZvvKoUPi8ym0tIqtBPA+uBf849uH4jVsZX8U4UrzuIFmRdIe1NToV/oO2QXK1e7SwiLVFPrbKCA3F0bMy/qUl0fKLE1lxO0AyC4Eujg5sAhEGie7oc723pYdsSio8Q/7xgH4LXqj/xLekHUijchvVYViNvmAHJHJOoN2j4NnmihOd2//lbGhMWna3UDVyW2jbxK9B9gZ8gLSXvf2Hl87bvea70GILdw76MSxNy6IWufnhKaV7Ey6hjjeD73xDQbXgSCr+Gm63UkFeoTsz+/bmvE6kBKdX/CT6xWvCrv8ML9plrqPDn34vV8tDvE9k1Z/CxFgRFxev6jhbp7b/BsI0XBIvq4rTd18fV4YmaKIRmI90uh0h1uSBRBHYqVkIFEhaxWtyDlcla0PH5wpC/rr1MInUw1NFPxr08F1c8Vzu1kv9MKdfZRDmQBuUztXisT4IF4S683dibGPjeB6F45SXyxn0FhvLAauPQSd/gCV+9lXNpMa4fLsnEG1vVv0affQ2AkZI6iWgtV9RLnWKgNw/YrhkhWK4JUJ96NCArJs0rvSepP/ce5LxE4MTMZNKz7A/If/FIA/zMGdk6Gc771L6MOhiHJhAaZExZhF5+H6qvZQ0gWpsPXn5ugvlHCsPXg4iruQR0zki7S06w4rqBA9BamNtxa2FMjRquaWbxHxT5lY8IWvZuRVHsRu6cBzlMJAlYthcubW+RskvKadSi+P4Hu//SDy0GoRaXvw0/xeJhhQ52XBGN/EhoeZSKxt/mMpNLlxZA6Cp4NvpdPnzV6MvIF8gH62QMT0CWks5i4pg1dpf/XYZbqPLd5qxWq3FGnhSvTh259d+Bq937cRP6jCQKMjyqfl+4DLEkDNSdj5u7iEn9Fe8LgdsTmJYsQC8E2eiu0fxsetBy3vS8NySFfAaz86wAq06RAwJbaFmEffCyQBcYypR00FKWsrSBLExykViQlr2FkRNXNK7odfZJaOUS9sK4hGdUTlsDVPzmJW/9dq7Wqbwje8iNuS+oP8sT0AKsTYSpDyNIZkXqpH29Z+sYA8Th1bWZxX5xcPCDE7OYdXk0O/ulADeW1FASNUAyptQfZ1xe3bgpZWh8HEZiOZzBo5BHem51wD+Im7NB0sX9kLZyBpH9QgM8E9w5PldcYJltJxV0xvn6h5MU7NMARCQnICFmEA1/nzAY3qOsDoEOUymQts66BDc2HVhRtYa/YZAEfZ6AWzZD104WknXhbRjty84XsVHMgnjLPPdasrxTt2Ij+A9KbwDKw6lEDlVCXJhMA+NTF/91r",
},1962,995,354204300,2664928064},
[55] = {{
"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",
},33114,21847,3236333843,4285774230},
[29] = {{
"2WC0+urW6zLY83vKJ0ROnOrrbh4hEM1U1xYbavkikJmKkT80tMHTpriWTvtINgRsU0EkjQAph+6i+Guo8kmnIBuwvh/cD+3kT8QB6vKzZTRB25mCklD4CP7DAF+qOkwgxHtxohlcaQUMviPrLiEmAmErMdDebIwYlwADa3/rhUlVOPyq9s3EEvic7G0ZRvp1Fp1SFFJ50b2wNJSwRCdekNJnvYohPv7pqzxTmYJxtlTuU394Gv5QgO5KuHisGqhnm0f8Yt/+uW5qi9DGHSa0Pvnt2Z3CD6lvXAAA8LRa2HcLS2uugqKrudIrj/f3mcK7SzrNUFC2UU2ob5JDRIe65Ki1Q5sC1QOmWiWb8VdrBfqL9y83EvehxanEUFWSG2xtMiHonuVJitP9i7EwxIrals3cVcJJ7UW1GZ6uzlR2SFNfXVKg/i8q3WYAU8OfRupsumAOeFscraW7tbknta6Ai7FNFfllrXiUz5BRb+ZRPZ/9P5Mq6OYA/ka9ptLzaW/9tzdpJV2p24KtYSZis6ZOj4aQ/6Bc5qSsCel8tp4jPXJ4vPAQ0gB9IqnZ4/xOqCdH4qjgtj33tiHo8oKBHrp+XHK8fiAd1tMEQefy9drpQLNuHt06YOGP8MO8SYFmRYsDfYojOBJXsf4lpla5k8aNgJpMWFFX8dyywEweKtXI8Lm90D9wcCcHWOrEO31FSItV+zLj4pIw1jQVXFlgIFlQ/QoiDxeXhVWmoKn4rHL6C16h6J695Sz4WSr6p0jYeTWLOuzSGgkxGJhgZV0ssstTCmdL3GC2rTf+/4f5gvHNgoC0ug4rv2yij0MzQlNRDJ6Pvxw8Cc0T7mNlN6dN/T7YWyFsD/6e2miAbpziP3/9EU8q3OkSR42A9CNyVJOrlQjw2tocALPrQN6U/m9PdvBKlJFmqmUL+1n/oCnqCm9NYg7Q1q0NtgnDgXUbL1F2Ihy7ClQsvvc/hT+zByW1YnQuxU9mgVs9Ylqe/2i+Ge+JXB7/vY53ZYimJAK3u7/pjvRAwhz36dxthHeyhzKXqVrVXu8RL9HpCRq7jHh1mzhVZQ5zz3nAClgr3EveXyH9/eXdHCRmhPc75giZvL4W6MqkTnh2rXEZ/cMAxEtRwtc85Cq7d6GQGaPmaTr6q12oIRqHlGd+KtpVzUJtlXm8D8ijbHeZnbuwfkvy31dRFuLGzlmzsyhBR3Hu/5/zlRYUTa/qu9yqgK5g6hF9F2n76NA2bJNdKzSqilVz2q1V4Pi4xXGrFnjLY3yYX1xcE7eIp9VPIHbyerWkz7swixzbnt7hR1HrapxeNcfcLOXlblCfPxl3V2di7MT91mpmtXv+WOSlNuVl89D9PTSO5wzvJljuGXKfM6I0V+WxY+B0VM0R268SZ++CESAJa88qVkbh6ZQ",
},21009,1055,1023988518,36757519},
[24] = {{
"fMKnq58Ggsggj1ZH2c6A1ub5dKhn44QVtlMFYROFKF4s99avwkiYgTJNrNdTQtL7/L2OS5k2LsU/5Jrp7H6mQvmHJpPNzf9Pj040w5s3RFNQGvlHnwxSAUZvDtvL3x3sY8JltWJtAlar/QjToSDc4LrD4+1NTRXKEJ9KEGVfPAWWRBeDAQPRjyFF4M0Q5ImSMKjw9k77WcMD4kEpEaHtfC+fguba5wgk9ePSM1ONgH+UN5zPPeJbScE+iUYo+gEIw3Y4Con1L6tzmMELxD9oVtXBPHxM+/DanJ4PGaC1fd9NDvo5Lc1B+mSVTrLJls3jupH81W2lzDeX5nVPqDOp+Jzka3PfaYXYGYXRG9DS+Z6U4R4+GrBOrvUd2RavVl0/dyzScsX1L/mtCpp9Oxq+0HVi+RkxJ+iUyUFPgiQM6UfaGZI91wV8STAfLMx9QV3EqWPUFXfobM9qV1sc4sqbw3",
},7283,352,2141491659,1740490268},
[11] = {{
"goLp1RZoYZffnU1dMTense/IqJwW2BThM0qyxmv6Dt7OK0MBvKkZABkEh+/pAqLP/agy2Xq8Y15eBA3Az06FeTpZd+rCPd4G9OdMmj8EZnqjbXEg26M2bV9JD6D5m+FV8yP9gaX/xgvByMzNOqmvLFEM3M7mraNf7LLQdAYuG2hbPlq4aKCgMnMZ7Lv7A/s+rIxul54H",
},53850,150,4090377168,1435474351},
[3] = {{
"0ec12eHraVn0A/rgIbZTyT4tfC9LdF/Z1BCFNAjK73zyymphaPGKZSmATTPuy105EeKA1+DGbg7afZIb50eZx2CAbJZOAcn4bGKR2894w91dljdWGCMAVG1m3TsxEQPimvc26QQDkVOhx+NzhUshR2ZHa8/Iy0hdQ8FypZBIYa3M3jbA5Bv2LjgpII+yj6YoZ2QDKKCx2Gc4uGI+p/5ApkCBnu/Fv43kU4rPjaV8d/E1oKA6DnD6g0Dm8Rfel4iX01dmi8HxObIglferXSZKW0I/jSodm0J+VmayA73xObudv9zRQtISHsk71UJ8VcnJpzx6obthE2jP6aOCQYqAqVBGcsrLotagqaTjL4YhVoZOT1QONUK/e0Vmv9cYUbWj8GkOXVLkDxyOOLvp4T4eHkz9ACa4Aq7LazVqurzRod6sfzaPgKZnO3",
},29803,328,4263871683,1570320678},
[41] = {{
"bR2hsKASj866BV++HChv5uqHuEzjiUNeTDpqBkzb59GoP/Zhhejcr5lkWx06fho6YlsimUGmTV/e4jj/lN7uTmdlihCl/0RmolEpMaeELdchV1a7Ad9m00+XKcNUdx9kRUOfxddecnjwbG2lC3ssjrwcbx9HDxP2KyY2NCL4S90M3Zf4QOKzaNdpmd67h7j4l+LjKiVBa+ZPxj+ZijnvmCpuPv6HMvCM88GPOS8pbrhXeZCzifYVdlWSIEJhwLy6MfN9rVCnJ3/hDubmDxMg6usr7+zJqvzDhXuEmIhqUIM4yCB6nmTkf5x7tojPThoe3bJpZSKMfInOnjTYuTFNn8jjaUW8w2q3XF4r7WOXO1Zq8n/c4gWQWW6+kXirT2tW7MM80Bq6I8uY/Qy/FLXgGR7qFXUFOijymVZiWZXlFWTokux3mcFRf7+mRcEBS2bxgYK1A9RNXBbdOg4IHe+OmhejP+F7QqAjT+P89ypQDNplkNclGyFM/K6w4pK3TmoGWFMiL5H2J5Md7uXyyqE1KpiXBufPsN",
},5225,406,549561762,616269100},
[30] = {{
"OWPh/Hpj5KiMTqHqUFx28v8qsqep3nMH29fA5Nuc8ZjcEea1u00su3",
},23413,40,3571060023,4228649005},
[14] = {{
"Bnm+o9vOXYef7Jiw3B9KluqsWIlEzCyckfa0XSfmkZUhhQmDzMd5kluqSu6qbXE7XHAoILSB51eDx+yYszMKkMUNUvLcxusHxuBTp/nkVA9JI7KNBwiBnziBwepOM+iNNx8nMN4F74oRgZXMJBdkyQ0iva5btPzpDAH21HkDr0qjqAObTEYys11Ad0VeeXAu1bsLWdgjqPYbbTT7lDnhY6ejujZq9c1KhLb+1mzcE1/Mm2j5t1Paj0zHz1TkoZJqoKuZv/HGAHMOpmXPy5zploD+7eNVR5q+fvne+TU+FFvbPcmYGzc6bhoQm1iP4kDNXXZI3q/GTkGdiw5gqpfGiFyp00YbBRSv2bj7FZzd0LJQeX+0Ua+RbROMDgmLiDjSdaFlE/oONRTp74CksWWYCX5z0ExXK4UpSyRfAXwwl5BkemTjHA2DL7ruSHNSQIjeIazHMfUFN5j9wN6PjCOvjztCF3LtvsuD+b9riZYhvzohT9ks1y9UKdEJLMhzd85oR6yIg/FZD29Uw7VZRj0ZqHbGe9olUF4hmM/OwJbL5YjrgUzaDosxwtIi4UZ6CSHBL0bAc9x87jT/mzPxFi+8ZrfkEPin3wSp72SkhW1Vv2hhlgXj0HRP80RIJq/vP8ahCLLPhU0yHPEEnm3/ca5MQDRZENoGvaeszIR1wbProEEBChXFvJcqbwYmoGm8QDm65mccJsENFQ0yzb9W+HD2b3lQv/fpYp+R+tXRS59HN4rrlggsmt8zLo3WakrU9tEdrUGR+QT5cnerW8o3YBi1MGYXj0Qb20L4GxzsBh1u3saATNrnFnPUpPzUFjdWFXCPhThOEzXO5Rgs65E/xoxVeS8/rPxvEf02iZztGzjnPkW6LRldwqJEEosDrIeSO1usMVH7zD3t+lt1vWxLvXNaYHRinkYwiuVWTTiDBNyU7Z7Rhj6GWeoKbxdFkQrqsSe1JvgsyoM6S1Z0Xwel0TyJPF+yopbhANnsFkAgrtHXc8HBctHTE6C2RxaCWG7n3XstKWOrb3m8XLWGqTTs+HJP5XCDfmaw/jcbGDRZ7ZgmjSK9acJ7Fkcg67zeAi3Zy+CzUKRikwnLET4Xo/JTlR43ZVQ3Q8CmcENn0BskMYUZkW9Iw72Raz3uUBCUWff4GXvWiszNkq6h6P/wkI+r6ohptkOUZNfPZkOV8KEhCMp4TclKSv1QEs66J54sBMO+ZjH5DRAwFJ1huC5+X2+e6vXkR//vInT2jJpc71ULdBpo7ZLptwiCUsorky3yVlAO8A0OLi5/paBWlImzq65W5mzWenOlj2ATqCW8mdS9yc4biSl7Koijb2CxzoClkVLcRN",
},35613,1006,1585883745,3384195837},
[15] = {{
"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",
},48427,1517,3397362770,2469131101},
[35] = {{
"pWNbxvGotmLUwPNZx8kJVw/tw9aDexNyZbWlEdBMfEbhv9ksKE3q3XOzVbHu/yHSaTeV6sZrroAbHtEiUK3XUtG92VkmydyDsgEjzS0c+mCFHFNN1tdYCLErXR3BQHQyQywjjtRplI5fayWbDWh2AQabkDk5+3vcrvzOuf2Cku4/2vHwLgIUy6tIlSl0hknDJZlXQe0e0QXYSDCeAvQEYPWgp3XBlLWJM+ZtYuBpPWDa/EhCEzL8oQ6Bti+bL0YWF8wRJ6N+8ULeidcISU782mnkZhaiEvt1YwL3cl/RMZ/+JmugVZpeej00wLPPiVyk6Z/qGN0hvN6ixUo795gYFHe0nNvntMiD+fUNmTrC4zHt395rb9ge09YRPagMvYw+VMSh+25aa5DkesZhpxwltI/Y6+S2m41Q6Vo6uYjVY7HSZlgsqml0Y8Sr5exF6k1eitMDPAQEVFOZxAWzCxlrwyOeZ495D5XEo7J8unB5AbUkA6YGQ2Pjng2zJTuMBjzMaIQjI2M0iieBYU66aXeSyr1/iiU4L8C/A6RqI99bRwiIGIf65iDBPhVy8A5lvl2xV6Sj47+T5zXTwqJLSjNR3pdP0MTagRYpXHAq4Fvh73t+e3fa06+vaYWCBqTCJuNVRJvWwRFs2Ri0ECyoyqxFIKjeZJA7C5mhSbIV1te2xEK4qlVLCCBorIs9Bqir/F",
},41760,526,3578717642,1234778227},
[12] = {{
"PS/XL7+vrc2qOpydg17wB0uRtsu3ojdUH3Cc/PMqPeZ2dkjvcsinIVuciEABfjtZ3pqPBZbsCTh4piA6afeUSXDi6zSX+BULkssuLCods9fQpQ8K6hHO4CgD+z1JvofdLyfLWS/ROw3ZOeDIV7aY+hPcQovYDBARetr5cs7bM2Y91Nxd6yFqjyzC1rQdamqlPrdYyQWMk3LDgSgbpPQOB/jBjfHVgpYOSSD4UqguT7RA9vhaK8xhOx/HnGYMlWj8OzXL1NihUuHtfk0WXchiIiP00XUzcUlm4aPJT0dVOEKlyj9F5rwIRdkHPhK9mSPbSRgP3V/j/MrYSM8DAU/8Ktui+EcQcuWNQ3PVUdvqvWN18m0rC1YEdMtm3k4L25SCWJuadHU518EJwP4unF",
},57102,301,1406042733,1426964912},
[46] = {{
"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",
},54784,2980,1578253587,1465777441},
[34] = {{
"l0lz6p7RKzcnHWjBgHyQuIUCHvE1jEXEzJKFwIyzyabiWLLqUoQVjvrD6Pmm+pppR0OpDmzwkGtesTNetxpr6bgBCJIB2UKN22rYyyuNXbBCt0vPs7KN5cukwbTPjxbMENDsm/D5JTlt8y0RycIMw/pgGJK5KGcBv5pYeDdUpvNvOPBg2I0ojbkRIJ1iiZkN/IGa3EYh",
},17815,150,1494563488,2153190325},
[54] = {{
"3htNOY8awbMSZ5oxTUu7nJG8a+ODIP7C+daNrhycJJQ0h3H66Jm0yDIVcMSugyiong4",
},20470,50,2669089003,3229211490},
[33] = {{
"0bDywKOn+bY2VJAj/mQdxmDixM3KzWaORl/IIQaORxyozsvN3HHrE5S6rcWZX2ej40cMBpr9Y+gjLIpxxhuiwvvffGoSF3TG5rbRzxm85mkHr9pcI1MTX2NPGKpUUTkXG1LF58NCOnCOjZbN75LA9Wa3QkaOT3y3/ORVwmqcYFuY/wY8XB5hNsmI02LKEsO41ylnwwsV6op1iu8LRQltcvsXyQ13emLNPa02ia623iaG4Cw5Kr1miTZ0iAc7GdBiMSihaQk6hz04phIjO79GwwskAbO9vm6P4jCNr7776YpZlAjzJ2WoZbnLeTjclm1uyoYlsUJNoE4z8kBPUjZdIyFeOGobn+lHpRXXezhDdeZqzDFuDSTLz31uKGMy+3mvzZcUODQT+O+5UjYBkl/9bMmAzvLVCdcBIlBIp6rDYprFESjzgT2eJ4JgCPU5oX7/JiMfreWo4MCBUMKLhkcIwUwzfzs4LZJZoylU9V43BqiYK/KLqGn/dit0yAT7gf1m+giVjFBkcornIePAGbD6YkE2GtBMdqCLch5UqfQ5Mx1bGJf7flk1C04M08bS4E53gd0F2dqa+3k9zgm/UACEXbiQixZeUt1rTq/MDVxfCYu6l3cxNByp8DEm4RVkhrNgab23prmPgDPzpqn51PABGRB4dL3c7DNCUt9vjA18Qn6dxb4LceQetzG0GJhiBQRvZwj/0fgpyVLRwMqCu9fZpRF2WqmSs9yiuMHpLc6RoM8kZzfN6YlYC1jNtYSq3IpOxH5bSEQznLHNR2TS4RKTRalQdLSrJix18NHZMpKNsN9X2zKrwRgzv002nh7vTJjCXc001F",
},9850,628,1155734925,3213821816},
[13] = {{
"jXv7aYYBKGShHLYXHWJ5zwib+e5XfeZSflCC8B+YDudpz6d2gfMefCYRXhkLYWZVhEMWbq/IoaHkDZN2YyyIbzROvWWOQRv6fNfIo/Q5Mp0PZtkaijK3gP3dVEey6300uS0xXk4a0LWfWF",
},50956,106,1591880836,3929037182},
[39] = {{
"x8dCFDM6A1w7VkLYbKjsd2EDJGlucVICtwRpZZaDuEwjRVVgJ0VZdHMAREHIl089m6Y0QYjONsYFUAnawT3D8ThEf5FevRhYCp1XxCGWXVTtGpzzXf4",
},27709,86,3784711946,2596321852},
[2] = {{
"Y+IuGVm4gjWd9Q91AwpeJkpw35kwAXaNs/H4i3lS1bns1/vrCv8JKKOuTNAkW4VbuiIdzXUYMVQUOEu+MWVcfUDPgxDb0yyFDWSPvqs3138ybbedWx3jk8opO7RkF46gYp5TZ6wGVnPHaRGWJQAdy0v9IbWdHGf4STJeIC/bYAFQGv5wwx/167bxRFGMofUTw7n7/1bdws3DsG0ZkQ4BdsiZMmR7ACjo/2n+nzr3p528jdp39fW130BpL+cmHaMABsJnN+D93hUZJ2L1cP46kRqOmxtexbYE5BVUmcEfVqyCyUL0v4J6ZmnqQZ9K6J0vquxAMlfeleZ+BvznjCLo7mr",
},10029,257,3960957495,1677427979},
[1] = {{
"s86sCdcxDYyG9WwKxhQ5o+vmLNf8ejr2uvUNNgd2QrcgbPBfMp51T33ZYP8b6ikUlVtHjgUKqhbpspxxktvNyc64T+In7wd7lW7",
},61056,74,2561940817,508684908},
[23] = {{
"iPVYTO44QHpwS+h2IcRGLDDrcR8eapDYUPXvuJaobKZ+QpueciCa1XpJr17xZ1kDYVv2+q5NM0Fx/UYMEYIk3KTfAAJSl4uYQDIdxVpH96NDqD1NUMLfZMGWBxJxpXGDyxwaTn/g2ISussWv1x91z2eldjX23++yxguEWQZV0U/4OMKU5fDVzPeK+hBSbI0TBSCfJiu1qeKyBkril9HL3G0TpW3kBwmex3hq3N0IpWo0JwnWILfrMbtzELdeKHZ7Bbfrut8ZNPiUAZX0EqMz0CZg6EmCsrw9P4JEpSRQYgb0rE4LHTkEzwxVSM+0GtAlddaoLtALr7ksqstKCcCq7kIyxzb9G1L3hrnP7BbhhMVOf0bdX5i7GmggM2gvbUfo7HPDNBun3Z86fsBwjlmtVxdfg8ThbR+Fr8rrxU5sDiegbNeClXgD0gKQFtyJXkNi5bE0FjvQpHxF/cBhsSITX3xtklx7juAEmsPAk3PJOKOa4hSBUDic7qS3mDF68foBlYGSa1WNTdyOsWVYbNcCtBlT3G5h518r0L2HNN+P+H3VTIykK4omJoK98O423xsLYebMg3kjQ1yNhcZgGaNT6ACD/qz+2iHrrfCYHX7/pqu+jZUcaR3HWwMnu1g5/6mc5xxR",
},17098,483,4073835510,1202167206},
[48] = {{
"XkK3zLstmKWvu1E0yjXSs436pMoXSOvwITlMD3pYq/SxpGJQmPTUbZ+JlaVxS5UHfy0FIUPFut7lbfe2o+ZAmfWP9gDpHxN",
},28053,71,427235637,357342529},
[45] = {{
"sjFAaoLa291LK92HtLnk6vgax0vLkZwTkueMrTwEiN208HIUPKLdvU1WWKyX3kMBuVnO/bYUyebE4sXw32vH29QOnWbItcSW7If4rsXMvMKuMD+5QgzFXA5r3ESM2uvIsk7t1vxgc9lswQl5E8ou3l/SyNfnF7RXNyK7W9JkoeDwAwgzddylrilDpa4x9I2chn/U9Ze1PkbA4R52gX0k3N6cZuLAnhaZDozOKKPJvBP2mlRU4LcLMXL7lJ/xxSXUJpXWKsnz7mmlx5SvXizsXo5r739GQB8Bn1CHZ3J2Y7BWwOFrSZkdqEwS+qqXE52S74z+zl/yPDn76PWLoECzGDTbBFDR8U1YLbH9bn7qvteddJMbW+aAD6nA1umL8QGtq00io4wKSkOYAoz0/vBdXVONmPSC5QLQ+etu0e+GBvUgtmDfsDxbeyBa4YhzkwUpdQH47BsM/LJTWlhQf3nLSwYUFqS097QZ8WBv+zASos1BSk0ocXNMUTEux6YrE4gVFl1jTYj4moCW5NrkTQkS/oObdGmu8sRf5GzkLwsLxRAOdDe8ZBy3tUBuRvQsnILzA5NuxpxxYW5IF+ln8bXSVYWjIoB0O4zTEMNELNQGaye2/1iyCj3mJVqsL6MGMmSv+qtE7Py9klsMBAVhJ+WB7T5LxWutRS79W2qln3iyqFCHZkUEX9mbeAlQNyLAN+6DN+hFY4fkE13TO+J2CwdMGuxSkCn2DhVh8b2aY1PAQGfklUdG49SLlX1t4TFI5pzOxrkKE/Qvzz+dd9B27VtbWiv+gIC8oTwFaIlfzc8Wqu4dPCDISPQnEgpcimtDXyi14heCvx54qq/RnDjQZSGdCnSwVI86qVvAwlTSS8nqVQCPBInS9jb5OUFeF7ajqX/DUcxVa6beO4eZUNG4k2sBY3IPK6xD9iNXbLLfusBQMMg/VwihrqFMLv2s+fY84w9hr8Z10aNLGwKHv2AgNrLW7bDk4MlwbPhqwMS80GIaxkTy6Qa7SNO7fEqi89F1KMfXW6WArwej0hYPRES88GZ3rZFeR3rzSfgnmsL56LrXgDobCYlKLPJ/IGq9Hl0lWKSJySaEvfWfiXGZ9uEEwYao8b8s85MCjNeR3NAsskohUt02k4mPH4zSrh2ZobnSmZqmFHkpg2v+HLlUEAb5Q0o0cH492NbLdRTkomdQf6i58W2l+YyN87deXr6z4FGbSr1+jkC52b8+tNxTnr5+yRPM63in9/1INqOAfmZp6VzX5//ddyYpkHoZSjumJFixACINnbln2+Xt2doP1cYVcm45yRR1jQ7ILhmcAeN54hK5e4FV4DGpopmh5cDT4TF30pr7gYO+nQit27r1umQqoEZWxA9Db3mpbr1oM21PYTo+IM+IAYBYRBAeignXJyZPkoZcaYf1Vfi0HPhCYqmxJsbiHz8qj6P6WA7UXD2eWhMEFW2ehd0HAZtZEWXl37AdTU/TuDNiA4+TDiRe1rr636D+Nc2zAhniisRv7L/PeF/YsW/BL0r5mH7KRQqCktcTmt7IHAaawSbiraOkx5o1WVhWxczP3JB5xRvWzVi5eNucA9IsI71nqCFm3nOSBdCy5eYXVKUBvoKSq0BzFTOrqBmMC9QwI2TwEQ3uCgZ161ZtGKL8gATK650VPviHo6C6Vg3ZzapZJA52b843WiMjQEp630fJ7EzqVyTKUt6zvN7O41yJHWfeNIHu+Jw0FbQ/VHlXLVg5nUKoYWpjfFPUsNxkqAMkJl0v8OEkCNy1vP3Xc1v",
},15955,1328,1088635182,2814656610},
[38] = {{
"b7EvDzxvftI82YAmSXovdRAXzlyqtVWnwU1rIlwKpYFlvTTS2S+8Cy0DMxMSpswYZ1G4kMAvUkn4uktIioXe1CQftQjMnKLLXAX3N/YPsgMx7CxbCWemZCOUFaN9Fi7bfMTHxhD8e9VZhcnxH8yML8qyRNVopZgF8K6trMivKN0JVkIODtVFEvu26XYwHGqOC4du0HqrEjieCF1WBozF9f7lwWi+0UWGtLqObFMGby4fWbhRKue+fdtPfs1fwLx8alCMBmM4wAsAk0r8BhvsJtyAIcX8lJojtwmnKd015G/M/Docm2oykKi/NjGBHSpe2AeC/6hJDQUWpA3npVIwSvriOkCTFHLc+4OatcbnbNci/jYeFFw8ysoz8xfj6DcG7+DdA681B2xKJK+7fbm9x7AoIFggsDnEJnzKTp0d0f58P/C/ZlnshFfCibXiYFPZ+Y8hkCozutasR7NTi/qsx4Rp07pYqE421z1guqjxKUPD7mXyrr9FMpPOgbPK7WDRS3QNj8odVTb7mHsDEMHAQyCp3m9+G1Oakmh63JwqiMKQVknYpXoiDBjMpva0/al2gQWfd0gki9VN0ppbQoEzaP7hw2W02TsrYOiK8Go2BBsnsO8YeWw1S/T7iakQBXKdGJICXA4+ouU30IwBS84HPvj52GaPVtFkt8pjmi9Wl0QtYch1LpVm/kDsDJza51otjzpuhzRwfHg376KewAFNicqmvA34QeKniKW5Dkuv6/Q+4DslfnFjsJK8y4zhnvpvU8ZlTIaaZxqbXPGpd465VVhO1Euxnh2/KK3yS9T21T87GQ2g69HlG94MLjMs8yMFyhbZ4ctORVnYSpO/uaYRv33onlJg5ex3Rvet+hSVwDl05rlk52BS2r+Dg+wp23nJQk7AMfZZ0f6LzoLYnHCUN3HuYN/mPw6Zn7Uz+inNWtCNhTll/BbRpf/o3zowZxtXhzbxUY/SETzC/UHWR5/QW4UU9XK7WokIpHNzWIBGEigZkbX+QNehPVhJyMtxZ0kb7ABJxckF2UcqcMhGlvpskrQbvFdlKE+tEzfyJozEpkNQ7Bmy9/JhMq1fiz5od0rSnFCDEInnQdmGonmhBbd+f9M8SKctW4impUr4yZ453aVKRN1x2Cxr7Od1TR+DEaJcZfGB8S/kKPyBnTVUiZqyIimNLjoEegZmVSinuKUb7e+JBz6tsDIZP67cuky8meSfDVRakFRSorkdDWT7FP7sldO9htpGYe6Ll+tUs89AKiUAG3amDSW1HFhDBuUm36OobXqd/o6qoW3wwY5cfc8oW0cTkTXl5HiGX0tM4pebW4yYcdXgFavorkMhWq0uyRm5Zo76oml",
},48679,1013,3940006668,1728301860},
[6] = {{
"S+e77tBdtI8zqdU5gf9mOJQYoePqnt1aNDMxJEW/Kj57+Bam+NJtK7PMgRvRGDiJiP4RRrX36sgtn3hTUUGUMW/SQ+T4y10+N1Nqk4Wnamne5YmoyYsEzHk1DY/4zs39pr/DsqF+/tfu+gyBAOTnvTrIpuVJux0Ol16+ov+cPbhJdTr/iCTz6eKVM/z4+Q9O15+bp6sAhd6e7nspLuIVuqqu0mNsrMrklQZSqn7KQGH5liOsZNh5ZF+782FgVIA3iN3fpFI3dAlOwts8ddqZ6SOV2UoLo/0SM/iUsMrhuKluVuQtpHkZjFfqAB3FJVPsuylyLitGzqzTLquhxc5U7x/gsUw/eQEx8iCmO/8cPHttShSE730L2aRt4gMstnpT4gDe+pZ/dBKi7/vPecySo4ME1LPBcklrgDiuBCKNo8gWbtsQ9ACC5Iul6ZUwuhDBvFW6AmamZuMANc27czB3+ulQBuh7TXoTE/G6DN",
},57588,364,88315815,1224979336},
[32] = {{
"AdJzj+V41yA4rMkZfl48V2sen5g8O/kFSjbwxaDKTKZAkEsOzOBDMAa2bADxh/gfhEBqOlSMprhnLmIC/5you47IVDQPjgWyFNrQ6234j9VsUIFhfCD1zn0D1Q1cxRIPxeVceFZEw81n4QCksPkKz0FqBh9aG+bLfIk8knutlsIQmShF8f07koz9MJ1S9p7XwXQcF3VRoc/9llDnSGskhR16QkihjHD5NpS9xFYfUCwbdhmOr+y6VOcZEMy6gz45B6NrXaLYC04zGcV1xXZiWjL3/owRKgWPfwHfG6h6M0jFh0Jhx5jKTsc3M96ExAQ3Sl5DK+JBcnFAaLiMBHracqZyI+rwZLHEN/bKSRJYrcgZNzp4MwGc15PptZISbZ3nXQmiUFoO39bK0vWIwcn4S5oSyQ0n+rttz9+UanruvgHxdw09M8iyDS5/xnO1Pk238FlCractR66DmH9QE/50lshvVVEyQThhA3UtR9OyJ6WhI9JHbiPGGveryGZVb6yxhn6YiPIKC0G9Jb6riGBmAZJ1OY+5gEO/xkmJrAShAjTZghBxoUYTFc/4X7n0trh/D390E94fXIpH/SF0rvCl2dh/N27cLSLgxN",
},37438,457,4016554858,326630546},
[5] = {{
"Ps2t7WJ7xqMrBSvoNp5Vt+kHKTNulNsYv8zh8GVPsYJHY9lHfIINQDKnLYweMlFeZZcxIVZaBqFAqcE3E2F+AIun5q8zxhSD1zo0uamvkU/tysINI7A7O0iFUgVj4ja4J/wSVSQzxsQsL0kO/h8tSQy+jQE0fxohOXBfVaPFWzBZR9OtusDBySApSS1XQMEzYfGLiwOqrJcjJOC4Y4u2x1Y2yooR3A/vp2COHSELAJdKjhctfwRvvLtiSts/u9yY2N3d40hl7UZIWPSiZi72RV4qaSRilzaSQhmBM1TS0WsGcqTEdQ2gDtWJCPhHqVEbn3ZBpjYbhLUbJq5tKoN7J7DQqJpA4I3BwQmDd5DEBoyn0kiVf77kq8ABWrp/aj9sj7AqpcIm7iI1lTmfe/K5tuRD0GKn/dZf6cab60UxRvakjBA+VwEzsd7CMIxd4bWhlCGwRbscMUMZKDNJ6kLSa02mjjgBzer3TNdVKnatuedldl6BTnJvKEiJN9O312uxaU1BtibYOeZ3ZhHU7LOFe/h4T+P1HjetFtmS17m0kN",
},48341,415,291483596,1806496216},
[26] = {{
"i4GZG4agPCwkbVd0OzUwem3hXPdCQAi999tQHDMLG0sOOS0QfHKmZKPftCFRMBWWt4oqPUiqA7CJDSaBuajEUZMIFUMoRQcrBRA39SSr/KkkcoGJAWR1xOn8TpAnt2++yKL3kgiGXDH9UMohCvDi6ZbnrnyHgj4/s5hUA0u4VkYimzWkT2sljEVnEx8VnOr/R2G/GAvLDq1PMFUUSJ9qvVKlF+/qURNo0hBgWpu/2Sg8MYKjK8FV9Ag1vp5UMzvU0RfdrZpgvBlEiVv2y7mSC7dyj4sJublsb138nYNsame92wI9LDqX8567AAzq2hKhtDSWR3yqcvnj9zv8zYy468Fa717kdJ07Tzg35Xl98n2j6s/tcfVypfFGsy79+snfNB8RCLZXtWNlDdwWhGcU0poOocbAREBZIZCbZgn52oXDI9XsvTce3Ve909t5bMlrwTbtUPOBpZps26B0wI5fSMXtW8llX1EACf1HRF+qlGwM5wEmg7aCLs3qB2I/DOXf4CKPyhrgHnGEXhzoHQiqT3YBGIGhdOnUCIOQAHC4dYgHjKpt+bEzmPPnVmAPCGZAOBZMG+ma2P6u0F5j28ihjgMHlcyElZnGOpqoCBXbRDs20zLnKC513PB3U/hYt8pNL6iiXo92UwpThlj2W1+AV01gCJH/igvsMpiJtQMjTOas5airl0IAStQtDLixvIKL/ryde6IsCYeboZaqS4Erb7pQg9BewNAPQocMekYePX2PfXLhTsmzT5S/UVdhGkuAzzFo7py/7ouD/hdwI3siVpIsdQsZ23dudPhmVEYOR0v8YsmDULoOrdKK8cT/0eP+nYflw6QY1gsDR3J8S680bFfMSBs5ejmE14m/BJt4+HSPFi21JMKJPW2dnGrhKpjJj+jlo2K8htF0BVMGKZTaQJY2z6KbvPAOOS9fMhO+EdHLDVdhlsxA/PODL75liiFvLJn4fLb6XWKTR/N17a+6HMn8nE1afU6PZp4kICOVYip1lMV7tOVtvMcMY5z4y534AIWZL0zfW55sJLd7FqmQ7FR0NBGrI6UUrVyRjQXvGvFchj2Lvy/O3yvPbaOkiOvPOSapWSIxVcq/xuyobZxlVQo/fuFRuN5pCtleMchcZLcvXkA9tyy0EF00NNR7ROLBDGYhpP7+d/orEG2kWOyI53MTFeV4RVa8bMAB/q+GHL9qeLVZujn//O9OS9oXNx9tiXsRhR+6+1Bdime3cKui6F7kzlMLpXXR2LLOWWnGOmsaWYbPIcq+5xBY7KyAMeR+8zwIMOVjfmLLsenh4xM0JiMKZvG9kQHHBwb1ku+oWrTin817KHT2iftSRiMNSY1AdBkfuiz/auLbxorVVENoruxa0MZeXjjXinysPYcWIuNsL08J/5mh8YSd9a7aQTurncWRxseglr6McVjqNwC3xwP83WPXMaDhYoUCjhSMTVvmT/CUli/iJTFGiQyPO83lXpibFSfCBwnJeqn9nuodJIc7Aeuj7C79gDK16hb3TI2qYOpLLO1uV2xS2rD5ztWRzlhXIKvIpTryIla9CbXPXmNG2mUcotbMMtYhAnTlt3YSeeJ77Iz+WQK+FCEEBS2g/B01+MD8KK0j0qxXhgL+eD3333TxFyNRuOMmNNarsI4m5FjhCSK0UWYHyBnZRiSGD+6n4fFWoU1bOMN34HjmhR7eEj6uMdZ2gBDOXlxUSnQLOE7mnJl01C4qKnAzswFq1izuzxIBbaXQoLZYw23xYN8UjJgrHtoY1vcqKyuFGB57f1cpdOBZ4tqu3gdNibkts6dI1g7a1QKZSYZGhnVz0zN/Ck9tN6lHbRL7yQXd5WeZyaVFrpX8Y4vjRSDaqEqd8Ipvn+8dIRhnc66ZfaBSGggyG51UTy7FwTqNnBNUzRaZXwGWbySrVFDkLlcl2u5BqXACBLM7ucPEDVul7tPw+Ltp3UuSvAkRfKvHWmAhgDYMHxzVoKqCWdPv7Pcih9ojw4VDorjMEmpDd08cLiXNLCBUGhvmpRacu93bIGsIfH/HJo5ItqElte76eS32DPpzi537PSehzoXAF5zdwW0PAsplOQ6nr45J3s5COgTM78es6LLHGAuwyel95wYMeGCpltkLdkOs3sJYstbpyCpd+JUurlK3eVr4nTsJJ1reE28UUkkBMLFUcLaHYFdpxr9jIl3YQeMXj+BUG1MhGOIHHM5reFMUOSmKzDAU9H6qru1PZzUYOgp7bOZpujHtkKGMcMdqY/v3I/x6AoAsec0U6F",
},50977,1696,2956923639,3340839992},
[50] = {{
"2FlgX6EdvoPqDdWMa46e0POP1RgszYX/NPQ6LoIDj7oSAeue6gEsDNspd8Jz1K1Fd5OuqymRK3PQ9dhVIOp07WmRpP3vCqD5lQUx7og/jXnYSxRUkR61ZiQUKLP18WnTa/H+oGFTEfKx01anCTr1qaIPy1k7FrnkOxvuZ87ASV3gXz4zVDJA3iIea1AcxJpZJt3aQn2bFc1xrdrQMkXwqM0lA1mxin7X0TK90egnSxROBR27jTnn2brQK2Q0BaUat+WxClYuq95ZbU8SN8DzCzmBdErBLyM2jQ1oRkvpXxcOiVY5cOyar6rPHaL7VcGcxmyxcoj7K+w8NvkiqO1LAFGgseyz29n2M+RAHZwWRVhHWpbu3I22x6W3Ra5QkQkeLlXzI7SIFALsNenJcq7SX2v9fiUkbW4e2EK9WmYi/e43QHALcldYVXPBaEagQWoIUuQQNmauzCnQlsY0vKP88h96etGnO0MG3Fjr/IuoCQpJ6ncHSofikYjNDYDn9t6GcAyRHDVFy3s4KErOUHDE2AgNGK15Gr/hB5c0WsyKnwol3W1jeHkmbXaX5GsyTUkvFvFos9TTfQL5Cx6JDLdd0af50PKzJ7BncC/Z/DyDYztIIUh2hIKpZ824VEyPCH1X6taF0WYlsW7WhEphw9SQzrMYLd4JBL7Azfyg8/3Qe2OKLttWiIYt0nJtnI3iC5W77IIOn7mvRZmhxOGh9WS+2eWoSb6TkzZBFx+9aTPUK0eRaJWVuJZ1z8lgsojsVg6AFs+fiVNfur2u1wgfC0Z45qst4DFB1OqR96rXh9iuI68hGvXDXkVImpUBsP3fJbzYcDBVrPfNHSeyKZrKifbBjP0k8Rrg+jHQzT+TnarX6XMfPELzgnPzQCShg+XC0S/gRWQ42+GEbUhPaUE40BEu9l52ZTz/XsAFUZjP3PR/3Q+pXQ5Sydq3WQz/jyTEHNRjBqBO/CgsJFIqfNSfaesnsOgZB0gSCgwwFQlVSm8ofVMgbHstEE0T1AdGI5r5GWNBjp4fwblUv6EcEtsxqh1olXiNMtUMcxZye2iAhFAwdffx39xGwBElbELJKsKez8C28ylMYYUkyExsiZxhUlWjYjt7rd48mxsOcurJsw+46TElnUOtdFNdJrCVdlHHJY5JYSV8dwp/cxpVBNziI70aayMfbtfWxBLFn06epCcX10wFfkgx48vfCIaGjCbuDe2DIyJTGqG1vDjuVRBo0FpekwpJ/ybCzT7yL66zc4OLEybvCu8HW0oFzRJzv/XRSF12E1FAPgbFYwtW2lI3Nyfu9UdVkJevAI5K2l1PsA43g3qGJ/wUhFL+rzjW0AXgDMmDuy5Jtb90qe0/J+bYFf/WZIw2LWP2flCXhPMWYFY5wfV7EmIdu0kFUlp9J6MqmhJ54Um8NOrRQJ+8gKy44HmGQ02Wj0+nN+dc3klx1Hdkt6RA6EV2D9IJ1cmVCe00qfRULcbT4PFxmcfb9GSB4JhDg9yALvCfNM4B4MNpJekVIqktFG7W2bl4NhGuGHF7AKTD9BJUaVBsdfhpOR6TbMiOVwo1EbgmDd5yqlguGSK2Yk65bhPYbLXTVKTES90dJGt206XHoplzWDE5F2Rt",
},28806,1212,2469205133,2917333020},
[28] = {{
"fPxrexeDoXTk48wGog2taG8+x3XWw0TxH4/vhk9AafYOz0y1PPDnBIN",
},5696,41,3241610123,4142183790},
[4] = {{
"Bjq46xmHE9nmeRReM3oGJW/YvqiP95BrkgYDYVjIrgSmQMEp4UvKaLA9yuU9cZqml8KBGB6cURvFJ8z6BcAgan66ah/Gjg1fsCKx15TY47NEX4pL2I+rAY6FgANM590P9p/mVJ5vNRfR8fV0+KcaQKIbP8AhDRlcIXrSJMQ5bcpK4t6n7INViRKSfNZ8jiJVKbdj78DSll3TvxBKoRPDQ4LRiMEGMPrGEzO1NhpfP5+q4fddmXXOb3uckCcsDCp+4l06qmy7YCsTC2YXxMvwX4ObA/fzVwtffcryy5YbVyVMwC96zhe1MhyQpLXwxyXAWlv",
},60623,242,3838926473,1431949996},
[52] = {{
"zsouPQW/Of9vQMiPNXhoRXmX8IhYNuCEosNHDVU1crEnoudCS5h2mNI4W4hOmOXTAkX3qg8tCX/CEEF27Ge8yQAuSXSiZALlE3ZIK/Myw2c391h7jhlgzZh/e3mtQrHJtdJOGLsZxfMV4gbib9xZ3kNe3XOZ9IHqpMsVGZKKzrIDjWCKiLgTgFySuA0Xyh9bykmW0Gwhtxs5oV5cZPkfHZYo06CKiXlPzAjscJjNsQ8BSbkRbG7jBErAVFkHz0SPGzoSUVN21KqtoPw2Q+m6UOw6ibbjhkaqn4vqbctnXFyyb4hUgn7LTx76Ub54dR0myZTtTAQM1u3Q5r4ExbA29nXcdxBE8VxA5stH6g0NLcFMMJsy6+MRRSEsfrZl0NlMjQV7xuL+di4QEbGRDfVn0rqor1BbHPys3UcaH/jefxTd2/YI5aM3wcc6lQHmgspTvYBmynwgxRUh1F3FNMEiVlz8biulGPPINOXmDXq0eMmOxowa16Vy/IcULCvad1teBM8Lk6mzHADeU7fTodi8SplJovNhIFjO+VVQjYn7E2nE87uMB4D6NJSABJSrn0XqlEpp43syen61PRGIiZlH8xLSeR7aGjAcJgT+XtqzIjsrhp+HY3k49R/4fylHsZdG+S+2ViLBz8KYdpgHdaRly9agPozLPOaZJh2eWFmOp1VYivNkF73j1nV50CYRoLNNEfT1Gx/1VA7suUZFJ9SpJQi519OaQMGf6jerDQckmYjT7itgTgE5Y1ggpvx5kJvRu1PppZtzfs2B9EqKs3q/L0CpZ3/OSmNCK+w1+FleZsoa1/EHI/SA8HSlxAzK9VQm9/JtD0l53mkorCOCzkykVinp9O8aKLS1VLAefhGcrx5C2giipSHE0PZ9XKyOgp9GPUYC/n3eKLM6sixoFn5/1jZ4spfPPrcTNLiose4vj9SK1vRiCD5IKxBrslxKh33AdEcBFLLIsHTUh/CFCkuepew0fquu5xSYNmr1SVSOATMy9WupGt7g7sZNVom4TMsc19",
},64158,769,2383436038,453626417},
[51] = {{
"LW9ykL8KGbm6uNARMXxFnshd6WA7thQZzs3Ydgrrg9pWq5InBypPPDbLDWRLGyKXjotqhf54R26B0vBdic+DkN1qIpN5L6slf37x8+I0oz01husN35p1vE57YsIREfIs/eijQyd/gKDZ8zGlX5rBGxTPBEHx2TVTtQU4jYBJ0mJV6+grFjxXu5NsjgRQeq0PWAEg0uv66LOsZgHDYiEzt6SEhAWTrOlFR91/asxlY61Em8YiUmsJptjgfRmzgCkn52F2V/HKznUDRaGyx4pC8GYD2LwYDbtJOteHvTDeFxM5uSnyh9WtElPldHhdJKUEiJIdg3MN4sY7qmmFMr5xY65lhvJBT9ZwiqH3tGjrUi/LEFUkRhYgiHwwpsCbxrwdkTNJUhnqH75AAvujv5wHiK3o8BE9d7EYFlHqLXIVKXA+ei6sWHEoy/x1c3TBWGNYWBgTUiCBpDLCQ5XB0lmUxwbZcQ4vxxaC/9bJfX69TNrnZ8+t6qY4OO/i2fmiBbzsvDsu7cF2kcj3zPqTDl4RtWXe6UuP6RnHigXrdBDJZmKKQnbd1SvYJmvzxir14144rDIZuyYNK0pmhrMiyI854AxZKhGHPMZx1g8cCV7ekfn089JVY4rirEp72p4zF3",
},49048,478,470534131,1459813445},
[43] = {{
"8Owzdc4eVVkartDeK1ifPkW+qPVR11FobT45tSbU6uS20ywaZZPcc25/XrJt1Zj0pTpBrZOlli+rwv7rnWH2cDRW3jcQHH8pqltTQeBdl5ZPnhpD8WyCRjDVJWMXB6wg/C5kOMjtXHgN+czQS8UdjKlXqOxSbsBbLExReXamHkHjccUfERnOkGzpsO9clZ5SNjAuz4pz6qtoWby7GJlzIv1lznPEZWjQuNf9dlGGkm6DK9uDfdECupzCcx8BGUel6ADLAFfzsy/RNlBIeZjT8swxoowr1j+4MC1Uyg85JIHAV7IvQvZYEVGFx+UP9RLk7Nt4++K2cE+lk7ocUFRzazHCPhBdw3fg7MoXbuNFIoo6lUOaQlnGsOQAILleAm28UeuYepyrhZRjAyFnzpzbGiN5jycB7dmEXayj8w73AoaGZSRKDYHgFQkeaoVjGjgzQK1He1GwObebRooLxoxa4/417FzZPuzQCUroNsGGRYimNW0FJ7+VZiTHJhGDM49W1vqs4IoDNYx0QdKodnDdQuNT/FcWJOrQ65v5Mao+kDhv5TVwZgJ9o9joHJlEzBYO3V8hwRaGKetbyrBC7CGGno2FnwH7F7HCmmLOVRfHEEut53aO0aWqQZrE+MPYQReuX+jOEjx9NBtSwzaTVJ5GzmtAbnmmtNM/4Ltov2fzVqO1aC6FsxbjzC49JkQ8D975rZKx/wmxG4RUBudu2WynRaO0M2GzFDpFbf26eyWC6Frb1mTDb6M4WbnkrCvkMfbEmT2b1O+6YRxKYo9VVuQ9zsg0zAg3g8+5srBF3eOQ6WosoY6hurVnLO+R30/JIpVpzJiFE48cVOGPrFUb+xY35fzK8QndVXQeIiHXkOsd3BQA24tXInXe8FU5Iou0FZGIwO3rWV1VQkfPII8fuzAWd6XBFlRKyoxblzPDjhoLD1x7MG04M2F9DzlrfYI+MaocqWPdbwc95Gy6bwDrn3VAsWS5BAHGXM7LmIHGarz2ajIWYBE0zG3KpsG4jVx+MJn3r988FNRDPiWyL5YQad8yDtPhh+iD356BhdkK9VigH+YACes5wf7ALpEFPUb1ulYxucg2/3PNb8rBqKJ88q9hvIM2fEhvFqiBQWusEOPy7aEIiHpwD10qCLZ8B77KN2nSFpJle4k5ZjOYwC8znbdPjqmwQyZBDfxKA73DtIsmhSQYJuasglhCKUG6XOdGtp7d/X6TQTVkiiP4t0Ya8hc8cqcDfH1xMcfmcDRH1e/rDuBdQR6R+24rLFeZ0DzzomWS1VPpSXjBOgBfS41NE0XioL+qvcPpbpCJkcR/8C0Bj0Lv1rC/vNF6Svmq8Z3PkWM7YCT5eW2S6EdYicVZHozMx5n0+WA05iiVBvru9ZthuEZEI6SAfv9CBjI59qxG26Em4XrJCwB9fGkp+iNjR/eDm0nPsveCF8vt+jyJNluGtsuils2O/ByUn6yGpt1spxbo41pp66L+3xyiB7eTL2ZgD1Xhwk+1NWDbvxJkx+psXHjetFl31Z6yzTJuPCIzjGRQYQRL/8nlziwsdAHccPzzdiZ3+zvfyndO3MsFasHPxPRWhg6SHHWsMBoA5xWgnr47hOGoloWIicOc8E6pEPFfXhMz+oVb/QZqywegWXP3bVO0mJK+u6GEjd5S/XoINPWZ0Cv1AcqvsiWMh4uMq1KNJLkG/W6Mb0abXHBgTTvgkYQ9LeC0ptRnG7tjp4TQJ8pMGvUgDaEx00NpbJraQVvPH6C3XyRSR+izP+/WybXrZn6",
},51139,1328,2837733193,779050196},
[36] = {{
"KKzhY1LHGD7x00uGcbYMyXEmwnnuG5xpbS7XIgKoDVT1OsRIBdgUzkBYwZwYjULd0PJao5NmTu0McAu8v1bTsupjN053SKNkuDm967UgfVhWuAa8wCdBkZIC/mumhO0XF4e/UQwYJ3Q",
},12260,104,4017890607,3114420514},
[27] = {{
"rDrVbTTaCOAEjAJChQBS3IUl3bFmX7ILV2MeXFqU2CIsQ6Hd+W5DYOYgJnE9lL+I/D00B3LeI5/bPIhn3k0ImniMtN37u4+HTYVnqqTCzNkUQJp60fhwkfy4aLk+plDIA69gTF9Fdij5UbEkW4UnCiZ16eNRaXrUp7DRxekVoOVHYed+c9ItgoJdEGSJyaXCxTo46CmJArXF11ldeLed6swrvySoe//cnL2nea84GhMoLsAd2UhDLroR4NPSx11OfWJAFNKBhC6PuuGu9nS/fMdfXIffjzWhYXUXNMGtB1szIltGH7LZLDSRPms0i3gKenZ5ccsmvV1/DY/U1OSC9S53lGDzGG70wpjWCpf8CHaVnkfgWH7+cqoSuJW4W92iJ38jpFYVwwhzDxl2IJ5ZewZtfEq6WARCBn1uP6qc5Y0aaeqhpp5dbwJkUwnFUQoENJKyO9wrpCQCVEU2BCyRq4kl3dyo00IcArE5945L0x89be/4SG7RnzgnjOd9tf/xuKVhq6eRDvLSripIj7RanN1oKpn5q2L1ariDYPd2Ae+kTMuwSgUBL8TzBN9dkOsoAh3DeUK3HFUqUbTQ0+dBRpYFxmk3tS1R3o3G8ZmN/jQYwKrZ3NQeOg49Mxmc/4IcWE3cnhrZTTfInqO7RIfkGmHLFZfCO2DrVo8yFYBND111WBEZGBBvtqaJK/OD/WtYxzp8PQkjmPcrDfxIB5FzrwR8lNshxJa5YFCkHka7HrGDXIn40HqUpWn2bIElT5HfnA4bJU1zp8GFOrPSGiQTi9EE0uXc9gvlbbxzr7pOAPimJXtDL+GNJ9dJ7KX9xprNSnB3oweVJredMtL5q59AYTZk4zNrKZviXUldhnXdrVv+iThTI32sm7EuklBXgiYsEdlpCgUc",
},39155,678,2857181184,1860448067},
[7] = {{
"ur3mH1ccCICckIVao88saCPYoey8Zt/TsH0xNJot5bksj/2Upjybzn1VvATViFNrHjhnbASd4ecrTTEXMeLGO+d5aGe8mvpskABS24G/gB2A9kIkHb8JFBcaiM3rv0t/yA5qP9XwXunw8eoK2zmfZnUDCoZxoUBbaeUr/fz1KYA5YE9Ojt6049MF8LS0d9xt7OTp9VJwO9IbNd9n6pxzh2ZLo3ckRBm04wONw7IYIH++dJPY1qcH9LR7S4hTEbt7U3qpj/R1eM57UADAiLO3jhMYPEUpG092KcjENHOItw83lDXM6aw25fNHoAzyN5pFzBKyrHqwPJz+Y2BvmYTKncOvieBW+kzZZ0uy7adqFmcjySeU6dDHAhgx5eHhYHndRo+pRJlDbyIUY/pdg56wwdYVCMk62r5M4IAzPsC0rs+Y9ogDK3L61P82+ARD3F2hgITPpQg1tZYZve2Pr3zNDdvz",
},5718,354,1752927615,1132227774},
[19] = {{
"y3lBlDGY7OJ00Xk04To24AhcAHuOYy09PIoDCj3TmTcmex9LJV0x4p3zNwsVV3nr7Es9eAPme/dVVN",
},10776,58,2231242607,896572045},
}
                            
                                                                               
local function _zag(_abg, _bbg)
    local _cbg, _dbg = 0, 1
    for _ebg = _bbg, _bbg + 4 do
        local _fbg = buffer.readu8(_abg, _ebg)
        _cbg += _fbg % 128 * _dbg
        if _fbg < 128 then
            assert(_cbg <= 4294967295, _qef[40])
            return _cbg, _ebg + 1
        end
        _dbg *= 128
    end
    error(_qef[41])
end

local function _gbg(_hbg)
    return if _hbg % 2 == 0 then _hbg / 2 else -(_hbg + 1) / 2
end

local function _ibg(_jbg, _kbg, _lbg, _mbg, _nbg)
    assert(_nbg <= 8, _qef[42])
    local _obg
    _obg, _kbg = _zag(_jbg, _kbg)
    if _obg == 0 then return nil, _kbg
    elseif _obg == 1 then return false, _kbg
    elseif _obg == 2 then return true, _kbg
    elseif _obg == 3 then
        local _pbg, _qbg = _zag(_jbg, _kbg)
        return _gbg(_pbg), _qbg
    elseif _obg == 4 then
        return buffer.readf64(_jbg, _kbg), _kbg + 8
    elseif _obg == 5 then
        local _rbg
        _rbg, _kbg = _zag(_jbg, _kbg)
        return buffer.readstring(_jbg, _kbg, _rbg), _kbg + _rbg
    elseif _obg == 7 then
        local _sbg
        _sbg, _kbg = _zag(_jbg, _kbg)
        assert(_sbg <= buffer.len(_jbg) - _kbg, _qef[43])
        local _tbg = table.create(_sbg)
        for _ubg = 1, _sbg do
            _tbg[_ubg], _kbg = _ibg(_jbg, _kbg, _lbg, _mbg, _nbg + 1)
        end
        return _tbg, _kbg
    elseif _obg == 8 then
        local _vbg, _wbg = buffer.readf64(_jbg, _kbg), buffer.readf64(_jbg, _kbg + 8)
        local _xbg, _ybg = buffer.readf64(_jbg, _kbg + 16), buffer.readf64(_jbg, _kbg + 24)
        if _mbg then
            local _zbg = {_vbg,_wbg,_xbg,_ybg}
            _mbg[_zbg] = true
            return _zbg, _kbg + 32
        end
        if _lbg.vectorSize == 4 then return _lbg.vectorCtor(_vbg,_wbg,_xbg,_ybg), _kbg + 32 end
        return _lbg.vectorCtor(_vbg,_wbg,_xbg), _kbg + 32
    elseif _obg == 9 then
        assert(integer and integer.fromstring, _qef[44])
        local _acg, _bcg = _ibg(_jbg, _kbg, _lbg, _mbg, _nbg + 1)
        return integer.fromstring(_acg, 10), _bcg
    end
    error(_qef[45])
end

local function _ccg(_dcg, _ecg, _fcg, _gcg, _hcg, _icg)
    local _jcg, _kcg = buffer.len(_dcg), 0
    local function _lcg()
        local _mcg
        _mcg, _kcg = _zag(_dcg, _kcg)
        return _mcg
    end
    local function _ncg()
        local _ocg = _lcg()
        assert(_ocg > 0 and _ocg <= _jcg - _kcg, _qef[46])
        local _pcg = {_kcg, _ocg}
        _kcg += _ocg
        return _pcg
    end
    local _qcg, _rcg, _scg, _tcg = _lcg(), _lcg(), _lcg(), _lcg()
    assert(_qcg <= 255 and _rcg <= _qcg and _scg <= 200, _qef[47])
    local _ucg = _lcg()
    assert(_ucg <= _jcg - _kcg, _qef[48])
    local _vcg = table.create(_ucg)
    for _wcg = 1, _ucg do
        local _xcg = _lcg()
        assert(_xcg > 0 and _xcg <= _gcg, _qef[49])
        _vcg[_wcg] = _xcg
    end
    local _ycg = _lcg()
    assert(_ycg <= (_jcg - _kcg) / 2, _qef[50])
    local _zcg = table.create(_ycg)
    for _adg = 1, _ycg do _zcg[_adg] = _ncg() end
    local _bdg = _lcg()
    assert(_bdg <= (_jcg - _kcg) / 3 and _bdg <= _tcg and _tcg <= _bdg * 4,
        _qef[51])
    local _cdg = _aff(12, _wef(_ecg, 0, 2))
    local _ddg = table.create(_tcg)
    local _edg = {}
    local _fdg = {
        __index = function(_gdg, _hdg)
            if _hdg == _xff[13] then return _ref(_gdg[_xff[15]], _gdg[_xff[16]]) end
            local _idg = _edg[_gdg]
            if not _idg or not _idg.fields[_hdg] then return nil end
            local _jdg = _jff(_dcg, _idg[1], _idg[2], _idg.key, false)
            local _kdg = _idg.literalStart
            for _ldg, _mdg in _idg.order do
                local _ndg
                _ndg, _kdg = _ibg(_jdg, _kdg, _hcg, _icg, 0)
                if _mdg == _hdg then
                    if _mdg == _idg.order[#_idg.order] then
                        assert(_kdg == _idg[2], _qef[52])
                    end
                    return _ndg
                end
            end
        end,
    }
    for _odg = 1, _bdg do
        local _pdg = _lcg()
        assert(_pdg > 0 and _pdg <= _tcg and not _ddg[_pdg], _qef[53])
        local _qdg = _ncg()
        _qdg.key = _wef(_ecg, _pdg, 2)
        local _rdg = _jff(_dcg, _qdg[1], _qdg[2], _qdg.key, false)
        local _sdg, _tdg = _zag(_rdg, 0)
        local _udg = _wef(_ecg, _pdg, 5) % 512
        local _vdg = _sdg % 512
        assert(_sdg < 2097152, _qef[54])
        local _wdg = {[_xff[15]]=_vdg, [_xff[16]]=_udg, [_xff[14]]=_qef[55]}
        local _xdg = math.floor(_sdg / 512)
        local _ydg, _zdg
        for _aeg = 1, #_cdg do
            local _beg = _cdg[(_aeg + _pdg - 1) % #_cdg + 1]
            if not bit32.btest(_xdg, 2 ^ (_beg - 1)) then continue end
            local _ceg = _xff[_beg]
            if _hff(_beg) then
                local _deg
                _deg, _tdg = _zag(_rdg, _tdg)
                _wdg[_ceg] = if _beg == 4 or _beg == 5 then _gbg(_deg) else _deg
            else
                if not _ydg then _ydg, _zdg = {}, {} end
                _ydg[_ceg] = true
                _zdg[#_zdg + 1] = _ceg
            end
        end
        if _ydg then
            assert(_tdg < _qdg[2], _qef[56])
            _qdg.literalStart, _qdg.fields, _qdg.order = _tdg, _ydg, _zdg
            _edg[_wdg] = _qdg
        else
            assert(_tdg == _qdg[2], _qef[52])
        end
        _ddg[_pdg] = setmetatable(_wdg, _fdg)
    end
    assert(_kcg == _jcg and _ddg[1], _qef[57])

    local _eeg = setmetatable({}, {
        __index = function(_feg, _geg)
            local _heg = _zcg[_geg]
            if not _heg then return nil end
            local _ieg = _jff(_dcg, _heg[1], _heg[2], _wef(_ecg, _geg, 1), false)
            local _jeg, _keg = _ibg(_ieg, 0, _hcg, _icg, 0)
            assert(_keg == _heg[2], _qef[58])
            return _jeg
        end,
    })
    return {
        maxstacksize=_qcg, numparams=_rcg, nups=_scg, sizecode=_tcg,
        sizek=_ycg, code=_ddg, k=_eeg, protos=_vcg, debugcode={},
        debugname=_qef[59], bytecodeid=_fcg - 1, lineinfoenabled=false,
        flowKey=_wef(_ecg, _fcg, 4),
    }
end

local _leg = _yff.luau_newsettings()
_leg.errorHandling = false
if type(Vector3) == _qef[1] and type(Vector3.new) == _qef[2] then
    _leg.vectorCtor = Vector3.new
elseif type(vector) == _qef[1] and type(vector.create) == _qef[2] then
    _leg.vectorCtor = vector.create
end

local _hfg = type
_leg.useNativeNamecall = true
_leg.namecallHandler = function(_ifg, _jfg, ...)
    if _hfg(_jfg) == _qef[60] then
        local _h_ok, _h_1, _h_2, _h_3, _h_4 = _MS_GUARD.invoke(_jfg, _ifg, ...)
        if _h_ok then return true, _h_1, _h_2, _h_3, _h_4 end
    end
    return false
end
local _lfg = 55
local _mfg = 55

local function _nfg(_ofg, _pfg)
    local _qfg = _yag[_ofg]
    assert(_qfg and _qfg[3] <= 16777216, _qef[61])
    local _rfg = _eag(_qfg[1], _qfg[2], _qfg[3], _qfg[4])
    return _ccg(_rfg, _qfg[5], _ofg, _lfg, _leg, _pfg)
end
local _sfg = setmetatable({}, {
    __index = function(_tfg, _ufg)
        assert(type(_ufg) == _qef[4] and _ufg >= 1 and _ufg <= _lfg, _qef[62])
        local _vfg = _nfg(_ufg)
        rawset(_tfg, _ufg, _vfg)
        _yag[_ufg] = nil
        return _vfg
    end,
})
local _wfg = {protoList = _sfg, mainProto = _sfg[_mfg]}
local _xfg = _yff.luau_load(_wfg, getfenv(1), _leg)
local _pack, _unpack = table.pack, table.unpack
local _results = _pack(_xfg(...))
_MS_GUARD.wipe(_wfg.mainProto)
return _unpack(_results, 1, _results.n)

