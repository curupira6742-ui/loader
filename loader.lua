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


local _rldf=function(_sldf,_tldf)
    local _uldf, _vldf = {}, bit32.bxor
    for _wldf=1,#_sldf do
        local _xldf = string.byte(_sldf,_wldf)
        _uldf[_wldf] = string.char(_vldf(_xldf,_tldf))
        _tldf = (_tldf + _xldf + 43) % 256
    end
    return table.concat(_uldf)
end
local _yldf={
_rldf("\101\192\238\201\252",17),
_rldf("\222\180\206\250\202\218\215\212",184),
_rldf("\025\217\200\221\222\248\227\130\054\150\229\252\147\181\056\153\196\160\000\204\088\137\202\213\209\201\230\192\227\190\203\008\209\217\144\028\219\204\199\129\047\210\194\247\214\198\137\121\159\174\212\172\068\197\180\218\221\225\185\208\206\201\252\238\180\215\204\212",84),
_rldf("\217\206\217\218\216\178",183),
_rldf("\059\218\193\246\174\254",72),
_rldf("\218\210\213\214\222\165\250",184),
_rldf("\029\214\215\194\204\232\238\178\204\232\141\018\195\227\190\233\244\206\147\001\239\216\204\216\208\202\192",107),
_rldf("\091\250\180\246\182\196\176\052\149\228\248\209\221\163\239\196\251\157\237\252\170\253\173\252\178\189\242\195\227\190\233\244\206\147\001\239\216\204\216\208\202\192",21),
_rldf("\115\200\209\217\239\185\203\208\235\220\210\222\177\190\244\206\240\207\216\211\149\023\210\148\018\144\031\212\214\217\220",31),
_rldf("\218\206\213\193\255\185\203\208\235\220\210\222\177\176\015\214\215\194\204\232\238\178\204\232\141\022\206\240\207\216\211\149\023\210\148\018\144\013\214\202\250\202\218\215\212",182),
_rldf("\161\236\209\217\239\185\203\208\235\220\210\222\177\176\015\214\215\194\204\232\254\191\186\192\176\024\198\240\207\216\211\149\023\210\148\018\144\005\238\217\218\216\178",205),
_rldf("\160\226\197\225\255\185\203\208\235\220\210\222\177\176\012\195\251\138\024\200\198\214\196\222\248\209\221\163\239\196\251\157\246\206\240\207\216\211\149\023\210\148\018\144\009\240\213\214\222\165\250",204),
_rldf("\045\236\209\217\239\185\203\208\235\220\210\222\177\176\023\218\173\253\163\239\196\251\245\188\170\253\173\252\178\189\246\206\240\207\216\211\149\023\210\148\018\144\013\214\202\250\202\218\215\212",65),
_rldf("\201\236\209\217\239\185\203\208\235\220\210\222\177\176\028\184\215\192\254\202\199\207\244\202\142\020\206\240\207\216\211\149\023\210\148\018\144\031\212\214\217\220\224\164\252\225\171\214\202\250\202\218\215\212\202",165),
_rldf("\128\226\197\225\255\185\203\208\235\220\210\222\177\176\026\223\164\251\245\178\213\209\197\134\036\206\240\207\216\211\149\023\210\148\018\144\031\212\214\217\220\224\164\252\225\171\214\202\250\202\218\215\212\202",236),
_rldf("\066\238\213\193\255\185\203\208\235\220\210\222\177\176\028\178\239\216\200\229\220\170\253\173\240\218\222\226\188\222\208\207\216\211\149\023\210\148\018\144\009\240\213\214\222\165\250",46),
_rldf("\075\232\209\217\239\185\203\208\235\220\210\222\177\176\030\167\250\220\178\252\168\254\186\192\244\230\180\250\182\196\224\246\175\244\153\014\222\208\207\216\211\149\023\210\148\018\144\009\240\213\214\222\165\250",39),
_rldf("\067\232\209\217\239\185\203\208\235\220\210\222\177\176\024\208\219\210\205\226\205\216\194\222\245\162\239\216\200\222\150\004\206\240\207\216\211\149\023\210\148\018\144\009\240\213\214\222\165\250",47),
_rldf("\143\232\209\217\239\185\203\208\235\220\210\222\177\176\010\218\210\196\246\163\203\234\239\218\202\194\244\212\221\174\237\145\030\222\208\207\216\211\149\023\210\148\018\144\031\212\214\217\220",227),
_rldf("\081\204\209\217\239\185\203\208\235\220\210\222\177\176\012\195\251\141\017\200\196\232\217\242\161\244\202\218\210\222\205\194\190\244\206\240\207\216\211\149\023\210\148\018\144\009\240\213\214\222\165\250",61),
_rldf("\191\200\209\217\239\185\203\208\235\220\210\222\177\176\011\202\209\211\251\135\026\212\201\219\198\192\227\190\244\206\240\207\216\211\149\023\210\148\018\144\009\240\213\214\222\165\250",211),
_rldf("\053\204\209\217\239\185\203\208\235\220\210\222\177\176\029\164\243\193\254\166\219\234\143\026\198\240\207\216\211\149\023\210\148\018\144\013\214\202\250\202\218\215\212",89),
_rldf("\000\023\217\167\243\144\006\243\222\182\200\242\148\001\250\181\209\201\230\192\244",79),
_rldf("\250\150\212\220",180),
_rldf("\208\210",166),
_rldf("\035\229",72),
_rldf("\193\250\207\210\220\222\164\175\038\215\217\167\243\144\015\204\239\198\198\236\204\206\191\250\218\210\196\250",168),
_rldf("\033\249\136\221\222\248\227\130\054\150\229\252\147\175\079\128\250\207\210\220\222\164\175\063\158\188\234\246\202\218\193\234\215\194\202\247\212",108),
_rldf("\246\204\219\208\221\200\223\149\001\206\186\022\180\250\182\196\224\250\228\188\204\212\194\189\228\180\086\135\134\033\194\252\194\193",151),
_rldf("\181\210\207\210\220\222\164\175\078\132\254\200\138\066\163\244\209\209\192\191\161\059\206\217\218\216\178\189\224\232\211\196\243\218\214\208\134",220),
_rldf("\119\174\239\210\220\222\164\175\078\132\254\200\138\066\188\194\198\228\131\121\155\206\217\218\216\178\189\224\232\211\196\243\218\214\208\134",30),
_rldf("\198\206\239\210\220\222\164\175\078\132\254\200\138\066\166\206\253\164\232\131\121\155\206\217\218\216\178\189\224\232\211\196\243\218\214\208\134",175),
_rldf("\061\210\220\194\193",75),
_rldf("\183\218\218\209\207\218\205\212\194\248\164\175\028\222\209\212\218\221\173\252\164\175\042\255\184\159\192\210\056",210),
_rldf("",170),
_rldf("\098\216\193\128\029\222\188\198\006\215\200\232\141\030\142\041\218\173\253\250\197\240\131\190\203\020\210\220\250\197\240\131\190\215\202\068\205\192\163\190\200\010\204\201\254\166\174\077\192\163\190\250\150\077\192\163",36),
_rldf("\017\250\205\144\061\158\188\198\006\215\200\232\141\030\142\041\218\173\253\250\197\240\131\190\215\202\068\205\192\163\190\200\010\204\201\254\166\174\077\192\163\190\250\150\077\192\163",87),
_rldf("\043\240\228\170\252\134\240\214\223\206\231\134\042\143\233\165\022\212\222\247\188\210\220\200\151\072\138\172\019\231\134\006\202\225\151\055\240\175\236\225\179\217\241\246\200\128\200\217\244\232\150\243\231\231\128\050\255\175\152\213\245\252\177\223",100),
_rldf("\083\221\240\237\158\248\227\130\054\150\229\252\147\175\079\128\250\207\210\220\222\164\175\063\158\188\243\192\245\192\248\219\164",30),
_rldf("\032\215\217\167\243\144\029\210\194\244\210\205\145\002\236\212\194\251\175\242\205",111),
_rldf("\062\174\239\210\220\222\164\175\038\215\217\167\243\144\029\210\194\244\210\205",87),
_rldf("\087\247\217\167\243\144\008\241\212\202\218\210\222\205\145\003\254\183\210\202\246\222\226\163\244\209\209\192",24),
_rldf("\180\210\207\210\220\222\164\175\038\215\217\167\243\144\008\241\212\202\218\210\222\205\145\001\240\199\210",221),
_rldf("\247\183\217\167\243\144\025\202\213\209\201\230\192\227\190\239\206\233\218\147\024\218\205\212\215\215\198\133\038\211\212\211\206\232\217",184),
_rldf("\090\214\207\210\220\222\164\175\038\215\217\167\243\144\008\241\212\202\218\210\222\205\145\025\208\203",51),
_rldf("\000\237\194\202\250\223\188\202\192\175\038\215\217\167\243\144\013\209\254\165\253",116),
_rldf("\201\250\207\210\220\222\164\175\038\215\217\167\243\144\013\214\202\250\202\218\215\212\153\027\177\254\165\253",160),
_rldf("\139\246\207\210\220\222\164\175\038\215\217\167\243\144\008\242\212\201\219\198\192\176\008\241\207\218\205",226),
_rldf("\236\242\207\210\220\222\164\175\038\215\217\167\243\144\008\242\212\201\219\198\192\176\025\202\194\244\194\248\174\250\219",133),
_rldf("\164\242\207\210\220\222\164\175\038\215\217\167\243\144\008\241\212\202\218\210\222\205\194\190\228\249\207\218\205",205),
_rldf("\241\218\207\210\220\222\164\175\038\215\217\167\243\144\008\241\222\166\180\000\247\186\192",152),
_rldf("\044\222\220\184\211\196\243\218\214\208\143\038\215\217\167\243\144\002\246\202\218\193\234\215\194\202\247\212\153\009\208\197\240",89),
_rldf("\217\218\207\210\220\222\164\175\038\215\217\167\243\144\002\246\202\218\193\234\215\194\202\247\212\153\028\160\235\215\194\231\213",176),
_rldf("\065\250\207\210\220\222\164\175\038\215\217\167\243\144\004\234\202\214\196\224\246\175\244",40),
_rldf("\176\215\217\167\243",223),
_rldf("\177\209\199\213\207\206\254\226\128\023\217\167\243\144\004\234\202\214\196\250\221\178",220),
_rldf("\005\242\207\210\220\222\164\175\038\215\217\167\243\144\027\208\207\205\251\176\191\229\248\197\195\239\192",108),
_rldf("\050\202\252\184\211\196\243\218\214\208\143\038\215\217\167\243\144\008\241\212\202\218\210\222\205\145\025\208\197\240",71),
_rldf("\002\056\215\217\167\243\153",42),
_rldf("\184\195\251\182\193\240\216\206",205),
_rldf("\160\250\207\210\220\222\164\175\038\215\217\167\243\144\027\208\207\205\251\176",201),
_rldf("\245\210\207\210\220\222\164\175\038\215\217\167\243\144\027\195\240\206\220\206\202\216\206",156),
}
                                                       

assert(type(buffer) == _yldf[1] and type(bit32) == _yldf[1] and type(table.move) == _yldf[2],
    _yldf[3])
                                                      
local _zldf, _amdf, _bmdf = bit32.bxor, bit32.lshift, bit32.rshift

local function _cmdf(_dmdf)
    _dmdf = _zldf(_dmdf, _amdf(_dmdf, 13))
    _dmdf = _zldf(_dmdf, _bmdf(_dmdf, 17))
    return _zldf(_dmdf, _amdf(_dmdf, 5))
end

local function _emdf(_fmdf, _gmdf, _hmdf)
    return _cmdf(_zldf(_fmdf, _gmdf * 65537, _hmdf)) + 1
end

local function _imdf(_jmdf, _kmdf)
    local _lmdf = table.create(_jmdf)
    for _mmdf = 1, _jmdf do _lmdf[_mmdf] = _mmdf end
    for _nmdf = _jmdf, 2, -1 do
        _kmdf = _cmdf(_kmdf + _nmdf)
        local _omdf = _kmdf % _nmdf + 1
        _lmdf[_nmdf], _lmdf[_omdf] = _lmdf[_omdf], _lmdf[_nmdf]
    end
    return _lmdf
end

local function _pmdf(_qmdf)
    return _qmdf <= 6 or _qmdf == 11
end

local function _rmdf(_smdf, _tmdf, _umdf, _vmdf, _wmdf)
    local _xmdf = buffer.create(_umdf)
    local _ymdf = _umdf - _umdf % 4
    for _zmdf = 0, _ymdf - 1, 4 do
        local _andf = buffer.readu32(_smdf, _tmdf + _zmdf)
        local _bndf = _zldf(_andf, _vmdf)
        buffer.writeu32(_xmdf, _zmdf, _bndf)
        _vmdf = _cmdf(_vmdf + (if _wmdf then _bndf else _andf) + _zmdf + 1)
    end
    for _cndf = _ymdf, _umdf - 1 do
        local _dndf = buffer.readu8(_smdf, _tmdf + _cndf)
        local _endf = _zldf(_dndf, _vmdf % 256)
        buffer.writeu8(_xmdf, _cndf, _endf)
        _vmdf = _cmdf(_vmdf + (if _wmdf then _endf else _dndf) + _cndf + 1)
    end
    return _xmdf
end

