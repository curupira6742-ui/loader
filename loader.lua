                                                                            
                                                                          
                                                                                      
                                                                           
    
                                            
                                                                                         
                                                                  
                                                                                  
                                                                  
                                                                                      
                                                                                   
                                                                                 
                                                                                   
                                                                                         
                                                                                                 
                                                                                                
                                                                                       
                                                                          

local _iaed = game:GetService("Players")
local _jaed = game:GetService("HttpService")
local _kaed = game:GetService("TeleportService")
local _laed = game:GetService("RunService")
local _maed = game:GetService("UserInputService")

                                                                           
                                                  
                                                                           
local _naed = _iaed.LocalPlayer
if not _naed then
    local _oaed = os.clock()
    while not _naed and (os.clock() - _oaed) < 8 do
        _naed = _iaed.LocalPlayer
        task.wait(0.1)
    end
    if not _naed then
        local _paed, _qaed = pcall(function() return _iaed.PlayerAdded:Wait() end)
        if _paed and _qaed then _naed = _qaed end
    end
end

if not _naed or not _naed.UserId or _naed.UserId <= 0 then
    warn("[MATRIX][FATAL] Identidade do LocalPlayer invalida ou nao inicializada.")
    return
end

local _raed = tostring(_naed.UserId)
local _saed = "6.0.0"
                                                                                                
local _taed = ""
local _uaed = "https://matrix-access-staging.curupira6742.workers.dev"

                                                                              
                                                                                                  
local _vaed = {
    ["matrix-access-staging.curupira6742.workers.dev"] = true,
}

                                                                                      
                                                                                                                       
                                                                                                      
local _waed = "https://raw.githubusercontent.com/curupira6742-ui/matrix-bootstrap-v6/main"

local function _xaed(_yaed)
    if type(_yaed) ~= "string" then return nil end
    if #_yaed > 2048 then return nil end
    
                                       
    local _zaed, _abed = _yaed:match("^(https?)://(.+)$")
    if _zaed ~= "https" or not _abed then return nil end
    
                                                          
    local _bbed = _abed:match("^([^/?#]+)")
    if not _bbed or #_bbed == 0 then return nil end
    
                                                                             
    if _bbed:find("@") then return nil end
    
                                                                              
    local _cbed, _dbed = _bbed:match("^([^:]+):?(%d*)$")
    if not _cbed or #_cbed == 0 then return nil end
    if _dbed and _dbed ~= "" and _dbed ~= "443" then
        return nil
    end
    
                                                    
    if not _cbed:match("^[a-zA-Z0-9%-%._]+$") then return nil end
    if _cbed:find("%.%.") or _cbed:sub(1,1) == "." or _cbed:sub(-1,-1) == "." then return nil end

    return _cbed:lower()
end

local function _ebed(_fbed)
                                                                                                        
    if globals.__MATRIX_BOOTSTRAP_DEGRADED then
        return false, "CYCLE_PREVENTED", "Tentativa de fallback em cascata/ciclo bloqueada"
    end
                                                                                                             
    if type(_fbed) ~= "string" or _fbed == "" or _fbed == "disabled" then
        return false, "FALLBACK_NOT_CONFIGURED", "Fallback desativado ou nao configurado para este ambiente"
    end
                                                                                               
    local _gbed = _fbed:gsub("/$", "")
    local _hbed = _uaed:gsub("/$", "")
    if _gbed == _hbed then
        return false, "SELF_FALLBACK_PROHIBITED", "Fallback aponta para a propria instancia primaria (auto-referencia proibida)"
    end
                                                    
    local _ibed = _xaed(_fbed)
    if not _ibed or not _vaed[_ibed] then
        return false, "FALLBACK_HOST_UNAUTHORIZED", "Hostname de fallback (" .. tostring(_ibed) .. ") nao autorizado no pinning"
    end
    return true, nil, nil