local _fndf = {11,15,9,3,5,13,6,10,2,14,1,12,8,4,16,7,}
local _gndf = (function()
local _hndf = {
  bit32.bxor(bit32.bxor(8755314, 5834639), 14458877),
  bit32.bxor(bit32.bxor(3883510, 4166497), 316054),
  bit32.bxor(9728660, bit32.bxor(9329723, 1715885)),
  bit32.bxor(5277491, bit32.bxor(7880480, 2668560)),
  bit32.bxor(2652482, bit32.bxor(8321072, 5669238)),
  bit32.bxor(bit32.bxor(2934878, 10675947), 9318064),
  bit32.bxor(1882472, bit32.bxor(4128299, 2246474)),
  bit32.bxor(bit32.bxor(1398172, 7269421), 8108476),
  bit32.bxor(9261419, bit32.bxor(4004323, 11552927)),
  bit32.bxor(bit32.bxor(2024364, 2340225), 4019764),
  bit32.bxor(5251928, bit32.bxor(8570079, 13821851)),
  bit32.bxor(bit32.bxor(1070203, 6656959), 7718873),
  bit32.bxor(7124475, bit32.bxor(3804102, 5684771)),
  bit32.bxor(7437307, bit32.bxor(1504761, 6786592)),
  bit32.bxor(bit32.bxor(254362, 1934806), 1991777),
  bit32.bxor(3718810, bit32.bxor(5163005, 7764308)),
  bit32.bxor(bit32.bxor(9787719, 5782062), 13460306),
  bit32.bxor(649734, bit32.bxor(647433, 2866)),
  bit32.bxor(9072432, bit32.bxor(1880474, 9887467)),
  bit32.bxor(bit32.bxor(8204763, 2323834), 6178019),
  bit32.bxor(5037026, bit32.bxor(5905203, 1491093)),
  bit32.bxor(7321533, bit32.bxor(9250728, 14848080)),
  bit32.bxor(2633712, bit32.bxor(1995369, 3562962)),
  bit32.bxor(123765, bit32.bxor(3105860, 3049340)),
  bit32.bxor(bit32.bxor(5159030, 4093201), 7392563),
  bit32.bxor(3743530, bit32.bxor(6744143, 6289200)),
  bit32.bxor(7758147, bit32.bxor(349412, 7550463)),
  bit32.bxor(1690003, bit32.bxor(2896804, 3537513)),
  bit32.bxor(bit32.bxor(5214807, 13079188), 8913052),
  bit32.bxor(bit32.bxor(3973958, 8272268), 4364969),
  bit32.bxor(4100697, bit32.bxor(2181079, 2086371)),
  bit32.bxor(bit32.bxor(2295386, 11223022), 8927706),
  bit32.bxor(bit32.bxor(5797023, 8843602), 14583228),
  bit32.bxor(bit32.bxor(5862640, 14002689), 9232003),
  bit32.bxor(bit32.bxor(8217811, 3740768), 4485316),
  bit32.bxor(bit32.bxor(5116850, 4316306), 1036121),
  bit32.bxor(bit32.bxor(1775360, 2687334), 3282458),
  bit32.bxor(8325240, bit32.bxor(6170276, 2174627)),
  bit32.bxor(bit32.bxor(6434532, 16221658), 9808825),
  bit32.bxor(bit32.bxor(4603841, 26684), 4609908),
  bit32.bxor(bit32.bxor(5160158, 9553800), 14646237),
  bit32.bxor(bit32.bxor(1961741, 10025281), 8722113),
  bit32.bxor(8803547, bit32.bxor(9685748, 1416895)),
  bit32.bxor(6260077, bit32.bxor(3463079, 7033426)),
  bit32.bxor(bit32.bxor(7577802, 1833359), 6838750),
  bit32.bxor(bit32.bxor(5112706, 13580412), 8469347),
  bit32.bxor(bit32.bxor(6508126, 7193890), 953307),
  bit32.bxor(bit32.bxor(855678, 2657263), 2458936),
  bit32.bxor(bit32.bxor(1933859, 1037894), 1201353),
  bit32.bxor(bit32.bxor(8804901, 2562666), 10567933),
  bit32.bxor(3305076, bit32.bxor(3062621, 1889690)),
  bit32.bxor(bit32.bxor(7001917, 3737120), 5493160),
  bit32.bxor(bit32.bxor(2645190, 4397844), 7030633),
  bit32.bxor(bit32.bxor(2545834, 3794469), 2047564),
  bit32.bxor(bit32.bxor(3926529, 1899344), 2560413),
  bit32.bxor(3268891, bit32.bxor(9042869, 12065407)),
  bit32.bxor(597813, bit32.bxor(6232182, 5638036)),
  bit32.bxor(bit32.bxor(9494726, 2912035), 12357381),
  bit32.bxor(bit32.bxor(2404113, 1150328), 3482248),
  bit32.bxor(bit32.bxor(7771317, 888660), 8067843),
  bit32.bxor(bit32.bxor(9004401, 678317), 8600633),
  bit32.bxor(bit32.bxor(7596974, 1906986), 7271011),
  bit32.bxor(bit32.bxor(6174101, 7844706), 2721307),
  bit32.bxor(bit32.bxor(1043931, 1664311), 1476609),
  bit32.bxor(bit32.bxor(4645170, 8479969), 13075747),
  bit32.bxor(bit32.bxor(3642857, 2242825), 1420306),
  bit32.bxor(8300538, bit32.bxor(3308917, 5036667)),
  bit32.bxor(1940241, bit32.bxor(5041482, 5338798)),
  bit32.bxor(bit32.bxor(1389050, 9834315), 8601159),
  bit32.bxor(bit32.bxor(5274661, 5574895), 355389),
  bit32.bxor(bit32.bxor(141184, 1061997), 1184534),
  bit32.bxor(151002, bit32.bxor(446277, 295520)),
  bit32.bxor(bit32.bxor(5244888, 7876000), 2632561),
  bit32.bxor(4471142, bit32.bxor(2605763, 6552232)),
  bit32.bxor(bit32.bxor(8623125, 12520148), 3973073),
  bit32.bxor(bit32.bxor(4617727, 393000), 4426694),
  bit32.bxor(bit32.bxor(8903084, 14546365), 5909763),
  bit32.bxor(8320782, bit32.bxor(7203719, 1252765)),
  bit32.bxor(2488329, bit32.bxor(2832131, 970257)),
  bit32.bxor(bit32.bxor(2302824, 4956796), 6848567),
  bit32.bxor(bit32.bxor(7581407, 4030015), 5165510),
  bit32.bxor(4888476, bit32.bxor(1043501, 4553371)),
  bit32.bxor(bit32.bxor(466799, 2270319), 2472499),
  bit32.bxor(bit32.bxor(9168010, 744620), 8435986),
  bit32.bxor(bit32.bxor(1579728, 8295306), 6719596),
  bit32.bxor(bit32.bxor(844284, 3501043), 3771192),
  bit32.bxor(bit32.bxor(9238208, 15519902), 6301541),
  bit32.bxor(bit32.bxor(6826856, 2919467), 4499071),
  bit32.bxor(6411236, bit32.bxor(714585, 7026172)),
  bit32.bxor(5231178, bit32.bxor(4237159, 1012847)),
  bit32.bxor(5342204, bit32.bxor(2990121, 8135313)),
  bit32.bxor(bit32.bxor(6948569, 8220815), 1537811),
  bit32.bxor(bit32.bxor(2169877, 297795), 2463261),
  bit32.bxor(bit32.bxor(1622485, 606369), 1146937),
  bit32.bxor(5439207, bit32.bxor(8432086, 13784703)),
  bit32.bxor(bit32.bxor(3921318, 6017716), 6293062),
  bit32.bxor(bit32.bxor(1328376, 5309654), 4538744),
  bit32.bxor(bit32.bxor(5862042, 3219348), 6843472),
  bit32.bxor(bit32.bxor(3577036, 11760815), 8773903),
  bit32.bxor(bit32.bxor(8612101, 8040324), 16369657),
  bit32.bxor(bit32.bxor(2425097, 546187), 2970882),
  bit32.bxor(bit32.bxor(8832663, 1142437), 9939376),
  bit32.bxor(bit32.bxor(6364512, 15458716), 9108853),
  bit32.bxor(bit32.bxor(2907344, 93576), 2961610),
  bit32.bxor(8413825, bit32.bxor(1353910, 9751468)),
  bit32.bxor(bit32.bxor(5898583, 3655830), 7194719),
  bit32.bxor(bit32.bxor(6910055, 5793113), 3216542),
  bit32.bxor(4524110, bit32.bxor(2587453, 6451927)),
  bit32.bxor(bit32.bxor(9720622, 3506756), 10604738),
  bit32.bxor(bit32.bxor(729398, 7017231), 6304659),
  bit32.bxor(bit32.bxor(7329834, 6759809), 588911),
  bit32.bxor(bit32.bxor(615653, 1225361), 1824698),
  bit32.bxor(bit32.bxor(716509, 333847), 1046297),
  bit32.bxor(bit32.bxor(3395375, 7643201), 4681399),
  bit32.bxor(bit32.bxor(3377819, 4822429), 8003293),
  bit32.bxor(bit32.bxor(2262439, 3347260), 1152837),
  bit32.bxor(928149, bit32.bxor(432611, 569748)),
  bit32.bxor(bit32.bxor(4448098, 6988860), 2718397),
  bit32.bxor(3167341, bit32.bxor(8084190, 4919127)),
  bit32.bxor(bit32.bxor(3114077, 9203741), 10745253),
  bit32.bxor(4744906, bit32.bxor(3886162, 7547760)),
  bit32.bxor(bit32.bxor(1090080, 4750494), 5824335),
  bit32.bxor(4931547, bit32.bxor(5949705, 1177377)),
  bit32.bxor(8175071, bit32.bxor(7974870, 332797)),
  bit32.bxor(bit32.bxor(5541575, 4264278), 1416809),
  bit32.bxor(bit32.bxor(338837, 5592255), 5275345),
  bit32.bxor(1796517, bit32.bxor(6410571, 8042770)),
  bit32.bxor(bit32.bxor(4759499, 5808419), 1064726),
  bit32.bxor(bit32.bxor(1756467, 1116862), 771698),
}
                                                                                                                       
local _indf = type
local _jndf = pcall
local _kndf = error
local _lndf = tonumber
local _mndf = assert
local _nndf = rawequal
local _ondf = setmetatable

local _pndf = string.format
local _qndf = math.floor
local _rndf = math.sqrt
local _sndf = if _indf(integer) == _yldf[1] then integer.fromstring else nil

local _tndf = table.move
local _undf = table.pack
local _vndf = table.unpack
local _wndf = table.create
local _xndf = table.insert
local _yndf = table.remove
local _zndf = table.concat

local _aodf = coroutine.create
local _bodf = coroutine.yield
local _codf = coroutine.resume
local _dodf = coroutine.close

local _eodf = buffer.fromstring
local _fodf = buffer.len
local _godf = buffer.readu8
local _hodf = buffer.readu32
local _iodf = buffer.readstring
local _jodf = buffer.readf32
local _kodf = buffer.readf64

local _lodf = bit32.bor
local _modf = bit32.band
local _nodf = bit32.btest
local _oodf = bit32.rshift
local _podf = bit32.lshift
local _qodf = bit32.extract

local _rodf = function(_sodf) return _indf(_sodf) == _yldf[4] end
local _todf = function(_uodf) return _indf(_uodf) == _yldf[5] end
local _vodf = function(_wodf) return _indf(_wodf) == _yldf[6] end
local _xodf = function(_yodf) return _indf(_yodf) == _yldf[2] end

                                                                                                    
                                         
                                                                          
            
         
          
           
          
          
                                                                                                                                                            
            
           
         
         
                  
                             
                              
         
                               
                                 
                                                                                                                                      

local _zodf = -1
local _apdf = -2

local function _bpdf()
	return {
		vectorCtor = function() _kndf(_yldf[7]) end,
		vectorSize = 4,
		useNativeNamecall = false,
		namecallHandler = function() _kndf(_yldf[8]) end,
		extensions = {},
		callHooks = {},
		errorHandling = true,
		generalizedIteration = true,
		allowProxyErrors = false,
		useImportConstants = false,
		reuseClosures = false,
		staticEnvironment = {},
		decodeOp = function(_cpdf) return _cpdf end
	}
end

local function _dpdf(_epdf)
	_mndf(_indf(_epdf) == _yldf[1], _yldf[9])
	_mndf(_indf(_epdf.vectorCtor) == _yldf[2], _yldf[10])
	_mndf(_indf(_epdf.vectorSize) == _yldf[4], _yldf[11])
	_mndf(_indf(_epdf.useNativeNamecall) == _yldf[6], _yldf[12])
	_mndf(_indf(_epdf.namecallHandler) == _yldf[2], _yldf[13])
	_mndf(_indf(_epdf.extensions) == _yldf[1], _yldf[14])
	_mndf(_indf(_epdf.callHooks) == _yldf[1], _yldf[15])
	_mndf(_indf(_epdf.errorHandling) == _yldf[6], _yldf[16])
	_mndf(_indf(_epdf.generalizedIteration) == _yldf[6], _yldf[17])
	_mndf(_indf(_epdf.allowProxyErrors) == _yldf[6], _yldf[18])
	_mndf(_indf(_epdf.staticEnvironment) == _yldf[1], _yldf[19])
	_mndf(_indf(_epdf.useImportConstants) == _yldf[6], _yldf[20])
	_mndf(_indf(_epdf.reuseClosures) == _yldf[6], _yldf[21])
	_mndf(_indf(_epdf.decodeOp) == _yldf[2], _yldf[22])
end

local function _fpdf(_gpdf, _hpdf, _ipdf)
	if _ipdf == nil then
		_ipdf = _bpdf()
	else 
		_dpdf(_ipdf)
	end

	_mndf(_indf(_gpdf) == _yldf[1], _yldf[23])

	local _jpdf = _gpdf.protoList
	local _kpdf = _gpdf.mainProto
	local _lpdf = {}

	local _mpdf = _ipdf.callHooks.breakHook
	local _npdf = _ipdf.callHooks.stepHook
	local _opdf = _ipdf.callHooks.interruptHook
	local _ppdf = _ipdf.callHooks.panicHook

	local _qpdf = true 

	local function _rpdf()
		_qpdf = false
	end

	local function _spdf(_tpdf, _updf, _vpdf)
		local function _wpdf(...)
			local _xpdf, _ypdf, _zpdf, _aqdf, _bqdf
			
			if _ipdf.errorHandling then
				_xpdf, _ypdf, _zpdf, _aqdf, _bqdf = ... 
			else 
				                                       
				local _cqdf = _undf(...)
				_ypdf = _wndf(_updf.maxstacksize)
				_bqdf = {
					len = 0,
					list = {},
				}
	
				_tndf(_cqdf, 1, _updf.numparams, 0, _ypdf)
	
				if _updf.numparams < _cqdf.n then
					local _dqdf = _updf.numparams + 1
					local _eqdf = _cqdf.n - _updf.numparams
					_bqdf.len = _eqdf
					_tndf(_cqdf, _dqdf, _dqdf + _eqdf - 1, 1, _bqdf.list)
				end
	
				_cqdf = nil
	
				_xpdf = {pc = 0, name = _yldf[24]}

				_zpdf = _updf.protos 
				_aqdf = _updf.code
			end 

			local _fqdf, _gqdf, _hqdf, _iqdf = -1, 1, _ondf({}, {__mode = _yldf[25]}), _ondf({}, {__mode = _yldf[26]})
			local _jqdf = _updf.k
			local _kqdf = _updf.debugcode
			local _lqdf = _ipdf.extensions

			local _mqdf = false
			local _nqdf, _oqdf
			local _pqdf = _updf.flowKey
			local _qqdf = _zldf(1, _pqdf)
			while _qpdf do
				_gqdf = _zldf(_qqdf, _pqdf)
				if not _mqdf then
					_nqdf = _mndf(_aqdf[_gqdf], _yldf[27])
					_oqdf = _zldf(_nqdf[_fndf[15]], _nqdf[_fndf[16]])
				end

				_mqdf = false

				_xpdf.pc = _gqdf
				_xpdf.top = _fqdf
				_xpdf.name = _nqdf[_fndf[14]]

				_gqdf += 1

				if _npdf then
					_npdf(_ypdf, _xpdf, _updf, _tpdf, _vpdf)
				end

if _oqdf < _hndf[65] then
if _oqdf < _hndf[33] then
if _oqdf < _hndf[17] then
if _oqdf < _hndf[9] then
if _oqdf < _hndf[5] then
if _oqdf == _hndf[1] then
					                                                         

elseif _oqdf == _hndf[2] then
					_ypdf[_nqdf[_fndf[1]]] = _ypdf[_nqdf[_fndf[2]]] + _ypdf[_nqdf[_fndf[3]]]
elseif _oqdf == _hndf[3] then
					local _rqdf = _nqdf[_fndf[12]]

					if (_ypdf[_nqdf[_fndf[1]]] == nil) ~= _rqdf then
						_gqdf += _nqdf[_fndf[4]]
					else
						_gqdf += 1
					end
elseif _oqdf == _hndf[4] then
					local _sqdf = _nqdf[_fndf[1]]
					local _tqdf = _nqdf[_fndf[2]] - 1

					if _tqdf == _zodf then
						_tqdf = _bqdf.len
						_fqdf = _sqdf + _tqdf - 1
					end

					_tndf(_bqdf.list, 1, _tqdf, _sqdf, _ypdf)
else _kndf(_yldf[28]) end
else
if _oqdf == _hndf[5] then
					_ypdf[_nqdf[_fndf[1]]] = _ypdf[_nqdf[_fndf[2]]] // _ypdf[_nqdf[_fndf[3]]]
elseif _oqdf == _hndf[6] then
					_ypdf[_nqdf[_fndf[1]]] = _nqdf[_fndf[7]]
elseif _oqdf == _hndf[7] then
					if _ypdf[_nqdf[_fndf[1]]] < _ypdf[_nqdf[_fndf[6]]] then
						_gqdf += 1
					else
						_gqdf += _nqdf[_fndf[4]]
					end
elseif _oqdf == _hndf[8] then
					_ypdf[_nqdf[_fndf[1]]] = _nqdf[_fndf[7]] / _ypdf[_nqdf[_fndf[3]]]
else _kndf(_yldf[28]) end
end
else
if _oqdf < _hndf[13] then
if _oqdf == _hndf[9] then
					_ypdf[_nqdf[_fndf[1]]] = _ypdf[_nqdf[_fndf[2]]] + _ypdf[_nqdf[_fndf[3]]]
elseif _oqdf == _hndf[10] then
					               
elseif _oqdf == _hndf[11] then
					local _uqdf = _nqdf[_fndf[7]]
					_hpdf[_uqdf] = _ypdf[_nqdf[_fndf[1]]]

					_gqdf += 1                    
elseif _oqdf == _hndf[12] then
					if _oqdf == 240 then
						_gqdf += 1                    
					end
					if _opdf then
						_opdf(_ypdf, _xpdf, _updf, _tpdf, _vpdf)	
					end

					local _vqdf, _wqdf, _xqdf = _nqdf[_fndf[1]], _nqdf[_fndf[2]], _nqdf[_fndf[3]]

					local _yqdf = if _wqdf == 0 then _fqdf - _vqdf else _wqdf - 1
					local _zqdf = _ypdf[_vqdf]
					local _ardf = _undf(
						_zqdf(_vndf(_ypdf, _vqdf + 1, _vqdf + _yqdf))
					)

					local _brdf = _ardf.n

					if _xqdf == 0 then
						_fqdf = _vqdf + _brdf - 1
					else
						_brdf = _xqdf - 1
					end

					_tndf(_ardf, 1, _brdf, _vqdf, _ypdf)
else _kndf(_yldf[28]) end
else
if _oqdf == _hndf[13] then
_ypdf[_nqdf[_fndf[1]]] = _ypdf[_nqdf[_fndf[2]]]
_ypdf[_nqdf[_fndf[3]]] = _ypdf[_nqdf[_fndf[4]]]
_gqdf += 1
elseif _oqdf == _hndf[14] then
					local _crdf = _nqdf[_fndf[7]]
					_ypdf[_nqdf[_fndf[1]]] = _crdf

					_gqdf += 1                     
elseif _oqdf == _hndf[15] then
					local _drdf = _nqdf[_fndf[1]]
					local _erdf = _nqdf[_fndf[2]]

					local _frdf = _nqdf[_fndf[7]]
					
					local _grdf = _ypdf[_erdf]

					_ypdf[_drdf + 1] = _grdf
					
					_gqdf += 1                     
					
					local _hrdf = true
					
					                                                   
					local _irdf = _ipdf.useNativeNamecall

					if _irdf then
						local _jrdf = _ipdf.namecallHandler

						local _krdf = _aqdf[_gqdf]
						local _lrdf = _krdf[_fndf[13]]

						                                       
						local _mrdf, _nrdf, _ordf = _krdf[_fndf[1]], _krdf[_fndf[2]], _krdf[_fndf[3]]

						if _npdf then
							_npdf(_ypdf, _xpdf, _updf, _tpdf, _vpdf)
						end

						if _opdf then
							_opdf(_ypdf, _xpdf, _updf, _tpdf, _vpdf)	
						end

						local _prdf = if _nrdf == 0 then _fqdf - _mrdf else _nrdf - 1
						local _qrdf = _undf(
							_jrdf(_frdf, _vndf(_ypdf, _mrdf + 1, _mrdf + _prdf))
						)

						if _qrdf[1] == true then
							_hrdf = false
							
							_gqdf += if _lrdf == 240 then 2 else 1                                    

							_nqdf = _krdf
							_oqdf = _lrdf
							_xpdf.pc = _gqdf
							_xpdf.name = _nqdf[_fndf[14]]

							local _rrdf = _qrdf.n - 1

							if _ordf == 0 then
								_fqdf = _mrdf + _rrdf - 1
							else
								_rrdf = _ordf - 1
							end

							_tndf(_qrdf, 2, _rrdf + 1, _mrdf, _ypdf)
						end
					end
					
					if _hrdf then
						_ypdf[_drdf] = _grdf[_frdf]
					end
elseif _oqdf == _hndf[16] then
					if _ypdf[_nqdf[_fndf[1]]] then
						_gqdf += _nqdf[_fndf[4]]
					end
else _kndf(_yldf[28]) end
end
end
else
if _oqdf < _hndf[25] then
if _oqdf < _hndf[21] then
if _oqdf == _hndf[17] then
					_ypdf[_nqdf[_fndf[1]]] = _nqdf[_fndf[2]] == 1
					_gqdf += _nqdf[_fndf[3]]
elseif _oqdf == _hndf[18] then
					_ypdf[_nqdf[_fndf[1]]] = _ypdf[_nqdf[_fndf[2]]]
elseif _oqdf == _hndf[19] then
					if _ypdf[_nqdf[_fndf[1]]] then
						_gqdf += _nqdf[_fndf[4]]
					end
elseif _oqdf == _hndf[20] then
					if _oqdf == 240 then
						_gqdf += 1                    
					end
					if _opdf then
						_opdf(_ypdf, _xpdf, _updf, _tpdf, _vpdf)	
					end

					local _srdf, _trdf, _urdf = _nqdf[_fndf[1]], _nqdf[_fndf[2]], _nqdf[_fndf[3]]

					local _vrdf = if _trdf == 0 then _fqdf - _srdf else _trdf - 1
					local _wrdf = _ypdf[_srdf]
					local _xrdf = _undf(
						_wrdf(_vndf(_ypdf, _srdf + 1, _srdf + _vrdf))
					)

					local _yrdf = _xrdf.n

					if _urdf == 0 then
						_fqdf = _srdf + _yrdf - 1
					else
						_yrdf = _urdf - 1
					end

					_tndf(_xrdf, 1, _yrdf, _srdf, _ypdf)
else _kndf(_yldf[28]) end
else
if _oqdf == _hndf[21] then
					local _zrdf = _nqdf[_fndf[7]]
					_ypdf[_nqdf[_fndf[1]]] = _ypdf[_nqdf[_fndf[2]]][_zrdf]

					_gqdf += 1                     
elseif _oqdf == _hndf[22] then
					local _asdf = _nqdf[_fndf[7]]
					_ypdf[_nqdf[_fndf[1]]] = _ypdf[_nqdf[_fndf[2]]][_asdf]

					_gqdf += 1                     
elseif _oqdf == _hndf[23] then
_ypdf[_nqdf[_fndf[1]]] = _nqdf[_fndf[4]]
_ypdf[_nqdf[_fndf[2]]] = _nqdf[_fndf[5]]
_gqdf += 1
elseif _oqdf == _hndf[24] then
					local _bsdf = _vpdf[_nqdf[_fndf[2]] + 1]
					_ypdf[_nqdf[_fndf[1]]] = _bsdf.store[_bsdf.index]
else _kndf(_yldf[28]) end
end
else
if _oqdf < _hndf[29] then
if _oqdf == _hndf[25] then
					_ypdf[_nqdf[_fndf[1]]] = _ypdf[_nqdf[_fndf[2]]] + _ypdf[_nqdf[_fndf[3]]]
elseif _oqdf == _hndf[26] then
					_ypdf[_nqdf[_fndf[1]]] = not _ypdf[_nqdf[_fndf[2]]]
elseif _oqdf == _hndf[27] then
					local _csdf = _ypdf[_nqdf[_fndf[2]]]
					_ypdf[_nqdf[_fndf[1]]] = if _csdf then _ypdf[_nqdf[_fndf[3]]] or false else _csdf
elseif _oqdf == _hndf[28] then
					_ypdf[_nqdf[_fndf[1]]] = nil
else _kndf(_yldf[28]) end
else
if _oqdf == _hndf[29] then
					local _dsdf = _nqdf[_fndf[7]]
					_ypdf[_nqdf[_fndf[1]]] = _ypdf[_nqdf[_fndf[2]]][_dsdf]

					_gqdf += 1                     
elseif _oqdf == _hndf[30] then
					_ypdf[_nqdf[_fndf[1]]] = _ypdf[_nqdf[_fndf[2]]][_nqdf[_fndf[3]] + 1]
elseif _oqdf == _hndf[31] then
					if not _ypdf[_nqdf[_fndf[1]]] then
						_gqdf += _nqdf[_fndf[4]]
					end
elseif _oqdf == _hndf[32] then
				    local _esdf = _ypdf[_nqdf[_fndf[2]]]
				    local _fsdf = _nqdf[_fndf[7]]
				
				    if _indf(_esdf) == _yldf[4] then
				        if _fsdf == 2 then
				            _ypdf[_nqdf[_fndf[1]]] = _esdf * _esdf
				        elseif _fsdf == 0.5 then
				            _ypdf[_nqdf[_fndf[1]]] = _rndf(_esdf)
				        elseif _fsdf == 3 then
				            _ypdf[_nqdf[_fndf[1]]] = _esdf * _esdf * _esdf
				        else
				            _ypdf[_nqdf[_fndf[1]]] = _esdf ^ _fsdf
				        end
				    else
				        _ypdf[_nqdf[_fndf[1]]] = _esdf ^ _fsdf
				    end
else _kndf(_yldf[28]) end
end
end
end
else
if _oqdf < _hndf[49] then
if _oqdf < _hndf[41] then
if _oqdf < _hndf[37] then
if _oqdf == _hndf[33] then
					local _gsdf = _nqdf[_fndf[7]]
					_ypdf[_nqdf[_fndf[2]]][_gsdf] = _ypdf[_nqdf[_fndf[1]]]

					_gqdf += 1                    
elseif _oqdf == _hndf[34] then
					if _oqdf == 240 then
						_gqdf += 1                    
					end
					if _opdf then
						_opdf(_ypdf, _xpdf, _updf, _tpdf, _vpdf)	
					end

					local _hsdf, _isdf, _jsdf = _nqdf[_fndf[1]], _nqdf[_fndf[2]], _nqdf[_fndf[3]]

					local _ksdf = if _isdf == 0 then _fqdf - _hsdf else _isdf - 1
					local _lsdf = _ypdf[_hsdf]
					local _msdf = _undf(
						_lsdf(_vndf(_ypdf, _hsdf + 1, _hsdf + _ksdf))
					)

					local _nsdf = _msdf.n

					if _jsdf == 0 then
						_fqdf = _hsdf + _nsdf - 1
					else
						_nsdf = _jsdf - 1
					end

					_tndf(_msdf, 1, _nsdf, _hsdf, _ypdf)
elseif _oqdf == _hndf[35] then
					_ypdf[_nqdf[_fndf[1]]] = _ypdf[_nqdf[_fndf[2]]][_ypdf[_nqdf[_fndf[3]]]]
elseif _oqdf == _hndf[36] then
					local _osdf = _vpdf[_nqdf[_fndf[2]] + 1]
					_ypdf[_nqdf[_fndf[1]]] = _osdf.store[_osdf.index]
_ypdf[_nqdf[_fndf[3]]] = _ypdf[_nqdf[_fndf[1]]]
_gqdf += 1
else _kndf(_yldf[28]) end
else
if _oqdf == _hndf[37] then
					local _psdf = _ypdf[_nqdf[_fndf[2]]]
					_ypdf[_nqdf[_fndf[1]]] = if _psdf then _psdf else _nqdf[_fndf[7]] or false
elseif _oqdf == _hndf[38] then
					_ypdf[_nqdf[_fndf[1]]] = nil
elseif _oqdf == _hndf[39] then
					if not _xodf(_ypdf[_nqdf[_fndf[1]]]) then
						_kndf(_pndf(_yldf[29], _indf(_ypdf[_nqdf[_fndf[1]]])))                                                
					end

					_gqdf += _nqdf[_fndf[4]]
elseif _oqdf == _hndf[40] then
					local _qsdf = _nqdf[_fndf[1]]
					local _rsdf = _nqdf[_fndf[2]]

					local _ssdf = _nqdf[_fndf[7]]
					
					local _tsdf = _ypdf[_rsdf]

					_ypdf[_qsdf + 1] = _tsdf
					
					_gqdf += 1                     
					
					local _usdf = true
					
					                                                   
					local _vsdf = _ipdf.useNativeNamecall

					if _vsdf then
						local _wsdf = _ipdf.namecallHandler

						local _xsdf = _aqdf[_gqdf]
						local _ysdf = _xsdf[_fndf[13]]

						                                       
						local _zsdf, _atdf, _btdf = _xsdf[_fndf[1]], _xsdf[_fndf[2]], _xsdf[_fndf[3]]

						if _npdf then
							_npdf(_ypdf, _xpdf, _updf, _tpdf, _vpdf)
						end

						if _opdf then
							_opdf(_ypdf, _xpdf, _updf, _tpdf, _vpdf)	
						end

						local _ctdf = if _atdf == 0 then _fqdf - _zsdf else _atdf - 1
						local _dtdf = _undf(
							_wsdf(_ssdf, _vndf(_ypdf, _zsdf + 1, _zsdf + _ctdf))
						)

						if _dtdf[1] == true then
							_usdf = false
							
							_gqdf += if _ysdf == 240 then 2 else 1                                    

							_nqdf = _xsdf
							_oqdf = _ysdf
							_xpdf.pc = _gqdf
							_xpdf.name = _nqdf[_fndf[14]]

							local _etdf = _dtdf.n - 1

							if _btdf == 0 then
								_fqdf = _zsdf + _etdf - 1
							else
								_etdf = _btdf - 1
							end

							_tndf(_dtdf, 2, _etdf + 1, _zsdf, _ypdf)
						end
					end
					
					if _usdf then
						_ypdf[_qsdf] = _tsdf[_ssdf]
					end
else _kndf(_yldf[28]) end
end
else
if _oqdf < _hndf[45] then
if _oqdf == _hndf[41] then
					if _opdf then
						_opdf(_ypdf, _xpdf, _updf, _tpdf, _vpdf)	
					end

					_gqdf += _nqdf[_fndf[5]]
elseif _oqdf == _hndf[42] then
					local _ftdf = _ypdf[_nqdf[_fndf[1]]]

					if _ipdf.generalizedIteration and not _xodf(_ftdf) then
						local _gtdf = _aqdf[_gqdf + _nqdf[_fndf[4]]]
						if _iqdf[_gtdf] == nil then 
							local function _htdf(...)
								for _itdf, _jtdf, _ktdf, _ltdf, _mtdf, _ntdf, _otdf, _ptdf, _qtdf, _rtdf, _stdf, _ttdf, _utdf, _vtdf, _wtdf, _xtdf, _ytdf, _ztdf, _audf, _budf, _cudf, _dudf, _eudf, _fudf, _gudf, _hudf, _iudf, _judf, _kudf, _ludf, _mudf, _nudf, _oudf, _pudf, _qudf, _rudf, _sudf, _tudf, _uudf, _vudf, _wudf, _xudf, _yudf, _zudf, _avdf, _bvdf, _cvdf, _dvdf, _evdf, _fvdf, _gvdf, _hvdf, _ivdf, _jvdf, _kvdf, _lvdf, _mvdf, _nvdf, _ovdf, _pvdf, _qvdf, _rvdf, _svdf, _tvdf, _uvdf, _vvdf, _wvdf, _xvdf, _yvdf, _zvdf, _awdf, _bwdf, _cwdf, _dwdf, _ewdf, _fwdf, _gwdf, _hwdf, _iwdf, _jwdf, _kwdf, _lwdf, _mwdf, _nwdf, _owdf, _pwdf, _qwdf, _rwdf, _swdf, _twdf, _uwdf, _vwdf, _wwdf, _xwdf, _ywdf, _zwdf, _axdf, _bxdf, _cxdf, _dxdf, _exdf, _fxdf, _gxdf, _hxdf, _ixdf, _jxdf, _kxdf, _lxdf, _mxdf, _nxdf, _oxdf, _pxdf, _qxdf, _rxdf, _sxdf, _txdf, _uxdf, _vxdf, _wxdf, _xxdf, _yxdf, _zxdf, _aydf, _bydf, _cydf, _dydf, _eydf, _fydf, _gydf, _hydf, _iydf, _jydf, _kydf, _lydf, _mydf, _nydf, _oydf, _pydf, _qydf, _rydf, _sydf, _tydf, _uydf, _vydf, _wydf, _xydf, _yydf, _zydf, _azdf, _bzdf, _czdf, _dzdf, _ezdf, _fzdf, _gzdf, _hzdf, _izdf, _jzdf, _kzdf, _lzdf, _mzdf, _nzdf, _ozdf, _pzdf, _qzdf, _rzdf, _szdf, _tzdf, _uzdf, _vzdf, _wzdf, _xzdf, _yzdf, _zzdf, _aaef, _baef, _caef, _daef, _eaef, _faef, _gaef, _haef, _iaef, _jaef, _kaef, _laef, _maef, _naef, _oaef, _paef, _qaef, _raef, _saef, _taef, _uaef, _vaef, _waef, _xaef, _yaef, _zaef in ... do 
									_bodf({_itdf, _jtdf, _ktdf, _ltdf, _mtdf, _ntdf, _otdf, _ptdf, _qtdf, _rtdf, _stdf, _ttdf, _utdf, _vtdf, _wtdf, _xtdf, _ytdf, _ztdf, _audf, _budf, _cudf, _dudf, _eudf, _fudf, _gudf, _hudf, _iudf, _judf, _kudf, _ludf, _mudf, _nudf, _oudf, _pudf, _qudf, _rudf, _sudf, _tudf, _uudf, _vudf, _wudf, _xudf, _yudf, _zudf, _avdf, _bvdf, _cvdf, _dvdf, _evdf, _fvdf, _gvdf, _hvdf, _ivdf, _jvdf, _kvdf, _lvdf, _mvdf, _nvdf, _ovdf, _pvdf, _qvdf, _rvdf, _svdf, _tvdf, _uvdf, _vvdf, _wvdf, _xvdf, _yvdf, _zvdf, _awdf, _bwdf, _cwdf, _dwdf, _ewdf, _fwdf, _gwdf, _hwdf, _iwdf, _jwdf, _kwdf, _lwdf, _mwdf, _nwdf, _owdf, _pwdf, _qwdf, _rwdf, _swdf, _twdf, _uwdf, _vwdf, _wwdf, _xwdf, _ywdf, _zwdf, _axdf, _bxdf, _cxdf, _dxdf, _exdf, _fxdf, _gxdf, _hxdf, _ixdf, _jxdf, _kxdf, _lxdf, _mxdf, _nxdf, _oxdf, _pxdf, _qxdf, _rxdf, _sxdf, _txdf, _uxdf, _vxdf, _wxdf, _xxdf, _yxdf, _zxdf, _aydf, _bydf, _cydf, _dydf, _eydf, _fydf, _gydf, _hydf, _iydf, _jydf, _kydf, _lydf, _mydf, _nydf, _oydf, _pydf, _qydf, _rydf, _sydf, _tydf, _uydf, _vydf, _wydf, _xydf, _yydf, _zydf, _azdf, _bzdf, _czdf, _dzdf, _ezdf, _fzdf, _gzdf, _hzdf, _izdf, _jzdf, _kzdf, _lzdf, _mzdf, _nzdf, _ozdf, _pzdf, _qzdf, _rzdf, _szdf, _tzdf, _uzdf, _vzdf, _wzdf, _xzdf, _yzdf, _zzdf, _aaef, _baef, _caef, _daef, _eaef, _faef, _gaef, _haef, _iaef, _jaef, _kaef, _laef, _maef, _naef, _oaef, _paef, _qaef, _raef, _saef, _taef, _uaef, _vaef, _waef, _xaef, _yaef, _zaef})
								end

								_bodf(_apdf)
							end

							_iqdf[_gtdf] = _aodf(_htdf)
						end
					end

					_gqdf += _nqdf[_fndf[4]]
elseif _oqdf == _hndf[43] then
					_ypdf[_nqdf[_fndf[2]]][_ypdf[_nqdf[_fndf[3]]]] = _ypdf[_nqdf[_fndf[1]]]
elseif _oqdf == _hndf[44] then
					local _abef = _ypdf[_nqdf[_fndf[2]]]
					_ypdf[_nqdf[_fndf[1]]] = if _abef then _abef else _ypdf[_nqdf[_fndf[3]]] or false
else _kndf(_yldf[28]) end
else
if _oqdf == _hndf[45] then
					local _bbef = _nqdf[_fndf[1]]

					local _cbef = _ypdf[_bbef]
					if not _rodf(_cbef) then
						local _dbef = _lndf(_cbef)

						if _dbef == nil then
							_kndf(_yldf[30])
						end

						_ypdf[_bbef] = _dbef
						_cbef = _dbef
					end

					local _ebef = _ypdf[_bbef + 1]
					if not _rodf(_ebef) then
						local _fbef = _lndf(_ebef)

						if _fbef == nil then
							_kndf(_yldf[31])
						end

						_ypdf[_bbef + 1] = _fbef
						_ebef = _fbef
					end

					local _gbef = _ypdf[_bbef + 2]
					if not _rodf(_gbef) then
						local _hbef = _lndf(_gbef)

						if _hbef == nil then
							_kndf(_yldf[32])
						end

						_ypdf[_bbef + 2] = _hbef
						_gbef = _hbef
					end

					if _ebef > 0 then
						if not (_gbef <= _cbef) then
							_gqdf += _nqdf[_fndf[4]]
						end
					else
						if not (_cbef <= _gbef) then
							_gqdf += _nqdf[_fndf[4]]
						end
					end
elseif _oqdf == _hndf[46] then
_ypdf[_nqdf[_fndf[1]]] = nil
_ypdf[_nqdf[_fndf[2]]] = nil
_gqdf += 1
elseif _oqdf == _hndf[47] then
_ypdf[_nqdf[_fndf[3]]] = _ypdf[_nqdf[_fndf[2]]][_nqdf[_fndf[8]]]
_gqdf += 2
					local _ibef = _nqdf[_fndf[1]]
					local _jbef = _nqdf[_fndf[3]]

					local _kbef = _nqdf[_fndf[7]]
					
					local _lbef = _ypdf[_jbef]

					_ypdf[_ibef + 1] = _lbef
					
					_gqdf += 1                     
					
					local _mbef = true
					
					                                                   
					local _nbef = _ipdf.useNativeNamecall

					if _nbef then
						local _obef = _ipdf.namecallHandler

						local _pbef = _aqdf[_gqdf]
						local _qbef = _pbef[_fndf[13]]

						                                       
						local _rbef, _sbef, _tbef = _pbef[_fndf[1]], _pbef[_fndf[2]], _pbef[_fndf[3]]

						if _npdf then
							_npdf(_ypdf, _xpdf, _updf, _tpdf, _vpdf)
						end

						if _opdf then
							_opdf(_ypdf, _xpdf, _updf, _tpdf, _vpdf)	
						end

						local _ubef = if _sbef == 0 then _fqdf - _rbef else _sbef - 1
						local _vbef = _undf(
							_obef(_kbef, _vndf(_ypdf, _rbef + 1, _rbef + _ubef))
						)

						if _vbef[1] == true then
							_mbef = false
							
							_gqdf += if _qbef == 240 then 2 else 1                                    

							_nqdf = _pbef
							_oqdf = _qbef
							_xpdf.pc = _gqdf
							_xpdf.name = _nqdf[_fndf[14]]

							local _wbef = _vbef.n - 1

							if _tbef == 0 then
								_fqdf = _rbef + _wbef - 1
							else
								_wbef = _tbef - 1
							end

							_tndf(_vbef, 2, _wbef + 1, _rbef, _ypdf)
						end
					end
					
					if _mbef then
						_ypdf[_ibef] = _lbef[_kbef]
					end
elseif _oqdf == _hndf[48] then
					_ypdf[_nqdf[_fndf[1]]] = _ypdf[_nqdf[_fndf[2]]] % _ypdf[_nqdf[_fndf[3]]]
else _kndf(_yldf[28]) end
end
end
else
if _oqdf < _hndf[57] then
if _oqdf < _hndf[53] then
if _oqdf == _hndf[49] then
					_ypdf[_nqdf[_fndf[1]]] = _ypdf[_nqdf[_fndf[2]]][_ypdf[_nqdf[_fndf[3]]]]
elseif _oqdf == _hndf[50] then
					_ypdf[_nqdf[_fndf[1]]] = _ypdf[_nqdf[_fndf[2]]] / _nqdf[_fndf[7]]
elseif _oqdf == _hndf[51] then
					local _xbef = _nqdf[_fndf[7]]
					_ypdf[_nqdf[_fndf[1]]] = _ypdf[_nqdf[_fndf[2]]][_xbef]

					_gqdf += 1                     
elseif _oqdf == _hndf[52] then
					_ypdf[_nqdf[_fndf[1]]] = _ypdf[_nqdf[_fndf[2]]]
else _kndf(_yldf[28]) end
else
if _oqdf == _hndf[53] then
					_ypdf[_nqdf[_fndf[1]]] = _ypdf[_nqdf[_fndf[2]]] * _nqdf[_fndf[7]]
elseif _oqdf == _hndf[54] then
					_nqdf[_fndf[5]] += 1
elseif _oqdf == _hndf[55] then
					_ypdf[_nqdf[_fndf[1]]] = nil
elseif _oqdf == _hndf[56] then
					if _ipdf.useImportConstants then
						_ypdf[_nqdf[_fndf[1]]] = _nqdf[_fndf[7]]
					else
						local _ybef = _nqdf[_fndf[11]]
						local _zbef = _nqdf[_fndf[8]]
						local _acef = _lqdf[_zbef] or _hpdf[_zbef]
						if _ybef == 1 then
							_ypdf[_nqdf[_fndf[1]]] = _acef
						elseif _ybef == 2 then
							_ypdf[_nqdf[_fndf[1]]] = _acef[_nqdf[_fndf[9]]]
						elseif _ybef == 3 then
							_ypdf[_nqdf[_fndf[1]]] = _acef[_nqdf[_fndf[9]]][_nqdf[_fndf[10]]]
						end
					end

					_gqdf += 1                     
else _kndf(_yldf[28]) end
end
else
if _oqdf < _hndf[61] then
if _oqdf == _hndf[57] then
					if _opdf then
						_opdf(_ypdf, _xpdf, _updf, _tpdf, _vpdf)	
					end

					local _bcef = _nqdf[_fndf[1]]
					local _ccef = _nqdf[_fndf[7]]

					_fqdf = _bcef + 6

					local _dcef = _ypdf[_bcef]

					if (_ipdf.generalizedIteration == false) or _xodf(_dcef) then 
						local _ecef = { _dcef(_ypdf[_bcef + 1], _ypdf[_bcef + 2]) }
						_tndf(_ecef, 1, _ccef, _bcef + 3, _ypdf)

						if _ypdf[_bcef + 3] ~= nil then
							_ypdf[_bcef + 2] = _ypdf[_bcef + 3]
							_gqdf += _nqdf[_fndf[4]]
						else
							_gqdf += 1
						end
					else
						local _fcef, _gcef = _codf(_iqdf[_nqdf], _dcef, _ypdf[_bcef + 1], _ypdf[_bcef + 2])
						if not _fcef then
							_kndf(_gcef)
						end
						if _gcef == _apdf then 
							_iqdf[_nqdf] = nil
							_gqdf += 1
						else
							_tndf(_gcef, 1, _ccef, _bcef + 3, _ypdf)

							_ypdf[_bcef + 2] = _ypdf[_bcef + 3]
							_gqdf += _nqdf[_fndf[4]]
						end
					end
elseif _oqdf == _hndf[58] then
					                                                                       
					_gqdf += _nqdf[_fndf[4]]                            
elseif _oqdf == _hndf[59] then
					_ypdf[_nqdf[_fndf[1]]] = _nqdf[_fndf[4]]
elseif _oqdf == _hndf[60] then
					local _hcef = _vpdf[_nqdf[_fndf[2]] + 1]
					_ypdf[_nqdf[_fndf[1]]] = _hcef.store[_hcef.index]
else _kndf(_yldf[28]) end
else
if _oqdf == _hndf[61] then
					for _icef, _jcef in _hqdf do
						if _jcef.index >= _nqdf[_fndf[1]] then
							_jcef.value = _jcef.store[_jcef.index]
							_jcef.store = _jcef
							_jcef.index = _yldf[33]                    
							_hqdf[_icef] = nil
						end
					end
elseif _oqdf == _hndf[62] then
					local _kcef = _nqdf[_fndf[7]]
					local _lcef = _nqdf[_fndf[12]]
					local _mcef = _ypdf[_nqdf[_fndf[1]]]

					if (_mcef == _kcef) ~= _lcef then
						_gqdf += _nqdf[_fndf[4]]
					else
						_gqdf += 1
					end
elseif _oqdf == _hndf[63] then
					local _ncef = _nqdf[_fndf[7]]

					_ypdf[_nqdf[_fndf[1]]] = _lqdf[_ncef] or _hpdf[_ncef]

					_gqdf += 1                    
elseif _oqdf == _hndf[64] then
					                          
					_kndf(_yldf[34])
else _kndf(_yldf[28]) end
end
end
end
end
else
if _oqdf < _hndf[97] then
if _oqdf < _hndf[81] then
if _oqdf < _hndf[73] then
if _oqdf < _hndf[69] then
if _oqdf == _hndf[65] then
					if _oqdf == 240 then
						_gqdf += 1                    
					end
					if _opdf then
						_opdf(_ypdf, _xpdf, _updf, _tpdf, _vpdf)	
					end

					local _ocef, _pcef, _qcef = _nqdf[_fndf[1]], _nqdf[_fndf[2]], _nqdf[_fndf[3]]

					local _rcef = if _pcef == 0 then _fqdf - _ocef else _pcef - 1
					local _scef = _ypdf[_ocef]
					local _tcef = _undf(
						_scef(_vndf(_ypdf, _ocef + 1, _ocef + _rcef))
					)

					local _ucef = _tcef.n

					if _qcef == 0 then
						_fqdf = _ocef + _ucef - 1
					else
						_ucef = _qcef - 1
					end

					_tndf(_tcef, 1, _ucef, _ocef, _ypdf)
elseif _oqdf == _hndf[66] then
					                          
elseif _oqdf == _hndf[67] then
					               
					_gqdf += 1                    
elseif _oqdf == _hndf[68] then
					_ypdf[_nqdf[_fndf[1]]] = _ypdf[_nqdf[_fndf[2]]] // _nqdf[_fndf[7]]
else _kndf(_yldf[28]) end
else
if _oqdf == _hndf[69] then
					_ypdf[_nqdf[_fndf[2]]][_nqdf[_fndf[3]] + 1] = _ypdf[_nqdf[_fndf[1]]]
elseif _oqdf == _hndf[70] then
					_gqdf += _nqdf[_fndf[4]]
elseif _oqdf == _hndf[71] then
					if _opdf then
						_opdf(_ypdf, _xpdf, _updf, _tpdf, _vpdf)	
					end

					local _vcef = _nqdf[_fndf[1]]
					local _wcef = _nqdf[_fndf[2]] 
					local _xcef = _wcef - 1
					local _ycef

					if _xcef == _zodf then
						_ycef = _fqdf - _vcef + 1
					else
						_ycef = _wcef - 1
					end

					return _vndf(_ypdf, _vcef, _vcef + _ycef - 1)
elseif _oqdf == _hndf[72] then
					_ypdf[_nqdf[_fndf[1]]] = _nqdf[_fndf[4]]
else _kndf(_yldf[28]) end
end
else
if _oqdf < _hndf[77] then
if _oqdf == _hndf[73] then
					_ypdf[_nqdf[_fndf[1]]] = _ypdf[_nqdf[_fndf[2]]] * _ypdf[_nqdf[_fndf[3]]]
elseif _oqdf == _hndf[74] then
					_ypdf[_nqdf[_fndf[1]]] = _nqdf[_fndf[7]]
elseif _oqdf == _hndf[75] then
					if _opdf then
						_opdf(_ypdf, _xpdf, _updf, _tpdf, _vpdf)	
					end

					local _zcef = _nqdf[_fndf[1]]
					local _adef = _nqdf[_fndf[2]] 
					local _bdef = _adef - 1
					local _cdef

					if _bdef == _zodf then
						_cdef = _fqdf - _zcef + 1
					else
						_cdef = _adef - 1
					end

					return _vndf(_ypdf, _zcef, _zcef + _cdef - 1)
elseif _oqdf == _hndf[76] then
					if _ypdf[_nqdf[_fndf[1]]] == _ypdf[_nqdf[_fndf[6]]] then
						_gqdf += 1
					else
						_gqdf += _nqdf[_fndf[4]]
					end
else _kndf(_yldf[28]) end
else
if _oqdf == _hndf[77] then
					_ypdf[_nqdf[_fndf[1]]] = -_ypdf[_nqdf[_fndf[2]]]
elseif _oqdf == _hndf[78] then
_ypdf[_nqdf[_fndf[1]]] = _nqdf[_fndf[8]]
_ypdf[_nqdf[_fndf[2]]] = _nqdf[_fndf[9]]
_gqdf += 1
elseif _oqdf == _hndf[79] then
					local _ddef = _nqdf[_fndf[1]]
					local _edef = _nqdf[_fndf[2]]

					local _fdef = _nqdf[_fndf[7]]
					
					local _gdef = _ypdf[_edef]

					_ypdf[_ddef + 1] = _gdef
					
					_gqdf += 1                     
					
					local _hdef = true
					
					                                                   
					local _idef = _ipdf.useNativeNamecall

					if _idef then
						local _jdef = _ipdf.namecallHandler

						local _kdef = _aqdf[_gqdf]
						local _ldef = _kdef[_fndf[13]]

						                                       
						local _mdef, _ndef, _odef = _kdef[_fndf[1]], _kdef[_fndf[2]], _kdef[_fndf[3]]

						if _npdf then
							_npdf(_ypdf, _xpdf, _updf, _tpdf, _vpdf)
						end

						if _opdf then
							_opdf(_ypdf, _xpdf, _updf, _tpdf, _vpdf)	
						end

						local _pdef = if _ndef == 0 then _fqdf - _mdef else _ndef - 1
						local _qdef = _undf(
							_jdef(_fdef, _vndf(_ypdf, _mdef + 1, _mdef + _pdef))
						)

						if _qdef[1] == true then
							_hdef = false
							
							_gqdf += if _ldef == 240 then 2 else 1                                    

							_nqdf = _kdef
							_oqdf = _ldef
							_xpdf.pc = _gqdf
							_xpdf.name = _nqdf[_fndf[14]]

							local _rdef = _qdef.n - 1

							if _odef == 0 then
								_fqdf = _mdef + _rdef - 1
							else
								_rdef = _odef - 1
							end

							_tndf(_qdef, 2, _rdef + 1, _mdef, _ypdf)
						end
					end
					
					if _hdef then
						_ypdf[_ddef] = _gdef[_fdef]
					end
elseif _oqdf == _hndf[80] then
					_ypdf[_nqdf[_fndf[1]]][_nqdf[_fndf[7]]] = _ypdf[_nqdf[_fndf[3]]]
					_gqdf += 1                    
else _kndf(_yldf[28]) end
end
end
else
if _oqdf < _hndf[89] then
if _oqdf < _hndf[85] then
if _oqdf == _hndf[81] then
					_ypdf[_nqdf[_fndf[1]]] = _ypdf[_nqdf[_fndf[2]]] / _ypdf[_nqdf[_fndf[3]]]
elseif _oqdf == _hndf[82] then
					if _ypdf[_nqdf[_fndf[1]]] == _ypdf[_nqdf[_fndf[6]]] then
						_gqdf += _nqdf[_fndf[4]]
					else
						_gqdf += 1
					end
elseif _oqdf == _hndf[83] then
					local _sdef = _ypdf[_nqdf[_fndf[2]]]
					_ypdf[_nqdf[_fndf[1]]] = if _sdef then _nqdf[_fndf[7]] or false else _sdef
elseif _oqdf == _hndf[84] then
					if _opdf then
						_opdf(_ypdf, _xpdf, _updf, _tpdf, _vpdf)	
					end

					local _tdef = _nqdf[_fndf[1]]
					local _udef = _ypdf[_tdef]
					local _vdef = _ypdf[_tdef + 1]
					local _wdef = _ypdf[_tdef + 2] + _vdef

					_ypdf[_tdef + 2] = _wdef

					if _vdef > 0 then
						if _wdef <= _udef then
							_gqdf += _nqdf[_fndf[4]]
						end
					else
						if _udef <= _wdef then
							_gqdf += _nqdf[_fndf[4]]
						end
					end
else _kndf(_yldf[28]) end
else
if _oqdf == _hndf[85] then
					               
					_gqdf += 1                    
elseif _oqdf == _hndf[86] then
					if _ipdf.useImportConstants then
						_ypdf[_nqdf[_fndf[1]]] = _nqdf[_fndf[7]]
					else
						local _xdef = _nqdf[_fndf[11]]
						local _ydef = _nqdf[_fndf[8]]
						local _zdef = _lqdf[_ydef] or _hpdf[_ydef]
						if _xdef == 1 then
							_ypdf[_nqdf[_fndf[1]]] = _zdef
						elseif _xdef == 2 then
							_ypdf[_nqdf[_fndf[1]]] = _zdef[_nqdf[_fndf[9]]]
						elseif _xdef == 3 then
							_ypdf[_nqdf[_fndf[1]]] = _zdef[_nqdf[_fndf[9]]][_nqdf[_fndf[10]]]
						end
					end

					_gqdf += 1                     
elseif _oqdf == _hndf[87] then
					_ypdf[_nqdf[_fndf[1]]] = _nqdf[_fndf[7]] - _ypdf[_nqdf[_fndf[3]]]
elseif _oqdf == _hndf[88] then
					_ypdf[_nqdf[_fndf[1]]] = _wndf(_nqdf[_fndf[6]])

					_gqdf += 1                     
else _kndf(_yldf[28]) end
end
else
if _oqdf < _hndf[93] then
if _oqdf == _hndf[89] then
					_gqdf += _nqdf[_fndf[4]]
elseif _oqdf == _hndf[90] then
					if _opdf then
						_opdf(_ypdf, _xpdf, _updf, _tpdf, _vpdf)	
					end

					local _aeef = _nqdf[_fndf[1]]
					local _beef = _nqdf[_fndf[2]] 
					local _ceef = _beef - 1
					local _deef

					if _ceef == _zodf then
						_deef = _fqdf - _aeef + 1
					else
						_deef = _beef - 1
					end

					return _vndf(_ypdf, _aeef, _aeef + _deef - 1)
elseif _oqdf == _hndf[91] then
					if not _ypdf[_nqdf[_fndf[1]]] then
						_gqdf += _nqdf[_fndf[4]]
					end
elseif _oqdf == _hndf[92] then
					local _eeef = _nqdf[_fndf[7]]
					local _feef = {}
					if _eeef[1] == -1 then
						for _geef = 2, #_eeef, 2 do
							local _heef = _eeef[_geef + 1]
							_feef[_jqdf[_eeef[_geef] + 1]] = if _heef >= 0 then _jqdf[_heef + 1] else nil
						end
					else
						for _ieef, _jeef in _eeef do
							_feef[_jqdf[_jeef + 1]] = nil
						end
					end
					_ypdf[_nqdf[_fndf[1]]] = _feef
else _kndf(_yldf[28]) end
else
if _oqdf == _hndf[93] then
					_gqdf += _nqdf[_fndf[4]]
elseif _oqdf == _hndf[94] then
					local _keef = _vpdf[_nqdf[_fndf[2]] + 1]
					_keef.store[_keef.index] = _ypdf[_nqdf[_fndf[1]]]
elseif _oqdf == _hndf[95] then
					_ypdf[_nqdf[_fndf[1]]] = #_ypdf[_nqdf[_fndf[2]]]
elseif _oqdf == _hndf[96] then
					_ypdf[_nqdf[_fndf[1]]] = _ypdf[_nqdf[_fndf[2]]] + _nqdf[_fndf[7]]
else _kndf(_yldf[28]) end
end
end
end
else
if _oqdf < _hndf[113] then
if _oqdf < _hndf[105] then
if _oqdf < _hndf[101] then
if _oqdf == _hndf[97] then
					local _leef = _vpdf[_nqdf[_fndf[2]] + 1]
					_ypdf[_nqdf[_fndf[1]]] = _leef.store[_leef.index]
local _meef = _vpdf[_nqdf[_fndf[4]] + 1]
_ypdf[_nqdf[_fndf[3]]] = _meef.store[_meef.index]
_gqdf += 1
elseif _oqdf == _hndf[98] then
					local _neef = _vpdf[_nqdf[_fndf[2]] + 1]
					_ypdf[_nqdf[_fndf[1]]] = _neef.store[_neef.index]
elseif _oqdf == _hndf[99] then
					_ypdf[_nqdf[_fndf[1]]] = _nqdf[_fndf[4]]
elseif _oqdf == _hndf[100] then
					_ypdf[_nqdf[_fndf[1]]] = _ypdf[_nqdf[_fndf[2]]]
else _kndf(_yldf[28]) end
else
if _oqdf == _hndf[101] then
					local _oeef = _nqdf[_fndf[7]]
					_ypdf[_nqdf[_fndf[2]]][_oeef] = _ypdf[_nqdf[_fndf[1]]]

					_gqdf += 1                    
elseif _oqdf == _hndf[102] then
					if _ipdf.useImportConstants then
						_ypdf[_nqdf[_fndf[1]]] = _nqdf[_fndf[12]]
					else
						local _peef = _nqdf[_fndf[11]]
						local _qeef = _nqdf[_fndf[8]]
						local _reef = _lqdf[_qeef] or _hpdf[_qeef]
						if _peef == 1 then
							_ypdf[_nqdf[_fndf[1]]] = _reef
						elseif _peef == 2 then
							_ypdf[_nqdf[_fndf[1]]] = _reef[_nqdf[_fndf[9]]]
						elseif _peef == 3 then
							_ypdf[_nqdf[_fndf[1]]] = _reef[_nqdf[_fndf[9]]][_nqdf[_fndf[10]]]
						end
					end

					_gqdf += 1                     

_ypdf[_nqdf[_fndf[2]]] = _ypdf[_nqdf[_fndf[3]]][_nqdf[_fndf[7]]]
_gqdf += 2
elseif _oqdf == _hndf[103] then
_ypdf[_nqdf[_fndf[1]]] = _ypdf[_nqdf[_fndf[2]]] - _ypdf[_nqdf[_fndf[3]]]
_ypdf[_nqdf[_fndf[4]]] = _ypdf[_nqdf[_fndf[1]]]
_gqdf += 1
elseif _oqdf == _hndf[104] then
					local _seef = _nqdf[_fndf[1]]
					local _teef = _nqdf[_fndf[2]]

					local _ueef = _nqdf[_fndf[7]]
					
					local _veef = _ypdf[_teef]

					_ypdf[_seef + 1] = _veef
					
					_gqdf += 1                     
					
					local _weef = true
					
					                                                   
					local _xeef = _ipdf.useNativeNamecall

					if _xeef then
						local _yeef = _ipdf.namecallHandler

						local _zeef = _aqdf[_gqdf]
						local _afef = _zeef[_fndf[13]]

						                                       
						local _bfef, _cfef, _dfef = _zeef[_fndf[1]], _zeef[_fndf[2]], _zeef[_fndf[3]]

						if _npdf then
							_npdf(_ypdf, _xpdf, _updf, _tpdf, _vpdf)
						end

						if _opdf then
							_opdf(_ypdf, _xpdf, _updf, _tpdf, _vpdf)	
						end

						local _efef = if _cfef == 0 then _fqdf - _bfef else _cfef - 1
						local _ffef = _undf(
							_yeef(_ueef, _vndf(_ypdf, _bfef + 1, _bfef + _efef))
						)

						if _ffef[1] == true then
							_weef = false
							
							_gqdf += if _afef == 240 then 2 else 1                                    

							_nqdf = _zeef
							_oqdf = _afef
							_xpdf.pc = _gqdf
							_xpdf.name = _nqdf[_fndf[14]]

							local _gfef = _ffef.n - 1

							if _dfef == 0 then
								_fqdf = _bfef + _gfef - 1
							else
								_gfef = _dfef - 1
							end

							_tndf(_ffef, 2, _gfef + 1, _bfef, _ypdf)
						end
					end
					
					if _weef then
						_ypdf[_seef] = _veef[_ueef]
					end
else _kndf(_yldf[28]) end
end
else
if _oqdf < _hndf[109] then
if _oqdf == _hndf[105] then
_ypdf[_nqdf[_fndf[1]]] = _ypdf[_nqdf[_fndf[2]]] + _ypdf[_nqdf[_fndf[3]]]
_ypdf[_nqdf[_fndf[4]]] = _ypdf[_nqdf[_fndf[1]]]
_gqdf += 1
elseif _oqdf == _hndf[106] then
					if not _ypdf[_nqdf[_fndf[1]]] then
						_gqdf += _nqdf[_fndf[4]]
					end
elseif _oqdf == _hndf[107] then
					_ypdf[_nqdf[_fndf[1]]] = _ypdf[_nqdf[_fndf[2]]][_ypdf[_nqdf[_fndf[3]]]]
elseif _oqdf == _hndf[108] then
					if _ypdf[_nqdf[_fndf[1]]] < _ypdf[_nqdf[_fndf[6]]] then
						_gqdf += _nqdf[_fndf[4]]
					else
						_gqdf += 1
					end
else _kndf(_yldf[28]) end
else
if _oqdf == _hndf[109] then
					_ypdf[_nqdf[_fndf[1]]] = _ypdf[_nqdf[_fndf[2]]] % _nqdf[_fndf[7]]
elseif _oqdf == _hndf[110] then
					local _hfef = _nqdf[_fndf[1]]
					local _ifef = _nqdf[_fndf[2]]
					local _jfef = _nqdf[_fndf[3]] - 1

					if _jfef == _zodf then
						_jfef = _fqdf - _ifef + 1
					end

					_tndf(_ypdf, _ifef, _ifef + _jfef - 1, _nqdf[_fndf[6]], _ypdf[_hfef])

					_gqdf += 1                     
elseif _oqdf == _hndf[111] then
					_ypdf[_nqdf[_fndf[1]]] = _ypdf[_nqdf[_fndf[2]]] - _ypdf[_nqdf[_fndf[3]]]
elseif _oqdf == _hndf[112] then
					local _kfef = _nqdf[_fndf[1]]
					local _lfef = _jpdf[_nqdf[_fndf[7]] + 1]
					local _mfef = _lfef.nups
					local _nfef
					if _ipdf.reuseClosures then
						_nfef = _lpdf[_nqdf]
					end
					local _ofef = _nfef ~= nil

					if _nfef then
						_ypdf[_kfef] = _nfef.closure
						for _pfef = 1, _mfef do
							local _qfef = _aqdf[_gqdf + _pfef - 1]
							local _rfef = _nfef.upvalues[_pfef]
							if _qfef[_fndf[1]] == 0 then                   
								if not _nndf(_rfef.store[_rfef.index], _ypdf[_qfef[_fndf[2]]]) then
									_ofef = false
									break
								end
							elseif _qfef[_fndf[1]] == 2 then                     
								if not _nndf(_rfef, _vpdf[_qfef[_fndf[2]] + 1]) then
									_ofef = false
									break
								end
							else
								_ofef = false
								break
							end
						end
					end

					if _ofef then
						_gqdf += _mfef
					else
						local _sfef = _wndf(_mfef)
						local _tfef = _spdf(_tpdf, _lfef, _sfef)

						_ypdf[_kfef] = _tfef

						for _ufef = 1, _mfef do
							local _vfef = _aqdf[_gqdf]
							_gqdf += 1

							local _wfef = _vfef[_fndf[1]]
							if _wfef == 0 then           
								local _xfef = {
									value = _ypdf[_vfef[_fndf[2]]],
									index = _yldf[33],                   
								}
								_xfef.store = _xfef

								_sfef[_ufef] = _xfef

								                                              
							elseif _wfef == 2 then             
								_sfef[_ufef] = _vpdf[_vfef[_fndf[2]] + 1]
							end
						end

						if _ipdf.reuseClosures then
							_lpdf[_nqdf] = {closure = _tfef, upvalues = _sfef}
						end
					end
else _kndf(_yldf[28]) end
end
end
else
if _oqdf < _hndf[121] then
if _oqdf < _hndf[117] then
if _oqdf == _hndf[113] then
					               
elseif _oqdf == _hndf[114] then
					if _mpdf then
						local _yfef = _undf(_mpdf(_ypdf, _xpdf, _updf, _tpdf, _vpdf))
						
						if _yfef[1] then 
							return _vndf(_yfef, 2, #_yfef)
						end 
					end
					
					_gqdf -= 1
					_oqdf = _kqdf[_gqdf]
					_mqdf = true
elseif _oqdf == _hndf[115] then
					if _opdf then
						_opdf(_ypdf, _xpdf, _updf, _tpdf, _vpdf)	
					end

					_gqdf += _nqdf[_fndf[4]]
elseif _oqdf == _hndf[116] then
					local _zfef = _nqdf[_fndf[7]]
					local _agef = _nqdf[_fndf[12]]
					local _bgef = _ypdf[_nqdf[_fndf[1]]]

					if (_bgef == _zfef) ~= _agef then
						_gqdf += _nqdf[_fndf[4]]
					else
						_gqdf += 1
					end
else _kndf(_yldf[28]) end
else
if _oqdf == _hndf[117] then
					local _cgef = _jpdf[_zpdf[_nqdf[_fndf[4]] + 1]]

					local _dgef = _cgef.nups
					local _egef = _wndf(_dgef)
					_ypdf[_nqdf[_fndf[1]]] = _spdf(_tpdf, _cgef, _egef)

					for _fgef = 1, _dgef do
						local _ggef = _aqdf[_gqdf]

						_gqdf += 1

						local _hgef = _ggef[_fndf[1]]

						if _hgef == 0 then           
							local _igef = {
								value = _ypdf[_ggef[_fndf[2]]],
								index = _yldf[33],                   
							}
							_igef.store = _igef

							_egef[_fgef] = _igef
						elseif _hgef == 1 then               
							local _jgef = _ggef[_fndf[2]]
							local _kgef = _hqdf[_jgef]

							if _kgef == nil then
								_kgef = {
									index = _jgef,
									store = _ypdf,
								}
								_hqdf[_jgef] = _kgef
							end

							_egef[_fgef] = _kgef
						elseif _hgef == 2 then             
							_egef[_fgef] = _vpdf[_ggef[_fndf[2]] + 1]
						end
					end
elseif _oqdf == _hndf[118] then
					if _ypdf[_nqdf[_fndf[1]]] <= _ypdf[_nqdf[_fndf[6]]] then
						_gqdf += 1
					else
						_gqdf += _nqdf[_fndf[4]]
					end
elseif _oqdf == _hndf[119] then
					if _ipdf.useImportConstants then
						_ypdf[_nqdf[_fndf[1]]] = _nqdf[_fndf[7]]
					else
						local _lgef = _nqdf[_fndf[11]]
						local _mgef = _nqdf[_fndf[8]]
						local _ngef = _lqdf[_mgef] or _hpdf[_mgef]
						if _lgef == 1 then
							_ypdf[_nqdf[_fndf[1]]] = _ngef
						elseif _lgef == 2 then
							_ypdf[_nqdf[_fndf[1]]] = _ngef[_nqdf[_fndf[9]]]
						elseif _lgef == 3 then
							_ypdf[_nqdf[_fndf[1]]] = _ngef[_nqdf[_fndf[9]]][_nqdf[_fndf[10]]]
						end
					end

					_gqdf += 1                     
elseif _oqdf == _hndf[120] then
					if _ypdf[_nqdf[_fndf[1]]] then
						_gqdf += _nqdf[_fndf[4]]
					end
else _kndf(_yldf[28]) end
end
else
if _oqdf < _hndf[125] then
if _oqdf == _hndf[121] then
					_ypdf[_nqdf[_fndf[1]]] = _ypdf[_nqdf[_fndf[2]]] ^ _ypdf[_nqdf[_fndf[3]]]
elseif _oqdf == _hndf[122] then
					               
elseif _oqdf == _hndf[123] then
					               
					_gqdf += 1                    
elseif _oqdf == _hndf[124] then
					local _ogef, _pgef = _nqdf[_fndf[2]], _nqdf[_fndf[3]]
					local _qgef, _rgef = _jndf(_zndf, _ypdf, _yldf[35], _ogef, _pgef)
	
					if not _qgef then
						_rgef = _ypdf[_ogef]
	
						for _sgef = _ogef + 1, _pgef do
							_rgef ..= _ypdf[_sgef]
						end
					end

					_ypdf[_nqdf[_fndf[1]]] = _rgef
else _kndf(_yldf[28]) end
else
if _oqdf < _hndf[127] then
if _oqdf == _hndf[125] then
					local _tgef = _nqdf[_fndf[7]]
					local _ugef = _nqdf[_fndf[12]]
					local _vgef = _ypdf[_nqdf[_fndf[1]]]

					if (_vodf(_vgef) and (_vgef == _tgef)) ~= _ugef then
						_gqdf += _nqdf[_fndf[4]]
					else
						_gqdf += 1
					end
elseif _oqdf == _hndf[126] then
					_ypdf[_nqdf[_fndf[1]]] = _nqdf[_fndf[7]]
else _kndf(_yldf[28]) end
else
if _oqdf == _hndf[127] then
					if not _xodf(_ypdf[_nqdf[_fndf[1]]]) then
						_kndf(_pndf(_yldf[29], _indf(_ypdf[_nqdf[_fndf[1]]])))                                                 
					end

					_gqdf += _nqdf[_fndf[4]]
elseif _oqdf == _hndf[128] then
					_ypdf[_nqdf[_fndf[1]]] = _ypdf[_nqdf[_fndf[2]]] - _nqdf[_fndf[7]]
elseif _oqdf == _hndf[129] then
					if _ypdf[_nqdf[_fndf[1]]] <= _ypdf[_nqdf[_fndf[6]]] then
						_gqdf += _nqdf[_fndf[4]]
					else
						_gqdf += 1
					end
else _kndf(_yldf[28]) end
end
end
end
end
end
end
				_pqdf = _cmdf(_pqdf + _oqdf + _gqdf + 1)
				_qqdf = _zldf(_gqdf, _pqdf)
				if not _mqdf then _nqdf = nil end
			end

			for _wgef, _xgef in _hqdf do
				_xgef.value = _xgef.store[_xgef.index]
				_xgef.store = _xgef
				_xgef.index = _yldf[33]                    
				_hqdf[_wgef] = nil
			end

			for _ygef, _zgef in _iqdf do 
				_dodf(_zgef)
				_iqdf[_ygef] = nil
			end
		end

		local function _ahef(...)
			local _bhef = _undf(...)
			local _chef = _wndf(_updf.maxstacksize)
			local _dhef = {
				len = 0,
				list = {},
			}

			_tndf(_bhef, 1, _updf.numparams, 0, _chef)

			if _updf.numparams < _bhef.n then
				local _ehef = _updf.numparams + 1
				local _fhef = _bhef.n - _updf.numparams
				_dhef.len = _fhef
				_tndf(_bhef, _ehef, _ehef + _fhef - 1, 1, _dhef.list)
			end

			_bhef = nil

			local _ghef = {pc = 0, name = _yldf[24]}
			local _hhef
			if _ipdf.errorHandling then 
				_hhef = _undf(_jndf(_wpdf, _ghef, _chef, _updf.protos, _updf.code, _dhef))
			else
				_hhef = _undf(true, _wpdf(_ghef, _chef, _updf.protos, _updf.code, _dhef))
			end

			if _hhef[1] then
				return _vndf(_hhef, 2, _hhef.n)
			else
				local _ihef = _hhef[2]

				if _ppdf then
					_ppdf(_ihef, _chef, _ghef, _updf, _tpdf, _vpdf)
				end

				if _todf(_ihef) == false then
					if _ipdf.allowProxyErrors then
						_kndf(_ihef)
					else 
						_ihef = _indf(_ihef)
					end
				end

				if _updf.lineinfoenabled then
					return _kndf(_pndf(_yldf[36], _updf.debugname, _updf.instructionlineinfo[_ghef.pc], _ghef.pc, _ghef.name, _ihef), 0)
				else 
					return _kndf(_pndf(_yldf[37], _updf.debugname, _ghef.pc, _ghef.name, _ihef), 0)
				end
			end
		end

		if _ipdf.errorHandling then
			return _ahef
		else
			return _wpdf
		end
	end

	return _spdf(_gpdf, _kpdf),  _rpdf
end

return {
	luau_newsettings = _bpdf,
	luau_validatesettings = _dpdf,
	luau_load = _fpdf,
}

end)()
local _jhef = _yldf[38]
local _khef = {}
for _lhef = 1, #_jhef do
    _khef[string.byte(_jhef, _lhef)] = _lhef - 1
end
local function _mhef(_nhef, _ohef, _phef, _qhef)
    local _rhef = buffer.create(_phef)
    local _shef, _thef, _uhef, _vhef, _whef = 0, 0, 0, 1, 0
    local _xhef, _yhef, _zhef, _aief = string.byte, buffer.writeu8, bit32.bxor, math.floor
    for _bief, _cief in ipairs(_nhef) do
        for _dief = 1, #_cief do
            _thef = _thef * 64 + _khef[_xhef(_cief, _dief)]
            _shef += 6
            if _shef >= 8 then
                _shef -= 8
                local _eief = 2 ^ _shef
                _ohef = _ohef * 48271 % 65521
                local _fief = _zhef(_aief(_thef / _eief), _ohef % 256)
                _yhef(_rhef, _uhef, _fief)
                _vhef = (_vhef + _fief) % 65521
                _whef = (_whef + _vhef) % 65521
                _uhef += 1
                _thef %= _eief
            end
        end
    end
    assert(_uhef == _phef and _whef * 65536 + _vhef == _qhef, _yldf[39])
    return _rhef
end
                              
local _gief = {
[16] = {{
"b2VUIrdiXwKwEjufUzDgpWVFlx9OUW7FG1T/PTUqY7F+rYBA/nxVBRHEvKaxava8yMEZNtCdk7qpuPEXemXw1T++jvi2UPmluVHLZlTPMN2ORWmOkECZMpDb90KSIYt3fm7GNS5PJWTkTKUOw4GqF/Iu+k8baRJRcLHQv3z2feX+cND8SQVvR/PQCR0wSIKjDs2mb56sfUJUVGHueaJ3j0fh627Yf0FczUaU65pKLJoeItMh+X+idcik+YKz8dsmml2Mb5rp1AegyeHR7eskdF/e3rM35z8U65nkXuEniiBR7BBkwFN2bh0b7DMif7kKWLMl9VLky1aoPk4TyBM9+0Z2OduxzzaXzF8ZgTWhVDAZHinNcSBcelcnd1WMkxqVRdUfk/K8Vqz1dTo7v3aJISXvir9WMWtUJom4RUxyv1ZQlqyg2ecOo5E9c66PEM2uQxt586Qy3QXJR6aXlPA7zsIf5Zp5OQ5hl/OD9nycPMAUMl63ubeIkxNROEDbGjIfBQmgRFSMkdJCHmNnnSxgZ+69xDHHeP9Yy3KTGl9rIMZbXIgQkiQjsRvK1cCN",
},49616,429,2114498689,1982704419},
[67] = {{
"FNrSiJjEXn4DJLf+aexjS+VKqXIYCaLlanY8+0LGnb8L1GvexLlfc9fHbLARV7HaCGhIj4ThRHlbfBDYDDsguiP+k/XGvKMVVswiyPipSO",
},26056,79,2621185544,3575075553},
[59] = {{
"k1JEtTA0+NebHDPu9MHFlslTrsVNofu34pgsPtNXEM2omgttEbek2x44EpkFMQ9wzaKOkzWWcV/kwL2yFW3GG+8ZASQAb9HF7lGvegvvg+Rm20dJrLb",
},32294,86,539041964,1020924831},
[6] = {{
"nljUolDDLF1A1CViELlDdALSQ++CQKsRM8IVQU/iLkkvsTWwEbgOKPktUaVPmkDzZqf0dGUTqkvTohfahf/I/3qaOWAoiZJqSVsNyOHLzAvECZy4IPFCANHathUsq+jpqvMBpx4teLnracg+Lc606dodgAVo/NAf70cFStzvBa9qQbrtJ9lS//UAXkofuI6sSlK+DEW/t9SMWTXCn0ghPd8DZ0Ke1rmuDieUy/pP+6vfSxB/B2nZOi71U0ZbMc3Vit5xf9UCoFR3wS98PNKtu5i1I/UGYgQSiSjddPJOPiYA3stvU1Iu3d1UJ/R3Qtm7t6XLjvODn7jYLJKWCj247rHAMrEIdUt/m3k+Vcb1y/h8yCD+omMwNEYHtCnHM4u2cCjO3qQadXoDWZVvi52AmVBINsBWJ3XwWUhEbCX/yaJW8YNFuPNtpcHqRcMmKM+f0ZOuC0cFJlxQ5D5Qdxnq0CROSBarLW8GBBmigO",
},15821,364,193696799,4020779729},
[33] = {{
"/hRVrcNGzvEdtvHzYaC23DUeL+kkt4NokDYvA2rF2NvdoNSNpQ0OQhnaFkRO7bQ+Dv1N6dhG8j/QtmtZyhz2RuOGqcnBowHr4EXtzKQj6JnhffiErzUFktV3S1LjZwAIEAGeZVTlHpUoAC185Lgc50dLVnXoAJi0cW6tLD4Cpph4FGMbJtYZXg449fYnPLEHxirc4HJ6TDgAMpnMAXhZSU60vSANOTuwsNcWQy6Furvy6jDQCY1FZJS6ABKElnrnv7l+zYVUb0prt4SiCjVsYCi1N/6d5TrL0WetxTbZKtZDiRnGb4VsVmInchIPF1qmP4YNo6Z4+i45KZUMxa4q6FD+1g+gJDzBBgqS75r+SZ9dkKo5LFHCMRH6Y4MVV6byD/WXmngKC14V/YkD+qjaQXzo/N+11CS+b2xmOa/5kIVols7z2A+Duyg4iDCWhPCUmKrqm5hoU1ivHBiuIQV9Guvvnip4MGIHMZup5c6PKlx+w8TzCDhleGmlVGO4dtmUdOL2s5jm6LPsfo9tjO",
},47090,397,3900220261,3498678994},
[7] = {{
"gNMYsbLeWDHoUAjI4RmnZgoKE1mWaxFZa8BW7hOQBYA69YwmIKRd11gR7L1EE/JBaHPerbCYmHoTCuG3ylkK/pVTaS9I0VFQSgr6Gq5PZsx/HVibAilAEnhfnJsntrf2zJmnpEDZvl54saobORRmKhnVfpYxhpSzCo177Hn01eK07GYkJnRjUwVlWXJpD+hL4lU/CHLiG91/yBfxRZu6vcAObKTs527V6ABCLzOvgWagrjh1YVIYVai92C3LjQ8Xl895JLK+nFOkKYmh635aJNFcbMQs2WFooVPZj8OmI0d+PjMbG0XBNu0RMleIooz0QENSCHJLOARj7A5/gar5a4r+szpB0bv+n+ptCFVNlQRnuV03HmO3M/SI+ZstkJX0HegaXAK5k4biOqY2quwLQ8KKJbhET9ck0IINuG9u4ItrKBDNb+COPVmXmo9VP8nJ22xH11d0xH91nsgNBTY4fTBG",
},30314,354,2946405339,3249013394},
[50] = {{
"6i73xg3uPwyP8D1okbI4K7qQFPwdYoydmpd3iwyjGA9g4A8UbExltIdlIE+qy0BLLtWjI4DKhhZCmU/wIMDLPbfR/GyqNW+/8ez4wL53ljmusApekLlDs78GipEEPYsFDW5N9TM8Wlyl7E9I57P7/4F1eIZqxNZ5SX0Q4sb3WxvHX1GsYskVicNaGRVVat/bdRZmywsVx2eBD/NlDcQwUA1bGBKnGAqpozwzMazPaKD73+S/qjXiitNcIf8GkSDwWWeqezAPo73PQqMxJBT5ukr",
},2670,209,2266978550,4003586333},
[22] = {{
"ftHAOeXN5YC/Fkg5KWbkWAxbbtq0VP7jrSAPG7iXTq3uOclhh8D++PSZrPnPJJYQBj0uOAkvnbQuDnPbcqfyGZf6kWZeNTJ4aLfQreFDTziE8tiLXOiSKngpI+bmoe2dTbebVpMuj38w",
},45028,105,1293821010,377425927},
[43] = {{
"Oq5NkqOhbguiV8DsYVs45wBL11qiUAnb2/7MjGXgdUWgXVX83tI92mXqREND5qxnstJg2MdJ+4eQA0+PxAMK7pXTHpHxsuM9a+w9V43naLoWva/UApf+1GRatkKhS8bKuMHiwHnzHwSY/fGOs/FoUSyV9iQNHcK5WKk6tcfx1jex5x0od68dVEMyLP4AUtIlvN/aq29/eHJUrECmZhhdThC9RhACiyihX+/sdv6NAsSadC2LONnDPSlivIKNnyQ+Io6U2wghbnUGeyxL2ptW1Ov1c7GEMkRdu8kIlVGuCdt92sepsWMmiELqJ/i9cjkok64/LA/4HGEXdsSbmV/dXj1ngjhn8NpwdVnLjrZ10YSIPi4UCPkBpXzlCf7+MnBmIfxLxTZR9JHgyUWj5UtWK8GpC4fSmS2C5WG1EsQImihg+0uSzg0JtI3Itpd/3yACNpVXWlhHql4DmZNJteKUBZtc93ipn7KqmFxigqIStphiumzRRYQkZcpvXm2qZ596B8xpv2AC135kHcjgj0iKDruiJ0PM4myLKz7HTQaAHPsVMB5LT4I8qRQ5N4VWGlwp9nV44h8PC9knzGWPaTZ7WnzHwSQUIvOFrQ7UWZx2eFfjA4SKr+ie7nF11xchKsV/RJzqtRSreqllEnnIouTC/2FDFYHFlUsduaXHmFh0HiLtACQN0w2go7mV2CiEyzBfzCrly85+tMDAWE4s9PUOXMeRV0YaeWPx1H1+9o9UCozeWT9yjAbVIf53U87lsN+6J5Q12/BEqDrxtnnCVxNiYlMJjIG505S/JUJY1SLrH9EOi7ihbeP3ZrEOvqQnAlpZqOzRJL0j+3yT4sQvVsvbaIbVNLGEi6yYt9PfP5fJGn+pCKB+/u2CJajX7l7ty1tPrGEhUD1ecIOE65sgsEYKQojacbncLjqo3IpUphSF3PrdA/eAj1fm593+sFsXPucti7V2h34B6pEvceWcxRF/kM3Tpg9VZi/O5h9Phf97wqfuzQkXoZ9xwpxEMrlVsLAAFQh8VVcu10CeIdjvvf8FdDNItEYHuIEJw0L6S3kxsn5Hb6d+eLhYZBZWc8g3gfs1bcCghpAHLBqAgc5ourKk0sBqmw1+KP0q0NEv6OxzISo1Ja2BMijPj9gL25JvJFRA6te9ILIs+s1e5xvJucMaAFw2W+6TmsF4OPgwA2XfSB+K9UzXb0hDMp2f6XaCJAQqog0fuccdF4yWf/7ydUuzxTIEgYRcKeSIMFx/PhTiJZfdlsvwpbNKQn70D5j5hdi/5HEEmg",
},21419,964,911453546,3315298625},
[21] = {{
"1+N2ze+Q/liKtOc2Xh",
},17075,13,46268659,3529884886},
[18] = {{
"FZrGEJekOWfdOHvEydxXJg7LmqhpxK72TG+MVeFpXcBwbCk9jRxABpJRXQwntLy+9zJhxb4m41pzrgVJC3DwGOp6Ie/0AR92m+CjlvJNkbZDPtjK/QYTwK9dtGO+z2qyYD1tg8A8RpaGV5c",
},33318,107,1972642482,3179696394},
[58] = {{
"+9yuJE61JoBiR3cGELrU252Uca9zEN6IHK66YnxJ4GZ3EGJSZ9NYGShWPbCVIILPKTe9/8qILryE4/YnxU05Yed0OphJ8HkalMB/5EGUD2Im1Xg9iU/bbwtLImm+bmx8m3DeACKcZlRZlsMWhaPrsthZ8cjMAYIew7MhNS6HHVOyLWLntPfJ5MD05xtNRv1kK7cFNXdNLgFQFp9qqINjRIkIFqeqoUPYigFIGLOKxdN0VnHfR1fKym8SAez1P8pO96nPkHKM9BavMERER3ZOofoYhMs/jJ7jYpx//qBrCL7N6jFrojsp6JPAH0+rz3PCK1LtrrA6tra7ojSzGuAH80t7K7XW3b5ujRQtGN8KHelKGfn2sAXUY3Rca41iTLPOxK3sbwM2xRCxbHRI/SXgnful2Nj20F4XKoDeSU1prMZ9sg0kDwIrxAm4jmoEqF04zuWFhO2ui6/9YcDorvpDduerqAtLpkBMkvALq94/QlnrR8TBmU4QZywFiZExsL/EdsLtNnzmN3H03FUVfh0nELl+fZaiysDgyoV0b1Tdy7VOlLHk2QgA/+NzO+HCrWzdPlsl0H3M8kQLbIrsmxG0kIMA6QJxlXEreV3sk9/qc3+n80qdXSJ1KK5rdXy+pa8LKmU4/BoDj9cVw58ufgdPUjjUC1ItBjgrO+OW2R/qxldqUVed9prfKL2Gzc7257JiVKJtuYoGJeEUgfXomj7wOq69E19mZG4YPXACdRHAIryzJtTjP5+VSPV7dw4CihHqyktAbhl2ediuMiEHUw0G87fqYUhqqfwGw3qdbvA1dX2WhfqdwJDTocL6n9yBqNBQhDaT15GpsOCupPueZ+8LJGhmh4+Asqzcwpr2Bp5YLo7lT9tQU5N/icXmqmmEsVqUE54NR+aRtyEJmMxWURZttj8FYSUwWrH+7EpZty8PDc5yAiVnFPgjTtcE05G4HdztOGsfhq2IRH0LH7tBsAbotnAxBu815mvYWnLOy1G5v4rPKyDX6cis1rBqTwxAcgKkkhwjpmqMyMIXCW2CNw4eQn35V58+CO4I7jg5W8c5Lp1KSQ7Pl0Q0AwQEpCW3WWONVbEOd3VZj6hjBBK08JuHZSXRuNaCpIjBxaV/1XT+QU2thhNyLjGMAfAzP0FQoC15MtG+wIs5l9G6jte51y2mlYTgPlDiqhpiqkD+TpgM0PjCXn7LprcJ6kBXpHw9XW+pDETvbQSM4zZmKeSSMJGfZiIuN5TbFj1BLTgR1lxAwAyQhu2315ZqSrctcsWw0VfOvcJ31U6PP779dyGWuJKmga2q+yWyU83k033ZQMkN5v3t3GbwGulDkPgZOIh/Plh0xgHWTnp",
},44449,1013,3635591643,2435184170},
[14] = {{
"C80arJ1BIKQcX7IuZse7/G+w8MwSkWOltnUTNFnYEFVqDhTvsFiy+16zhsyz3jnZXSTdJnrUkbibxvti04cLWlh3Ri/i8Mi7+oa+mo5ZTEHzJA3XnjsVK330Y8JomeRabAcoGkM2923VZsVCOaNtcW2WLIDY5OWnF/6ve1LN4FrllruYcFnh+CkF+7Vzs4cAjyqaewJj8rTvvXaNzASG1uxtZw+un6l8TYkMBSfBytw6caXWV3Ino+sXO6iAf4+DVAwulaFZdf+gLFI0iIdlDYq5b8UBQFisQY5hCCmoOEAtO5989BJtfSuFt4T4z3xtRXKUPQqh0UIloejOdGWoiFRL9fhNjtPkYXnsFfnh2Y0zzjrmLYVzo41Kp+YrfM4vY8K0a5qTURVVDktNItgzhgfyiRIvQ7sF6sv/xfxrpfY8tHYneKV7Ay3tEK2DS/PJMwaejuCVN/cif60jHdrKOsgSBk1EfOjSHaxvySsHtfUAQqxqfUOxvhdG2GcY2tYFnb7OzLXhaOSZopnAhHunn3amC8c23OZe0thLvm6UVzvHOKhWnj2ZAJgyKpAHWM7BQatrDJRg52kQGN+JIV7KzSBxEl0/mXREen/qgbHLvnYyMiQ7giPoYsVMnaj38Ucac1Uvy/634buxEiCdtVX07xEtXIZUWFK0xIJrXY2oPf2TwAK4aLpX4nGerJCAj+gWxcY5HHhm2pLuoXs/dQigHQNA7URMjgRXLGdALePW5PXOyluGldgffFy2aYaMKRCFqQJaJESWfha3RYacr541NeOYm6KzTMJGAufsKsUFcG9Tpw1xabLswUyY0DYQGbbj3ub/7oc2vZCU8/KIBYdo3CLBlLk7ZO4Ny0lNz/xzcSkeWEoDCLEwi+xdW4DE5dFKkLbxt9Xxm22wfPQJsNbrShUeuJMRDw5Xs+yzdC7yFZVqutgXRgDDnJQem3hoN3EknkdzJ7fZzwseppvSHBcuXk991iChRZMcNEZi3RMYFF28yAKeauT6Ec82vIZi6Ts4FMwlhWhQZx4xH5PcFIenC+Sc3HrfTtC0s616DM8SMWC3Qu1Y4xJ6pKZC3imws6OGoQqqt+ffLMii5zUh2FtFKRdMVF4BBDdBoxkodryOAKCoKzqD1YFhBRTFVaF27ZoXh7lvaZxQ0IspmLQd8QSwKIPNml2UuWw6TQv/xoJuZyxHxJNCtZW5ueiZzl2IfEAaBL/jiTjHemk9oSK1gFhdyQUam50PndfupxPior55HcE6Nc+J8vG6rwz/Q0lgAVt01rxD6NcugX66Sd4UvtwMy+4wALeVkHiQ/BtQWkLrwQ1eYtL8+mAoj1Uvj5g0Hp",
},47183,1006,1185528047,3849292470},
[68] = {{
"2rfrw1Fz/gvNr9IRHCBPSFpf/vQ6B6qzb+Y4X6hUYKOPKhhNj6FJjR3V749RVsCXf5fDvpphLED3RXvfrBKfZqCyhhDLyzl",
},9214,71,2208766942,3008828379},
[26] = {{
"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",
},34585,1696,3195858211,1261108},
[19] = {{
"vRLdzUHT6iJ9+uD88Ea36ix/etXUP+6p6IH7nqfxAhoOy2BhiB2BjkVvXcxdS9MW40NXsgCYqmSSog",
},20745,58,3578336191,680491141},
[63] = {{
"YvatbpAQGFIFCv1c3yidw3HL9/a8cPir1+XirKQsFc8E3HztZRRUYtslFJIw+5hMrSCQdUfP2m+2v/PZwwTZ9B/HIiJYM5rzG6iww+hVWuWJNrxfrWcIyOqovJrY8cWDX6q8Hkj75/FlNx5raxPuWMz/CRniVYVvrzh0mJmsBwCCTCP5SHHZdY8f4JWlAFDoBHSjIpNfq0fWeqMykV6eJDmcWazc3r8JhOTO4SoIfUkVwOdkHtHZLBF2iEHzD16Ci41GIB8MGAhhYQvxiVjhAdMGF3UDJm76N+PTf4u5ZxzHQ87KIQCCUx6H5rWIK6bJ03iqi+kz0Ol+qxiWguWK3ssUJXv2BfLbOY8q7cvduKaLfEqiXkxY0S9gCJL2Gur7oisnH7UgdqCDjOo40+SSFi5NoH0d95mEDEr6SQ+xzD5gKIYnqBnzeH02fgtG9SBzbw4h79K2Y894AL5cy+7ej/A8sDNKOUCWsQlE4OjjULD0xhgGMxDs5tU0keDsW/16URBzqu17SPCUIh06kpyXnEI2FdHqI7VVTBn1/ONMloNiPao/KakhNb3qSERM1uvE1mVPXlX8zbDZCEDn3AUwHDgvb8f3PZdenoEMCLO0wv6SxM8mQh8L9UMsGmgKNAJh7x6KifMi8e6G/+ssYZ6kCeulEG5hvm4vqGlpOsoBTtkqwn7kUmZFxz+tWLDHFW61BBopiqUy9LPR2jOY00f+/VrXTMF+Ex3Du3tu2RhDh4RIqnh18rGsj49NWbdp1BrSuKRn1Ji1GnUvFcNvW3dQqhgxLKR3/AzKXDaO3tZgm0ihqolZJc9mVjfiJsFi5fCAYraYOq4hnUMO3xOx6DZVt5IX49Trw1Jrp4Dx4xpLxli7FXACYCjEq/f4ulUE2clgU78cOODTp14X8KvPR1lNUnxaxzWIXnH22Y0P25+gE2Aq8rYBslrwbFERcWOA9o3NTWwQ9l1WSk1z7SBTwdN3ZUDrYpZX458Xpo76lO+EayiSyp6kV0UUVZXfg3dvdO3ribLurw51nsQeXE9GAk6OH1iVY8ITFywVOb+ExW0qprqNTNxpphUIIkBIeyR/eoSwU4lGPwEeX6Sll0rmqeWhPIsKL1LxRPOV/hWd6iSvefSqfLJX5x7pgS+euQi03fSdPg9JOn10/bkyxMQW/mPRvmVq9/R6fAvwgq9mJ7TdEJ7gDAsUIw4KwHwjJd+LzECsfuRdoFnxO9ULaoQwIQ3odMn/WwVz7aWDmO9rOTN6LPfoK86pAWaKscPcmKd/Jk5cWmGXKQ8MOizTsSxD4HlEB1cvyUtRsKGMl8Wrd5640hsnpXEUTdwmW2slwsPQpFyTgpYrPfTO2l1dkipYETOqST+2LMaUuD86cUMjB8u7Rljovq1hEeyQ6K4sErbpzFo0eI/vBg5H4CHtNlu/IOJbuN7f22ZOrpezSSaCjlpiUNeTgYsbmpCiPSxEC1dRHIjXJsEcNoKO2K8ns6KWD2+YjYKrK18cqHKm+rUCGzujLAQ0JZ8CM96ktrdeDJKWHd58IzHP4nBJymOntuAsO1BjVYCLOcaraCPxPLQ+x1u3A9xSWYJE7eCxP7HhcbzukmkDekyzxhVQemE/pgmqnxGimyLh3eYiweHfHf+mYgFRAGQwqyQcundUirhD3iBH6Kk/lggLpL8aQcTT+r1trIWB75ciGtKihNIS/edXsSR9f91juDmiBhXhPwus2CsEICVtZVUUUB4qVWdooYdHAQQKML+0ulBlwzuqdznACKo2tPh",
},7196,1328,371608278,1427093568},
[4] = {{
"OqIosITcsgVXWan9ey54JmjrTXFqioVD/6y9WrItiRvTei31ctvJKCKgXfUN5JlFwbVF4Q42LflDsrnsAtyorbzlD/jXm232xGbyGgPklqa9/7+v1y0su0AvEyjeK0aC3uMAVDgiqJFvtEiUdLXYLCX7TBh4iZ81CZseisnMH/GGTVjq5To+qv9J1LOMuunxppmn22jwyDwjGWxNWsQ97Ibm58gezKxf1siFRxMVBwMRZAOeJ1TnDg7hY9/JuFPIEPT3M3ioVG5fAa0YlorcSLOysuMr/KmgqeQNtDbkQ0LYFyYD/mFoxVC1EQFyJ+fvKwC",
},477,242,2877646524,2830076763},
[28] = {{
"O3xCAm4iEbSWlg8ragYZDu9lpkVRFryNN0nEXxE5TPnJqxfKxEkOGe8",
},11478,41,3057519182,823549691},
[36] = {{
"/SoXTQ1rC3sysOca7viipKBF7jiUB0pSNPvBiHoV3R6IoIKCvSO0LbG0zs9ENux/NE8m3QH4lGJK7x4LAbjCTri562YxlKtF9xnX8h198keiD9Le0aW1Sv+RfEOM6ouYdPOjV4GqMyGhawXenstJZor8QAd6r47RK1LVDV156VcRrpl95dNVKrtUoA99V7jGW13IXQJrCC3WgE6va4e2homFxn0BkZarJKxnbP36uLMrLwOMoWbk0HJ9XriUxuuVvyPkiemIq4urAS5JxhtM0e1wINJ4eI2sotCr7eSIEByFTlT8Qsi0JJLSBF4b1DFRbW1pOr+LASvAbNnV8InATqT9JD+V03RLJRAppK0WMH0ZoLbQoxcZvFYK3iYi4NAxMmzm9m43U6HJDAK8o6BIRnlpisO3oOMsj9Hx6Q5w/vXCXpyffYPByuBzTyEzL5fvIhc8yqAtbYgWpgPbhLFYtA1jBKKdIWTKwmtyw2NcVSDpgaRaC6EyL7q4kqZWUSIZdretqRyS3OUptN2sL8QDus8Ie09AmUT1cqMF29ObAB38DahKhACt+Hs7Pwb0Y9l35rSMAngnzrLSbR1oUQ3GoPGjn/LThPppZFnoagA2oaXzG9reFt0VFW2ineLbHg/2L4LfMQcwjwYpYlIvtCw/VUhZG6Jli2pUsvTfEDbJsKap/LAzYs2duaxXTDSsILiRAxfDTwiN5nsul5G/xqjGVBbTEIKCHQP56r7QLmP0ln34xMFl91I3AqLQ/M214XQyp066AfwB3DpJ5Ih2rUAnKBSgnuE2gCVYkpto3ZfC29nuRuCtDHJA+YjYsqBXA2MYwBxxJJmIHw1Apa+tzgr3Pth+chIGwnFM8wX7/QD4UGiM72zEI7fy5ALqZEPK8AB7XAYU//WIoQxAEF6T8ALB3PoK14cHZNP9UK7/6IorXzmSV65hXPVyWXIW2jq/SfDJ8snoHiIaKX9Vh3QYcaTY6PfNerY",
},60956,740,3977529545,1573331195},
[1] = {{
"85fYjSG5Sc5WSm2VAh0sWc5DDr2GDulpd1//B9tDbC58Sn3MRiWoe4ek50WKSwo3lGfBgRWNIAwxUGi9Ra8rvzLSkgmYJRDG+oO",
},15467,74,1817845371,3413872346},
[17] = {{
"lZVEJvNJyltJ53qHu7Cgj86FzIjDta8A6E3lFnERXx9mZUYMzluJV1KGsgTJ7DuqWC3ILJSVuuwhjsnnkeyKUq5JDElzBhDEHrbnuSimPTMOsUaSsMbnR23d4tIoxCoewnj+9bptbuopnoaQE/K4r+OzEZJGNQoczzmQtmFxVql15peMDA5SH2a88gItiu827le7dK9me5EI0osqtm9NMKixDAP6UTkG9kiw1W233lMWTYgxPJRTWhk2xEGMt66GEp+K+6sjAIfsBqkwqt1mQshFz4Ep5lCLzSSAynySA1EtJll",
},17980,227,1307530918,1335682275},
[44] = {{
"ey4W5V7lfkQaN/5CYO3B2Z2UHGxIvHNC3aLfRr6ZY5W50ZT2u0FAWaoUKQb69v9gwCy52YPz2NJy2BVtWWE70Bp4ePojG5FMlpzfzjlOeW80M5liAEcStKdzRDPRTZGHC02IFwEAzhQYyMavazprHcUzZ/h30zKnduZzFJPUqGBx8U6N5zrYs5nl/3teVyojaAzmUFAfbkmHK0TggY9J9IqsmrQH0YVpPNam64r",
},55665,173,2232502302,3165532982},
[46] = {{
"ZD8Z5m+x3aLawpFEq1pfGH9nn4tmNu56yWradoEz4Oow1W6Zv1P91DI7Vqv7+wcTg3dptEfFJiajbN/DB5ZlHl+zH+KKfecm0fl5J0+jOlaTjSKO7EjijHVjpduueLbB8IocEJMbKDwnXyOHyw6bS0SqDFh+zJSNna84o93r5aR0wmKxTAo1xWiwf3Q7fYBm6wK7npWaBqYw2g0pUsFTzoOeXK9KpBvDnBuIk7Mzk6W/rXvJ/ZYQ6Sgf6s0VLTMqB46jZCohuIModWWbrC+1FLS9LbOTXdNi3QNo5rFR6KHyc66t9XW2oOGXBzLY1vWlFL/8qkACUUIGLYe+0FjDPgJzRuZaM6us2d8nuDtTMvzIHdMUzuS81qYZw6RfPZOWH3l41rLxG8FTH48FOGTqKFRQ3crA",
},58925,309,1781757881,3845212402},
[29] = {{
"XRFkBgyEdsU52fIgx73nN2+/oavbJISKz6oPEQIPRSNAt9H6HfJDlFJwZRFZ75qhC4ACWVh08eoCZ6PC4vLt3wPjSmYjywgyPrt0YVKknUlA9ECmKglRUa5Q4LxCLBaSeOABZLLY1et4TelcCfazFVAJwJumMI8kc+WRhOtSy9yueUL/CA3cYZ6CTqWDx3rsod6Cj41lfTmU1DFB4mKoq6Z6AVKm9p51IOs6AyPCwieT2cT+1E9bRa6WMDYu4YVKg2uvRhyxyx3xl5REK09YceJpRf+CrBVGVuDaTWTovH3RS+KPPpCUCjvOaKh14apWPKoWGP1zbPTFr25b14dQgquogE/nW6882Q4P9rhkBFwYZMsgMotViYIC3APjP/YlT379s0FLhB1yr+zz1RbYy7KDLI/pAWGKz1K22/xXaUvafpwg02b+YoZY2ryZA/GuYPJTyenlgCOu4iHrwjwfE9Cj2WuJ9Nr7dwLUL2kDAj6lhwBRTh8+pE2oSHJewkq9BsfiLcyjSLm9hRI9dGlmgEXr1sTRJvPPdwpqj1V65vYQ43pgRjNFDZbWIG45Yp0o4ccUzugAG74mIfI1Hk6MZz0p02EraMx0cmH9ukcdYGoto74XbrfySkaifnABP1RipmwW7CD0Ap0UH8xKfmpHAFaM197qQZHs/K1d+3J6nIqJ/N0Cqe72qMUDBnxz7YiB1nzjck0MLvFK5N6t0Cuf/NTxgORhJI+1W1yYeb/Dntvnb4NVJ6FE1Ios7cNLXerO3CHCmCImXzBsZ5mXCORd0vWF7ZQ852oRwF12qQVtRvz7qwsl8buKswCn6rrOWwSgb7MsE3z3T1O/Ob/g8ovFaWRfqYX3Zq2zsKNPtoI1ulHcD4Nobqj+kkgYcJVGSEcWWEiarxkbQD9rDrc8vVvz463HTcimhR6+S7HuLwZ7wsopx4KpD90jhuV0XEzBCMUZSSHzBJl6F87x/mzmL/2dSniMIRl3KzhswuQDgiMl/J/Zr8T2VE+Q0eIv2zYT8Dd85OG2D2UlzHjQ074DJM5kqy+gv607R16LDgK0vqsH++SJXrMFd00hvZ78zFqXgfPZdjV9oINwQLFov9j/zL4KKGcjSTwUbVYWdO65Rkmaxu9U+ZOpNgFf0qWhqVl6D1oNX/KAbvSBcR96OakJsV3kVHUV7fIdZEj5DmVB9trUbqCLTth6YJHRd1hyeNkwzruBFEGg1d8gAhCUCsDjTuhCioZvtmro9FMhDA9WFuJiGBgRaxYN8yMiE7L8nCOx/ANWKMWQck1TezoAVP/MJGIuyZbIcghcxO3sTpLVMP2aRWhSzK5cTSVNy/q/NLXboRyp2AxD7oitpl2/IZ9VAsHXTMAjXFE+Ml+s/m1sKBe1uAN4QkWIC+V+TgwwXRxyVV6",
},58984,1055,836295608,1466847348},
[60] = {{
"OdSjgdkYMZWARUjCTYDgTTvu5qJ6US5dNBpfk1cqZMg9NXf69cDqbs1M510cZBQNfG7/fcuB6d5ASYV0FXkjoLLJGAicNTb3/0PqIxl5Hv7UXphAvjO+phwCayBtreIddEoGzf29Y+h/Us7ENyNDBRWbaUFS/cVwbqKB5HN+Emunc6+cLUXV1vd29oAZZydETd2EAzU9oh/iM1dU81rHKdvanoSsENKQOyf823Vw01mCzSILrAZ8qcurV9iVAr8OUUv1U5yowNPKE3WFTJbQJYBb4AGewkajqooTpEYGIqK2z5kgHTXuEhIldzJtdJlcdN6S51CfircIDgxodiXNcmkY1pfFKVd/3xFnk4BeGbO90dVdEAhtnWY1dMgZZyOVN5R+bVwNV7Bl967rVYYn7NxLHwdc3DUkbAMy6VXfzBQHKBk88f8PIopeIQzoXIWUFYmqkcDWtTUkOO3JCHtoABx1Ez+pQ2QkPmX2OXVwwW1OxhdEo9dnDOkGZNEro01VO4ISkNG5TyCp0K156DotzbmYA+M8kxSQyxELB2v5KXsYQeT7nb+M2Hf0mdVrloJLkLGLxhQAozBDIwy8ZPe1kZx9l6t02E7vMs6F08TcAF4wX+9YahGPR5DfwJVyOBbKKCJI9PoTPSkM7PK1LBj889thuuz3Ex3YWZj5riKk9SaNBItbgQxbjxin8MdzL0mSBmfJUIJZ9VNAil2wTlGaOuyZ/SIdwZkopys80e+Js4vFgoq7QQiRCCjPDAuMV97ol4urguTgR199Yc+WJ/wOZLx2D1e2nsbJkXBsKMsimue9QKzJowy/Vec1nUl/Sjlq6XB2pHiu62k6wWAIjhbETWDIG9ywK5itU6hqVTfU5UInTaeKup2oDtoL0gcv/f1TzRSA+uwcCvxyiydUax9HT76d8aE0Y2M712ETfUzdsmYndhKy9kR4YXx0wcEKyudl/kSgt3xlN7qP3dFo7Ajb78MFs+Ow8JYBVGxkMCkb6h6V7DqDi9zXr5ypTs3ckb6IcsE/IJ80QHhqIYMa0zztSXVuB9a6ejw8SYE/OOb",
},18780,797,3804123871,1193253198},
[10] = {{
"vd08HG9LyAKrTQogLapV6yOF1ivHvHM7nLULe636NGOo5vFXBAoDrMeaAwmW+ic0Hi1dDe6Kh7Aer7rE1sllHePam9jcBWBCV5WNRgZgvVDjXDXdsMzK99ZLljpJjhupte1l4hO+3cpdlcHmKO5RX5fVp92dtS1vjp2jNybpaddUREe6SRoKjQGuYv6Cank2UJGQEygoTdCgAknowQXjkgBkNe7+WpaU04yitYyeuJ7BefK1zfWYrUlkJjTPVmlMXcpXKN0AHSIdFwBA8fmJo/J5kC8fUn/DHcZ3h4vTSCQ56F+6y+vfiO+640UPFr8fR1XGO9UEc27/Jm/SWjI8LaTpLneXkVDtgTiYtk8xCzmjtbomlvvoq47BJS0bzlFEc+CpPWhWK2jY3AXUDfCUHxt7CBMghlwuGluoPzcPpw8IewKe1WclZOibkPlEGt6WPJS2y/pwEILNNEoNfrjFqvmFmXReaUvp5mjvzMbI8+8yQEoQwEAWagm8S+Dox3myY0AQ7GDwLkmmh4KdUu6o2FkBw+YrzqFfNn+GTj2ATeJ5PmfStOE+B0RSAPW0z+LvKfLeTM419mr4M1FIwSIRO/JK+WZbFAjsdemDtI3dxbTXCgtcUmt2dk/6OjSFRXE8LnBLOrKT75Xr/avmm9/b5g7a6SWzmN9yYo9Jch7f62NDX093bANg8z8jRLtxvplREpDNZ1boCehs1T0XgRsAV9/yx/lf0cxEazkXz6AYmVMCJf73iElmAV1M2ifbxYoW3oYVPWnuINmJi+HA+RMpB633p9hHH14oLaykDTi2WcbORpsWbs8oIG5GfTyhJ87swvnY1yZh/7lOj2wd8/B9ZYzLrn1HRawRLxBBAyGT82hcCI8n+rPeI4cfwGUnAOx3IwW4GXnNkM552UhdpxttuTIo3iYR063lAcxFWTcKsVBUHwmcjq8EKC+ZbUqaNYUwZD2BJ3YZjkbkDIOUDvaF4/j5obxg3OHKQRhWJPHPtiuxfeAjJbHJ2lusI4J6WV5+ieXKBIqH99N/HAkPeKJIACcV5OlJ9zXjmUraq138vheckK6+YQ2MDq4F1zaTuotaIHBzj5AdXifTljum3+TumJk0EAoPN6q8Gg",
},1897,841,645618833,892481677},
[71] = {{
"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",
},21808,31025,1795652035,1342241719},
[51] = {{
"8tcRBV/5y4wq2gVhngamxtAtORLVCTB5cvpXmOvJvDkW5JyV+zGVJ4pLLGScdPdDKXhpqj1cnuKzv1e5elUU/IqUVOw7nTAmNG+rboWtGV5bIOmiKQhl8l6Dso5PC1lbSBYyztKFY3uIT56y3DTeb8aA3lPDA3IOd9MmeVzpWnhcrVG7rcqRdP3n/HfHOqakYp",
},53497,145,713046116,2812217254},
[70] = {{
"/gFGofC2wZIqnydUyoViP/hztdGiugANZY69phh2mDQDeXKsdR2J1DybWWv/HjgaDpE",
},35607,50,1689587676,2544258273},
[38] = {{
"y6wzgy2nGZHxYNh+p9JW4SSLLc67MtX3iDdjvCcbmWoO+nJqpZi+s8Syl0uW+0TR96RtCTwCfgulcBN2RtJDUhLfiHjrLbXdJAmX27nXTIdj2v6Fpsgsmio+HUb6WX2m5YOiG/lb3K5iK7Exkk65V+L+oSG5ZjUT5rQQt2iq+1P0gajzTutn5C57a4VduQ22GIB3coTDs9fB1l4Ya7v8qhlOGozsSzOQslB1JQC251UCpD+Y+Tf6gy0tVv7GH63QOkj9KCHiv5CHEtl0ND9ea0ADWNvLkOZArzJRKdjy/iNOmQu9c9VfJ9CoHQJHyzhi0ZGBVNShoLaVzs0RTJDpGZxXltUpuEFSxvmbWYtqzGi8CGKdLA9O05Ig9vPQ3A0P+f3IhNnCODGqo+21lzmou1hxzPZOkUboowll0lH5BifIBN5NHVHztXFm5WbE6BpXroQjoXTkhUVH9pRqsGjHQ8LpJ25BgVd/Q5vElDjdjTXY4owF4GwzIxbNGKGUJ/UQ7Zi/4h",
},53470,388,2843648826,2524233360},
[12] = {{
"wpmbWSnrgu4dtuboUB86+8qCjeLTuvOlKG4L5c2o1aelp19RSFhz4f3NxD9hh2JADuLmKbJTNWCx+PYnjSx5jTvlhx33J0T9CM6Mz2OBS+avuN3GlijXrM3B/9UmrE3XtIUeoodrmQXlRM/sb2OFLWoMmEl1DGOpO/0iQTdO5oVwN3tHs88k6ddeGJOtgulnPbeUw6ltAumim6AisZ1BbrOst/aWjCW/xa3K7iR4pPSvqVImVbWmNEfxus/pRLvdBh4USks9xYuk1i3raOwvt+I52bt3DrDb41UEP56onBk3908U9DGT0qhNT6tA4xfp98jEnVhOWuo02v7y2MsJu6o7XMBnGEtyfePsin/2qSZWMn6nhcbTsP6+JWWT8jPZaVh2HziDsi2Kt8b3Kp",
},41617,301,3925901702,506237729},
[53] = {{
"HIk8XFO9W7RrgNRgbbypjLwZOo996oUPKFZ3vLIX5yY28Sj9k+7m0EMYAR4LKDsD2rOWnYNpQHPps+2+BiUzNBAtpwKCWs13/PHB/62w40GCdosykPhW/W+yKLrn/E+n1kxwSA1rFYu4MSfbmo+zPxJTEwm2FOI12HMKF4J+Xh9070ipbPSrjv79awK1Asdacmjhu0SyKSzloxRl5jsQq0PPQ5QlAVVYi5juIWfoGiWQZqLPmmsuamhmT073HtmTq06ZDvc3t637NkIT+0FL/Ha3MkFO1c6w1908BB6suPjsraddDemEr34IJCx0TdVTYsLjfAx3iIPIxs92lpBYDNhWwu4rULK/S/fasDeAcf+fK2TUY14l8kKal5JOiX1nbKsp7f+ifsXUtchhWWl+LraOPe9+XWvirvcbLq0l0vzP58uPtBXm/LG4/ltgbshZgd2tjBQKMQXgzgCX+FPQ9joSphg1Cg+j3lXRN7JuFqmRCVamVN6n2yvGBZ9I8DsGvPS1naY2zaAGaaMkn9hhs2Fm38n7PC/iRSL24lsrTZa8jQxwqQBTNWPcoN7TKYqnpFwWMfDzCXTYhpJSTk6Hvc9RXmSL9ytvGn+dFMiAA1pnHolP2boaDefn2CqZbFgo2FvQsWdJ5C81R3CbPfDvr135aT7BNuuN05E/ki/m57khEggICoJjG3gTX6doqqDmcBv+k3v3SxEreZ+0tHcUcT/FvFAh1G8NHd3RmWhYjnw0pMSytuzmiXBYIr3ro/nTKNi2719mOHwiLMhEeSXR3UYLa+KE3KiKcuc5yclzCtG6MA1WYsWK4S7Kl63Wb+Ce6186YxwP6c4ApWMYLwsiBxdxaxMECxu/cmW9tV8yOp4hksmZBng11jSdcdU/fUes1CiiUq1kBKfvya8AGWa4V7u4ljqZLXU1Gmp2wpx0GU7lXBTY8WM0MyexVF8aa/jxmJgpUFdZeCp6qcdggrtOtMU3TV4ReSZ+1XpjQ1iO1tAzfXi6I6frqdEvgr5sqqD7BNmh1FOixvHjkg",
},9585,778,836455852,1749264005},
[62] = {{
"bwG4isF7Gvh29NuxyRNi/yZJJjkHX1gJ8Bk9fvmSqNOmkGQG2I5mpKlXr7PJQ7jO8M/2Jk6Bx5mBOO2AmI6vp59pBFz3pZP1q3hfitQVksJjml93fAUo9hR9P9BXnnEhCaP21V/JCPbWt5pQbZQc/psvRjLOW5uUWE8B7LHZvoJura9NpL0gip79EErpSrkDG4iDRt5iylAl75ED1GyNMJZy2BtqxqhnVg1mGxZqjMeT8DXV49+RMWVIBfVT1rw5TrHPTOrf8FDY+wrNyouKOdoxGhgA8ngUHlfe+nbklaZs8/CjOwcQGtzaO3hKo1h86h6WhQhIkiKfGG6fTtm0KJo96oETeuMAeT6c5cb6kfFDmSjBABWXXbVR3bT+mKPoMiIig3O/nSfiXgP2lZoKuzDIkEuPovXjLFUNtj6Yu075L5wSveSvlOrOQJOgKkpbnzsiPNDKhT3GgPUIX9Q+52kLMcLZNXCMl1FMcTGOy7veg2XNbLsuNJL4sos6O2B5LDXq/ynBxjj5NPqQlzJxLfrPyHA4XHWhi1MApqd7Nc/Qc/271eVt+zmymtEb2sWNOAlPoanubfDcE+ZDR0mf2A/fLOPpHpa+9Ul4oS8oy6+hYHKw43NZm6W1crl8Sw0veDOmt9F/YBzd0rZdkZR72qdA4P8Y5l7W3YHNO7bIQMIv2/jiK5YGeFVcvj/zlYeVdU65haTbo5kdTXtC8QKwU9qm20KmSSiLSZLHXStNK+Jcw1R7gVR/WKYybJWFfD+S4AgqSnPBKiRCp3K9JrSN+Ya896i4LWdO9RGhGD0sR74ICVa9bwOeccdT+R3P+Qg3Wg+XzZk0tn2rQjY",
},33706,635,980886340,2011410935},
[45] = {{
"z0TUkX+UvX/a4Fsq9L6VYF/Dx9+4Ode6gSh+RuRthcW1TV9qQW90PLXnByUxraQ70bBiE375C0MWVPV7jDn1DfH9iqIL6/sUixLvxtpPGE2tvW/d4ye5+hh88svvNl/18oj5RCkPu6DIUjhouecGYtjGe7kqhbXgkboZIITM8oi+GnhmmT2n8o91yNjEL/JFtkQBM9yM+bmytmQPMSPYpbJUI8SvTMM/h6W+QBedFwV8M9ioNxt8fRelSd/DCAGIjPJRAwEH+ND7a4nKtl9Ohp7",
},54929,209,1500600587,3560044708},
[9] = {{
"v2JWXq3mP472Sc2nVtYyXGMJdYsruUmJuOtGkYhszR/WdhK9ddZdslStM7ZtlsEye1aqzr3Ly5pR4PMdy2ODWpJE+jaCrjweAdEq+EUXmdtluUKtdElfxEqFGpQMMBLc7tJlWr6yJrCQXQNmxqY00HYs3QOBBNdpTbzWtS4JRsPjmGSN0DA5iWJDxR7n6JQ6LQD1yWEQiaH+DgOYHea1uI3GcjnFBbU+vxRkGmGJiWnIuotPt7gSCO4KgBWMEp4cWOlxKX3uYgZyIhWUsPiKqcj+lCvpN/34w6lZ45uBaCelkcVCCEh80zM/54SOED32slPmoWbbU+sOoI6770MYkLc+c1Rn9sclb/2VpNrw2x5vlpJeSfZnVuz99IWukeKNwzINPqX9AkpR0VAAjBwNz+o7UyPFjg",
},14593,310,3015802714,1840457193},
[25] = {{
"TdM/0a1Z4kVzcjuAlAXpolIewj2cpG7+axHIy2+OY14wVDKwSVzITOtj1RV+LqRSoOPsdcsc9n9NSLQqJqhpEY+fNc/DQLchLKYMMMzznaXUiz2XF9gRVL4RbjZMPqIkWrWrogHwlvEc7sQW4mS+IQwnbzmStg0IEFPHYPPkKBe+pJpocE6KlMThDQNHjYKJWP6ruUEUGaFjzCkIC5Q1KfhUqaNvfls+TYjQ6zWm8CI3r3qTlZaBiv8VdRtmQvqJM++jBW0D4Q3AVUlpyZ3ZiaGjpjL9mbQY4erMmN3OPAttUjEOfGGLgLjr6bnTrumhu3qmb9GhyRSbxO1Xz3yTw6f0TVf72EKgQnH4RfUcP2Ha0ZHHDv3QvdECVhXpHhtAhAwKDyQVuKPq9xqHpzCH0TdyGPzIfW4npM1YyoXvukeISvY+e3dLylIMR/2NHEqOjiYrnXAw0on4/WxujHr8ba6yeAHIlRu35S2dxLMHA443i4CgMxT4ox+t6et4WsH+9uV3PhxBBHKDRbqH7hbcRutRPYvdvBKiK79ip7Ts9wDi1bbCqLy5WL8zIUVO8BuDZSIl6un+y3cDJbdJEQWtm3NPaGasFRvRoaLwGJL8K9jD2XIZkzakOW7sW3j3mNzOrb9aWNWOpZieaWI7McI59lXF7I0Rocr2ALkBy/E6Bl6DVhx/yLxbVYXNSH7c7ZANMSaeqk8Sj7kMdqFaLW5HbatsJ6D/JNg7js14+PC7KLWX82zrhORMq2BSousGdp",
},6650,574,2471490031,730793096},
[47] = {{
"+aILM/QXbtDSRUA/SMCsYUWX0NraAxosxyXNhDGMyiHym1H6O2FpMI8zHodjgklt0wYzmghXmGjGnK2hancQVb/K5JdKUuKanq8rhJJ8Jb1VcQNw2SBWeU7n5frqZf7ra1nO3k4LkWLYOyTQXb0uTAaKpxae/l1MIRDAO+qGp8T/rQIF3ovC/se06+VtIJM1/mqghLXoJJmFwnCBxwTDLeA6qxnkvDMhRVUQf+2xwpZ59G3m2geUoSftFbjOVJEXSJRveqG+2HAkbep2udvHaCm",
},23798,209,907365429,2387421449},
[39] = {{
"wSElAWHrLC2aMx474uz9NX6eJ8u7heM68n8EviPPKSVuZiTnhl6MiFJ+MwiTtnxfgnlIlBjwpNy60XIJebQ9RILwX3iU0cpVB8iwcplqE07WZvX4Rdhge738kv4hshy4U9heVAoVZbvWaQW/FXV2bZGJK10QThAB92odVv4IuF/vjD2l6Jmvsh/shrQ3MnUNf0x8HL60SqBj4wFAnA6d6r3+slHSSaDbkNcVSBecZwh3lHOVop6dS65F49/hLBxWBRna6AJA+hnHo+EfFoI+1X2fi41+8fKsNimh2BwIOpI8v4qP1pfC5pSg3rwnj033efkvR5CEmm6tmRY/h5MwOkxRln8Xhuef1IT3IKJu5Uk3WSuNVb/NxjbKOnkUMdJUrvtw/Gyuz4z8BsWQymfnH2aERHL6AnMtEmOaH6/Pfz2RDDY8pIDdY+mWDp/D5Q65XhBaVn2Xe650J6uNommnp7mSbvU5jKKkuNXzwPcqR94H+eD9QCeKiYiUGglT7sHZhlrVQflu41/lokL6fUYnSdtxmnAGX5ptpIShK4SkNGnO2P14RDqMJh14mmz5htZ4RJkIgMgUv1BIwCyHURBmGxEulN/jDz4rf5qxPxhLpKsGh2OVxaT7zgIXsZR3b9HLjOezDZ7HC00/wFGnzdw2qyn0acDbElEgtRVbDkFE8n8IpzmhiX/VOFle1rYs5E1JzNBDWtPLVbz7gtXZYa2yYnM3O3Phev/MAMRxQhPqsSDNYqP25ohliaPREVQxKOEU20TXGnwBr6FZb5PU9Q6DC4vlecuOD9VrQiFJ3iwOxiy+xDmNwWAlDQshRRZTybM2Cw4x3iiIf2xAfaki9dsiQfwVnoNj7av5lsWMbSiMC7CEw/d5IFpl8/T9W4kpb3kryUtYlkbRiuZhur0dH5hxhvQWiglWeCikBTM0UtVWyRNiICauSTNpkvoAgS/yCFRqWLEIdB1MxcoJqp",
},54692,730,1070608822,1737186068},
[65] = {{
"rfmb1zKX5XN1HZPVQlQWvf2CSLIVCnbfegwxMJy7ofNfrnB/ii2m4p0MJJUHcgyt5DpV2z0WEsbYCHfQQnWqePszr/SfUX/yHEoZzhQzeVNsIQobaSUyrw3VFYlEpBBtg3iUSEIfyQOxJqWMCMRDawOGznKT4rchpc6Tf7ebVPv/Gfy01wCimbbJL1pKb/tw4HngHvUB28sWf4KSXKvu0yH4vzSSxN7rkVp1+WXxvPrW6PBpEcQ6Y9hRdkS+XLzgB1bJkYewgGJ0oN1M4SDNHaO7KHUOqOKIOD0e4cqpl3nLwPkUASh5OGmjxkTNB/liAVLKFv+lzNPy2eLDHgt4qpDSapkJPZRyaFE4rfOmwA1gB3SHItJMzAjMyhXFSIiVsWHfIArnmXA6quaXw0E4KwWzJyK7We/dwfVkgxgKALNWyvGubyEBsVGjggo0Nr44IVdotH5xB9Ns3/aCLipcOfeyYfThiJ7y/9FIKZUu3qd01sRziC1wUwm/z/okBBHo9xL82TeOyrnO+7ySvWcvCYSJGHklgaR7sMVRfYtvrX2pLkPmtpcvAPmAMA1brc+JTNAjaLr4DV5qgbYVUnqY8E3HrOvyzQ9i8u73Y1BPkGIw3puRLk7NuYupiyMaRu4R1HNGJSkykBJwlv1xqoeo7ZwmEKaB0e7GUnrmOphlPCTJgTOPXKaR5eeVs5vVSrNTMEQoGYOg3eY8asJWwRKBWoaTEFLdTnyHuPAvg6o87vcuTQlWIW81PagbRdgbKL2LBspHr1hUz+auAFhDiIW2vv5G/lO1w0rS7QCl4HavFsbhovGBpakt8DbpgNbQjhUXIvvSo4ct7bRXg0bVxlHrB/UpaEP0MZ+ytAuIvRO2tAdM3fJLg2K7bkzn9PvToKZMRNo3/P+o6lrpKZF4RMbXsjHD721vUiPxdWNGoLMHLD8yh3xsBBXJ8p+FhtF8jSPN5JG7LlfnZoSXXJ61sKw6Wd0TIA/e2vi/cXGe83jIID54ASzPnKb+Ud0z8qiBW1yQPbJWg5m0RR/wrc/JcWOb0KH1kwq6CRmakVtCQMKEFy8qVPh+O/+lSIkRcp3Hi1yGRowwD1tpLnVbz/jJSYw6LU565V6+cHnaofaADzwdsljU3XA3wapR8tp3WFMk4Pprpcu3UZfeZB9mgHKNhCqbcUDC3HDEuBveOj7VoLUVO2Oxjhf1us6TIugU0sBMB4AamqHYyZVex2ge6fXX5zQRwgWGTfZJzBTM66y+Lnb3jUzx84Vez8vieOZbkqgGM1oTSmaz0HOnDqS/G3mni4/SRsxVGkcl+TdL0AvHOJuPYrIGhTZzBs/FO15jUJ7G8KNaUlJofIDg9Apop+18OPfat/CO9+OIppz9dOK1VVVt7UGK22tIPQGyErYflu8+PfOoEfxdEkMoSD7esL6ea+5UD+6sdThohPLyVcHb6BwVakjx2B6ivu4Aezzn+YPOrj3ScU343YS4aGyiqKx0C+e49FBGQScGjGravsL3JoojvG6+Re2G/O6D/ZN1En48OP3Wmhy3OGjVr/uNTVQulajMOeznmu3IsBZZAAMu5RW9DDZR3AydI19OZD2VMuBjumVXTM82p29ioU4W571TdQRpM8GRctpfXBNTBnKs9HJ3A9YA7dZEKwpmJ20qUxp9JV7EVKqTh3X6eLoH+QYiV/eDe7l3MjXI5urSC6uu9EIAY9JCKcJa3hd7n/3DUMAecW8eYke3R/W6cdCbPPZTR2GbQk7ELsK5nMH+WNN0cdONdSr",
},23395,1328,4224406684,3691741829},
[66] = {{
"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",
},59378,2980,2944672497,4189943837},
[69] = {{
"lsR9Yc5kr5Ze36clc7jZgNbms6OvLBxUqdnl61OwXMp2reFDDzMGKnTgUxO9/L+pWCJVq4CwYfyPaKzy2wGrQJ389VmZjLxfHR6+xFqyorz6n8reocvorEjFevcReprkIiArpjn0irnRh97OWb+M7xFuiciyv6s4ahCs8ZQRcYrkAfvOXJOChfzZcLNaZF4xbN3bVUqWMMwOni/FhEDHdMN0a2WQvliMPHm7VNS+CbnLJdrAdxDy+xnjeAwXKt3yUdDSAuL8s+h9e7jk+yGrfzSyhqj3WzqXvZQVaN+hhFtqgHnKL0dNbsOmR3Keeus1BNsuKkjpoCseMZXLfph2qhX2QlgZ9oHEEgYT0Jj8MHi2u1I4+ItQurFfrqgShWp0Fk/Fq8US9sjH6IPIt/oIRPlI0fzXt1ycXE5IWV6NvmkZsYSfdSZ/wgog8usBXYatI5rY727PzJNaOc6nvA+jAx9styJWGpgXIOT4ytJ3Q5a7I/bIw7AoDPf5D0T9QS8qoNFz2SPNPd03r2N9XTyiY11BhkxmSOK0ItIs8vHi4Q8WXCaXdBGqCASnyWeJ563YhtQMkUWGDYtABAAU6WZlulQT6aRXV7NRHYeFyNpNA69PaZ6VNspBW6+OtTprUAgPSph4pOquHJ057Tp4RjMnyliE6l3dkEt5viSHeS9bTCj5Oom4MdNkLkzdVUKjVI+k84i6HUrGy8NjgRN9YFCmKYGtOv2hqN8Y7KOU1dVyiHoZgSGbYZ3YL8+HX5EoiGzeoIpnkZ8qO4qK9a2Z+UAaBNOSZdSUX9mBuaXv8i/b0YlNDgp7ylGCIG62XQLksUpcdxFIVlhXmot6sWscqKItpCKyKWz5dH62HEuncncXSVKesw0XGIlgwLIdsyjPXGhSpOIUUtNwz20ZorRqRtmDnSzM640mc/41YNci8ZUo9mWf69CHIq1GGhEksDed+7AknHm549qx+i8zAI+Zt8B4Gpp49tBTV+OWxhrJ6LmMd9jNblesvSkhy9Yny7J7K/LMMpkqhaRkw7YrdltyBeshWTqu1OsqzkUEV7hCDRgFh66AEWVXgMvyoQ2v5iVpvbfJC5exgsNYzDHVJt0+ah8Ok6znsal1ypAkieQiqd79RI8QG08L4dScDs5UoORIrCrEt6QGe5H7rv8DFaBz59awCvC1nH7Crisx0SLRdXRsJr2pWUIZZw5NEXmZ/eJRSAVCdwg7rz8BEgNB1a3hVPzOE10z7NyFo+0oLnqiCsH9DwAdWgyiB5JOn/gCy2htVBd/TdSuVWuMKTOJxdO8rACA9cLUc/29fN0SmhgOLK9iM08JgK1HOO",
},39658,997,1070377766,2002523542},
[30] = {{
"IEMFpnTS19+0DoDtut/0XrmMIHNrT2nzYDoZ7+igohzx6QGbLCSm5h",
},38644,40,3083799503,3562860465},
[41] = {{
"HyONuPDmI0OJAmkthLiRGlqZbjOgIjl7FrOB9tRHMkgXFbgzEVRio2aUuJaukwq+lTqHrL08Ga16AigbHRIqV4Bqc0Sp/AWxXRs9OOfr5lTUVqEhFmdUDNsPiFZH43aXtEvL+1Ka4TRTQ0rcOJ8sy2mPhppFOPxejmWF5jZrvVtijw0qz/JupJtn9FE6AoUcO1VrMH2oH7LtklkGerKBn2ejFRfJ2MMA3N2RA9PYYS97qAmkm9vQEon4rWC2GRqANzJIWQcaRRT7f7CkWWi1QTVs65oHyFcvfGXg+4FAqzWD+GqoekT+fonodkFwGfb2xKJJA3EUFAuZrW5CRa4rUg0L8+w0KqyiffA43kLQGnCYdq6F1x7c7BPPpTydWRm8rrSVPS38FQY8fpao4bIPBCKVfh7dk9/VVH1lBlyZXEfKXO8Eo42zKDYhAw8agrEo/W8dDE9zQAcdtiMZdQ2neKcwQA+f5aN7PR7JodV+LuA8qVOLCWNkfeH327r05yPcUi00BifqZBtp0OE9bpo1nwcre+ZwCUXqiIa4h3FiAdxf1V2IftD5VvGB5kKFDGhBk3dUQMdi4IxvA8rk1mvpYAswRHFid2b/EO",
},63854,457,3849374234,1790673319},
[5] = {{
"YSAjZx8KQjxLjhKLTQDBzEUEUQLPdOW1PNV0vD0fZySgkRYetD5oZi0Eb/3vrW6wvHuUBy+o+sWBHwepnUKLMrqoDfMiPIki97bm2qsFuB+jR5/67Garkg8OpuGg0p9ENHSFSQ9PjPmCvVOfsOH2xQeocBeJmITFrquTl3D3tRCi6IBDpvfr0/4hhTKDEoaGcITdhonx0iUW3uECnj4B0QCgFEal1TGWESCZsC6/HT6V09IGY5d4aWb0VbP5HbTzdKjN7hkzrxCVtm0KVKi7uoL6PkTNAkPwW/y0/Dt8AdLkJMoyZd1CrCadgsEkJaFyNu3Kbgti/IPZP1GxcsU6NT71fK3EnDHou6HkCbnn4UVRFbA0alkn3GJLlRYqxhFQ1NlGE573Uzmvvby7HUqtLTYm45H7k/Fl6LCvOaAPlq9/7MrhRHXkLCb4LlXLaUBIEunrVBWWRPIyLss6NABXwv5U/B1SmfqjoRIz0TpjJQjP6DBB9HxPHJKvPRcW5SG+VKDiCXul0+F/ktdzqss5E1su5i/+Qpnwd3cy51P+jO",
},20698,415,1123725215,3228660002},
[64] = {{
"hsp/SGvOikA+/YQ0vfLAfPiRBYyKwfr07CMZdG50IFBJnxeIQB+7Ub/R6Xtk+SIkmi2BO747yUm2NOBftDupJ/0jzGVTPIbytoQ9XBPaHFpxCOyoxmCh3nh0Ji66qfY6q3ASrRFGwedV7OYK39KrLgv3pVmqJ80ej75OVgypqT0NWoVoq9pHA4D0+jfrSMJUAL55huaNTuZRlqKMTeMIHZujbLjv0uOZdCMMw6fbI9AUiAvSW02R8PkRbcUqqAXr0yzW5Dy8bCEUmek/SgmmUMNn+8JH0hKbBkzz2TfKW4PfGlGadSz0Jn2LrU79IoUAH9h3v0E60m/pC1SqmKtcZLAZ6qi5fWd+A6P3PXltA7Dw9+Ng8NAbb1+2+BD7PGUjwfISLxK6GpCl1zVfdk4hOzBewP/lsFF8b2HQSQY8BSN0D/LfRvH3oC7MVbhghdrC2xOMc5x3RV0vU5Jce3GUUSbHC3chk6iJMxYdp0dyWpSYnRVgiZifIR3qJoWjKpcEa2mKCDCl0sLaW6MflP1HRYCDDVQ+l0UHP2FCPsQ+f6SRf4ONUdSHt3EBd0X5n8HUE2yIjth08+xQzUoJuY7UALYtrpYR/GfGRanD9mHtrFmJJHbMHVwvP06u9v/FNgWJsNSe9ZikzMQb9KxO5fYkNj0I+2Tf4RfSEmtOucBXyKHAsotnlZ9OuRIobuLzqfP3aG0fcvs0nzNHNRJaHM+HtaivfCpXUj6agEtUbMX0BSeY8uCBmDeidiCjWUqRrmy5aU0fedbhCzz9FfMgg3cg8X/GMbaD4XQLCjWaICgMyDvhxkt0n38j5M0/do2dFLaHANwn31OZu7xit6cTA/Emos0n2SCpfMGuLW3EwSTQW+zaMkN3T0bLztVftdvkiPwg1jnqe7xpb8vZNGOXUq5lH0MfMO6clYcbLHYn8iAGJIvq7ZxrIvC6s/b0mI68SN02sUUHcp6S2XK+Dl6A6y5LWN091wVReWILFi+G1znALQBBZbCkbHFY9uah6QRH67aUlNAfq0MnyDCxeR4JC51ubfFz+lz27uF//Lbzg8OzkBqv2qEB6h2ZpOIrBC/D392Cgp7L3Nowo9QJm9qeLw5Bryi0oT3yPhsTg2+XVzTqtklCv+dqTN7q73B72hAh/t3Yc/QF89PEvsBtWFCnwYsI1zeRgCP/DDaKsvuLHfi/2SL6NRDhvRJu0e5NctECSoLp3FMeLQKN9Fa6cTcebA2nndQumc+RALEQY38vaYf6Mo3QIL3yDG+Ukg5K/Xng6MzKHIASpcDy4f37mRHme23mEGHpNKK7tAKF+I69PSAvhTpDyF0G0kRZduYDn5RarN0heVgHZjwyXstOLsmr6AHIQPNRvSLnVm32eLiza/MwH0P5f7orhIfb9UVoxS7Bc7uwVTB94ulG4fMrrvjuPTH3zwYGkAvOm8e5jPYtKxHkUV1mhk6LVGzfV3TIbc0bHjkCjEHRTzPe93H1Sl5XTIpqCS+x9PKN3X7w2iuKJQMgXm8B5K4LzxUEFoeI99Ut+9jOAc5fa0TTPo7f/0cR0r53qiAbgE4aos9Kd25QuAeEOGndPCqugAsaSIqK2skELL2W4vCIqEPdOvdspjQFTvOkZPZoD2nlxsxUZ32oB2IcN4jk0NPcVyWn6GEESW95YIjrgZL1r7S2DmKxJPNAssyoQH06NQ3MQkf7A6N5eqd/8iLIS3xWT5b9531lcOaO21l3gOPIeSv26sDIzTH92s3eq7REcDV/iCUK2xFtmLbkS8S8JpfU47Ct2udCuSKbHQ8ZF9qsJTLbLyPCkQH5eaivxavKnHxViFZFkXYl7UcAdyDwMp9+uY7foQhdppxX8qgsdHFwG5dLZVXqfEHkGWLsd/bBVsc+aTReH6Alhatl/PXLUQKIwCocrVWZ8NA4m35K8p7qEJA4hwzKeJACO6P7hGpItTbcmFQpZqherEYpTkWis3ALlRbc/BedOKW+wu7cxfndXqFi7Qe73DCYN8lpYHtU6ZHs7w57zGU42f86Fs8Gga19eNY0cBPbcTHEbt6r48QZaZIv8cXr6y177I5rWBoOyP24Xb1IOJwnExY1m0QNo0BZHzp3XmO4qt2n8zCoM3/y35qoSWW1b0lOhXONAVQp53uQgNjVuMLUduk5nhrVdg4rHnWs/Z5fDs3iUOjj858yrpJ973rMF5VLM34lUcfGpt8TLUmU3xO5lM6u+hAc34yz5XlcYzemDiEJ46avYOvCuyL1S67vTJJ3DLY8Ochufz7mDGq0pdxWWGJ+QrlzxgItYQ0vKRTYfCC66DEyxDRR1t3c8So9Zf9gsQBBmbNykjGIqOOZT+dQ3obsD4vtWjArcUzeYhmpvz7N7s8uMJjjsLCNFP/9tXppIzejszNnhVJpPxyXrxweBbpoTTO9LLQJvcgtfjDxAvLnHoNjWkF+28oKtCRb2vhHJrBLcBtEEQRwXduS47gM4Xp8P6qj5n6fkeJSCA8iVAtQ0VGLJGzM+wfQzpnAFsjja7NSzFxC1L0j5jxvXHtAJ9QuHXGqDFj2m1Y2t0F/xBJ2dGw7VBAvPrej3VGd1h0pW3CaygFCC2POQQfWGLtREbGQRvUW4knGrnCRmiRiaDgyUnHylODAYUT8f0mNAJBe0l1V60xUqpADtt7eLXbCggJY5EMK59AOuGNaK05HulgjvijwKKfZ+h9J6fD0n+seGRtSJs6e0MRKLC9rq4FqiDqGhht7hXW3jZs79hFPQ7jUsL0x",
},58348,2064,3041895001,548319051},
[15] = {{
"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",
},31119,1517,2625219187,2500633706},
[8] = {{
"0aHKeKqKIwkY4G00WvwTxSphKPY8BSgJYIhA3eLF5aHjy2OLec4lu/VMQHByHVKA+nSogvirPBO73HUxoQN+ukEwXVMC2Ttl8oFCCB+cZAwbUuzYK442sDalP6HbJ63FTwedsIoiHRiCgUT3S1dbWkTKw0Yif7DkYIITDaZSmYgNn376czPQyf282JcncI9uGseWx6+1QfZV7Mku4twFvCgFhGW8x7EnSH//jOz5pMh2XvwFwRONyVbTc+Q/nbRXrTAODGXPh3V6HkFyf9g1u6dOK46GaDQEp0UFPLvJAHLLzjvaWbvts+PNwhikqpgUCDdKHp47aZwt6JyYU33ihWHqGne3HFJ+OC+fNtVRJGIbItDJAIqIfKKbn/e3iwQOz+BYw8wiip1WioExD2uLOwasNTcQbWkTDECFgyQl6FB5R5wlOqaP7YfXqTwqrFV0s3h73yPPNR2ocYJhWj4MBkHGUDPbz42Z01/kOiIJIuGRRn5tVauZxWX22NvPcqdCIG4VWEGdXd1C+JadgUtlAgWTKVuk+FT1EDZK3FX5H4Q97jWKspTN/j+BXeoPnh1BqqYHXkyullp9f9fH",
},46,444,3169631154,2254752069},
[31] = {{
"RC0k6gm8fdExQzCNW1oPwYMcLRNCLfSqGHcHvocN+KZf6699o0r25Nmgzgb+VyofEWwlhuo17uhBM5t/LkS7WxPDMH055z6ibQvTPtf4OvO/9WCZ/hpKrXkRG++3jz4ohCAj3GAYGcI6CyhG319S5AKdIxmPXoaKcjNkeP9CG3l6WSEwgo1JQUgEtiBmu4OZw8+gvkxthkT6sW+vx4xn585yL/Xd3Duu9GuYzm1k2QQgE18P3dX+V23phcU54MMQw6w3cBXw+fzrsqwX2j8V6F3IG/baTguppaKLzg1qDW3k5roz1BOBuTQ4Cer2r2vdonZhHD6+QTx7xqcFoeU2PBs2qXvTscr4JMkJKdjEbsvP6xRPdRtkjPPW0JxOIlEj0YrcrM/FC/ah2+9s+G0MK+5+Jf9+z0fV+pAXgSkXGZoqZDBzrHFFx8YKZ5Jg8PNeUs40bL4FV5PFBCdhn9S5MsNUPTNyIOUZVTLSZiz2C3CW76AEe4/TvD4HYu7iFAbZbYo/E2b1C6zrndyTtGZEwsLTSUqmh8XLbfSMl73Tnl5hcE4DbZVcpwYrQQ1GXMxFhonGDWbaPya8xuOl/PGqXTnI4wDkmgCWaTZ3d4vsTTnRsHumxQkPY4nxKRVZ+wxXH6pFIwk2vYJMduU2LWiG1YAPnZV/nmZggDzrfCHuVNaDr4WjGjGMarGBLRl8pa9N6fLtl0rPDMx10CCnIammiyEaTqTHS9gkuI4hIw+R5kekEva2x6PY/we6txZc+pH6XqsNoqdULaAJDcrvGNA21u6rq3mA9S9e13isY/7AC9ZnesEteUe5aAJUQzpKiAGwP6P1c7uabprbQd1XqExqbMsd3MhtVSd3X12vbk2DpEmRgntVhMt/PbzvxGzEEuVn1QlRHwdMc/LnHJbRzeE9V5Y/AkVsS7UhHCobuIKfcL6soo/F6vYouazeskyUlqtkuXhocVxaqJ7Yctug4oGs0Siixl8gAmT7wuBvotpIhTw1UuJC5zRv1N/weTYz/+v+bYpNVh",
},26548,772,2441691858,1325166241},
[35] = {{
"EfGkUQYOQJzG4XKWi7lDZ+hiHPUPLEAcxx9fv+jC3ndDCtuFrb2/4mbk2Ii1Z6ikPjxoJyodfZpFLF/Fj774GyC1KF8nUx7RkzZH3ZBGilI5o5yR3qnXeKofco8wp1ska0fguZhcgvBFJCfwAeSRIVBPQ4wgYklarmqsOg76Pv4Rph9b/2WbQVyuqTTYhRq+piImATAVFWst+TGuPFTdAGZhRGsIRwXlGXesu7E7nCthjyHXYeI5Ad0/a/ch6SYTOrSC63B8EZaGdU7sXbgI7rFQtU/dbry+76Q8RnuTpGebj0wYarOZ7S5K",
},50821,234,806902574,503830326},
[55] = {{
"MsqN4esSCW4mD0gz+8IKAGjmoAYYtQ57x5athcZSjBVjS5WISWQD+sPyeDD0N0gMbofU8SZdpREZJ8dkPIQ7iFu/dynnuh/ZskX0kuB4XKn5/ABGWVJKC7CPUkNW0SQHAi3XJ2xO105SHCEsDEX043FLC6BgkwhFsQgdLYRgb3DJabk204AUgmUTOtsU+Z4XeDydnCgNEDA/9fMdxq9yMd6H3FScKn2u/Gd8mEiK1XKOr9w35r06ROdcKUOMkOed3UI6jySmrBbTbyeVgN4BtGuUr07TunAzCfghf8VS2fshETzFUDqSngn97+zhqza5XQNi8bHRy1fP/3IRv+JjoEbKm0PJshgkXAw0jbd03b9PSmMG7+waZ2VAROYok5dJe+XMlgQI2jqi8ZHdEmiG6w6kOxf9St+mB2KPNX7abQrS7y+BYisUliMMXvvXQqTj8/+1Qq/U7lIU4Ay/lHlEquDwN4xTcrTnw48Br35694dNYKP3WKDK0ga2lmfetiry5GF8edvIM+i2SIAcv1B6jbGI/iKQu5BfkZwPOpTWJfg70VOmBGf4CVBfj1y9mNU+g7+ACnS/auoTgz5HTXZ1P08a1qpJAeUD684YDNuPrP3GfoVS8mGIuLfO8ijPcSueR+aJVEXVNVbtijFnlvlNGk6Gh67aEZl2GiZgmxIg2F/3gqHAnJE92s554AXGug",
},61459,526,2840127153,928731044},
[54] = {{
"p8XqTlz10tRbkdnW5VAi+aZqU9X8evpte60gEvpbR1NPy0k5qF8EQRfuB0Ly5eiXFaur3F/OjnKxdLcq/KrJ/iR+l2tExG9oioACyMT3fvsNmO03bEFM1DC0TnmU/cgJ4t5ENA25l9DhDNcaQstbSEK+e0hY3S/rItbb8GfrANCLZFSA3TfA0AQe49G2+nGR3k82bqae0pKjOrrZbV7w2YkSsw0RtmZzbvFmF0I/0+0VXkuQ9n3YWoZnb3lVlkgfF8KH",
},11191,195,2091994077,3304902749},
[20] = {{
"J2HvyG6oQlmx5CbRSiOdf+sL7C7BHdVRW4oDraeyOWdXDGDwDwHtvaFwSsbXWdLH9MNJ0VPUYRORJCdLUqAl+43TrWexH9EAngl",
},2290,74,4258863870,3892536928},
[23] = {{
"+gxOQ3qnp+zFh0ydSQCkLZx4jcMVu3Iadx5thw8vnP4pxXK7FW9V9m0a1v8xLm6+dhva62BTltXYgZVFyY2TYK9203WuaY8eFPxjZY9wdzcYti0BFckr465UQ4PzH1v8xwds/6VgY2M6hyCVAwgpjYFL1rsVSmqqNyEJiFkq+nUUDXA4IuZ4muSq0oBJnkhtw+Xkxk5H4BffSjhPHSvpb2yntsUvijGQTePECnAnI279nmWvYarb7OLKDSOKhM1xXTIe1IFSu+c53UEIp5Yhopk8ZcLd7gBdmPYMvpP4xWhAeJF/2lOMUdW9tNsVctB5C3DywHJOxTgVm6IONLyxAhbJBN9jx55/xr8e7Q7g8AZ08fa9Whlp780V/vmvw7DOlfXem8hcrA1ihTtzsuWIy0NNSW46y4Cr4XghCm2zqLh8u0m/X8SuJ5rCzrT6ijJCAULEG5z+md2bW4VqmuE7KT3DwuOFgPj8t5USELoCGcSUbyfoh+ZvM8fxMysc/4R40i67UtUPDLcup29ZROLMSqAXir3ggZ3aDX6fxpqOm6il1EJNGIjvBY9VmTqgqUUVWOnn84Dhfifd4oIvZk4D9TsFAYb/egcgtO5EXYmFNh/LdA4DEs76EZ+uzY811CzsyVQS",
},56811,483,314625784,1202645701},
[37] = {{
"VgldePIqatMq7MqmthG3eRAZgu+2hc2DKJms6aZ/NL1xduWiujynODpPtldmK3m68+gCrxiD4y+4ZykJgHbiezA6MVlEUhxaxJvnGkXmvnBHQvDD5kWhZD3w7QBK26PAu1M2RLqsNSgDdB9PppWK40V2rI+ag77+YeC15xls0D5modldoPZB9zQ5DzmSrqS+3UaYdTU9VjPo+kXGy4YXZh",
},12596,160,1346125926,459571583},
[13] = {{
"jX6Gy5+Fyfda5w4X1H7UuakF9epIXaVjVMh+gBxWtnHTfhVsRHo0pyggim4q9dukQO9HBCyRiB0kygR8no7gASodoz+FQX6eFmKr8+8MnjA7dE1dCXqPtoHf2IbtENxHoc5Vo1gTzs8sxO",
},4514,106,3006081287,126305137},
[3] = {{
"y9VLd4hujdhFR86r4lgb/ByfO1X7qyNdBKjW6eXeHZ+WJKHVo37vuYUXCo+2o4639lD8Ijxby4C3TCirTLuviWMfGrVwW1ruXpXKUWH2hYyZJkDjwG7VkiTWIMP56P+sRFJWRM6vat3cDaxCV7nj6TeKvqznKjjU/fpkV1TNRNmEOXYP4APM+MvmHM1JC8mS07v2WikJHA0g4Ci93SgOIqh526nbLQ59VQer1DNHwAFQege49pZC1zuDWHpoEpV9lsCZIYHW4QZbca5t7NC9OVf6Ka4frAGlRmoX6f1xgBf5UEX3pOdrVn1Wms0iZKxPMN5/AtuuUIwMbuM82THO5IJdx2FmHyAPqMq+pPqdyZeB9HUsTJ0jBwx9tsW4g6gcLvqaNwZkbr9lkXeuDKzrTdKJbzxFp8BUdW5z2kIGYoIlzpOlOuXT+h",
},61641,328,141591837,108629187},
[11] = {{
"1C+Gdamt/O4SVvYMyZWshQQsr01JxBTi5xrqPWVV8zEYsu0+vCwJMOE4TkdIoBHpzdRGLWYanOzMIX3pblK49ltGgkyAaWl/KfxgpAFaxoQM0sTgsWYqyjg//ptvhHzLuodgDo9I0OXKzwxpLdgWoB+zv5ZaiyX9/RUkaHaLI5x0fgaO2rMH2bxbGdsY3+lE4de0kzwM",
},19247,150,727725377,1092735737},
[57] = {{
"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",
},34103,3577,3133361559,251796585},
[56] = {{
"lFRiodZHbtoPWc7Vy5Nv6orUsvYgnSyElyHW6sp/vpC2QqfMF9r7O0RvkcUxpn0bZ9NsUEwV2g3TG4aqU4joesH3NbcJVhwO1V174N00p8U9cLfEVxPo95Ox9GXEYXxFvpKiNP0tidY",
},6733,104,3633260418,3522840544},
[27] = {{
"JtH+biDScCdN4c1dCOeHaI6GCwwps5qGk7lxhtBiBCgvweMZJzgvDx+6Cy5/vS7gej0ty5cA7GiYHi4u3GN5ZyHBygMdQa2PyaqQ0R+E9MbbrVaXWt36v8o245+xK8QlCajC4wLtylKVubADYmNjDRbcTG3beYLo17FPhZFNGBGRDBN0td+eD2Lt0xB0OzDF90ZcFA0Mg+ULfAYyvEk7lm0KLXmEpPomHOszQDpCDQv3dVm9U13LLXN3mcTQXtBgNO3ysF7xXw1IcPj2o1IzM38wM6PDwgzuENFlTLNy6sqXNeQwfyYDHa+kGyYkDqQtgj67aZyqsANbRoC2J+VYbcdTjAKwu0w3HNNcy8uVe5WHfjFysnTB4ZXqE7314kUQyhgIjQ32IUJaOuvi3BHntNHgQ0hKRfhr9lFwgslzcfMPC0Rl47cpdFAtt53NiVHO9jc0xqPZ+4tuOICeLSpfS/OrYrXSe1j9EPCM15x5VdnJ6eV/aItKIL+mnZ5HXONyuPrP5++hlrNUg5+5RUcZGpH/EyLW879IH5+FQxbthqjIx4nnvTxI8H1qEJxbc9rxvDwdBxPMN94iK/EWf2W7uHGVDnmmumEyQdsPHHdjyVJUBFbcWgnMoxUh6SI/i54BWO3E2VIwlCcTzXoU/likovp7u/y7DdvyU6TlL9u46g9L5hSErF1sGDKqJwjE28fFIsOIg9sPQwXfzR+xnZZL8/R5s9HPKF+LpcB669AYEFVz3baisOcB5U/p/+EIFXh3Stm0S0NpsJv2+wq4Gbfoi48NwIsbeJHtQiQG2qjiQNOATVcRg9XMmHNNVegnEif7uFW0qjQFRD4flec/LUTbawaPn3mtc8flDZIrjzOrUjO0twl+CW8CslEDcNiavDL5rGf+TkLp",
},44114,678,2393511599,2768129999},
[48] = {{
"Q0JAOPGeyBlWMl4RqUCqawV7lBsUSHGPTs1cub5EZwc9ZzTWfKN83DD4UwbTlhhvHpesAMtje4NVhpl6LeNkCPhsQ0pf/r/QYR7Az3DFVyZ+w3Nu3cckKtKhpcrelEsGXPf1LPsFd0ZEcqCZ1GUozrU19aR5Tg",
},16719,118,3998034902,4040009078},
[34] = {{
"rToD1Pdu3h1XiWDCNGVe77fYyxWwYbScnwzsW/nDvTDQ2x6x9AHa+KeqjWCVzJV0VDl+CNPNbZubZJZC22r7D+9CBGeKbsmgFYc+ILQv6oHP1TaEr/XRNEMQKHnQVFmlr/9xfBF9kCHP3EJ0YLQ53hBmz4xT/y3e0ya8RVa5VeqgzkEH6uMp/htJxZW/JiZPSh8uVQ1zD+jweSL62ljONnqunVS3JTDq8Zd5D5Ul3dDUkZQKN05bMQj9k5m7dv2+r/gXPomailqFCL6ET5zrDYoYspU3cA8s9XYL0o0e8zxPnjdlaseAnlvUT4w7XTIyhFvypFEJDzRloOWmMuvbahyYiEy615Uxf/JHUh6+LMBoOvYQSCvFhr8F3V+18BoW151RgfhnNLk9L7LNVBjPHTUZ9tKYm20mQFeHo0Nsl3Xu6p8UZTX1XyV05HjIQR/7lTm+L/ubNHSzZTyYpiWRGgLEpf2q7suwRXVg741L+ocB6Sz7hJTtvZPmsq9tVWZBdM9vgpCRRVsXASNYhhsCT5mnXSuaMz2vL+t9+C/tYEvQFlnJXrJuvxbSzmmiyIWEbP+CjnEM7HvVyzHUnyfcngx6aOhDFReEGUBvivy4tFzcwCqlErh+ZcxiZIdv0OA2ksdzyVrgIBSuxa3jxIVZDh21HOgAhR91UOjR2wFcLK188keIQXpcxUhWWmBaD0fzSfy1IHP2ZVsf7XGLX44VoUZ+L9tij9saec+k0LBjsVrdqr4evf8b/fPrlqXP+uRfZ58Yybtj+ZWlT/IAfdXhIaXX77kxGSGW5HmTe8B1BoG4iRs4pWcdijUO/E58hz/k+eImH5eMNCv7cQEkssTXtxigKsTYkPxEqWBKFsffuQcdHPGUKbvL",
},3957,663,576526339,2220531505},
[49] = {{
"4MOTkNKoOdZeLWGFhJayR6gu7mFTGUvm7AJAH01yYWPCIm/JaV4JTYOwT1tS7Rb8hvA23AfdI0Ek4GYQEgw3NReVQ4cWfFlMVuDVTk7JdeAWneZ5TH+0MihywH89L/fLzET8zqr7U079pXEgavjT43w/2yjf/0xFCvt71bL1mJ6Y4zEXGbXzuwnfax/D7XpI0efZOKgPrTBomlFl/xBBIfSc8jOkFG8QjZU9zp/tXsFaQqiEZh",
},17021,181,2913094021,3208785330},
[42] = {{
"xlbzPrvilffAh8rXenTzSabR2nX2KraGDoH0/4icIFavnUOW7hFsIrxlQNbokTBBwaEol07xUW5ViY892sxyIN8zRxK3rW5HqJcscQKrL99zi5oATRwUEh9tGOOXDhaK0rrnbN17zu8XqKoStEYuRPB6kG0qpnBYSeqC1eH3/Tu/Z3v9as7q0FaCUNjV4CyNb3d0fokP2FQ5FGyHCgFuJW99cJnZ2KOeqgH+suBb4zvPXpERrejpGv6EbFJ/mueI5CYd1zodGvshCQtYuYduBTntM/RE",
},17421,213,545642,3508153780},
[24] = {{
"zMWBmcPQPJV0KQD2G4yi5MPnJFB6NWUTWbNpNKCHJT1gfOeRGEHbiIItd47ek+TgFWk4NvNYdoLVDoSE38d3p9VhQVlNbegSQfcG1L5fojJ88hayDyN3s74/ftiX73wPt5wNeetgE6Yiq/B4mIaj+oyZ/eDjVvTNK9mSWImKu3KRvoad2ej7mRovLHleXkjDjp638tvFeNImkMwvOmLr/V0k94eEAMVrcDFLFfPiW0g4m+22+SHbcZ9V6XfJyA8KvE+YSYL+yEll+hqV3e3bDjywwsHc6uSclmy6uKoyfiFSiFnvDFJcWpOddpPmVVhvr24g1Tk4Yz2VSvRJFFSBQg9EjxQYq/6jNrYVfhhAXTaHoQlaor7ckDA8uzT5uKZDkWBi34SEFehnBIfYHG3iTzBZfTCAzsFX5SIzWJa0KwfaCJii8ocyF8gfGYjVPNbv8WU8ouecEdzj22K2fGovGh",
},38238,352,2092731545,357000603},
[61] = {{
"F+2ptVfhIjWkIhP9ep6A0uQ3Y3hdh+b+atONlvez2u7o2lUlgV2OscFw7LRtM9vfoEQwxy0+na29LKQpV4CIbbzvvPfo4hVasCC5VNYVzCjBRll3OahavmfZ0A6Vcd7XyXH7Ql7gGCjC2bdDgtkCQ5Xe6AFXNDoGPITpXGYFmHt115fMd9Rdy6jN2U2VWKZgJMfryVD8+IEEohqhlG1lejj/3hLk1SV85GbEwyS8WSjxxlQT16rt4JNNoEOHb4ngzUIN7109FDV1sXW89WgV9jEZE7YAvCxD4dfY/3MaYeWq3E8Bxuq7v1+G3w2qc2HcpnYHjyT40CWy4vFDCwCKTS/GXucfipM33zLLKX3GanPSizcKB75UFBV+EtokGuwQ0Lp3db678XYIWQFdMRjYr1rKGO3h9v0ItveNcrPHpLKktQzfSAuOEd2CIu+3+TVeEaPewOkH7wPeQoQ4vGBSB7Sd4u29pF+isfnqRkH/GmeiUckN1ZU6Q1kUPh+OyEFbfIfx7GXstCd2hOgYF1UzmqA1BxIbDp",
},41293,406,3758206219,1848439574},
[52] = {{
"CyiRhTgnSZyYYRj+eEbR7eX5pnlTetrTERV+ImOIVFXqjG6DevP7sOfI6p0pzTJoYjPAp6yEbjf2BNAimzwIh8t5HeHqY7rjMBEwFWw0x9N9pU+quYJp75EpW6AvRtJigL2LYaeOQHCvDOADIU+Ws4ANjstfCd0tYu8/HLSyu8gnh/FRSJr6w+PERaebIcpH7HVZzRp4l0cPUH4GsZjWhuS2X3oEz31b1de+vMuueMuuvE0MUd9Xjb8Jfcvfp8nq4+h63H+Fv0z2s29VTIn5a2PunejMpImiv0t+lghVoVnKwAeIU64Vul86UHYJKHpDJCZBy83SxA52Tjx36AjR8ESiPH4YxLtWFdzyyiCwP64+iCjzBTTbOCgXy9PegxH7mLQr9WSMIeHFL69JwxgvtTHKo9idZvMCI4EG2RqyRbNPWaPC0q/mVTzLDO",
},10916,331,1487638650,359512126},
[32] = {{
"sv5KLOhZ2FxLvlxUdZmwUBqqSodInDD8t3wuFxYoteg+1dBvQt+GonnCjJYS68Qbi2OoNK4aK/ZSqX6JkaPevbxM+WanSLjSWyRcipYxAZqv5SJyXSIi69o19+qPTAsxn2qBXEUxt0Kx+s7totdA47io6Y8lmjxyd4hsg3faUlZBQN+2thvqBSvS/Ep70qEAMwjgs7jT+6DEGvcZ0+vcPyQyFGGflMwXV7njovuhQdguTRuoI+6Yua+qUg",
},21421,187,878593002,4133862065},
[40] = {{
"L6yiChYtA0OAeKUh+0kpegnnRo73kaR6rkkgtyLnVZg12dllH4+dXh2vUFbTsWZG8O+/TGMLeU8QfdvasWvrsXh/fOpUrnmFfWk8M1FV6ssWA74hJ/NXcyz8nIszBJve+RC1nggkKEn2OHk4yMbmq98BWsXyAAS7rAoaUhfUJ4971V2bJHg83gd03+0pm34HcuOQ3YRRC/bAl54W2qWe1N3Cf9B6EW3rccBK8NLye41xEnYvAzvc4CFwnaCjiReolvuE72yZFWEu6LUUFSmHldU7cgffOwWkanZM9vrrsIu4vjUUmtaTRzies9rMtA5qNLSDcX26Nh4Ey79Klq5Du3ePT03ILbTbwBnBne15wrOpJ0XreIxqFcnYFYrF7fnN4xUJcNIQQV3dLSZ8fSbB1/iFPL73TNeTr9hCDtGDIAOd2rJc+x4sMGYPQoFjOUnZKrV0czaTjaXRh7TFXVze1Hic1JlGXFIvOwYLFnDx3lPW1ZiywdoSTo9c2Eijr9A1y4c/jTMFDVeZJiwGhSPhKVoyxRWsxOkPFgAiXWt0sEwTuCB2uQQoN8A/BT0W6CkrQiapmhEH7jBoUyDPMHt1RxXFnaS8cH0s2omaWKsNNYiKcCmxyK2+1/f4G0U2jDtsrzcdViAdlxY/C6cPocXGi3y+v9K08FC8EDM1zcQeAPmTeC+wYT3MQIhTFx+mjfcDmKhH2kbARdGMi2nn2SZ3nTL/R3JqVo6qsGqqlh6xD8efj+ue7KcCPFApcKcvnMCohaXONrXBql1SwfCtXAmL8fQ3Jrh0q5VobDWNVkhb6IEW9guAWa7+qLNr/1A7FuYrnHJ3ooDpB46SPADLxKr1GIrActkvGCOJWBw8URHUMG45wKe9O6UT2Jkb6HfjDDNeUEYnHtlPaBSm/Dp0p7HwRnqPiajweAJ9GPDmQUtBySzGIcKUX8iCmadIG+EVs2XjeHxc/S3F92e9pj6qf3pDq31uqtegbFOkJdEHuCLr9D2dwXtEZDle/e5sXJjsDekVW2IcaB5ukFS932uM+BXn9E+flGo8z6muplmOq6TAhZ9nY1F+2DzBLlm+YIdAC592G6Id1p4rmGM06lofi3lIuHOvj71UjCZCwIguBDIrU295zqjwEs48j65gH5fId5z1hpgQVQOgQCYChewg9kwX8oh15TGLg/4QaqLJNASsWFSY25NQSEFXrzAnK6OITFlhyjZcI8nRRDSvgJwHyCAGe/61M1sI1P4IFA7WFNePSyLOQCxBWYkxg8CHn8t/2qhV1KeWPncbi8r9DalhZKtStW+LHWURTJ/03nWZg5FwLpEgmCpRl73gJ2O4Vxq8xr2RIwJ9sPPQFu2bYePvfaxHExxC7d8bdYtFUNPaU4P09GNKTKcwIbZaQChjEu3aa1bk09VJRoZ0HnYHHD3TqAqblrK4nqMPrx4HNOSVILAkL6iRboTYf36ff8GwnVZHvMo5jBBBwbMO2WuazNf9k8tJocPpHu36GBZ1mWSA5tEinG6B8iX/P46Ox6982rCMDwSgbtwS770l/5QLujYkIC5KsYLW9mNV66KA9ojFvArk4cbyYUFwtItF3idLQkTdV1TYF7Vx8UuktLFa1/49RMxGQdsDo9VodmvfUqALc3jZga1uOOIicTfKTw27KBUMhjHhl3w6jxWhhdZoXDumT6HIP4brhZ2xMPETrpdbC5jb8sz3nxWgLdS35poT17BkKIRQaE03SnX+gZQA0Yy6la/F8gbDbPE43rfWuyKnP6T/Qu3Z0aM2lAikyF6f3V2jOTFTrFZ6eWiNtSpyVfp5CJWnYfBYBMLsRHhYi910k+TvuD0hmWUzKkiVI5VD5yHPq0+Evx3tOssvhLKpUwWnFGOtObNirGukogp71y8e61aPhi5F6JSw6sP9Zog",
},540,1433,1458996496,2918851496},
[2] = {{
"7+ONWUjO9Pus6VfR3yHpGghzlMgZ7gDJAWQrQsAiLLqoW80Q9bf49sLw2aM7PUmikLLKfYjCKnlu6Jb98wrFlrpdGI5jjuRZW7bjX0i8AcWtWeLiCLGpZRN1Iw8Q/gK8+Fniam7AxTZbBJOgPp3WiaR7uZscY3KM0GLTrmIhSthYn9t6dxpF3Gwbt4gvjqOOXpnYyp18rlXM+IRAc6uF+HFzEfC4fMn7HpvbdaxjVpdAnURkNDB+GbPgWNVv0aTVnCGw37xdk6rwWL+NqH/SdjbeCr01QDSENwH/ucXC5PbFmeCrbTqhND9e/qsC2NG7cpgH5T25hHjVY2YFeIDwBMg",
},38601,257,981235402,2580127929},
}
                            
                                                                               
local function _hief(_iief, _jief)
    local _kief, _lief = 0, 1
    for _mief = _jief, _jief + 4 do
        local _nief = buffer.readu8(_iief, _mief)
        _kief += _nief % 128 * _lief
        if _nief < 128 then
            assert(_kief <= 4294967295, _yldf[40])
            return _kief, _mief + 1
        end
        _lief *= 128
    end
    error(_yldf[41])
end

local function _oief(_pief)
    return if _pief % 2 == 0 then _pief / 2 else -(_pief + 1) / 2
end

local function _qief(_rief, _sief, _tief, _uief, _vief)
    assert(_vief <= 8, _yldf[42])
    local _wief
    _wief, _sief = _hief(_rief, _sief)
    if _wief == 0 then return nil, _sief
    elseif _wief == 1 then return false, _sief
    elseif _wief == 2 then return true, _sief
    elseif _wief == 3 then
        local _xief, _yief = _hief(_rief, _sief)
        return _oief(_xief), _yief
    elseif _wief == 4 then
        return buffer.readf64(_rief, _sief), _sief + 8
    elseif _wief == 5 then
        local _zief
        _zief, _sief = _hief(_rief, _sief)
        return buffer.readstring(_rief, _sief, _zief), _sief + _zief
    elseif _wief == 7 then
        local _ajef
        _ajef, _sief = _hief(_rief, _sief)
        assert(_ajef <= buffer.len(_rief) - _sief, _yldf[43])
        local _bjef = table.create(_ajef)
        for _cjef = 1, _ajef do
            _bjef[_cjef], _sief = _qief(_rief, _sief, _tief, _uief, _vief + 1)
        end
        return _bjef, _sief
    elseif _wief == 8 then
        local _djef, _ejef = buffer.readf64(_rief, _sief), buffer.readf64(_rief, _sief + 8)
        local _fjef, _gjef = buffer.readf64(_rief, _sief + 16), buffer.readf64(_rief, _sief + 24)
        if _uief then
            local _hjef = {_djef,_ejef,_fjef,_gjef}
            _uief[_hjef] = true
            return _hjef, _sief + 32
        end
        if _tief.vectorSize == 4 then return _tief.vectorCtor(_djef,_ejef,_fjef,_gjef), _sief + 32 end
        return _tief.vectorCtor(_djef,_ejef,_fjef), _sief + 32
    elseif _wief == 9 then
        assert(integer and integer.fromstring, _yldf[44])
        local _ijef, _jjef = _qief(_rief, _sief, _tief, _uief, _vief + 1)
        return integer.fromstring(_ijef, 10), _jjef
    end
    error(_yldf[45])
end

local function _kjef(_ljef, _mjef, _njef, _ojef, _pjef, _qjef)
    local _rjef, _sjef = buffer.len(_ljef), 0
    local function _tjef()
        local _ujef
        _ujef, _sjef = _hief(_ljef, _sjef)
        return _ujef
    end
    local function _vjef()
        local _wjef = _tjef()
        assert(_wjef > 0 and _wjef <= _rjef - _sjef, _yldf[46])
        local _xjef = {_sjef, _wjef}
        _sjef += _wjef
        return _xjef
    end
    local _yjef, _zjef, _akef, _bkef = _tjef(), _tjef(), _tjef(), _tjef()
    assert(_yjef <= 255 and _zjef <= _yjef and _akef <= 200, _yldf[47])
    local _ckef = _tjef()
    assert(_ckef <= _rjef - _sjef, _yldf[48])
    local _dkef = table.create(_ckef)
    for _ekef = 1, _ckef do
        local _fkef = _tjef()
        assert(_fkef > 0 and _fkef <= _ojef, _yldf[49])
        _dkef[_ekef] = _fkef
    end
    local _gkef = _tjef()
    assert(_gkef <= (_rjef - _sjef) / 2, _yldf[50])
    local _hkef = table.create(_gkef)
    for _ikef = 1, _gkef do _hkef[_ikef] = _vjef() end
    local _jkef = _tjef()
    assert(_jkef <= (_rjef - _sjef) / 3 and _jkef <= _bkef and _bkef <= _jkef * 4,
        _yldf[51])
    local _kkef = _imdf(12, _emdf(_mjef, 0, 2))
    local _lkef = table.create(_bkef)
    local _mkef = {}
    local _nkef = {
        __index = function(_okef, _pkef)
            if _pkef == _fndf[13] then return _zldf(_okef[_fndf[15]], _okef[_fndf[16]]) end
            local _qkef = _mkef[_okef]
            if not _qkef or not _qkef.fields[_pkef] then return nil end
            local _rkef = _rmdf(_ljef, _qkef[1], _qkef[2], _qkef.key, false)
            local _skef = _qkef.literalStart
            for _tkef, _ukef in _qkef.order do
                local _vkef
                _vkef, _skef = _qief(_rkef, _skef, _pjef, _qjef, 0)
                if _ukef == _pkef then
                    if _ukef == _qkef.order[#_qkef.order] then
                        assert(_skef == _qkef[2], _yldf[52])
                    end
                    return _vkef
                end
            end
        end,
    }
    for _wkef = 1, _jkef do
        local _xkef = _tjef()
        assert(_xkef > 0 and _xkef <= _bkef and not _lkef[_xkef], _yldf[53])
        local _ykef = _vjef()
        _ykef.key = _emdf(_mjef, _xkef, 2)
        local _zkef = _rmdf(_ljef, _ykef[1], _ykef[2], _ykef.key, false)
        local _alef, _blef = _hief(_zkef, 0)
        local _clef = _emdf(_mjef, _xkef, 5) % 512
        local _dlef = _alef % 512
        assert(_alef < 2097152, _yldf[54])
        local _elef = {[_fndf[15]]=_dlef, [_fndf[16]]=_clef, [_fndf[14]]=_yldf[55]}
        local _flef = math.floor(_alef / 512)
        local _glef, _hlef
        for _ilef = 1, #_kkef do
            local _jlef = _kkef[(_ilef + _xkef - 1) % #_kkef + 1]
            if not bit32.btest(_flef, 2 ^ (_jlef - 1)) then continue end
            local _klef = _fndf[_jlef]
            if _pmdf(_jlef) then
                local _llef
                _llef, _blef = _hief(_zkef, _blef)
                _elef[_klef] = if _jlef == 4 or _jlef == 5 then _oief(_llef) else _llef
            else
                if not _glef then _glef, _hlef = {}, {} end
                _glef[_klef] = true
                _hlef[#_hlef + 1] = _klef
            end
        end
        if _glef then
            assert(_blef < _ykef[2], _yldf[56])
            _ykef.literalStart, _ykef.fields, _ykef.order = _blef, _glef, _hlef
            _mkef[_elef] = _ykef
        else
            assert(_blef == _ykef[2], _yldf[52])
        end
        _lkef[_xkef] = setmetatable(_elef, _nkef)
    end
    assert(_sjef == _rjef and _lkef[1], _yldf[57])

    local _mlef = setmetatable({}, {
        __index = function(_nlef, _olef)
            local _plef = _hkef[_olef]
            if not _plef then return nil end
            local _qlef = _rmdf(_ljef, _plef[1], _plef[2], _emdf(_mjef, _olef, 1), false)
            local _rlef, _slef = _qief(_qlef, 0, _pjef, _qjef, 0)
            assert(_slef == _plef[2], _yldf[58])
            return _rlef
        end,
    })
    return {
        maxstacksize=_yjef, numparams=_zjef, nups=_akef, sizecode=_bkef,
        sizek=_gkef, code=_lkef, k=_mlef, protos=_dkef, debugcode={},
        debugname=_yldf[59], bytecodeid=_njef - 1, lineinfoenabled=false,
        flowKey=_emdf(_mjef, _njef, 4),
    }
end

local _tlef = _gndf.luau_newsettings()
_tlef.errorHandling = false
if type(Vector3) == _yldf[1] and type(Vector3.new) == _yldf[2] then
    _tlef.vectorCtor = Vector3.new
elseif type(vector) == _yldf[1] and type(vector.create) == _yldf[2] then
    _tlef.vectorCtor = vector.create
end

local _tmef = type
_tlef.useNativeNamecall = true
_tlef.namecallHandler = function(_umef, _vmef, ...)
    if _tmef(_vmef) == _yldf[60] then
        local _h_ok, _h_1, _h_2, _h_3, _h_4 = _MS_GUARD.invoke(_vmef, _umef, ...)
        if _h_ok then return true, _h_1, _h_2, _h_3, _h_4 end
    end
    return false
end
local _xmef = 71
local _ymef = 71

local function _zmef(_anef, _bnef)
    local _cnef = _gief[_anef]
    assert(_cnef and _cnef[3] <= 16777216, _yldf[61])
    local _dnef = _mhef(_cnef[1], _cnef[2], _cnef[3], _cnef[4])
    return _kjef(_dnef, _cnef[5], _anef, _xmef, _tlef, _bnef)
end
local _enef = setmetatable({}, {
    __index = function(_fnef, _gnef)
        assert(type(_gnef) == _yldf[4] and _gnef >= 1 and _gnef <= _xmef, _yldf[62])
        local _hnef = _zmef(_gnef)
        rawset(_fnef, _gnef, _hnef)
        _gief[_gnef] = nil
        return _hnef
    end,
})
local _inef = {protoList = _enef, mainProto = _enef[_ymef]}
local _jnef = _gndf.luau_load(_inef, getfenv(1), _tlef)
local _pack, _unpack = table.pack, table.unpack
local _results = _pack(_jnef(...))
_MS_GUARD.wipe(_inef.mainProto)
return _unpack(_results, 1, _results.n)