end

                                                                           
                                                        
                                                                           
local function _jbed(_kbed)
    if type(_kbed) ~= "string" then return nil end
    local _lbed = #_kbed
                                                                                
    if _lbed > 2097152 then return nil end

    local _mbed = bit32
    local _nbed = {
        0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
        0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
        0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
        0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
        0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
        0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
        0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
        0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
    }
    local _obed = {
        0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
        0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19
    }
    local _pbed = (56 - (_lbed + 1) % 64) % 64
    local _qbed = _kbed .. string.char(0x80) .. string.rep(string.char(0), _pbed)
    
    local _rbed = _lbed * 8
    local _sbed = math.floor(_rbed / 4294967296)
    local _tbed = _rbed % 4294967296
    for _ubed = 3, 0, -1 do
        local _vbed = _mbed.band(_mbed.rshift(_sbed, _ubed * 8), 0xff)
        _qbed = _qbed .. string.char(_vbed)
    end
    for _wbed = 3, 0, -1 do
        local _xbed = _mbed.band(_mbed.rshift(_tbed, _wbed * 8), 0xff)
        _qbed = _qbed .. string.char(_xbed)
    end
    for _ybed = 1, #_qbed, 64 do
        local _zbed = {}
        for _aced = 0, 15 do
            local _bced = _ybed + _aced * 4
            local _cced, _dced, _eced, _fced = string.byte(_qbed, _bced, _bced + 3)
            _zbed[_aced + 1] = _mbed.bor(_mbed.lshift(_cced, 24), _mbed.lshift(_dced, 16), _mbed.lshift(_eced, 8), _fced)
        end
        for _gced = 17, 64 do
            local _hced = _zbed[_gced - 2]
            local _iced = _mbed.bxor(_mbed.rrotate(_hced, 17), _mbed.rrotate(_hced, 19), _mbed.rshift(_hced, 10))
            _hced = _zbed[_gced - 15]
            local _jced = _mbed.bxor(_mbed.rrotate(_hced, 7), _mbed.rrotate(_hced, 18), _mbed.rshift(_hced, 3))
            _zbed[_gced] = _mbed.band(_zbed[_gced - 16] + _jced + _zbed[_gced - 7] + _iced, 0xffffffff)
        end
        local _kced, _lced, _mced, _nced, _oced, _pced, _qced, _rced = _obed[1], _obed[2], _obed[3], _obed[4], _obed[5], _obed[6], _obed[7], _obed[8]
        for _sced = 1, 64 do
            local _tced = _mbed.bxor(_mbed.rrotate(_oced, 6), _mbed.rrotate(_oced, 11), _mbed.rrotate(_oced, 25))
            local _uced = _mbed.bxor(_mbed.band(_oced, _pced), _mbed.band(_mbed.bnot(_oced), _qced))
            local _vced = _mbed.band(_rced + _tced + _uced + _nbed[_sced] + _zbed[_sced], 0xffffffff)
            local _wced = _mbed.bxor(_mbed.rrotate(_kced, 2), _mbed.rrotate(_kced, 13), _mbed.rrotate(_kced, 22))
            local _xced = _mbed.bxor(_mbed.band(_kced, _lced), _mbed.band(_kced, _mced), _mbed.band(_lced, _mced))
            local _yced = _mbed.band(_wced + _xced, 0xffffffff)
            _rced, _qced, _pced, _oced = _qced, _pced, _oced, _mbed.band(_nced + _vced, 0xffffffff)
            _nced, _mced, _lced, _kced = _mced, _lced, _kced, _mbed.band(_vced + _yced, 0xffffffff)
        end
        _obed[1] = _mbed.band(_obed[1] + _kced, 0xffffffff)
        _obed[2] = _mbed.band(_obed[2] + _lced, 0xffffffff)
        _obed[3] = _mbed.band(_obed[3] + _mced, 0xffffffff)
        _obed[4] = _mbed.band(_obed[4] + _nced, 0xffffffff)
        _obed[5] = _mbed.band(_obed[5] + _oced, 0xffffffff)
        _obed[6] = _mbed.band(_obed[6] + _pced, 0xffffffff)
        _obed[7] = _mbed.band(_obed[7] + _qced, 0xffffffff)
        _obed[8] = _mbed.band(_obed[8] + _rced, 0xffffffff)
    end
    local _zced = {}
    for _aded = 1, 8 do
        _zced[#_zced + 1] = string.format("%08x", _obed[_aded])
    end
    return table.concat(_zced)
end

local function _bded(_cded)
    if type(_cded) ~= "string" then return nil end
    if crypt and type(crypt.hash) == "function" then
        local _dded, _eded = pcall(crypt.hash, _cded, "sha256")
        if _dded and type(_eded) == "string" and #_eded == 64 then return _eded:lower() end
    end
    if syn and syn.crypt and type(syn.crypt.hash) == "function" then
        local _fded, _gded = pcall(syn.crypt.hash, _cded, "sha256")
        if _fded and type(_gded) == "string" and #_gded == 64 then return _gded:lower() end
    end
    if crypt and type(crypt.sha256) == "function" then
        local _hded, _ided = pcall(crypt.sha256, _cded)
        if _hded and type(_ided) == "string" and #_ided == 64 then return _ided:lower() end
    end
    local _jded, _kded = pcall(_jbed, _cded)
    if _jded and type(_kded) == "string" and #_kded == 64 then
        return _kded:lower()
    end
    return nil
end
local _lded = "MATRIX_Obsidian"
local _mded   = _lded .. "/loader_v6.lua"
local _nded  = _lded .. "/session_v6_" .. _raed .. ".json"
local _oded   = _lded .. "/session_v6_backup_" .. _raed .. ".json"
local _pded  = _lded .. "/session_v6_staging_" .. _raed .. ".json"
local _qded   = _lded .. "/access_" .. _raed .. ".json"
local _rded = _lded .. "/access_backup_" .. _raed .. ".json"
local _sded   = _lded .. "/teleport_pending_v6_" .. _raed .. ".json"

local _tded = (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)
local _uded = (type(getgenv) == "function" and getgenv()) or _G
local _vded = tostring(game.JobId or "")
local _wded = _uded.__MATRIX_V6_FROM_TELEPORT_JOB == _vded
if _wded then _uded.__MATRIX_V6_FROM_TELEPORT_JOB = nil end

                                                                           
                                                                           
                                                                           
local _xded = 9007199254740991                                            

local _yded = {
    CurrentSeq = 0
}

local function _zded()
    if type(makefolder) == "function" then
        pcall(makefolder, _lded)
    end
end

local function _aeed(_beed)
    if type(readfile) ~= "function" then return nil end
    local _ceed, _deed = pcall(readfile, _beed)
    return (_ceed and type(_deed) == "string" and _deed ~= "") and _deed or nil
end

local function _eeed(_feed, _geed)
    if type(writefile) ~= "function" then return false end
    _zded()
    local _heed = pcall(writefile, _feed, _geed)
    return _heed
end

local function _ieed(_jeed)
    if type(delfile) == "function" then
        local _keed = pcall(delfile, _jeed)
        if _keed then return true end
    end
    if type(writefile) == "function" then
        return pcall(writefile, _jeed, "")
    end
    return false
end

local function _leed(_meed)
    if not _meed or type(_meed) ~= "string" or _meed:match("^%s*$") then return nil end
    local _need, _oeed = pcall(_jaed.JSONDecode, _jaed, _meed)
    return (_need and type(_oeed) == "table") and _oeed or nil
end

                                                                                        
local function _peed(_qeed)
    local _reed = 0x811c9dc5
    local _seed = 0x01000193
    for _teed = 1, #_qeed do
        local _ueed = string.byte(_qeed, _teed)
        _reed = bit32.bxor(_reed, _ueed)
        _reed = (_reed * _seed) % 4294967296
    end
    return string.format("%08x", _reed)
end

function _yded.computeChecksum(_veed)
                                                                                                  
    local _weed = tonumber(_veed.seq) or 0
    local _xeed = tonumber(_veed.savedAt) or 0
    local _yeed = string.format("%s:%s:%.0f:%d", tostring(_veed.userId), tostring(_veed.token), _weed, _xeed)
    return _peed(_yeed)
end

function _yded.validateEntry(_zeed)
    if not _zeed or type(_zeed) ~= "table" then return false end
    if tostring(_zeed.userId) ~= _raed then return false end
    if type(_zeed.token) ~= "string" or #_zeed.token ~= 68 or not _zeed.token:match("^MX6_[a-f0-9]+$") then return false end
    if type(_zeed.seq) ~= "number" or _zeed.seq < 1 or _zeed.seq > _xded or math.floor(_zeed.seq) ~= _zeed.seq then
        return false
    end
    if type(_zeed.savedAt) ~= "number" or _zeed.savedAt <= 0 then return false end
    if type(_zeed.checksum) ~= "string" or _zeed.checksum ~= _yded.computeChecksum(_zeed) then
        return false
    end
    return true
end

function _yded.readEntryFromFile(_afed)
    local _bfed = _aeed(_afed)
    if not _bfed then return nil end
    local _cfed = _leed(_bfed)
    if not _cfed or not _yded.validateEntry(_cfed) then return nil end
    return _cfed
end

                                                                             
function _yded.readCandidates()
    local _dfed = _yded.readEntryFromFile(_nded)
    local _efed = _yded.readEntryFromFile(_oded)
    local _ffed = _yded.readEntryFromFile(_pded)

    local _gfed = nil
    if _dfed and _efed then
        _gfed = (_dfed.seq >= _efed.seq) and _dfed or _efed
    else
        _gfed = _dfed or _efed
    end

    if _gfed then
        _yded.CurrentSeq = math.max(_yded.CurrentSeq, _gfed.seq)
                                                                                                 
        if not _dfed and _efed then
            pcall(function()
                _eeed(_nded, _jaed:JSONEncode(_efed))
            end)
        end
    end

    if _ffed then
        _yded.CurrentSeq = math.max(_yded.CurrentSeq, _ffed.seq)
    end

    return { primary = _gfed, staging = _ffed }
end

                                                                 
function _yded.saveStaging(_hfed, _ifed, _jfed)
    if type(_hfed) ~= "string" or #_hfed ~= 68 or not _hfed:match("^MX6_[a-f0-9]+$") then
        return false, "TOKEN_FORMAT_INVALID"
    end

    local _kfed = _yded.CurrentSeq or 0
    if _kfed < 0 or _kfed >= _xded then _kfed = 0 end
    local _lfed = _kfed + 1
    local _mfed = os.time()

    local _nfed = {
        version = 6,
        userId = _raed,
        token = _hfed,
        status = "PENDING_COMMIT",
        operationId = _jfed or nil,
        expiresAt = _ifed or os.date("!%Y-%m-%dT%H:%M:%SZ", _mfed + 30 * 86400),
        renewAfter = _mfed + (23 * 86400),
        savedAt = _mfed,
        seq = _lfed
    }
    _nfed.checksum = _yded.computeChecksum(_nfed)
    local _ofed = _jaed:JSONEncode(_nfed)

    if not _eeed(_pded, _ofed) then
        return false, "WRITE_STAGING_FAILED"
    end

    local _pfed = _yded.readEntryFromFile(_pded)
    if not _pfed or _pfed.checksum ~= _nfed.checksum then
        _ieed(_pded)
        return false, "STAGING_VERIFY_FAILED"
    end

    _yded.CurrentSeq = _lfed
    return true, _nfed
end

                                                                    
function _yded.promoteStaging(_qfed)
    local _rfed = _yded.CurrentSeq or _qfed.seq or 0
    if _rfed < 0 or _rfed >= _xded then _rfed = 0 end
    local _sfed = _rfed + 1
    local _tfed = os.time()

    local _ufed = {
        version = 6,
        userId = _qfed.userId,
        token = _qfed.token,
        status = "ACTIVE",
        expiresAt = _qfed.expiresAt,
        renewAfter = _qfed.renewAfter,
        savedAt = _tfed,
        seq = _sfed
    }
    _ufed.checksum = _yded.computeChecksum(_ufed)
    local _vfed = _jaed:JSONEncode(_ufed)

                            
    _eeed(_oded, _vfed)
                      
    if _eeed(_nded, _vfed) then
        _ieed(_pded)
        _yded.CurrentSeq = _sfed
        return true, _ufed
    end

    return false, "PROMOTE_PRIMARY_FAILED"
end

                                                                                
function _yded.saveSessionAtomic(_wfed, _xfed)
    if type(_wfed) ~= "string" or #_wfed ~= 68 or not _wfed:match("^MX6_[a-f0-9]+$") then
        return false, "TOKEN_FORMAT_INVALID"
    end

    local _yfed = _yded.CurrentSeq or 0
    if _yfed < 0 or _yfed >= _xded then _yfed = 0 end
    local _zfed = _yfed + 1
    local _aged = os.time()

    local _bged = {
        version = 6,
        userId = _raed,
        token = _wfed,
        status = "ACTIVE",
        expiresAt = _xfed or os.date("!%Y-%m-%dT%H:%M:%SZ", _aged + 30 * 86400),
        renewAfter = _aged + (23 * 86400),
        savedAt = _aged,
        seq = _zfed
    }
    _bged.checksum = _yded.computeChecksum(_bged)
    local _cged = _jaed:JSONEncode(_bged)

                             
    if not _eeed(_pded, _cged) then
        return false, "WRITE_STAGING_FAILED"
    end

                                                  
    local _dged = _yded.readEntryFromFile(_pded)
    if not _dged or _dged.checksum ~= _bged.checksum then
        _ieed(_pded)
        return false, "STAGING_VERIFY_FAILED"
    end

                                      
    _eeed(_oded, _cged)

                            
    if not _eeed(_nded, _cged) then
        return false, "WRITE_PRIMARY_FAILED"
    end

                                 
    _ieed(_pded)
    _yded.CurrentSeq = _zfed
    return true, _bged
end

function _yded.readLegacyKey()
    local function _eged(_fged)
        local _gged = _aeed(_fged)
        local _hged = _leed(_gged)
        if _hged and type(_hged.key) == "string" and _hged.key:len() >= 8 then
            return _hged.key
        end
        return nil
    end
    return _eged(_qded) or _eged(_rded)
end

function _yded.purgeLegacyKey()
    _ieed(_qded)
    _ieed(_rded)
end

function _yded.clearAllSessions()
    _ieed(_nded)
    _ieed(_oded)
    _ieed(_pded)
    _yded.CurrentSeq = 0
end

                                                                           
                                                                              
                                                                           
local _iged = {}

function _iged.requestWithTimeout(_jged, _kged, _lged)
    if type(_tded) ~= "function" then
        return false, { code = "EXECUTOR_NO_HTTP", message = "Executor sem API HTTP (request)." }
    end

    _kged = _kged or 15
    local _mged = coroutine.running()
    local _nged = false
    local _oged = false
    local _pged = nil
    local _qged = nil

                                                  
    _qged = task.delay(_kged, function()
        if not _nged then
            _nged = true
            _oged = true
            if _pged and coroutine.status(_pged) ~= "dead" then
                pcall(task.cancel, _pged)
            end
            task.spawn(_mged, false, { code = "TIMEOUT", message = "Tempo limite esgotado (" .. _kged .. "s)." })
        end
    end)

                                                      
    _pged = task.spawn(function()
        local _rged, _sged = pcall(_tded, _jged)
        if not _nged then
            _nged = true
            if _qged and coroutine.status(_qged) ~= "dead" then
                pcall(task.cancel, _qged)
            end
                                                                                               
            if _oged or (_lged and _uded.__MATRIX_FSM_EPOCH ~= _lged) then
                                                                         
                return
            end
            task.spawn(_mged, _rged, _sged)
        end
    end)

    local _tged, _uged = coroutine.yield()
    return _tged, _uged
end

function _iged.requestDirect(_vged, _wged, _xged, _yged, _zged)
    local _ahed = {
        ["Content-Type"] = "application/json; charset=utf-8",
        ["User-Agent"] = "Matrix-Loader-V6/Roblox"
    }
    if _yged then
        for _bhed, _ched in pairs(_yged) do _ahed[_bhed] = _ched end
    end

    local _dhed = {
        Url = _uaed .. _vged,
        Method = "POST",
        Headers = _ahed,
        Body = _jaed:JSONEncode(_wged)
    }

    local _ehed, _fhed = _iged.requestWithTimeout(_dhed, _xged or 15, _zged)
    if not _ehed or type(_fhed) ~= "table" then
        return nil, (type(_fhed) == "table" and _fhed.code) and _fhed or { code = "NETWORK_ERROR", message = "Falha de comunicacao no executor." }
    end

    local _ghed = tonumber(_fhed.StatusCode or _fhed.Status or 0) or 0
    local _hhed = _fhed.Body or ""

    if _ghed ~= 200 then
        local _ihed = _leed(_hhed) or {}
        local _jhed = _fhed.Headers or {}
        local _khed = _ihed.requestId or _jhed["x-matrix-request-id"] or _jhed["X-Matrix-Request-Id"]
        return nil, {
            status = _ghed,
            code = _ihed.code or ("HTTP_" .. _ghed),
            message = _ihed.error or ("Erro HTTP " .. _ghed),
            requestId = _khed,
            body = _hhed
        }
    end

    return {
        status = 200,
        body = _hhed,
        headers = _fhed.Headers or {}
    }, nil
end

                                                                                
function _iged.rawGetAnonymous(_lhed, _mhed, _nhed, _ohed)
    local _phed = {
        ["User-Agent"] = "Matrix-Loader-V6/Roblox",
        ["Accept"] = "application/json",
        ["X-Matrix-Loader-Version"] = _saed
    }
    if _ohed then
        for _qhed, _rhed in pairs(_ohed) do _phed[_qhed] = _rhed end
    end
    local _shed = {
        Url = _lhed,
        Method = "GET",
        Headers = _phed
    }
    local _thed, _uhed = _iged.requestWithTimeout(_shed, _mhed or 5, _nhed)
    if not _thed or type(_uhed) ~= "table" then
        return nil, (type(_uhed) == "table" and _uhed.code) and _uhed or { code = "NETWORK_ERROR", message = "Falha de comunicacao anonima." }
    end
    local _vhed = tonumber(_uhed.StatusCode or _uhed.Status or 0) or 0
    local _whed = _uhed.Body or ""
    if _vhed ~= 200 then
        return nil, { status = _vhed, code = "HTTP_" .. _vhed, body = _whed }
    end
    return { status = 200, body = _whed, headers = _uhed.Headers or {} }, nil
end

                                                                                  
function _iged.requestWithRetry(_xhed, _yhed, _zhed, _aied, _bied, _cied)
    _zhed = _zhed or 3
    _aied = _aied or 15
    local _died = 0

    while _died < _zhed do
        _died = _died + 1
        local _eied, _fied = _iged.requestDirect(_xhed, _yhed, _aied, _bied, _cied)
        if _eied then return _eied, nil end

        local _gied = _fied and (_fied.status == 429 or _fied.status == 502 or _fied.status == 503 or _fied.code == "TIMEOUT" or _fied.code == "NETWORK_ERROR")
        if not _gied or _died >= _zhed then
            return nil, _fied
        end

        local _hied = math.min(10.0, 1.0 * (2 ^ _died))
        local _iied = math.random() * _hied
        task.wait(_iied)
    end
end

                                                                           
                               
                                                                           
local _jied = [==[
task.defer(function()
    local ok, err = pcall(function()
        local Players = game:GetService("Players")
        local HttpService = game:GetService("HttpService")
        local p = Players.LocalPlayer or Players.PlayerAdded:Wait()
        if not game:IsLoaded() then game.Loaded:Wait() end
        local job = tostring(game.JobId or "")
        local path = "MATRIX_Obsidian/teleport_pending_v6_" .. tostring(p.UserId) .. ".json"
        if type(readfile) ~= "function" then return end
        local okRead, raw = pcall(readfile, path)
        if not okRead or type(raw) ~= "string" or raw == "" then return end
        local parsed, proof = pcall(HttpService.JSONDecode, HttpService, raw)
        local erased = false
        if type(delfile) == "function" then erased = pcall(delfile, path) end
        if not erased and type(writefile) == "function" then erased = pcall(writefile, path, "") end
        if not erased or not parsed or type(proof) ~= "table" then return end
        local age = os.time() - (tonumber(proof.startedAt) or 0)
        if tostring(proof.userId or "") ~= tostring(p.UserId)
            or proof.kind ~= "natural" or not proof.originJob or tostring(proof.originJob) == job
            or job == "" or tostring(proof.originGameId or "") ~= tostring(game.GameId)
            or age < -20 or age > 300 then return end
        local globals = (type(getgenv) == "function" and getgenv()) or _G
        if globals.__MATRIX_V6_BOOT_JOB == job then return end
        local source = readfile("MATRIX_Obsidian/loader_v6.lua")
        local compiled, errLoad = loadstring(source)
        if not compiled then error(errLoad) end
        globals.__MATRIX_V6_BOOT_JOB = job
        globals.__MATRIX_V6_FROM_TELEPORT_JOB = job
        compiled()
    end)
    if not ok then warn("[MATRIX][V6-BOOT] " .. tostring(err)) end
end)
]==]

local _kied = {}

local function _lied(_mied)
    if typeof(_mied) == "RBXScriptConnection" then
        table.insert(_kied, _mied)
    end
    return _mied
end

local function _nied()
    for _oied, _pied in ipairs(_kied) do
        if typeof(_pied) == "RBXScriptConnection" and _pied.Connected then
            pcall(_pied.Disconnect, _pied)
        end
    end
    table.clear(_kied)
end

local _qied = queue_on_teleport or queueonteleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport) or _uded.queue_on_teleport
local _ried = false
if type(_qied) == "function" and type(readfile) == "function" and type(writefile) == "function" then
    local _sied, _tied = pcall(readfile, _mded)
    if _sied and type(_tied) == "string" and _tied ~= "" then
        if _uded.__MATRIX_V6_QUEUED_JOB ~= _vded then
            local _uied, _vied = pcall(_qied, _jied)
            if _uied and _vied ~= false then
                _uded.__MATRIX_V6_QUEUED_JOB = _vded
                _ried = true
            end
        else _ried = true end
    end
end

local _wied = false
local function _xied()
    _ieed(_sded)
    _wied = false
end
if not _wded then _xied() end

_lied(_naed.OnTeleport:Connect(function(_yied)
    if _yied == Enum.TeleportState.Started or _yied == Enum.TeleportState.InProgress then
        if not _ried or _wied or type(writefile) ~= "function" then return end
        _wied = true
        _zded()
        local _zied = {
            kind = "natural",
            userId = _raed,
            originJob = _vded,
            originGameId = tostring(game.GameId),
            originPlaceId = tostring(game.PlaceId),
            startedAt = os.time()
        }
        if not _eeed(_sded, _jaed:JSONEncode(_zied)) then
            _wied = false
        end
    elseif _yied == Enum.TeleportState.Failed then
        _xied()
    end
end))

_lied(_kaed.TeleportInitFailed:Connect(function(_ajed)
    if _ajed == _naed then _xied() end
end))

                                                                           
                                       
                                                                           
local _bjed = _naed:WaitForChild("PlayerGui")
local _cjed = _bjed:FindFirstChild("MatrixAccessLoader")
if _cjed then _cjed:Destroy() end

local _djed = Instance.new("ScreenGui")
_djed.Name = "MatrixAccessLoader"
_djed.DisplayOrder = 999
_djed.ResetOnSpawn = false
_djed.IgnoreGuiInset = false
_djed.Parent = _bjed

local function _ejed(_fjed, _gjed, _hjed)
    local _ijed = Instance.new(_fjed)
    for _jjed, _kjed in pairs(_gjed) do _ijed[_jjed] = _kjed end
    _ijed.Parent = _hjed
    return _ijed
end

local _ljed = Color3.fromRGB(111, 255, 158)
local _mjed = Color3.fromRGB(233, 249, 237)
local _njed = Color3.fromRGB(136, 171, 148)
local _ojed    = Color3.fromRGB(4, 15, 9)
local _pjed = Color3.fromRGB(10, 33, 19)
local _qjed  = Color3.fromRGB(255, 177, 117)

local _rjed = _ejed("Frame", {
    Size = UDim2.fromOffset(482, 393),
    Position = UDim2.fromScale(0.5, 0.5),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = _ojed,
    BorderSizePixel = 0,
    ClipsDescendants = true
}, _djed)
_ejed("UICorner", { CornerRadius = UDim.new(0, 15) }, _rjed)
_ejed("UIStroke", { Color = _ljed, Transparency = 0.24, Thickness = 1.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, _rjed)
_ejed("UIGradient", { Color = ColorSequence.new(Color3.fromRGB(11, 34, 20), _ojed), Rotation = 118 }, _rjed)

local _sjed = _ejed("UIScale", { Scale = 1 }, _rjed)
local function _tjed()
    local _ujed = workspace.CurrentCamera
    local _vjed = _ujed and _ujed.ViewportSize or Vector2.new(1280, 720)
    _sjed.Scale = math.clamp(math.min(_vjed.X / 520, _vjed.Y / 450), 0.55, 1)
end
_tjed()

local _wjed
if workspace.CurrentCamera then
    _wjed = _lied(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(_tjed))
end

for _xjed = 1, 23 do
    _ejed("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(11 + _xjed * 20, 11),
        Size = UDim2.fromOffset(15, 370),
        Text = "0\n1\n0\n1\n1\n0\n1\n0\n0\n1\n0",
        TextColor3 = _ljed,
        TextTransparency = 0.93,
        TextSize = 12,
        Font = Enum.Font.Code,
        TextYAlignment = Enum.TextYAlignment.Top
    }, _rjed)
end

local function _yjed(_zjed, _aked, _bked, _cked, _dked, _eked)
    return _ejed("TextLabel", {
        Position = _aked, Size = _bked, BackgroundTransparency = 1, Text = _zjed,
        Font = _eked or Enum.Font.Code, TextSize = _cked, TextColor3 = _dked or _mjed,
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center
    }, _rjed)
end

_yjed("M A T R I X", UDim2.fromOffset(26, 17), UDim2.fromOffset(420, 38), 29, _mjed, Enum.Font.GothamBold)
_yjed("A C C E S S  /  V 6", UDim2.fromOffset(27, 55), UDim2.fromOffset(420, 22), 12, _ljed)
_ejed("Frame", { Position = UDim2.fromOffset(26, 91), Size = UDim2.fromOffset(429, 1), BackgroundColor3 = Color3.fromRGB(48, 103, 64), BorderSizePixel = 0 }, _rjed)
_yjed("CONTA / @" .. _naed.Name .. "  |  ID " .. _raed, UDim2.fromOffset(27, 105), UDim2.fromOffset(429, 22), 12, _njed)
_yjed("GAME " .. tostring(game.GameId) .. "  |  PLACE " .. tostring(game.PlaceId), UDim2.fromOffset(27, 129), UDim2.fromOffset(429, 20), 11, _njed)

local _fked = _ejed("TextBox", {
    Position = UDim2.fromOffset(26, 165), Size = UDim2.fromOffset(429, 44), Text = "",
    PlaceholderText = "INSIRA SUA KEY (PRIMEIRO ACESSO)", PlaceholderColor3 = _njed,
    ClearTextOnFocus = false, Font = Enum.Font.Code, TextSize = 14, TextColor3 = _mjed,
    BackgroundColor3 = _pjed, BorderSizePixel = 0
}, _rjed)
_ejed("UICorner", { CornerRadius = UDim.new(0, 8) }, _fked)
_ejed("UIStroke", { Color = Color3.fromRGB(55, 123, 72), Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, _fked)

local _gked = _ejed("Frame", { Position = UDim2.fromOffset(26, 165), Size = UDim2.fromOffset(429, 44), BackgroundColor3 = _pjed, Visible = false, BorderSizePixel = 0, ClipsDescendants = true }, _rjed)
_ejed("UICorner", { CornerRadius = UDim.new(0, 8) }, _gked)
local _hked = _ejed("Frame", { Size = UDim2.fromScale(0, 1), BorderSizePixel = 0, BackgroundColor3 = Color3.fromRGB(25, 148, 69) }, _gked)
local _iked = _ejed("TextLabel", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Font = Enum.Font.Code, TextSize = 12, TextColor3 = _mjed, Text = "PREPARANDO JOGO..." }, _gked)

local _jked = _ejed("TextButton", {
    Position = UDim2.fromOffset(26, 222), Size = UDim2.fromOffset(429, 46),
    BackgroundColor3 = Color3.fromRGB(22, 167, 80), Text = "[  INICIAR MATRIX  ]",
    TextColor3 = Color3.new(0, 0, 0), TextSize = 15, Font = Enum.Font.Code, BorderSizePixel = 0
}, _rjed)
_ejed("UICorner", { CornerRadius = UDim.new(0, 9) }, _jked)

local _kked = _yjed("● INICIANDO MATRIX ACCESS V6", UDim2.fromOffset(27, 278), UDim2.fromOffset(428, 45), 12, _ljed)
_kked.TextWrapped = true
_kked.TextYAlignment = Enum.TextYAlignment.Top

local _lked = _ried and "AUTO REJOIN: PRONTO" or "AUTO REJOIN: INDISPONIVEL"
local _mked = _yjed(_lked, UDim2.fromOffset(27, 320), UDim2.fromOffset(429, 18), 10, _njed)

local _nked = _ejed("TextButton", {
    Position = UDim2.fromOffset(26, 346), Size = UDim2.fromOffset(206, 30),
    Text = "DIAGNOSTICAR", TextColor3 = _mjed, TextSize = 11, Font = Enum.Font.Code,
    BackgroundColor3 = _pjed, BorderSizePixel = 0
}, _rjed)
local _oked = _ejed("TextButton", {
    Position = UDim2.fromOffset(249, 346), Size = UDim2.fromOffset(206, 30),
    Text = "ESQUECER SESSAO", TextColor3 = _mjed, TextSize = 11, Font = Enum.Font.Code,
    BackgroundColor3 = _pjed, BorderSizePixel = 0
}, _rjed)

for _pked, _qked in ipairs({ _nked, _oked }) do
    _ejed("UICorner", { CornerRadius = UDim.new(0, 8) }, _qked)
    _ejed("UIStroke", { Color = Color3.fromRGB(55, 123, 72), Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, _qked)
end

local function _rked(_sked, _tked)
    if not _djed.Parent then return end
    _kked.Text = _sked
    _kked.TextColor3 = _tked and _qjed or _ljed
end

                                                                           
                                                              
                                                                           
_uded.__MATRIX_FSM_EPOCH = 0

local _uked = {
    State = "UNINITIALIZED",
    Session = nil,
    CachedKey = nil,
    IsBusy = false
}

local _vked = {
    ["UNINITIALIZED"]          = { ["BOOTSTRAPPING"] = true, ["CHECKING_LOCAL_SESSION"] = true },
    ["BOOTSTRAPPING"]          = { ["CHECKING_LOCAL_SESSION"] = true, ["ERROR_RECOVERABLE"] = true },
    ["CHECKING_LOCAL_SESSION"]  = { ["PROMPTING_KEY"] = true, ["VALIDATING_SESSION"] = true, ["EXCHANGING_KEY"] = true },
    ["PROMPTING_KEY"]          = { ["EXCHANGING_KEY"] = true },
    ["EXCHANGING_KEY"]         = { ["WAITING_GAME_LOAD"] = true, ["ERROR_FATAL"] = true, ["ERROR_RECOVERABLE"] = true },
    ["VALIDATING_SESSION"]     = { ["CHECKING_RENEWAL"] = true, ["COMMITTING_SESSION"] = true, ["WAITING_GAME_LOAD"] = true, ["ERROR_FATAL"] = true, ["ERROR_RECOVERABLE"] = true },
    ["COMMITTING_SESSION"]     = { ["WAITING_GAME_LOAD"] = true, ["ERROR_FATAL"] = true, ["ERROR_RECOVERABLE"] = true },
    ["CHECKING_RENEWAL"]       = { ["RENEWING_SESSION"] = true, ["WAITING_GAME_LOAD"] = true },
    ["RENEWING_SESSION"]       = { ["COMMITTING_SESSION"] = true, ["WAITING_GAME_LOAD"] = true, ["ERROR_FATAL"] = true, ["ERROR_RECOVERABLE"] = true },
    ["WAITING_GAME_LOAD"]      = { ["FETCHING_SCRIPT"] = true, ["ERROR_RECOVERABLE"] = true },
    ["FETCHING_SCRIPT"]        = { ["VALIDATING_SCRIPT"] = true, ["ERROR_FATAL"] = true, ["ERROR_RECOVERABLE"] = true },
    ["VALIDATING_SCRIPT"]      = { ["COMPILING_SCRIPT"] = true, ["ERROR_RECOVERABLE"] = true },
    ["COMPILING_SCRIPT"]       = { ["EXECUTING"] = true, ["ERROR_RECOVERABLE"] = true, ["ERROR_FATAL"] = true },
    ["EXECUTING"]              = { ["RUNNING"] = true, ["ERROR_RECOVERABLE"] = true },
    ["RUNNING"]                = {},                   
    ["DIAGNOSING"]             = { ["WAITING_GAME_LOAD"] = true, ["ERROR_RECOVERABLE"] = true, ["PROMPTING_KEY"] = true },
    ["LOGGING_OUT"]            = { ["PROMPTING_KEY"] = true, ["ERROR_RECOVERABLE"] = true },
    ["ERROR_RECOVERABLE"]      = { ["BOOTSTRAPPING"] = true, ["CHECKING_LOCAL_SESSION"] = true, ["EXCHANGING_KEY"] = true, ["FETCHING_SCRIPT"] = true, ["PROMPTING_KEY"] = true, ["RENEWING_SESSION"] = true },
    ["ERROR_FATAL"]            = { ["PROMPTING_KEY"] = true }
}

function _uked:Transition(_wked, _xked)
    local _yked = self.State
    if _yked ~= "UNINITIALIZED" and not (_vked[_yked] and _vked[_yked][_wked]) then
        warn(string.format("[MATRIX][FSM] Transicao Proibida: %s -> %s", tostring(_yked), tostring(_wked)))
        return false
    end

    self.State = _wked
    self:OnStateChanged(_wked, _xked)
    return true
end

function _uked:OnStateChanged(_zked, _aled)
    if _zked == "BOOTSTRAPPING" then
        self.IsBusy = true
        _gked.Visible = true
        _fked.Visible = false
        _jked.Active = false
        _jked.Text = "[  CONECTANDO...  ]"
        _rked("Consultando configuracao de bootstrap segura...")
    elseif _zked == "PROMPTING_KEY" then
        self.IsBusy = false
        _gked.Visible = false
        _fked.Visible = true
        _fked.Text = ""
        _jked.Active = true
        _jked.Text = "[  VALIDAR KEY  ]"
    elseif _zked == "EXCHANGING_KEY" then
        self.IsBusy = true
        _fked.Visible = false
        _jked.Active = false
        _jked.Text = "[  AUTENTICANDO...  ]"
        _rked("Validando credencial mestre...")
    elseif _zked == "VALIDATING_SESSION" then
        _rked("Consultando autenticidade da sessao no Worker...")
    elseif _zked == "COMMITTING_SESSION" then
        _rked("Confirmando sessao em duas fases (ACK)...")
    elseif _zked == "CHECKING_RENEWAL" then
        _rked("Verificando janela de renovacao proativa...")
    elseif _zked == "RENEWING_SESSION" then
        _rked("Preparando rotacao segura de credencial...")
    elseif _zked == "WAITING_GAME_LOAD" then
        _fked.Visible = false
        _gked.Visible = true
        _jked.Active = false
        _jked.Text = "[  CARREGANDO JOGO  ]"
        _rked("Aguardando carregamento dos assets do jogo...")
    elseif _zked == "FETCHING_SCRIPT" then
        _gked.Visible = false
        _rked("Autorizado! Baixando runtime do jogo (/load)...")
    elseif _zked == "VALIDATING_SCRIPT" then
        _rked("Validando assinatura e hash do script...")
    elseif _zked == "COMPILING_SCRIPT" then
        _rked("Compilando versao publicada...")
    elseif _zked == "EXECUTING" then
        _jked.Text = "[  EXECUTANDO MATRIX  ]"
        _rked("Inicializando runtime seguro...")
    elseif _zked == "RUNNING" then
        self.IsBusy = false
        _rked("MATRIX V6 Ativado com Sucesso!")
        _nied()
        task.delay(0.4, function()
            if _djed and _djed.Parent then _djed:Destroy() end
        end)
    elseif _zked == "ERROR_RECOVERABLE" then
        self.IsBusy = false
        _gked.Visible = false
        _jked.Active = true
        _jked.Text = "[  TENTAR NOVAMENTE  ]"
        local _bled = (_aled and _aled.message) or "Falha de comunicacao."
        local _cled = (_aled and _aled.code) or "NET_ERROR"
        _rked(string.format("[%s] %s", tostring(_cled), tostring(_bled)), true)
    elseif _zked == "ERROR_FATAL" then
        self.IsBusy = false
        _gked.Visible = false
        _fked.Visible = true
        _fked.Text = ""
        _jked.Active = true
        _jked.Text = "[  VALIDAR NOVA KEY  ]"
        local _dled = (_aled and _aled.message) or "Acesso nao autorizado."
        local _eled = (_aled and _aled.code) or "AUTH_FATAL"
        _rked(string.format("[%s] %s", tostring(_eled), tostring(_dled)), true)
    end
end

                                                                           
                        
                                                                           
local function _fled(_gled, _hled)
    if not _uked.Session or not _uked.Session.token then
        return nil, { code = "SESSION_MISSING", message = "Sem sessao autorizada." }
    end
    if tostring(game.JobId) ~= _vded then
        return nil, { code = "GAME_CHANGED", message = "Sessao de jogo alterada." }
    end

    local _iled = {
        userId = _raed,
        sessionToken = _uked.Session.token,
        gameId = tostring(game.GameId),
        placeId = tostring(game.PlaceId)
    }
    for _jled, _kled in pairs(_hled or {}) do _iled[_jled] = _kled end
    local _lled, _mled = _iged.requestDirect(_gled, _iled, 15)
    if not _lled then return nil, _mled end
    local _nled = _leed(_lled.body)
    return _nled or nil, nil
end

_uded.__MATRIX_V6_CLOUD = {
    list = function() return _fled("/v6/cloud/slots/list", {}) end,
    save = function(_oled, _pled, _qled, _rled)
        if type(_oled) ~= "number" or _oled < 1 or _oled > 6 or math.floor(_oled) ~= _oled then
            return nil, { code = "SLOT_INVALID", message = "Slot deve ser inteiro entre 1 e 6." }
        end
        if type(_qled) ~= "table" then
            return nil, { code = "CONFIG_INVALID", message = "Configuracao deve ser uma tabela." }
        end
        return _fled("/v6/cloud/slots/save", {
            slot = _oled,
            name = tostring(_pled or ("Perfil " .. _oled)),
            config = _qled,
            expectedRevision = _rled
        })
    end,
    delete = function(_sled)
        if type(_sled) ~= "number" or _sled < 1 or _sled > 6 or math.floor(_sled) ~= _sled then
            return nil, { code = "SLOT_INVALID", message = "Slot invalido." }
        end
        return _fled("/v6/cloud/slots/delete", { slot = _sled })
    end
}

                                                                           
                                     
                                                                           
function _uked:Start()
    self:Transition("BOOTSTRAPPING")
    task.spawn(function()
        self:ProcessBootstrap()
    end)
end

                                                                           
                                                         
                                                                           
local function _tled(_uled)
    if type(_uled) ~= "string" then return nil end
    local _vled = _uled:match("^%s*v?(.-)%s*$")
    if not _vled or _vled == "" then return nil end

    local _wled = nil
    local _xled = _vled:find("+", 1, true)
    if _xled then
        _wled = _vled:sub(_xled + 1)
        _vled = _vled:sub(1, _xled - 1)
        if not _wled or _wled == "" or _wled:sub(-1) == "." then return nil end
        if _wled:find("%.%.") then return nil end
        for _yled in _wled:gmatch("([^%.]+)") do
            if not _yled:match("^[0-9a-zA-Z%-]+$") then return nil end
        end
    end

    local _zled = nil
    local _amed = _vled:find("-", 1, true)
    if _amed then
        _zled = _vled:sub(_amed + 1)
        _vled = _vled:sub(1, _amed - 1)
        if not _zled or _zled == "" or _zled:sub(-1) == "." then return nil end
        if _zled:find("%.%.") then return nil end
        for _bmed in _zled:gmatch("([^%.]+)") do
            if _bmed:match("^%d+$") then
                                                                                    
                if #_bmed > 1 and _bmed:sub(1, 1) == "0" then return nil end
            else
                if not _bmed:match("^[0-9a-zA-Z%-]+$") then return nil end
            end
        end
    end

    local _cmed, _dmed, _emed = _vled:match("^(%d+)%.(%d+)%.(%d+)$")
    if not _cmed then return nil end
                                                         
    if (#_cmed > 1 and _cmed:sub(1, 1) == "0") or (#_dmed > 1 and _dmed:sub(1, 1) == "0") or (#_emed > 1 and _emed:sub(1, 1) == "0") then
        return nil
    end

    return {
        major = tonumber(_cmed),
        minor = tonumber(_dmed),
        patch = tonumber(_emed),
        prerelease = _zled,
        build = _wled
    }
end

local function _fmed(_gmed, _hmed)
    local _imed = _tled(_gmed)
    local _jmed = _tled(_hmed)
    if not _imed or not _jmed then return nil end               

    if _imed.major ~= _jmed.major then return _imed.major > _jmed.major and 1 or -1 end
    if _imed.minor ~= _jmed.minor then return _imed.minor > _jmed.minor and 1 or -1 end
    if _imed.patch ~= _jmed.patch then return _imed.patch > _jmed.patch and 1 or -1 end

                                                                                      
    if _imed.prerelease == nil and _jmed.prerelease ~= nil then return 1 end
    if _imed.prerelease ~= nil and _jmed.prerelease == nil then return -1 end
    if _imed.prerelease == nil and _jmed.prerelease == nil then return 0 end

                                                                             
    local _kmed = {}
    for _lmed in _imed.prerelease:gmatch("([^%.]+)") do table.insert(_kmed, _lmed) end
    local _mmed = {}
    for _nmed in _jmed.prerelease:gmatch("([^%.]+)") do table.insert(_mmed, _nmed) end

    local _omed = math.min(#_kmed, #_mmed)
    for _pmed = 1, _omed do
        local _qmed = _kmed[_pmed]
        local _rmed = _mmed[_pmed]
        if _qmed ~= _rmed then
            local _smed = _qmed:match("^%d+$") ~= nil
            local _tmed = _rmed:match("^%d+$") ~= nil
            if _smed and _tmed then
                                                                                    
                local _umed = tonumber(_qmed)
                local _vmed = tonumber(_rmed)
                return _umed > _vmed and 1 or -1
            elseif _smed and not _tmed then
                                                                                                              
                return -1
            elseif not _smed and _tmed then
                return 1
            else
                                                                                          
                return _qmed > _rmed and 1 or -1
            end
        end
    end

                                                                    
    if #_kmed ~= #_mmed then
        return #_kmed > #_mmed and 1 or -1
    end

                                                                 
    return 0
end

function _uked:ProcessBootstrap()
                                                                                
    local function _wmed(_xmed)
        warn("[MATRIX][BOOTSTRAP][FATAL] " .. tostring(_xmed.message or _xmed.code))
        self.LastError = _xmed
        self:Transition("ERROR_FATAL", _xmed)
        _rked(string.format("[%s] %s", tostring(_xmed.code), tostring(_xmed.message)), true)
    end

                                                                                                               
    local _ymed = _uaed:gsub("/$", "") .. "/v6/bootstrap/resolve"
    local _zmed, _aned = _iged.rawGetAnonymous(_ymed, 5)

                                                                                               
    if not _zmed and _aned and type(_aned) == "table" then
        local _bned = tonumber(_aned.status or 0) or 0
        local _cned = _aned.body or ""
        local _dned = _leed(_cned)
        local _ened = (_dned and _dned.code) or _aned.code

                                                           
        if _bned == 426 or _ened == "UPGRADE_REQUIRED" then
            local _fned = (_dned and (_dned.min_loader_version or _dned.minVersion)) or "6.0.0"
            _wmed({ code = "UPGRADE_REQUIRED", message = "Versao do loader (" .. _saed .. ") obsoleta. Requer " .. tostring(_fned) })
            return                                                                    
        end

                                                                
        if _bned == 400 then
            _wmed({ code = _ened or "HTTP_400", message = "Requisicao de bootstrap rejeitada (HTTP 400): " .. tostring(_cned) })
            return                  
        end

                                    
        if _bned == 401 then
            _wmed({ code = "HTTP_401", message = "Nao autorizado no bootstrap (HTTP 401)." })
            return                  
        end

                                    
        if _bned == 403 then
            _wmed({ code = "HTTP_403", message = "Acesso proibido ao endpoint de bootstrap (HTTP 403)." })
            return                  
        end

                                                          
        if _bned == 500 then
            _wmed({ code = _ened or "HTTP_500", message = "Erro interno no servidor de bootstrap (HTTP 500)." })
            return                  
        end

                                                                          
        if _bned == 503 then
            if _ened == "BOOTSTRAP_STALE_GENERATION" then
                _wmed({ code = "OBSOLETE_GENERATION", message = "Topologia rejeitada por geracao obsoleta." })
                return
            elseif _ened == "BOOTSTRAP_EXPIRED" or _ened == "BOOTSTRAP_NOT_YET_VALID" then
                _wmed({ code = "CONFIG_EXPIRED", message = "Configuracao de bootstrap expirada ou fora da validade." })
                return
            elseif _ened == "BOOTSTRAP_DECRYPT_FAILED" then
                _wmed({ code = "SECURITY_REJECTION", message = "Falha criptografica na autenticacao do envelope de bootstrap." })
                return
            elseif _ened == "BOOTSTRAP_ORIGIN_MISMATCH" then
                _wmed({ code = "PINNING_VIOLATION", message = "Origem retornada viola o pinning canonico do ambiente." })
                return
            elseif _ened == "BOOTSTRAP_SECRET_UNCONFIGURED" then
                _wmed({ code = "BOOTSTRAP_SECRET_UNCONFIGURED", message = "Chave de bootstrap nao configurada no backend." })
                return
            elseif _ened == "BOOTSTRAP_SECRET_INVALID_FORMAT" then
                _wmed({ code = "BOOTSTRAP_SECRET_INVALID_FORMAT", message = "Formato de chave de bootstrap invalido no backend." })
                return
            elseif _ened == "BOOTSTRAP_SCHEMA_ERROR" then
                _wmed({ code = "BOOTSTRAP_SCHEMA_ERROR", message = "Esquema da carga de bootstrap corrompido ou invalido." })
                return
            elseif _ened == "BOOTSTRAP_INVALID_WORKER_ORIGIN" then
                _wmed({ code = "BOOTSTRAP_INVALID_WORKER_ORIGIN", message = "Origem primaria invalida na carga decriptada." })
                return
            elseif _ened == "BOOTSTRAP_CONFIG_ERROR" then
                _wmed({ code = "BOOTSTRAP_CONFIG_ERROR", message = "Erro de configuracao interna de bootstrap no servidor." })
                return
            else
                _wmed({ code = _ened or "BOOTSTRAP_UNAVAILABLE", message = "Servico de bootstrap indisponivel (HTTP 503)." })
                return
            end
        end

                                                                                                                     
        if _bned == 502 or _bned == 504 then
            local _gned, _hned, _ined = _ebed(_taed)
            if not _gned then
                _wmed({ code = _hned, message = _ined .. " (apos gateway HTTP " .. _bned .. ")" })
                return
            end
            warn("[MATRIX][BOOTSTRAP] Erro transitorio de gateway Cloudflare (HTTP " .. _bned .. "). Acionando fallback oficial independente.")
            _uaed = _taed
            _uded.__MATRIX_BOOTSTRAP_DEGRADED = true
            _rked("Bootstrap degradado (gateway " .. _bned .. ")")
            self:Transition("CHECKING_LOCAL_SESSION")
            self:CheckLocalSession()
            return
        end

                                                                                                                  
        if _bned == 0 or _bned == nil then
            if _ened == "NETWORK_ERROR" or _ened == "TIMEOUT" or _aned.code == "NETWORK_ERROR" then
                local _jned, _kned, _lned = _ebed(_taed)
                if not _jned then
                    _wmed({ code = _kned, message = _lned .. " (apos falha de transporte " .. tostring(_ened) .. ")" })
                    return
                end
                warn("[MATRIX][BOOTSTRAP] Falha transiente de transporte/rede comprovada. Acionando fallback oficial independente.")
                _uaed = _taed
                _uded.__MATRIX_BOOTSTRAP_DEGRADED = true
                _rked("Bootstrap degradado (falha de rede)")
                self:Transition("CHECKING_LOCAL_SESSION")
                self:CheckLocalSession()
                return
            end
        end

                                                                                             
        _wmed({ code = "HTTP_" .. _bned, message = "Resposta inesperada no bootstrap (HTTP " .. _bned .. ")." })
        return
    end

                                                        
    if _zmed and _zmed.body then
        local _mned = _leed(_zmed.body)
        if not _mned or type(_mned) ~= "table" then
            _wmed({ code = "MALFORMED_DISCOVERY", message = "Resposta HTTP 200 contem JSON corrompido ou invalido." })
            return                                                             
        end

                                                                                                          
        if _mned.mode == "rollback_v1" then
            local _nned, _oned, _pned = _ebed(_taed)
            if not _nned then
                _wmed({ code = _oned, message = _pned .. " (ao tentar rollback_v1)" })
                return
            end
            warn("[MATRIX][BOOTSTRAP] Modo de rollback v1 ativo no backend. Usando fallback oficial autorizado.")
            _uaed = _taed
            _uded.__MATRIX_BOOTSTRAP_DEGRADED = true
            _rked("Bootstrap operando em rollback v1")
            self:Transition("CHECKING_LOCAL_SESSION")
            self:CheckLocalSession()
            return
        end

                                                  
        if type(_mned.active_worker) ~= "string" or not _mned.active_worker:match("^https://")
           or (_mned.protocol_version ~= "2.0" and _mned.protocol_version ~= "2")
           or type(_mned.generation_id) ~= "number" or _mned.generation_id <= 0
           or _mned.status ~= "PASS" then
            _wmed({ code = "INVALID_DISCOVERY_SCHEMA", message = "Esquema da resposta HTTP 200 incompleto ou invalido." })
            return                                                       
        end

                                                                          
        if _mned.min_loader_version then
            if type(_mned.min_loader_version) ~= "string" then
                _wmed({ code = "MALFORMED_SEMVER", message = "min_loader_version deve ser string." })
                return
            end
            local _qned = _fmed(_saed, _mned.min_loader_version)
            if _qned == nil then
                _wmed({ code = "MALFORMED_SEMVER", message = "Versao minima no discovery viola a especificacao SemVer 2.0.0." })
                return                                                                      
            end
            if _qned < 0 then
                _wmed({ code = "UPGRADE_REQUIRED", message = "Loader obsoleto (" .. _saed .. " < " .. _mned.min_loader_version .. "). Atualizacao necessaria." })
                return                  
            end
        end

                                             
        local _rned = _mned.active_worker
        local _sned = _xaed(_rned)
        if _sned and _vaed[_sned] then
            _uaed = _rned:gsub("/$", "")
            _uded.__MATRIX_RESOLVED_BASE = _uaed
            _uded.__MATRIX_BOOTSTRAP_DEGRADED = false
            _rked("Bootstrap V2 conectado: " .. tostring(_sned))
            self:Transition("CHECKING_LOCAL_SESSION")
            self:CheckLocalSession()
            return
        else
            _wmed({ code = "PINNING_VIOLATION", message = "Hostname retornado fora do pinning autorizado: " .. tostring(_sned) })
            return                  
        end
    end

                                                                                        
    _wmed({ code = "BOOTSTRAP_FAILED", message = "Falha critica nao autorizada no bootstrap." })
end
function _uked:CheckLocalSession()
    local _tned = _yded.readCandidates()
    local _uned = _tned.staging
    local _vned = _tned.primary

    if _uned then
                                                                                 
        self:Transition("VALIDATING_SESSION")
        self:ProcessValidation(_uned, true, _vned)
    elseif _vned then
                                                  
        self.Session = _vned
        self:Transition("VALIDATING_SESSION")
        self:ProcessValidation(_vned, false, nil)
    else
                                                                    
        local _wned = _yded.readLegacyKey()
        if _wned then
            self.CachedKey = _wned
            self:Transition("EXCHANGING_KEY")
            self:ProcessExchange(_wned, true)
        else
            self:Transition("PROMPTING_KEY")
        end
    end
end

                                                                       
function _uked:ProcessValidation(_xned, _yned, _zned)
    local _aoed = {
        userId = _raed,
        sessionToken = _xned.token,
        readOnly = true
    }
    local _boed = {
        ["Authorization"] = "Bearer " .. _xned.token
    }

    local _coed, _doed = _iged.requestDirect("/v6/auth/validate", _aoed, 10, _boed)
    if not _coed then
        if _doed and (_doed.status == 401 or _doed.status == 403) then
                                                            
            if _yned and _zned then
                                                                        
                _ieed(_pded)
                self:ProcessValidation(_zned, false, nil)
                return
            end
            _yded.clearAllSessions()
            self.Session = nil
            self:Transition("ERROR_FATAL", _doed)
            self:Transition("PROMPTING_KEY")
        else
                                                              
                                                                                          
            warn("[MATRIX] Validacao remota offline temporaria. Prosseguindo em modo resiliente.")
            if _yned and _zned then
                self.Session = _zned
            else
                self.Session = _xned
            end
            self:Transition("WAITING_GAME_LOAD")
            self:ProcessGameLoad()
        end
        return
    end

    local _eoed = _leed(_coed.body) or {}
    local _foed = _eoed.status or (_eoed.valid and "ACTIVE") or "INVALID"

    if _foed == "ACTIVE" then
        if _yned then
                                                                                    
            local _goed, _hoed = _yded.promoteStaging(_xned)
            self.Session = _goed and _hoed or _xned
        else
            self.Session = _xned
        end
        self:Transition("CHECKING_RENEWAL")
        self:ProcessRenewal()
    elseif _foed == "PENDING" then
                                                                        
        self:Transition("COMMITTING_SESSION")
        self:ProcessCommitAck(_xned.token, _xned.operationId)
    elseif _foed == "EXPIRED" or _foed == "REVOKED" or _foed == "INVALID" then
        if _yned and _zned then
            _ieed(_pded)
            self:ProcessValidation(_zned, false, nil)
            return
        end
        _yded.clearAllSessions()
        self.Session = nil
        local _ioed = {
            code = "SESSION_" .. _foed,
            message = "Sessao " .. _foed:lower() .. ". Insira sua key novamente."
        }
        self:Transition("ERROR_FATAL", _ioed)
        self:Transition("PROMPTING_KEY")
    else
        self:Transition("ERROR_RECOVERABLE", { code = "UNKNOWN_VALIDATE_STATUS", message = "Status de sessao desconhecido." })
    end
end

function _uked:ProcessExchange(_joed, _koed)
    local _loed = { userId = _raed, key = _joed }
    local _moed, _noed = _iged.requestWithRetry("/v6/auth/exchange", _loed, 2, 12)
    if not _moed then
        if _noed and (_noed.status == 401 or _noed.status == 403) then
            self:Transition("ERROR_FATAL", _noed)
            self:Transition("PROMPTING_KEY")
        else
            self:Transition("ERROR_RECOVERABLE", _noed)
        end
        return
    end

    local _ooed = _leed(_moed.body)
    if not _ooed or type(_ooed.sessionToken) ~= "string" or #_ooed.sessionToken ~= 68 or not _ooed.sessionToken:match("^MX6_[a-f0-9]+$") then
        self:Transition("ERROR_RECOVERABLE", { code = "BAD_SESSION_TOKEN", message = "Formato de sessao retornado pelo servidor invalido." })
        return
    end

    local _poed, _qoed = _yded.saveSessionAtomic(_ooed.sessionToken, _ooed.expiresAt)
    if _poed then
        self.Session = _qoed
        if _koed then
            _yded.purgeLegacyKey()
        end
        self:Transition("WAITING_GAME_LOAD")
        self:ProcessGameLoad()
    else
        self:Transition("ERROR_RECOVERABLE", { code = "DISK_WRITE_FAIL", message = "Falha ao gravar sessao no sistema de arquivos local." })
    end
end

function _uked:ProcessRenewal()
    local _roed = self.Session
    local _soed = os.time()

                                                                                     
    if (tonumber(_roed.renewAfter) or 0) > _soed then
        self:Transition("WAITING_GAME_LOAD")
        self:ProcessGameLoad()
        return
    end

    self:Transition("RENEWING_SESSION")
    _uded.__MATRIX_FSM_EPOCH = (_uded.__MATRIX_FSM_EPOCH or 0) + 1
    local _toed = _uded.__MATRIX_FSM_EPOCH
    local _uoed = "op-" .. tostring(os.time()) .. "-" .. tostring(math.random(100000, 999999))

    local _voed = {
        userId = _raed,
        sessionToken = _roed.token,
        operationId = _uoed
    }
    local _woed = {
        ["Authorization"] = "Bearer " .. _roed.token
    }

    local _xoed, _yoed = _iged.requestWithRetry("/v6/auth/prepare", _voed, 2, 10, _woed, _toed)

    if not _xoed then
        if _yoed and (_yoed.status == 401 or _yoed.status == 403) then
            _yded.clearAllSessions()
            self.Session = nil
            self:Transition("ERROR_FATAL", _yoed)
            self:Transition("PROMPTING_KEY")
        else
            warn("[MATRIX] Instabilidade temporaria no prepare. Continuando com a sessao ativa.")
            self:Transition("WAITING_GAME_LOAD")
            self:ProcessGameLoad()
        end
        return
    end

    local _zoed = _leed(_xoed.body)
    if _zoed and type(_zoed.sessionToken) == "string" and #_zoed.sessionToken == 68 and _zoed.sessionToken:match("^MX6_[a-f0-9]+$") then
        local _aped = _zoed.operationId or _uoed
                                                                    
        local _bped, _cped = _yded.saveStaging(_zoed.sessionToken, _zoed.pendingExpiresAt or _zoed.expiresAt, _aped)
        if _bped then
            self:Transition("COMMITTING_SESSION")
            self:ProcessCommitAck(_zoed.sessionToken, _aped)
            return
        end
    end

    self:Transition("WAITING_GAME_LOAD")
    self:ProcessGameLoad()
end

                                                            
function _uked:ProcessCommitAck(_dped, _eped)
    local _fped = {
        userId = _raed,
        sessionToken = (self.Session and self.Session.token) or _dped,
        ackToken = _dped,
        operationId = _eped
    }
    local _gped = {
        ["Authorization"] = "Bearer " .. _dped
    }

    local _hped, _iped = _iged.requestWithRetry("/v6/auth/ack", _fped, 3, 10, _gped)
    if not _hped then
        if _iped and (_iped.status == 401 or _iped.status == 403) then
            _yded.clearAllSessions()
            self.Session = nil
            self:Transition("ERROR_FATAL", _iped)
            self:Transition("PROMPTING_KEY")
            return
        else
                                                                                     
                                                                              
            warn("[MATRIX] Resposta do ACK nao recebida. Confiando em Commit-on-First-Use.")
            self:Transition("WAITING_GAME_LOAD")
            self:ProcessGameLoad()
            return
        end
    end

    local _jped = _leed(_hped.body) or {}
    if _jped.ok or _jped.confirmed or _jped.alreadyCommitted then
        local _kped = _yded.readEntryFromFile(_pded)
        if _kped then
            local _lped, _mped = _yded.promoteStaging(_kped)
            if _lped then self.Session = _mped end
        end
    end

    self:Transition("WAITING_GAME_LOAD")
    self:ProcessGameLoad()
end

function _uked:ProcessGameLoad()
                                                                                             
    if not game:IsLoaded() then
        local _nped = os.clock()
        while not game:IsLoaded() and (os.clock() - _nped) < 40 do
            local _oped = os.clock() - _nped
            _hked.Size = UDim2.fromScale(math.clamp(_oped / 40, 0, 0.9), 1)
            _iked.Text = "AGUARDANDO O JOGO CARREGAR (" .. math.floor(_oped) .. "s)..."
            task.wait(0.2)
        end
    end

    if not game:IsLoaded() then
        self:Transition("ERROR_RECOVERABLE", { code = "GAME_TIMEOUT", message = "O jogo nao terminou de inicializar em 40s." })
        return
    end

    _hked.Size = UDim2.fromScale(1, 1)
    _iked.Text = "JOGO CARREGADO / BAIXANDO SCRIPT"

    self:Transition("FETCHING_SCRIPT")
    self:ProcessFetchScript()
end

                                                                                              
function _uked:ProcessFetchScript()
    local _pped = {
        userId = _raed,
        sessionToken = self.Session.token,
        gameId = tostring(game.GameId),
        placeId = tostring(game.PlaceId)
    }
    local _qped = {
        ["Authorization"] = "Bearer " .. self.Session.token
    }

    local _rped, _sped = _iged.requestWithRetry("/load", _pped, 3, 20, _qped)
    if not _rped then
        if _sped and (_sped.status == 401 or _sped.status == 403) then
            _yded.clearAllSessions()
            self.Session = nil
            self:Transition("ERROR_FATAL", _sped)
            self:Transition("PROMPTING_KEY")
        elseif _sped and _sped.status == 404 then
            self:Transition("ERROR_RECOVERABLE", {
                code = "GAME_NOT_FOUND",
                message = "Script nao configurado para este jogo (Place " .. tostring(game.PlaceId) .. ")."
            })
        elseif _sped and _sped.status == 429 then
            self:Transition("ERROR_RECOVERABLE", {
                code = "RATE_LIMITED",
                message = "Limite de taxa atingido. Aguarde alguns instantes."
            })
        elseif _sped and (_sped.status == 502 or _sped.status == 503) then
            self:Transition("ERROR_RECOVERABLE", {
                code = "SERVER_UNAVAILABLE",
                message = "Servidor temporariamente indisponivel (" .. tostring(_sped.status) .. ")."
            })
        else
            self:Transition("ERROR_RECOVERABLE", _sped)
        end
        return
    end

    local _tped = _rped.body
    if type(_tped) ~= "string" or _tped:len() < 10 then
        self:Transition("ERROR_RECOVERABLE", { code = "SCRIPT_EMPTY", message = "O servidor retornou script vazio ou invalido." })
        return
    end

    self:Transition("VALIDATING_SCRIPT")
    local _uped = _rped.headers or {}
    local _vped = _uped["x-matrix-delivery-sha256"] or _uped["X-Matrix-Delivery-Sha256"] or _uped["x-matrix-sha256"] or _uped["X-Matrix-Sha256"]
    local _wped = _uped["x-matrix-version"] or _uped["X-Matrix-Version"] or "V6"
    local _xped = _uped["x-matrix-compat-mode"] or _uped["X-Matrix-Compat-Mode"]

                                                                                      
                                                                                                
                                                                                         
                                                                                                    
                                                                                                   
    if _vped and type(_vped) == "string" and _vped:len() > 0 then
        local _yped = _bded(_tped)
        if not _yped or _yped:lower() ~= _vped:lower() then
            warn(string.format("[MATRIX][LOAD] Falha de integridade: SHA-256 do corpo (%s) diverge do anunciado pelo servidor (%s)", tostring(_yped), tostring(_vped)))
            self:Transition("ERROR_RECOVERABLE", {
                code = "DELIVERY_SHA_MISMATCH",
                message = "Falha de integridade: o script recebido diverge do hash anunciado pelo servidor."
            })
            return
        end
    else
                                                                                          
        if _xped ~= "legacy_unprotected" then
            warn("[MATRIX][LOAD] Falha de seguranca: cabecalho x-matrix-sha256 ausente na resposta V6.")
            self:Transition("ERROR_RECOVERABLE", {
                code = "DELIVERY_HEADER_MISSING",
                message = "Servidor nao enviou o cabecalho de integridade obrigatorio (x-matrix-sha256)."
            })
            return
        end
    end

                                                                
    local _zped = _tped:match("%-%-%s*%[MATRIX%-DISTRIBUTION%-V1%].-%-%-%s*distribution_id:%s*([%w_%-]+)")
    if _zped then
        _mked.Text = "BUILD: " .. tostring(_wped) .. " | DIST: " .. tostring(_zped):sub(1, 10)
    elseif _vped and _vped:len() > 0 then
        _mked.Text = "BUILD: " .. tostring(_wped) .. " | SHA: " .. _vped:sub(1, 8)
    end

    self:Transition("COMPILING_SCRIPT")
    local _aqed, _bqed = loadstring(_tped)
    if not _aqed then
        self:Transition("ERROR_RECOVERABLE", { code = "SCRIPT_COMPILE", message = tostring(_bqed):sub(1, 150) })
        return
    end

    self:Transition("EXECUTING")
    local _cqed, _dqed = pcall(_aqed)
    if not _cqed then
        self:Transition("ERROR_RECOVERABLE", { code = "SCRIPT_RUNTIME", message = tostring(_dqed):sub(1, 150) })
        return
    end

    self:Transition("RUNNING")
end

                                                                           
                                      
                                                                           
_jked.Activated:Connect(function()
    if _uked.IsBusy then return end
    if _uked.State == "PROMPTING_KEY" or _uked.State == "ERROR_FATAL" then
        local _eqed = _fked.Text:match("^%s*(.-)%s*$")
        if not _eqed or _eqed:len() < 8 then
            _rked("Digite uma key valida (minimo 8 caracteres).", true)
            return
        end
        _uked:Transition("EXCHANGING_KEY")
        task.spawn(function()
            _uked:ProcessExchange(_eqed, false)
        end)
    elseif _uked.State == "ERROR_RECOVERABLE" then
        if _uked.Session and _uked.Session.token then
            _uked:Transition("WAITING_GAME_LOAD")
            task.spawn(function()
                _uked:ProcessGameLoad()
            end)
        else
            _uked:Transition("PROMPTING_KEY")
        end
    end
end)

_nked.Activated:Connect(function()
    if _uked.IsBusy then return end
    if not _uked.Session or not _uked.Session.token then
        _rked("DIAGNOSTICO: valide sua key primeiro.", true)
        return
    end

    _uked.IsBusy = true
    _rked("Executando MATRIX Doctor...")
    task.spawn(function()
        local _fqed = {
            userId = _raed,
            sessionToken = _uked.Session.token,
            gameId = tostring(game.GameId),
            placeId = tostring(game.PlaceId)
        }
        local _gqed, _hqed = _iged.requestDirect("/v6/doctor", _fqed, 15)
        if not _gqed then
            _rked("DOCTOR FALHA: " .. tostring(_hqed and _hqed.code or "NET_ERROR"), true)
        else
            local _iqed = _leed(_gqed.body) or {}
            local _jqed = (_iqed.release and _iqed.release.version) or _iqed.fallback or "sem release"
            _rked(string.format("DOCTOR OK: ROTA %s | %s", tostring(_iqed.scriptPath or "/"), tostring(_jqed)))
        end
        _uked.IsBusy = false
    end)
end)

_oked.Activated:Connect(function()
    if _uked.IsBusy then return end
    _uked.IsBusy = true
    _rked("Revogando credencial...")

    task.spawn(function()
        if _uked.Session and _uked.Session.token then
            _iged.requestDirect("/v6/auth/logout", {
                userId = _raed,
                sessionToken = _uked.Session.token
            }, 10)
        end
        _nied()
        _yded.clearAllSessions()
        _uked.Session = nil
        _uked:Transition("PROMPTING_KEY")
        _rked("Sessao esquecida localmente. Insira sua key para reconectar.")
    end)
end)

                                     
task.defer(function()
    _uked:Start()
end)
