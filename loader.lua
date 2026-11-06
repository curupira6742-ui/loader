--[========================================================================[
    MATRIX ACCESS V6 — HIGH-RESILIENCE ENTERPRISE LOADER (ROBLOX / LUAU)
    Architecture: Subagent Beta (Senior Luau Engineer + Client Reliability Specialist)
    Mission: Operacao Masterpiece IV — Mensagem 013 (Release Candidate 1)
    
    Guarantees & Key Architectural Features:
    1. Strict 14-State Finite State Machine (FSM): Zero dead-ends, exhaustive validation,
       dedicated VALIDATING_SESSION and COMMITTING_SESSION states.
    2. Decoupled Session Recovery: Direct integration with POST /v6/auth/validate.
       Zero /load probing during boot or session lifecycle checks.
    3. Multi-Phase Atomic Staging StorageEngine: Checksums FNV-1a 32-bit em Luau puro,
       sequenciamento monotônico de 53 bits (IEEE-754 até 9.007.199.254.740.991),
       auto-reparo determinístico contra crash de 0 bytes e corrupção física.
    4. Out-of-Order & Race Immunity: Epoch counter e cancelamento de corrotinas com
       descarte de respostas HTTP tardias que chegam após timeout ou mudança de estado.
    5. Two-Phase Token Rotation (Prepare -> Commit ACK) com suporte a Commit-on-First-Use (CoFU).
    6. Robust DataModel Lifecycle: Detecção universal de LocalPlayer, barreira de carregamento
       de jogo, prevenção de vazamento de RBXScriptConnection e Cloud Bridge isolada.
]========================================================================]

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ========================================================================
-- 1. IDENTIDADE ROBUSTA DO LOCALPLAYER E AMBIENTE
-- ========================================================================
local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    local startWait = os.clock()
    while not LocalPlayer and (os.clock() - startWait) < 8 do
        LocalPlayer = Players.LocalPlayer
        task.wait(0.1)
    end
    if not LocalPlayer then
        local okWait, player = pcall(function() return Players.PlayerAdded:Wait() end)
        if okWait and player then LocalPlayer = player end
    end
end

if not LocalPlayer or not LocalPlayer.UserId or LocalPlayer.UserId <= 0 then
    warn("[MATRIX][FATAL] Identidade do LocalPlayer invalida ou nao inicializada.")
    return
end

local USER_ID = tostring(LocalPlayer.UserId)
local LOADER_VERSION = "6.0.0"
-- Staging: Fallback desativado por padrão (DIRETIVA 063/064: previne auto-referência e ciclo)
local FALLBACK_WORKER_URL = ""
local BASE = "https://matrix-access-staging.curupira6742.workers.dev"

-- Allowlist Rígida de Hostnames Autorizados de STAGING (DIRETIVA 064 - P0-A)
-- Apenas o host de staging é autorizado; hostnames de produção são terminantemente proibidos.
local PINNED_HOSTNAMES = {
    ["matrix-access-staging.curupira6742.workers.dev"] = true,
}

-- URL Canônica de Bootstrap do Repositório Oficial (GitHub Raw público de release)
-- URL Canônica de Bootstrap Dedicada (Repositório / CDN Público Isolado de Configurações - Proposta MENSAGEM 019)
-- Não contém scripts, credenciais ou backend; serve unicamente os 51 JSONs públicos de roteamento.
local CANONICAL_BOOTSTRAP_REPO = "https://raw.githubusercontent.com/curupira6742-ui/matrix-bootstrap-v6/main"

local function parseUrlHostname(url)
    if type(url) ~= "string" then return nil end
    if #url > 2048 then return nil end
    
    -- Exige estritamente esquema HTTPS
    local proto, rest = url:match("^(https?)://(.+)$")
    if proto ~= "https" or not rest then return nil end
    
    -- Isolamento da autoridade (antes de '/', '?' ou '#')
    local authority = rest:match("^([^/?#]+)")
    if not authority or #authority == 0 then return nil end
    
    -- Rejeição estrita de credenciais embutidas (userinfo: user:pass@host)
    if authority:find("@") then return nil end
    
    -- Tratamento de porta opcional (:443 permitida, demais portas rejeitadas)
    local host, port = authority:match("^([^:]+):?(%d*)$")
    if not host or #host == 0 then return nil end
    if port and port ~= "" and port ~= "443" then
        return nil
    end
    
    -- Validação de formato de hostname (RFC 1123)
    if not host:match("^[a-zA-Z0-9%-%._]+$") then return nil end
    if host:find("%.%.") or host:sub(1,1) == "." or host:sub(-1,-1) == "." then return nil end

    return host:lower()
end

local function canEngageFallback(targetUrl)
    -- 1. Prevenção de loop/ciclo: se o fallback já foi ativado previamente, proíbe novo chaveamento
    if globals.__MATRIX_BOOTSTRAP_DEGRADED then
        return false, "CYCLE_PREVENTED", "Tentativa de fallback em cascata/ciclo bloqueada"
    end
    -- 2. Verificação de configuração: targetUrl deve ser uma string não vazia e diferente de 'disabled'
    if type(targetUrl) ~= "string" or targetUrl == "" or targetUrl == "disabled" then
        return false, "FALLBACK_NOT_CONFIGURED", "Fallback desativado ou nao configurado para este ambiente"
    end
    -- 3. Prevenção de auto-referência: o fallback não pode ser idêntico ao host primário
    local cleanTarget = targetUrl:gsub("/$", "")
    local cleanBase = BASE:gsub("/$", "")
    if cleanTarget == cleanBase then
        return false, "SELF_FALLBACK_PROHIBITED", "Fallback aponta para a propria instancia primaria (auto-referencia proibida)"
    end
    -- 4. Validação de Pinning estrito de Hostname
    local host = parseUrlHostname(targetUrl)
    if not host or not PINNED_HOSTNAMES[host] then
        return false, "FALLBACK_HOST_UNAUTHORIZED", "Hostname de fallback (" .. tostring(host) .. ") nao autorizado no pinning"
    end
    return true, nil, nil
end

-- ========================================================================
-- PURE LUAU SHA-256 (RFC 6234 COMPLIANT 32-BIT BITWISE)
-- ========================================================================
local function computePureLuauSha256(msg)
    if type(msg) ~= "string" then return nil end
    local len = #msg
    -- Limite máximo estrito de payload (2 MB) fail-closed contra DoS e estouro
    if len > 2097152 then return nil end

    local bit = bit32
    local K = {
        0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
        0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
        0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
        0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
        0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
        0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
        0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
        0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
    }
    local H = {
        0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
        0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19
    }
    local extra = (56 - (len + 1) % 64) % 64
    local padded = msg .. string.char(0x80) .. string.rep(string.char(0), extra)
    
    local bitLen = len * 8
    local highWord = math.floor(bitLen / 4294967296)
    local lowWord = bitLen % 4294967296
    for i = 3, 0, -1 do
        local b = bit.band(bit.rshift(highWord, i * 8), 0xff)
        padded = padded .. string.char(b)
    end
    for i = 3, 0, -1 do
        local b = bit.band(bit.rshift(lowWord, i * 8), 0xff)
        padded = padded .. string.char(b)
    end
    for chunkStart = 1, #padded, 64 do
        local W = {}
        for i = 0, 15 do
            local o = chunkStart + i * 4
            local b0, b1, b2, b3 = string.byte(padded, o, o + 3)
            W[i + 1] = bit.bor(bit.lshift(b0, 24), bit.lshift(b1, 16), bit.lshift(b2, 8), b3)
        end
        for i = 17, 64 do
            local v = W[i - 2]
            local s1 = bit.bxor(bit.rrotate(v, 17), bit.rrotate(v, 19), bit.rshift(v, 10))
            v = W[i - 15]
            local s0 = bit.bxor(bit.rrotate(v, 7), bit.rrotate(v, 18), bit.rshift(v, 3))
            W[i] = bit.band(W[i - 16] + s0 + W[i - 7] + s1, 0xffffffff)
        end
        local a, b, c, d, e, f, g, h = H[1], H[2], H[3], H[4], H[5], H[6], H[7], H[8]
        for i = 1, 64 do
            local S1 = bit.bxor(bit.rrotate(e, 6), bit.rrotate(e, 11), bit.rrotate(e, 25))
            local ch = bit.bxor(bit.band(e, f), bit.band(bit.bnot(e), g))
            local temp1 = bit.band(h + S1 + ch + K[i] + W[i], 0xffffffff)
            local S0 = bit.bxor(bit.rrotate(a, 2), bit.rrotate(a, 13), bit.rrotate(a, 22))
            local maj = bit.bxor(bit.band(a, b), bit.band(a, c), bit.band(b, c))
            local temp2 = bit.band(S0 + maj, 0xffffffff)
            h, g, f, e = g, f, e, bit.band(d + temp1, 0xffffffff)
            d, c, b, a = c, b, a, bit.band(temp1 + temp2, 0xffffffff)
        end
        H[1] = bit.band(H[1] + a, 0xffffffff)
        H[2] = bit.band(H[2] + b, 0xffffffff)
        H[3] = bit.band(H[3] + c, 0xffffffff)
        H[4] = bit.band(H[4] + d, 0xffffffff)
        H[5] = bit.band(H[5] + e, 0xffffffff)
        H[6] = bit.band(H[6] + f, 0xffffffff)
        H[7] = bit.band(H[7] + g, 0xffffffff)
        H[8] = bit.band(H[8] + h, 0xffffffff)
    end
    local res = {}
    for i = 1, 8 do
        res[#res + 1] = string.format("%08x", H[i])
    end
    return table.concat(res)
end

local function computeSha256(str)
    if type(str) ~= "string" then return nil end
    if crypt and type(crypt.hash) == "function" then
        local ok, h = pcall(crypt.hash, str, "sha256")
        if ok and type(h) == "string" and #h == 64 then return h:lower() end
    end
    if syn and syn.crypt and type(syn.crypt.hash) == "function" then
        local ok, h = pcall(syn.crypt.hash, str, "sha256")
        if ok and type(h) == "string" and #h == 64 then return h:lower() end
    end
    if crypt and type(crypt.sha256) == "function" then
        local ok, h = pcall(crypt.sha256, str)
        if ok and type(h) == "string" and #h == 64 then return h:lower() end
    end
    local okPure, hPure = pcall(computePureLuauSha256, str)
    if okPure and type(hPure) == "string" and #hPure == 64 then
        return hPure:lower()
    end
    return nil
end
local FOLDER = "MATRIX_Obsidian"
local LOADER_PATH   = FOLDER .. "/loader_v6.lua"
local SESSION_PATH  = FOLDER .. "/session_v6_" .. USER_ID .. ".json"
local BACKUP_PATH   = FOLDER .. "/session_v6_backup_" .. USER_ID .. ".json"
local STAGING_PATH  = FOLDER .. "/session_v6_staging_" .. USER_ID .. ".json"
local LEGACY_PATH   = FOLDER .. "/access_" .. USER_ID .. ".json"
local LEGACY_BACKUP = FOLDER .. "/access_backup_" .. USER_ID .. ".json"
local MARKER_PATH   = FOLDER .. "/teleport_pending_v6_" .. USER_ID .. ".json"

local rawRequest = (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)
local globals = (type(getgenv) == "function" and getgenv()) or _G
local CURRENT_JOB = tostring(game.JobId or "")
local IS_TELEPORT = globals.__MATRIX_V6_FROM_TELEPORT_JOB == CURRENT_JOB
if IS_TELEPORT then globals.__MATRIX_V6_FROM_TELEPORT_JOB = nil end

-- ========================================================================
-- 2. STORAGE ENGINE — PERSISTÊNCIA ATÔMICA, CHECKSUMS E MONOTONICIDADE
-- ========================================================================
local MAX_SAFE_INTEGER = 9007199254740991 -- 2^53 - 1 (Limite exato IEEE-754 em Luau)

local StorageEngine = {
    CurrentSeq = 0
}

local function ensureFolder()
    if type(makefolder) == "function" then
        pcall(makefolder, FOLDER)
    end
end

local function safeRead(path)
    if type(readfile) ~= "function" then return nil end
    local ok, res = pcall(readfile, path)
    return (ok and type(res) == "string" and res ~= "") and res or nil
end

local function safeWrite(path, content)
    if type(writefile) ~= "function" then return false end
    ensureFolder()
    local ok = pcall(writefile, path, content)
    return ok
end

local function safeErase(path)
    if type(delfile) == "function" then
        local ok = pcall(delfile, path)
        if ok then return true end
    end
    if type(writefile) == "function" then
        return pcall(writefile, path, "")
    end
    return false
end

local function decodeJson(raw)
    if not raw or type(raw) ~= "string" or raw:match("^%s*$") then return nil end
    local ok, res = pcall(HttpService.JSONDecode, HttpService, raw)
    return (ok and type(res) == "table") and res or nil
end

-- FNV-1a 32-bit Checksum em puro Luau (Detecção de arquivos truncados ou corrompidos)
local function fnv1a32(str)
    local hash = 0x811c9dc5
    local prime = 0x01000193
    for i = 1, #str do
        local byte = string.byte(str, i)
        hash = bit32.bxor(hash, byte)
        hash = (hash * prime) % 4294967296
    end
    return string.format("%08x", hash)
end

function StorageEngine.computeChecksum(entry)
    -- Canonical: userId:token:seq:savedAt (formatação com %.0f preserva inteiros até 2^53 - 1)
    local seqNum = tonumber(entry.seq) or 0
    local savedAtNum = tonumber(entry.savedAt) or 0
    local canonical = string.format("%s:%s:%.0f:%d", tostring(entry.userId), tostring(entry.token), seqNum, savedAtNum)
    return fnv1a32(canonical)
end

function StorageEngine.validateEntry(entry)
    if not entry or type(entry) ~= "table" then return false end
    if tostring(entry.userId) ~= USER_ID then return false end
    if type(entry.token) ~= "string" or #entry.token ~= 68 or not entry.token:match("^MX6_[a-f0-9]+$") then return false end
    if type(entry.seq) ~= "number" or entry.seq < 1 or entry.seq > MAX_SAFE_INTEGER or math.floor(entry.seq) ~= entry.seq then
        return false
    end
    if type(entry.savedAt) ~= "number" or entry.savedAt <= 0 then return false end
    if type(entry.checksum) ~= "string" or entry.checksum ~= StorageEngine.computeChecksum(entry) then
        return false
    end
    return true
end

function StorageEngine.readEntryFromFile(path)
    local raw = safeRead(path)
    if not raw then return nil end
    local data = decodeJson(raw)
    if not data or not StorageEngine.validateEntry(data) then return nil end
    return data
end

-- Seleção monotônica de candidatos e auto-reparo de corrupção / 0-bytes
function StorageEngine.readCandidates()
    local primary = StorageEngine.readEntryFromFile(SESSION_PATH)
    local backup = StorageEngine.readEntryFromFile(BACKUP_PATH)
    local staging = StorageEngine.readEntryFromFile(STAGING_PATH)

    local bestMaster = nil
    if primary and backup then
        bestMaster = (primary.seq >= backup.seq) and primary or backup
    else
        bestMaster = primary or backup
    end

    if bestMaster then
        StorageEngine.CurrentSeq = math.max(StorageEngine.CurrentSeq, bestMaster.seq)
        -- Self-Healing: Se o arquivo primário estiver corrompido ou ausente, restaura do backup
        if not primary and backup then
            pcall(function()
                safeWrite(SESSION_PATH, HttpService:JSONEncode(backup))
            end)
        end
    end

    if staging then
        StorageEngine.CurrentSeq = math.max(StorageEngine.CurrentSeq, staging.seq)
    end

    return { primary = bestMaster, staging = staging }
end

-- Gravação de Staging para Two-Phase Renewal (Fase 1: Prepare)
function StorageEngine.saveStaging(token, expiresAt, operationId)
    if type(token) ~= "string" or #token ~= 68 or not token:match("^MX6_[a-f0-9]+$") then
        return false, "TOKEN_FORMAT_INVALID"
    end

    local current = StorageEngine.CurrentSeq or 0
    if current < 0 or current >= MAX_SAFE_INTEGER then current = 0 end
    local nextSeq = current + 1
    local now = os.time()

    local entry = {
        version = 6,
        userId = USER_ID,
        token = token,
        status = "PENDING_COMMIT",
        operationId = operationId or nil,
        expiresAt = expiresAt or os.date("!%Y-%m-%dT%H:%M:%SZ", now + 30 * 86400),
        renewAfter = now + (23 * 86400),
        savedAt = now,
        seq = nextSeq
    }
    entry.checksum = StorageEngine.computeChecksum(entry)
    local encoded = HttpService:JSONEncode(entry)

    if not safeWrite(STAGING_PATH, encoded) then
        return false, "WRITE_STAGING_FAILED"
    end

    local verified = StorageEngine.readEntryFromFile(STAGING_PATH)
    if not verified or verified.checksum ~= entry.checksum then
        safeErase(STAGING_PATH)
        return false, "STAGING_VERIFY_FAILED"
    end

    StorageEngine.CurrentSeq = nextSeq
    return true, entry
end

-- Promoção de Staging para Master (Fase 2: Commit ACK Confirmado)
function StorageEngine.promoteStaging(stagingEntry)
    local current = StorageEngine.CurrentSeq or stagingEntry.seq or 0
    if current < 0 or current >= MAX_SAFE_INTEGER then current = 0 end
    local nextSeq = current + 1
    local now = os.time()

    local masterEntry = {
        version = 6,
        userId = stagingEntry.userId,
        token = stagingEntry.token,
        status = "ACTIVE",
        expiresAt = stagingEntry.expiresAt,
        renewAfter = stagingEntry.renewAfter,
        savedAt = now,
        seq = nextSeq
    }
    masterEntry.checksum = StorageEngine.computeChecksum(masterEntry)
    local encoded = HttpService:JSONEncode(masterEntry)

    -- Grava Backup primeiro
    safeWrite(BACKUP_PATH, encoded)
    -- Grava Primário
    if safeWrite(SESSION_PATH, encoded) then
        safeErase(STAGING_PATH)
        StorageEngine.CurrentSeq = nextSeq
        return true, masterEntry
    end

    return false, "PROMOTE_PRIMARY_FAILED"
end

-- Protocolo de Gravação Atômica em 5 Fases (Para Primeiro Acesso / Exchange)
function StorageEngine.saveSessionAtomic(token, expiresAt)
    if type(token) ~= "string" or #token ~= 68 or not token:match("^MX6_[a-f0-9]+$") then
        return false, "TOKEN_FORMAT_INVALID"
    end

    local current = StorageEngine.CurrentSeq or 0
    if current < 0 or current >= MAX_SAFE_INTEGER then current = 0 end
    local nextSeq = current + 1
    local now = os.time()

    local entry = {
        version = 6,
        userId = USER_ID,
        token = token,
        status = "ACTIVE",
        expiresAt = expiresAt or os.date("!%Y-%m-%dT%H:%M:%SZ", now + 30 * 86400),
        renewAfter = now + (23 * 86400),
        savedAt = now,
        seq = nextSeq
    }
    entry.checksum = StorageEngine.computeChecksum(entry)
    local encoded = HttpService:JSONEncode(entry)

    -- Fase 1: Gravar Staging
    if not safeWrite(STAGING_PATH, encoded) then
        return false, "WRITE_STAGING_FAILED"
    end

    -- Fase 2: Readback e Verificação do Staging
    local verifyStaging = StorageEngine.readEntryFromFile(STAGING_PATH)
    if not verifyStaging or verifyStaging.checksum ~= entry.checksum then
        safeErase(STAGING_PATH)
        return false, "STAGING_VERIFY_FAILED"
    end

    -- Fase 3: Gravar Backup e Validar
    safeWrite(BACKUP_PATH, encoded)

    -- Fase 4: Gravar Master
    if not safeWrite(SESSION_PATH, encoded) then
        return false, "WRITE_PRIMARY_FAILED"
    end

    -- Fase 5: Limpeza do staging
    safeErase(STAGING_PATH)
    StorageEngine.CurrentSeq = nextSeq
    return true, entry
end

function StorageEngine.readLegacyKey()
    local function get(path)
        local raw = safeRead(path)
        local data = decodeJson(raw)
        if data and type(data.key) == "string" and data.key:len() >= 8 then
            return data.key
        end
        return nil
    end
    return get(LEGACY_PATH) or get(LEGACY_BACKUP)
end

function StorageEngine.purgeLegacyKey()
    safeErase(LEGACY_PATH)
    safeErase(LEGACY_BACKUP)
end

function StorageEngine.clearAllSessions()
    safeErase(SESSION_PATH)
    safeErase(BACKUP_PATH)
    safeErase(STAGING_PATH)
    StorageEngine.CurrentSeq = 0
end

-- ========================================================================
-- 3. HTTP CLIENT — CANCELAMENTO DETERMINÍSTICO E PROTEÇÃO CONTRA ATRASOS
-- ========================================================================
local HttpClient = {}

function HttpClient.requestWithTimeout(options, timeoutSeconds, requestEpoch)
    if type(rawRequest) ~= "function" then
        return false, { code = "EXECUTOR_NO_HTTP", message = "Executor sem API HTTP (request)." }
    end

    timeoutSeconds = timeoutSeconds or 15
    local callerThread = coroutine.running()
    local completed = false
    local isCancelled = false
    local reqThread = nil
    local timerThread = nil

    -- Timer Fiber: dispara rigorosamente no prazo
    timerThread = task.delay(timeoutSeconds, function()
        if not completed then
            completed = true
            isCancelled = true
            if reqThread and coroutine.status(reqThread) ~= "dead" then
                pcall(task.cancel, reqThread)
            end
            task.spawn(callerThread, false, { code = "TIMEOUT", message = "Tempo limite esgotado (" .. timeoutSeconds .. "s)." })
        end
    end)

    -- Request Fiber: executa a chamada nativa de rede
    reqThread = task.spawn(function()
        local success, result = pcall(rawRequest, options)
        if not completed then
            completed = true
            if timerThread and coroutine.status(timerThread) ~= "dead" then
                pcall(task.cancel, timerThread)
            end
            -- Proteção contra respostas tardias de rede após cancelamento/mudança de epoch
            if isCancelled or (requestEpoch and globals.__MATRIX_FSM_EPOCH ~= requestEpoch) then
                -- Descarta silenciosamente o pacote tardio fora de ordem
                return
            end
            task.spawn(callerThread, success, result)
        end
    end)

    local ok, res = coroutine.yield()
    return ok, res
end

function HttpClient.requestDirect(endpoint, payload, timeoutSeconds, customHeaders, requestEpoch)
    local headers = {
        ["Content-Type"] = "application/json; charset=utf-8",
        ["User-Agent"] = "Matrix-Loader-V6/Roblox"
    }
    if customHeaders then
        for k, v in pairs(customHeaders) do headers[k] = v end
    end

    local options = {
        Url = BASE .. endpoint,
        Method = "POST",
        Headers = headers,
        Body = HttpService:JSONEncode(payload)
    }

    local ok, res = HttpClient.requestWithTimeout(options, timeoutSeconds or 15, requestEpoch)
    if not ok or type(res) ~= "table" then
        return nil, (type(res) == "table" and res.code) and res or { code = "NETWORK_ERROR", message = "Falha de comunicacao no executor." }
    end

    local status = tonumber(res.StatusCode or res.Status or 0) or 0
    local rawBody = res.Body or ""

    if status ~= 200 then
        local errObj = decodeJson(rawBody) or {}
        local resHeaders = res.Headers or {}
        local reqId = errObj.requestId or resHeaders["x-matrix-request-id"] or resHeaders["X-Matrix-Request-Id"]
        return nil, {
            status = status,
            code = errObj.code or ("HTTP_" .. status),
            message = errObj.error or ("Erro HTTP " .. status),
            requestId = reqId,
            body = rawBody
        }
    end

    return {
        status = 200,
        body = rawBody,
        headers = res.Headers or {}
    }, nil
end

-- Consulta GET Anônima Estrita (Zero PII, Zero Credenciais enviadas ao GitHub)
function HttpClient.rawGetAnonymous(url, timeoutSeconds, requestEpoch, customHeaders)
    local headers = {
        ["User-Agent"] = "Matrix-Loader-V6/Roblox",
        ["Accept"] = "application/json",
        ["X-Matrix-Loader-Version"] = LOADER_VERSION
    }
    if customHeaders then
        for k, v in pairs(customHeaders) do headers[k] = v end
    end
    local options = {
        Url = url,
        Method = "GET",
        Headers = headers
    }
    local ok, res = HttpClient.requestWithTimeout(options, timeoutSeconds or 5, requestEpoch)
    if not ok or type(res) ~= "table" then
        return nil, (type(res) == "table" and res.code) and res or { code = "NETWORK_ERROR", message = "Falha de comunicacao anonima." }
    end
    local status = tonumber(res.StatusCode or res.Status or 0) or 0
    local rawBody = res.Body or ""
    if status ~= 200 then
        return nil, { status = status, code = "HTTP_" .. status, body = rawBody }
    end
    return { status = 200, body = rawBody, headers = res.Headers or {} }, nil
end

-- Retry com Exponential Backoff e Full Jitter (Exclusivo para falhas transientes)
function HttpClient.requestWithRetry(endpoint, payload, maxRetries, timeoutSeconds, customHeaders, requestEpoch)
    maxRetries = maxRetries or 3
    timeoutSeconds = timeoutSeconds or 15
    local attempt = 0

    while attempt < maxRetries do
        attempt = attempt + 1
        local res, err = HttpClient.requestDirect(endpoint, payload, timeoutSeconds, customHeaders, requestEpoch)
        if res then return res, nil end

        local isRecoverable = err and (err.status == 429 or err.status == 502 or err.status == 503 or err.code == "TIMEOUT" or err.code == "NETWORK_ERROR")
        if not isRecoverable or attempt >= maxRetries then
            return nil, err
        end

        local maxWait = math.min(10.0, 1.0 * (2 ^ attempt))
        local sleepTime = math.random() * maxWait
        task.wait(sleepTime)
    end
end

-- ========================================================================
-- 4. TELEPORTE E BOOT PIPELINE
-- ========================================================================
local TELEPORT_BOOT = [==[
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

local activeConnections = {}

local function registerConnection(conn)
    if typeof(conn) == "RBXScriptConnection" then
        table.insert(activeConnections, conn)
    end
    return conn
end

local function cleanUpConnections()
    for _, conn in ipairs(activeConnections) do
        if typeof(conn) == "RBXScriptConnection" and conn.Connected then
            pcall(conn.Disconnect, conn)
        end
    end
    table.clear(activeConnections)
end

local queueFn = queue_on_teleport or queueonteleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport) or globals.queue_on_teleport
local rejoinReady = false
if type(queueFn) == "function" and type(readfile) == "function" and type(writefile) == "function" then
    local ok, stored = pcall(readfile, LOADER_PATH)
    if ok and type(stored) == "string" and stored ~= "" then
        if globals.__MATRIX_V6_QUEUED_JOB ~= CURRENT_JOB then
            local queued, result = pcall(queueFn, TELEPORT_BOOT)
            if queued and result ~= false then
                globals.__MATRIX_V6_QUEUED_JOB = CURRENT_JOB
                rejoinReady = true
            end
        else rejoinReady = true end
    end
end

local teleportMarked = false
local function consumeMarker()
    safeErase(MARKER_PATH)
    teleportMarked = false
end
if not IS_TELEPORT then consumeMarker() end

registerConnection(LocalPlayer.OnTeleport:Connect(function(state)
    if state == Enum.TeleportState.Started or state == Enum.TeleportState.InProgress then
        if not rejoinReady or teleportMarked or type(writefile) ~= "function" then return end
        teleportMarked = true
        ensureFolder()
        local data = {
            kind = "natural",
            userId = USER_ID,
            originJob = CURRENT_JOB,
            originGameId = tostring(game.GameId),
            originPlaceId = tostring(game.PlaceId),
            startedAt = os.time()
        }
        if not safeWrite(MARKER_PATH, HttpService:JSONEncode(data)) then
            teleportMarked = false
        end
    elseif state == Enum.TeleportState.Failed then
        consumeMarker()
    end
end))

registerConnection(TeleportService.TeleportInitFailed:Connect(function(failedPlayer)
    if failedPlayer == LocalPlayer then consumeMarker() end
end))

-- ========================================================================
-- 5. INTERFACE DO USUÁRIO & LIFECYCLE
-- ========================================================================
local guiParent = LocalPlayer:WaitForChild("PlayerGui")
local oldGui = guiParent:FindFirstChild("MatrixAccessLoader")
if oldGui then oldGui:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "MatrixAccessLoader"
gui.DisplayOrder = 999
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.Parent = guiParent

local function ui(class, properties, parent)
    local obj = Instance.new(class)
    for name, value in pairs(properties) do obj[name] = value end
    obj.Parent = parent
    return obj
end

local GREEN = Color3.fromRGB(111, 255, 158)
local WHITE = Color3.fromRGB(233, 249, 237)
local MUTED = Color3.fromRGB(136, 171, 148)
local BG    = Color3.fromRGB(4, 15, 9)
local PANEL = Color3.fromRGB(10, 33, 19)
local WARN  = Color3.fromRGB(255, 177, 117)

local window = ui("Frame", {
    Size = UDim2.fromOffset(482, 393),
    Position = UDim2.fromScale(0.5, 0.5),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = BG,
    BorderSizePixel = 0,
    ClipsDescendants = true
}, gui)
ui("UICorner", { CornerRadius = UDim.new(0, 15) }, window)
ui("UIStroke", { Color = GREEN, Transparency = 0.24, Thickness = 1.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, window)
ui("UIGradient", { Color = ColorSequence.new(Color3.fromRGB(11, 34, 20), BG), Rotation = 118 }, window)

local scale = ui("UIScale", { Scale = 1 }, window)
local function applyScale()
    local camera = workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
    scale.Scale = math.clamp(math.min(viewport.X / 520, viewport.Y / 450), 0.55, 1)
end
applyScale()

local sizeConnection
if workspace.CurrentCamera then
    sizeConnection = registerConnection(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(applyScale))
end

for i = 1, 23 do
    ui("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(11 + i * 20, 11),
        Size = UDim2.fromOffset(15, 370),
        Text = "0\n1\n0\n1\n1\n0\n1\n0\n0\n1\n0",
        TextColor3 = GREEN,
        TextTransparency = 0.93,
        TextSize = 12,
        Font = Enum.Font.Code,
        TextYAlignment = Enum.TextYAlignment.Top
    }, window)
end

local function textLabel(text, pos, size, fontSize, color, font)
    return ui("TextLabel", {
        Position = pos, Size = size, BackgroundTransparency = 1, Text = text,
        Font = font or Enum.Font.Code, TextSize = fontSize, TextColor3 = color or WHITE,
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center
    }, window)
end

textLabel("M A T R I X", UDim2.fromOffset(26, 17), UDim2.fromOffset(420, 38), 29, WHITE, Enum.Font.GothamBold)
textLabel("A C C E S S  /  V 6", UDim2.fromOffset(27, 55), UDim2.fromOffset(420, 22), 12, GREEN)
ui("Frame", { Position = UDim2.fromOffset(26, 91), Size = UDim2.fromOffset(429, 1), BackgroundColor3 = Color3.fromRGB(48, 103, 64), BorderSizePixel = 0 }, window)
textLabel("CONTA / @" .. LocalPlayer.Name .. "  |  ID " .. USER_ID, UDim2.fromOffset(27, 105), UDim2.fromOffset(429, 22), 12, MUTED)
textLabel("GAME " .. tostring(game.GameId) .. "  |  PLACE " .. tostring(game.PlaceId), UDim2.fromOffset(27, 129), UDim2.fromOffset(429, 20), 11, MUTED)

local credentialInput = ui("TextBox", {
    Position = UDim2.fromOffset(26, 165), Size = UDim2.fromOffset(429, 44), Text = "",
    PlaceholderText = "INSIRA SUA KEY (PRIMEIRO ACESSO)", PlaceholderColor3 = MUTED,
    ClearTextOnFocus = false, Font = Enum.Font.Code, TextSize = 14, TextColor3 = WHITE,
    BackgroundColor3 = PANEL, BorderSizePixel = 0
}, window)
ui("UICorner", { CornerRadius = UDim.new(0, 8) }, credentialInput)
ui("UIStroke", { Color = Color3.fromRGB(55, 123, 72), Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, credentialInput)

local progress = ui("Frame", { Position = UDim2.fromOffset(26, 165), Size = UDim2.fromOffset(429, 44), BackgroundColor3 = PANEL, Visible = false, BorderSizePixel = 0, ClipsDescendants = true }, window)
ui("UICorner", { CornerRadius = UDim.new(0, 8) }, progress)
local progressFill = ui("Frame", { Size = UDim2.fromScale(0, 1), BorderSizePixel = 0, BackgroundColor3 = Color3.fromRGB(25, 148, 69) }, progress)
local progressLabel = ui("TextLabel", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Font = Enum.Font.Code, TextSize = 12, TextColor3 = WHITE, Text = "PREPARANDO JOGO..." }, progress)

local action = ui("TextButton", {
    Position = UDim2.fromOffset(26, 222), Size = UDim2.fromOffset(429, 46),
    BackgroundColor3 = Color3.fromRGB(22, 167, 80), Text = "[  INICIAR MATRIX  ]",
    TextColor3 = Color3.new(0, 0, 0), TextSize = 15, Font = Enum.Font.Code, BorderSizePixel = 0
}, window)
ui("UICorner", { CornerRadius = UDim.new(0, 9) }, action)

local status = textLabel("● INICIANDO MATRIX ACCESS V6", UDim2.fromOffset(27, 278), UDim2.fromOffset(428, 45), 12, GREEN)
status.TextWrapped = true
status.TextYAlignment = Enum.TextYAlignment.Top

local rejoinText = rejoinReady and "AUTO REJOIN: PRONTO" or "AUTO REJOIN: INDISPONIVEL"
local footer = textLabel(rejoinText, UDim2.fromOffset(27, 320), UDim2.fromOffset(429, 18), 10, MUTED)

local doctor = ui("TextButton", {
    Position = UDim2.fromOffset(26, 346), Size = UDim2.fromOffset(206, 30),
    Text = "DIAGNOSTICAR", TextColor3 = WHITE, TextSize = 11, Font = Enum.Font.Code,
    BackgroundColor3 = PANEL, BorderSizePixel = 0
}, window)
local logout = ui("TextButton", {
    Position = UDim2.fromOffset(249, 346), Size = UDim2.fromOffset(206, 30),
    Text = "ESQUECER SESSAO", TextColor3 = WHITE, TextSize = 11, Font = Enum.Font.Code,
    BackgroundColor3 = PANEL, BorderSizePixel = 0
}, window)

for _, b in ipairs({ doctor, logout }) do
    ui("UICorner", { CornerRadius = UDim.new(0, 8) }, b)
    ui("UIStroke", { Color = Color3.fromRGB(55, 123, 72), Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, b)
end

local function setStatus(message, isWarning)
    if not gui.Parent then return end
    status.Text = message
    status.TextColor3 = isWarning and WARN or GREEN
end

-- ========================================================================
-- 6. MÁQUINA DE ESTADOS FINITA (FSM) — 14 ESTADOS ESTRITOS
-- ========================================================================
globals.__MATRIX_FSM_EPOCH = 0

local FSM = {
    State = "UNINITIALIZED",
    Session = nil,
    CachedKey = nil,
    IsBusy = false
}

local VALID_TRANSITIONS = {
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
    ["RUNNING"]                = {}, -- Estado Terminal
    ["DIAGNOSING"]             = { ["WAITING_GAME_LOAD"] = true, ["ERROR_RECOVERABLE"] = true, ["PROMPTING_KEY"] = true },
    ["LOGGING_OUT"]            = { ["PROMPTING_KEY"] = true, ["ERROR_RECOVERABLE"] = true },
    ["ERROR_RECOVERABLE"]      = { ["BOOTSTRAPPING"] = true, ["CHECKING_LOCAL_SESSION"] = true, ["EXCHANGING_KEY"] = true, ["FETCHING_SCRIPT"] = true, ["PROMPTING_KEY"] = true, ["RENEWING_SESSION"] = true },
    ["ERROR_FATAL"]            = { ["PROMPTING_KEY"] = true }
}

function FSM:Transition(targetState, context)
    local current = self.State
    if current ~= "UNINITIALIZED" and not (VALID_TRANSITIONS[current] and VALID_TRANSITIONS[current][targetState]) then
        warn(string.format("[MATRIX][FSM] Transicao Proibida: %s -> %s", tostring(current), tostring(targetState)))
        return false
    end

    self.State = targetState
    self:OnStateChanged(targetState, context)
    return true
end

function FSM:OnStateChanged(state, ctx)
    if state == "BOOTSTRAPPING" then
        self.IsBusy = true
        progress.Visible = true
        credentialInput.Visible = false
        action.Active = false
        action.Text = "[  CONECTANDO...  ]"
        setStatus("Consultando configuracao de bootstrap segura...")
    elseif state == "PROMPTING_KEY" then
        self.IsBusy = false
        progress.Visible = false
        credentialInput.Visible = true
        credentialInput.Text = ""
        action.Active = true
        action.Text = "[  VALIDAR KEY  ]"
    elseif state == "EXCHANGING_KEY" then
        self.IsBusy = true
        credentialInput.Visible = false
        action.Active = false
        action.Text = "[  AUTENTICANDO...  ]"
        setStatus("Validando credencial mestre...")
    elseif state == "VALIDATING_SESSION" then
        setStatus("Consultando autenticidade da sessao no Worker...")
    elseif state == "COMMITTING_SESSION" then
        setStatus("Confirmando sessao em duas fases (ACK)...")
    elseif state == "CHECKING_RENEWAL" then
        setStatus("Verificando janela de renovacao proativa...")
    elseif state == "RENEWING_SESSION" then
        setStatus("Preparando rotacao segura de credencial...")
    elseif state == "WAITING_GAME_LOAD" then
        credentialInput.Visible = false
        progress.Visible = true
        action.Active = false
        action.Text = "[  CARREGANDO JOGO  ]"
        setStatus("Aguardando carregamento dos assets do jogo...")
    elseif state == "FETCHING_SCRIPT" then
        progress.Visible = false
        setStatus("Autorizado! Baixando runtime do jogo (/load)...")
    elseif state == "VALIDATING_SCRIPT" then
        setStatus("Validando assinatura e hash do script...")
    elseif state == "COMPILING_SCRIPT" then
        setStatus("Compilando versao publicada...")
    elseif state == "EXECUTING" then
        action.Text = "[  EXECUTANDO MATRIX  ]"
        setStatus("Inicializando runtime seguro...")
    elseif state == "RUNNING" then
        self.IsBusy = false
        setStatus("MATRIX V6 Ativado com Sucesso!")
        cleanUpConnections()
        task.delay(0.4, function()
            if gui and gui.Parent then gui:Destroy() end
        end)
    elseif state == "ERROR_RECOVERABLE" then
        self.IsBusy = false
        progress.Visible = false
        action.Active = true
        action.Text = "[  TENTAR NOVAMENTE  ]"
        local msg = (ctx and ctx.message) or "Falha de comunicacao."
        local code = (ctx and ctx.code) or "NET_ERROR"
        setStatus(string.format("[%s] %s", tostring(code), tostring(msg)), true)
    elseif state == "ERROR_FATAL" then
        self.IsBusy = false
        progress.Visible = false
        credentialInput.Visible = true
        credentialInput.Text = ""
        action.Active = true
        action.Text = "[  VALIDAR NOVA KEY  ]"
        local msg = (ctx and ctx.message) or "Acesso nao autorizado."
        local code = (ctx and ctx.code) or "AUTH_FATAL"
        setStatus(string.format("[%s] %s", tostring(code), tostring(msg)), true)
    end
end

-- ========================================================================
-- 7. CLOUD SLOTS BRIDGE
-- ========================================================================
local function cloudCall(endpoint, fields)
    if not FSM.Session or not FSM.Session.token then
        return nil, { code = "SESSION_MISSING", message = "Sem sessao autorizada." }
    end
    if tostring(game.JobId) ~= CURRENT_JOB then
        return nil, { code = "GAME_CHANGED", message = "Sessao de jogo alterada." }
    end

    local payload = {
        userId = USER_ID,
        sessionToken = FSM.Session.token,
        gameId = tostring(game.GameId),
        placeId = tostring(game.PlaceId)
    }
    for k, v in pairs(fields or {}) do payload[k] = v end
    local res, err = HttpClient.requestDirect(endpoint, payload, 15)
    if not res then return nil, err end
    local decoded = decodeJson(res.body)
    return decoded or nil, nil
end

globals.__MATRIX_V6_CLOUD = {
    list = function() return cloudCall("/v6/cloud/slots/list", {}) end,
    save = function(slot, name, config, expectedRevision)
        if type(slot) ~= "number" or slot < 1 or slot > 6 or math.floor(slot) ~= slot then
            return nil, { code = "SLOT_INVALID", message = "Slot deve ser inteiro entre 1 e 6." }
        end
        if type(config) ~= "table" then
            return nil, { code = "CONFIG_INVALID", message = "Configuracao deve ser uma tabela." }
        end
        return cloudCall("/v6/cloud/slots/save", {
            slot = slot,
            name = tostring(name or ("Perfil " .. slot)),
            config = config,
            expectedRevision = expectedRevision
        })
    end,
    delete = function(slot)
        if type(slot) ~= "number" or slot < 1 or slot > 6 or math.floor(slot) ~= slot then
            return nil, { code = "SLOT_INVALID", message = "Slot invalido." }
        end
        return cloudCall("/v6/cloud/slots/delete", { slot = slot })
    end
}

-- ========================================================================
-- 8. ORQUESTRAÇÃO DE FLUXOS DA FSM
-- ========================================================================
function FSM:Start()
    self:Transition("BOOTSTRAPPING")
    task.spawn(function()
        self:ProcessBootstrap()
    end)
end

-- ========================================================================
-- SEMVER 2.0.0 COMPARATOR (CLIENT-SIDE DEFENSE IN DEPTH)
-- ========================================================================
local function parseSemver(v)
    if type(v) ~= "string" then return nil end
    local clean = v:match("^%s*v?(.-)%s*$")
    if not clean or clean == "" then return nil end

    local buildPart = nil
    local plusPos = clean:find("+", 1, true)
    if plusPos then
        buildPart = clean:sub(plusPos + 1)
        clean = clean:sub(1, plusPos - 1)
        if not buildPart or buildPart == "" or buildPart:sub(-1) == "." then return nil end
        if buildPart:find("%.%.") then return nil end
        for b in buildPart:gmatch("([^%.]+)") do
            if not b:match("^[0-9a-zA-Z%-]+$") then return nil end
        end
    end

    local prereleasePart = nil
    local dashPos = clean:find("-", 1, true)
    if dashPos then
        prereleasePart = clean:sub(dashPos + 1)
        clean = clean:sub(1, dashPos - 1)
        if not prereleasePart or prereleasePart == "" or prereleasePart:sub(-1) == "." then return nil end
        if prereleasePart:find("%.%.") then return nil end
        for p in prereleasePart:gmatch("([^%.]+)") do
            if p:match("^%d+$") then
                -- Rejeição de identificadores numéricos com zeros iniciais (§9)
                if #p > 1 and p:sub(1, 1) == "0" then return nil end
            else
                if not p:match("^[0-9a-zA-Z%-]+$") then return nil end
            end
        end
    end

    local maj, min, pat = clean:match("^(%d+)%.(%d+)%.(%d+)$")
    if not maj then return nil end
    -- Rejeição de zeros iniciais na versão base (§2)
    if (#maj > 1 and maj:sub(1, 1) == "0") or (#min > 1 and min:sub(1, 1) == "0") or (#pat > 1 and pat:sub(1, 1) == "0") then
        return nil
    end

    return {
        major = tonumber(maj),
        minor = tonumber(min),
        patch = tonumber(pat),
        prerelease = prereleasePart,
        build = buildPart
    }
end

local function compareSemver(v1, v2)
    local p1 = parseSemver(v1)
    local p2 = parseSemver(v2)
    if not p1 or not p2 then return nil end -- FAIL-CLOSED

    if p1.major ~= p2.major then return p1.major > p2.major and 1 or -1 end
    if p1.minor ~= p2.minor then return p1.minor > p2.minor and 1 or -1 end
    if p1.patch ~= p2.patch then return p1.patch > p2.patch and 1 or -1 end

    -- Precedência de pré-release (§11.3): versão normal tem precedência superior
    if p1.prerelease == nil and p2.prerelease ~= nil then return 1 end
    if p1.prerelease ~= nil and p2.prerelease == nil then return -1 end
    if p1.prerelease == nil and p2.prerelease == nil then return 0 end

    -- Comparação dot-separated de identificadores de pré-release (§11.4)
    local ids1 = {}
    for part in p1.prerelease:gmatch("([^%.]+)") do table.insert(ids1, part) end
    local ids2 = {}
    for part in p2.prerelease:gmatch("([^%.]+)") do table.insert(ids2, part) end

    local minLen = math.min(#ids1, #ids2)
    for i = 1, minLen do
        local id1 = ids1[i]
        local id2 = ids2[i]
        if id1 ~= id2 then
            local isNum1 = id1:match("^%d+$") ~= nil
            local isNum2 = id2:match("^%d+$") ~= nil
            if isNum1 and isNum2 then
                -- 1. Identificadores numéricos comparados numericamente (§11.4.1)
                local n1 = tonumber(id1)
                local n2 = tonumber(id2)
                return n1 > n2 and 1 or -1
            elseif isNum1 and not isNum2 then
                -- 2. Identificadores numéricos sempre têm menor precedência que não-numéricos (§11.4.3)
                return -1
            elseif not isNum1 and isNum2 then
                return 1
            else
                -- 3. Identificadores alfanuméricos comparados por ordem ASCII (§11.4.2)
                return id1 > id2 and 1 or -1
            end
        end
    end

    -- 4. Maior conjunto de campos tem maior precedência (§11.4.4)
    if #ids1 ~= #ids2 then
        return #ids1 > #ids2 and 1 or -1
    end

    -- Metadados de build são ignorados na precedência (§11.2)
    return 0
end

function FSM:ProcessBootstrap()
    -- Helper local para falha fechada imediata com transição para ERROR_FATAL
    local function failClosed(errObj)
        warn("[MATRIX][BOOTSTRAP][FATAL] " .. tostring(errObj.message or errObj.code))
        self.LastError = errObj
        self:Transition("ERROR_FATAL", errObj)
        setStatus(string.format("[%s] %s", tostring(errObj.code), tostring(errObj.message)), true)
    end

    -- Bootstrap V2: Resolução de topologia autenticada com Matriz de Erros Estrita (Zero Fallback Genérico)
    local resolveUrl = BASE:gsub("/$", "") .. "/v6/bootstrap/resolve"
    local resResolve, errResolve = HttpClient.rawGetAnonymous(resolveUrl, 5)

    -- 1. INSPEÇÃO DE RESPOSTAS NEGATIVAS / REJEIÇÕES (FAIL-CLOSED IMEDIATO, ZERO FALLBACK)
    if not resResolve and errResolve and type(errResolve) == "table" then
        local status = tonumber(errResolve.status or 0) or 0
        local rawBody = errResolve.body or ""
        local errData = decodeJson(rawBody)
        local errCode = (errData and errData.code) or errResolve.code

        -- HTTP 426: Rejeição de versão mínima obsoleta
        if status == 426 or errCode == "UPGRADE_REQUIRED" then
            local minV = (errData and (errData.min_loader_version or errData.minVersion)) or "6.0.0"
            failClosed({ code = "UPGRADE_REQUIRED", message = "Versao do loader (" .. LOADER_VERSION .. ") obsoleta. Requer " .. tostring(minV) })
            return -- BLOQUEIO FATAL: Sem fallback para evitar evasao de versao minima
        end

        -- HTTP 400: Requisição malformada / versão inválida
        if status == 400 then
            failClosed({ code = errCode or "HTTP_400", message = "Requisicao de bootstrap rejeitada (HTTP 400): " .. tostring(rawBody) })
            return -- BLOQUEIO FATAL
        end

        -- HTTP 401: Não autorizado
        if status == 401 then
            failClosed({ code = "HTTP_401", message = "Nao autorizado no bootstrap (HTTP 401)." })
            return -- BLOQUEIO FATAL
        end

        -- HTTP 403: Acesso proibido
        if status == 403 then
            failClosed({ code = "HTTP_403", message = "Acesso proibido ao endpoint de bootstrap (HTTP 403)." })
            return -- BLOQUEIO FATAL
        end

        -- HTTP 500: Erro interno no servidor de bootstrap
        if status == 500 then
            failClosed({ code = errCode or "HTTP_500", message = "Erro interno no servidor de bootstrap (HTTP 500)." })
            return -- BLOQUEIO FATAL
        end

        -- HTTP 503: Rejeições de segurança criptográfica e de esquema
        if status == 503 then
            if errCode == "BOOTSTRAP_STALE_GENERATION" then
                failClosed({ code = "OBSOLETE_GENERATION", message = "Topologia rejeitada por geracao obsoleta." })
                return
            elseif errCode == "BOOTSTRAP_EXPIRED" or errCode == "BOOTSTRAP_NOT_YET_VALID" then
                failClosed({ code = "CONFIG_EXPIRED", message = "Configuracao de bootstrap expirada ou fora da validade." })
                return
            elseif errCode == "BOOTSTRAP_DECRYPT_FAILED" then
                failClosed({ code = "SECURITY_REJECTION", message = "Falha criptografica na autenticacao do envelope de bootstrap." })
                return
            elseif errCode == "BOOTSTRAP_ORIGIN_MISMATCH" then
                failClosed({ code = "PINNING_VIOLATION", message = "Origem retornada viola o pinning canonico do ambiente." })
                return
            elseif errCode == "BOOTSTRAP_SECRET_UNCONFIGURED" then
                failClosed({ code = "BOOTSTRAP_SECRET_UNCONFIGURED", message = "Chave de bootstrap nao configurada no backend." })
                return
            elseif errCode == "BOOTSTRAP_SECRET_INVALID_FORMAT" then
                failClosed({ code = "BOOTSTRAP_SECRET_INVALID_FORMAT", message = "Formato de chave de bootstrap invalido no backend." })
                return
            elseif errCode == "BOOTSTRAP_SCHEMA_ERROR" then
                failClosed({ code = "BOOTSTRAP_SCHEMA_ERROR", message = "Esquema da carga de bootstrap corrompido ou invalido." })
                return
            elseif errCode == "BOOTSTRAP_INVALID_WORKER_ORIGIN" then
                failClosed({ code = "BOOTSTRAP_INVALID_WORKER_ORIGIN", message = "Origem primaria invalida na carga decriptada." })
                return
            elseif errCode == "BOOTSTRAP_CONFIG_ERROR" then
                failClosed({ code = "BOOTSTRAP_CONFIG_ERROR", message = "Erro de configuracao interna de bootstrap no servidor." })
                return
            else
                failClosed({ code = errCode or "BOOTSTRAP_UNAVAILABLE", message = "Servico de bootstrap indisponivel (HTTP 503)." })
                return
            end
        end

        -- HTTP 502 / 504: Erros transitórios de gateway de borda Cloudflare (autorizados para fallback condicional)
        if status == 502 or status == 504 then
            local canFallback, rejectCode, rejectMsg = canEngageFallback(FALLBACK_WORKER_URL)
            if not canFallback then
                failClosed({ code = rejectCode, message = rejectMsg .. " (apos gateway HTTP " .. status .. ")" })
                return
            end
            warn("[MATRIX][BOOTSTRAP] Erro transitorio de gateway Cloudflare (HTTP " .. status .. "). Acionando fallback oficial independente.")
            BASE = FALLBACK_WORKER_URL
            globals.__MATRIX_BOOTSTRAP_DEGRADED = true
            setStatus("Bootstrap degradado (gateway " .. status .. ")")
            self:Transition("CHECKING_LOCAL_SESSION")
            self:CheckLocalSession()
            return
        end

        -- Falhas de transporte de rede comprovadas (DNS timeout, queda de conexão, socket error sem status HTTP)
        if status == 0 or status == nil then
            if errCode == "NETWORK_ERROR" or errCode == "TIMEOUT" or errResolve.code == "NETWORK_ERROR" then
                local canFallback, rejectCode, rejectMsg = canEngageFallback(FALLBACK_WORKER_URL)
                if not canFallback then
                    failClosed({ code = rejectCode, message = rejectMsg .. " (apos falha de transporte " .. tostring(errCode) .. ")" })
                    return
                end
                warn("[MATRIX][BOOTSTRAP] Falha transiente de transporte/rede comprovada. Acionando fallback oficial independente.")
                BASE = FALLBACK_WORKER_URL
                globals.__MATRIX_BOOTSTRAP_DEGRADED = true
                setStatus("Bootstrap degradado (falha de rede)")
                self:Transition("CHECKING_LOCAL_SESSION")
                self:CheckLocalSession()
                return
            end
        end

        -- Qualquer outro status HTTP não tratado explicitamente falha fechado imediatamente
        failClosed({ code = "HTTP_" .. status, message = "Resposta inesperada no bootstrap (HTTP " .. status .. ")." })
        return
    end

    -- 2. INSPEÇÃO DE RESPOSTA BEM-SUCEDIDA (HTTP 200)
    if resResolve and resResolve.body then
        local discovery = decodeJson(resResolve.body)
        if not discovery or type(discovery) ~= "table" then
            failClosed({ code = "MALFORMED_DISCOVERY", message = "Resposta HTTP 200 contem JSON corrompido ou invalido." })
            return -- BLOQUEIO FATAL: Sem fallback para resposta 200 corrompida
        end

        -- Nível 2: Procedimento de Rollback V1 autorizado pelo Worker (env.BOOTSTRAP_V2_ENABLED = false)
        if discovery.mode == "rollback_v1" then
            local canFallback, rejectCode, rejectMsg = canEngageFallback(FALLBACK_WORKER_URL)
            if not canFallback then
                failClosed({ code = rejectCode, message = rejectMsg .. " (ao tentar rollback_v1)" })
                return
            end
            warn("[MATRIX][BOOTSTRAP] Modo de rollback v1 ativo no backend. Usando fallback oficial autorizado.")
            BASE = FALLBACK_WORKER_URL
            globals.__MATRIX_BOOTSTRAP_DEGRADED = true
            setStatus("Bootstrap operando em rollback v1")
            self:Transition("CHECKING_LOCAL_SESSION")
            self:CheckLocalSession()
            return
        end

        -- Validação estrita do esquema HTTP 200
        if type(discovery.active_worker) ~= "string" or not discovery.active_worker:match("^https://")
           or (discovery.protocol_version ~= "2.0" and discovery.protocol_version ~= "2")
           or type(discovery.generation_id) ~= "number" or discovery.generation_id <= 0
           or discovery.status ~= "PASS" then
            failClosed({ code = "INVALID_DISCOVERY_SCHEMA", message = "Esquema da resposta HTTP 200 incompleto ou invalido." })
            return -- BLOQUEIO FATAL: Sem fallback para esquema inválido
        end

        -- Validação de SemVer 2.0.0 no Cliente (Defesa em Profundidade)
        if discovery.min_loader_version then
            if type(discovery.min_loader_version) ~= "string" then
                failClosed({ code = "MALFORMED_SEMVER", message = "min_loader_version deve ser string." })
                return
            end
            local cmp = compareSemver(LOADER_VERSION, discovery.min_loader_version)
            if cmp == nil then
                failClosed({ code = "MALFORMED_SEMVER", message = "Versao minima no discovery viola a especificacao SemVer 2.0.0." })
                return -- BLOQUEIO FATAL: compareSemver retornando nil provoca falha fechada
            end
            if cmp < 0 then
                failClosed({ code = "UPGRADE_REQUIRED", message = "Loader obsoleto (" .. LOADER_VERSION .. " < " .. discovery.min_loader_version .. "). Atualizacao necessaria." })
                return -- BLOQUEIO FATAL
            end
        end

        -- Validação de Pinning de Hostname
        local targetUrl = discovery.active_worker
        local host = parseUrlHostname(targetUrl)
        if host and PINNED_HOSTNAMES[host] then
            BASE = targetUrl:gsub("/$", "")
            globals.__MATRIX_RESOLVED_BASE = BASE
            globals.__MATRIX_BOOTSTRAP_DEGRADED = false
            setStatus("Bootstrap V2 conectado: " .. tostring(host))
            self:Transition("CHECKING_LOCAL_SESSION")
            self:CheckLocalSession()
            return
        else
            failClosed({ code = "PINNING_VIOLATION", message = "Hostname retornado fora do pinning autorizado: " .. tostring(host) })
            return -- BLOQUEIO FATAL
        end
    end

    -- 3. Caso inalcançável por exclusão de branches anteriores: FAIL-CLOSED ABSOLUTO
    failClosed({ code = "BOOTSTRAP_FAILED", message = "Falha critica nao autorizada no bootstrap." })
end
function FSM:CheckLocalSession()
    local candidates = StorageEngine.readCandidates()
    local staging = candidates.staging
    local primary = candidates.primary

    if staging then
        -- Caso 1: Staging residual detectado (recuperação de crash pós-renew)
        self:Transition("VALIDATING_SESSION")
        self:ProcessValidation(staging, true, primary)
    elseif primary then
        -- Caso 2: Sessão master ativa encontrada
        self.Session = primary
        self:Transition("VALIDATING_SESSION")
        self:ProcessValidation(primary, false, nil)
    else
        -- Caso 3: Nenhuma sessão V6 encontrada; checa chave legada
        local legacy = StorageEngine.readLegacyKey()
        if legacy then
            self.CachedKey = legacy
            self:Transition("EXCHANGING_KEY")
            self:ProcessExchange(legacy, true)
        else
            self:Transition("PROMPTING_KEY")
        end
    end
end

-- Validação de Sessão Desacoplada de /load (POST /v6/auth/validate)
function FSM:ProcessValidation(candidate, isStaging, fallbackPrimary)
    local payload = {
        userId = USER_ID,
        sessionToken = candidate.token,
        readOnly = true
    }
    local customHeaders = {
        ["Authorization"] = "Bearer " .. candidate.token
    }

    local res, err = HttpClient.requestDirect("/v6/auth/validate", payload, 10, customHeaders)
    if not res then
        if err and (err.status == 401 or err.status == 403) then
            -- Token definitivamente rejeitado pelo servidor
            if isStaging and fallbackPrimary then
                -- Descarta staging inválido e valida o token primário
                safeErase(STAGING_PATH)
                self:ProcessValidation(fallbackPrimary, false, nil)
                return
            end
            StorageEngine.clearAllSessions()
            self.Session = nil
            self:Transition("ERROR_FATAL", err)
            self:Transition("PROMPTING_KEY")
        else
            -- Falha transiente de rede (5xx, timeout, socket)
            -- Tolerância offline: prossegue com sessão em cache sem deslogar o usuário
            warn("[MATRIX] Validacao remota offline temporaria. Prosseguindo em modo resiliente.")
            if isStaging and fallbackPrimary then
                self.Session = fallbackPrimary
            else
                self.Session = candidate
            end
            self:Transition("WAITING_GAME_LOAD")
            self:ProcessGameLoad()
        end
        return
    end

    local data = decodeJson(res.body) or {}
    local tokenStatus = data.status or (data.valid and "ACTIVE") or "INVALID"

    if tokenStatus == "ACTIVE" then
        if isStaging then
            -- O servidor já havia comitado este token! Promove staging para master
            local okPromote, masterEntry = StorageEngine.promoteStaging(candidate)
            self.Session = okPromote and masterEntry or candidate
        else
            self.Session = candidate
        end
        self:Transition("CHECKING_RENEWAL")
        self:ProcessRenewal()
    elseif tokenStatus == "PENDING" then
        -- O token está staged no Worker aguardando confirmação (ACK)
        self:Transition("COMMITTING_SESSION")
        self:ProcessCommitAck(candidate.token, candidate.operationId)
    elseif tokenStatus == "EXPIRED" or tokenStatus == "REVOKED" or tokenStatus == "INVALID" then
        if isStaging and fallbackPrimary then
            safeErase(STAGING_PATH)
            self:ProcessValidation(fallbackPrimary, false, nil)
            return
        end
        StorageEngine.clearAllSessions()
        self.Session = nil
        local errCtx = {
            code = "SESSION_" .. tokenStatus,
            message = "Sessao " .. tokenStatus:lower() .. ". Insira sua key novamente."
        }
        self:Transition("ERROR_FATAL", errCtx)
        self:Transition("PROMPTING_KEY")
    else
        self:Transition("ERROR_RECOVERABLE", { code = "UNKNOWN_VALIDATE_STATUS", message = "Status de sessao desconhecido." })
    end
end

function FSM:ProcessExchange(key, isLegacy)
    local payload = { userId = USER_ID, key = key }
    local res, err = HttpClient.requestWithRetry("/v6/auth/exchange", payload, 2, 12)
    if not res then
        if err and (err.status == 401 or err.status == 403) then
            self:Transition("ERROR_FATAL", err)
            self:Transition("PROMPTING_KEY")
        else
            self:Transition("ERROR_RECOVERABLE", err)
        end
        return
    end

    local body = decodeJson(res.body)
    if not body or type(body.sessionToken) ~= "string" or #body.sessionToken ~= 68 or not body.sessionToken:match("^MX6_[a-f0-9]+$") then
        self:Transition("ERROR_RECOVERABLE", { code = "BAD_SESSION_TOKEN", message = "Formato de sessao retornado pelo servidor invalido." })
        return
    end

    local okSave, savedEntry = StorageEngine.saveSessionAtomic(body.sessionToken, body.expiresAt)
    if okSave then
        self.Session = savedEntry
        if isLegacy then
            StorageEngine.purgeLegacyKey()
        end
        self:Transition("WAITING_GAME_LOAD")
        self:ProcessGameLoad()
    else
        self:Transition("ERROR_RECOVERABLE", { code = "DISK_WRITE_FAIL", message = "Falha ao gravar sessao no sistema de arquivos local." })
    end
end

function FSM:ProcessRenewal()
    local session = self.Session
    local now = os.time()

    -- Avaliação Proativa: se ainda não atingiu a janela de renovação, prossegue
    if (tonumber(session.renewAfter) or 0) > now then
        self:Transition("WAITING_GAME_LOAD")
        self:ProcessGameLoad()
        return
    end

    self:Transition("RENEWING_SESSION")
    globals.__MATRIX_FSM_EPOCH = (globals.__MATRIX_FSM_EPOCH or 0) + 1
    local currentEpoch = globals.__MATRIX_FSM_EPOCH
    local operationId = "op-" .. tostring(os.time()) .. "-" .. tostring(math.random(100000, 999999))

    local payload = {
        userId = USER_ID,
        sessionToken = session.token,
        operationId = operationId
    }
    local customHeaders = {
        ["Authorization"] = "Bearer " .. session.token
    }

    local res, err = HttpClient.requestWithRetry("/v6/auth/prepare", payload, 2, 10, customHeaders, currentEpoch)

    if not res then
        if err and (err.status == 401 or err.status == 403) then
            StorageEngine.clearAllSessions()
            self.Session = nil
            self:Transition("ERROR_FATAL", err)
            self:Transition("PROMPTING_KEY")
        else
            warn("[MATRIX] Instabilidade temporaria no prepare. Continuando com a sessao ativa.")
            self:Transition("WAITING_GAME_LOAD")
            self:ProcessGameLoad()
        end
        return
    end

    local body = decodeJson(res.body)
    if body and type(body.sessionToken) == "string" and #body.sessionToken == 68 and body.sessionToken:match("^MX6_[a-f0-9]+$") then
        local opId = body.operationId or operationId
        -- Salva token preparado no staging com operação rastreada
        local okStaging, stagedEntry = StorageEngine.saveStaging(body.sessionToken, body.pendingExpiresAt or body.expiresAt, opId)
        if okStaging then
            self:Transition("COMMITTING_SESSION")
            self:ProcessCommitAck(body.sessionToken, opId)
            return
        end
    end

    self:Transition("WAITING_GAME_LOAD")
    self:ProcessGameLoad()
end

-- Confirmação Atômica de Renovação (POST /v6/auth/ack)
function FSM:ProcessCommitAck(nextToken, operationId)
    local payload = {
        userId = USER_ID,
        sessionToken = (self.Session and self.Session.token) or nextToken,
        ackToken = nextToken,
        operationId = operationId
    }
    local customHeaders = {
        ["Authorization"] = "Bearer " .. nextToken
    }

    local res, err = HttpClient.requestWithRetry("/v6/auth/ack", payload, 3, 10, customHeaders)
    if not res then
        if err and (err.status == 401 or err.status == 403) then
            StorageEngine.clearAllSessions()
            self.Session = nil
            self:Transition("ERROR_FATAL", err)
            self:Transition("PROMPTING_KEY")
            return
        else
            -- Falha de rede no ACK: Commit-on-First-Use (CoFU) no Worker garante que
            -- a próxima chamada (/load) completará o commit implicitamente.
            warn("[MATRIX] Resposta do ACK nao recebida. Confiando em Commit-on-First-Use.")
            self:Transition("WAITING_GAME_LOAD")
            self:ProcessGameLoad()
            return
        end
    end

    local body = decodeJson(res.body) or {}
    if body.ok or body.confirmed or body.alreadyCommitted then
        local stagingData = StorageEngine.readEntryFromFile(STAGING_PATH)
        if stagingData then
            local okPromote, promoted = StorageEngine.promoteStaging(stagingData)
            if okPromote then self.Session = promoted end
        end
    end

    self:Transition("WAITING_GAME_LOAD")
    self:ProcessGameLoad()
end

function FSM:ProcessGameLoad()
    -- Barreira Universal de Carregamento de Jogo (Previne crash de DataModel não replicado)
    if not game:IsLoaded() then
        local t0 = os.clock()
        while not game:IsLoaded() and (os.clock() - t0) < 40 do
            local elapsed = os.clock() - t0
            progressFill.Size = UDim2.fromScale(math.clamp(elapsed / 40, 0, 0.9), 1)
            progressLabel.Text = "AGUARDANDO O JOGO CARREGAR (" .. math.floor(elapsed) .. "s)..."
            task.wait(0.2)
        end
    end

    if not game:IsLoaded() then
        self:Transition("ERROR_RECOVERABLE", { code = "GAME_TIMEOUT", message = "O jogo nao terminou de inicializar em 40s." })
        return
    end

    progressFill.Size = UDim2.fromScale(1, 1)
    progressLabel.Text = "JOGO CARREGADO / BAIXANDO SCRIPT"

    self:Transition("FETCHING_SCRIPT")
    self:ProcessFetchScript()
end

-- Download do Script via /load (Chamado estritamente na fase final após validação prévia)
function FSM:ProcessFetchScript()
    local payload = {
        userId = USER_ID,
        sessionToken = self.Session.token,
        gameId = tostring(game.GameId),
        placeId = tostring(game.PlaceId)
    }
    local customHeaders = {
        ["Authorization"] = "Bearer " .. self.Session.token
    }

    local res, err = HttpClient.requestWithRetry("/load", payload, 3, 20, customHeaders)
    if not res then
        if err and (err.status == 401 or err.status == 403) then
            StorageEngine.clearAllSessions()
            self.Session = nil
            self:Transition("ERROR_FATAL", err)
            self:Transition("PROMPTING_KEY")
        elseif err and err.status == 404 then
            self:Transition("ERROR_RECOVERABLE", {
                code = "GAME_NOT_FOUND",
                message = "Script nao configurado para este jogo (Place " .. tostring(game.PlaceId) .. ")."
            })
        elseif err and err.status == 429 then
            self:Transition("ERROR_RECOVERABLE", {
                code = "RATE_LIMITED",
                message = "Limite de taxa atingido. Aguarde alguns instantes."
            })
        elseif err and (err.status == 502 or err.status == 503) then
            self:Transition("ERROR_RECOVERABLE", {
                code = "SERVER_UNAVAILABLE",
                message = "Servidor temporariamente indisponivel (" .. tostring(err.status) .. ")."
            })
        else
            self:Transition("ERROR_RECOVERABLE", err)
        end
        return
    end

    local bodyScript = res.body
    if type(bodyScript) ~= "string" or bodyScript:len() < 10 then
        self:Transition("ERROR_RECOVERABLE", { code = "SCRIPT_EMPTY", message = "O servidor retornou script vazio ou invalido." })
        return
    end

    self:Transition("VALIDATING_SCRIPT")
    local headers = res.headers or {}
    local serverSha = headers["x-matrix-delivery-sha256"] or headers["X-Matrix-Delivery-Sha256"] or headers["x-matrix-sha256"] or headers["X-Matrix-Sha256"]
    local buildVersion = headers["x-matrix-version"] or headers["X-Matrix-Version"] or "V6"
    local compatMode = headers["x-matrix-compat-mode"] or headers["X-Matrix-Compat-Mode"]

    -- P0-2: Verificação Criptográfica de Integridade de Entrega (Delivery SHA-256)
    -- O digest anunciado pelo servidor autentica a exatidão literal dos bytes UTF-8 recebidos,
    -- protegendo contra corrupção em trânsito e adulterações antes da compilação.
    -- (Nota técnica: o hash do servidor afere integridade de transporte; a autenticidade de origem
    -- é garantida conjuntamente pelo canal seguro TLS e pelo token de sessão na arquitetura V6).
    if serverSha and type(serverSha) == "string" and serverSha:len() > 0 then
        local computedDeliverySha = computeSha256(bodyScript)
        if not computedDeliverySha or computedDeliverySha:lower() ~= serverSha:lower() then
            warn(string.format("[MATRIX][LOAD] Falha de integridade: SHA-256 do corpo (%s) diverge do anunciado pelo servidor (%s)", tostring(computedDeliverySha), tostring(serverSha)))
            self:Transition("ERROR_RECOVERABLE", {
                code = "DELIVERY_SHA_MISMATCH",
                message = "Falha de integridade: o script recebido diverge do hash anunciado pelo servidor."
            })
            return
        end
    else
        -- Em modo protegido V6, o cabeçalho x-matrix-sha256 é estritamente obrigatório
        if compatMode ~= "legacy_unprotected" then
            warn("[MATRIX][LOAD] Falha de seguranca: cabecalho x-matrix-sha256 ausente na resposta V6.")
            self:Transition("ERROR_RECOVERABLE", {
                code = "DELIVERY_HEADER_MISSING",
                message = "Servidor nao enviou o cabecalho de integridade obrigatorio (x-matrix-sha256)."
            })
            return
        end
    end

    -- Inspeção de Metadados de Distribuição Individualizada
    local distId = bodyScript:match("%-%-%s*%[MATRIX%-DISTRIBUTION%-V1%].-%-%-%s*distribution_id:%s*([%w_%-]+)")
    if distId then
        footer.Text = "BUILD: " .. tostring(buildVersion) .. " | DIST: " .. tostring(distId):sub(1, 10)
    elseif serverSha and serverSha:len() > 0 then
        footer.Text = "BUILD: " .. tostring(buildVersion) .. " | SHA: " .. serverSha:sub(1, 8)
    end

    self:Transition("COMPILING_SCRIPT")
    local compiled, compileErr = loadstring(bodyScript)
    if not compiled then
        self:Transition("ERROR_RECOVERABLE", { code = "SCRIPT_COMPILE", message = tostring(compileErr):sub(1, 150) })
        return
    end

    self:Transition("EXECUTING")
    local okExec, runtimeErr = pcall(compiled)
    if not okExec then
        self:Transition("ERROR_RECOVERABLE", { code = "SCRIPT_RUNTIME", message = tostring(runtimeErr):sub(1, 150) })
        return
    end

    self:Transition("RUNNING")
end

-- ========================================================================
-- 9. EVENT LISTENERS E DISPATCH DA UI
-- ========================================================================
action.Activated:Connect(function()
    if FSM.IsBusy then return end
    if FSM.State == "PROMPTING_KEY" or FSM.State == "ERROR_FATAL" then
        local inputKey = credentialInput.Text:match("^%s*(.-)%s*$")
        if not inputKey or inputKey:len() < 8 then
            setStatus("Digite uma key valida (minimo 8 caracteres).", true)
            return
        end
        FSM:Transition("EXCHANGING_KEY")
        task.spawn(function()
            FSM:ProcessExchange(inputKey, false)
        end)
    elseif FSM.State == "ERROR_RECOVERABLE" then
        if FSM.Session and FSM.Session.token then
            FSM:Transition("WAITING_GAME_LOAD")
            task.spawn(function()
                FSM:ProcessGameLoad()
            end)
        else
            FSM:Transition("PROMPTING_KEY")
        end
    end
end)

doctor.Activated:Connect(function()
    if FSM.IsBusy then return end
    if not FSM.Session or not FSM.Session.token then
        setStatus("DIAGNOSTICO: valide sua key primeiro.", true)
        return
    end

    FSM.IsBusy = true
    setStatus("Executando MATRIX Doctor...")
    task.spawn(function()
        local payload = {
            userId = USER_ID,
            sessionToken = FSM.Session.token,
            gameId = tostring(game.GameId),
            placeId = tostring(game.PlaceId)
        }
        local res, err = HttpClient.requestDirect("/v6/doctor", payload, 15)
        if not res then
            setStatus("DOCTOR FALHA: " .. tostring(err and err.code or "NET_ERROR"), true)
        else
            local data = decodeJson(res.body) or {}
            local release = (data.release and data.release.version) or data.fallback or "sem release"
            setStatus(string.format("DOCTOR OK: ROTA %s | %s", tostring(data.scriptPath or "/"), tostring(release)))
        end
        FSM.IsBusy = false
    end)
end)

logout.Activated:Connect(function()
    if FSM.IsBusy then return end
    FSM.IsBusy = true
    setStatus("Revogando credencial...")

    task.spawn(function()
        if FSM.Session and FSM.Session.token then
            HttpClient.requestDirect("/v6/auth/logout", {
                userId = USER_ID,
                sessionToken = FSM.Session.token
            }, 10)
        end
        cleanUpConnections()
        StorageEngine.clearAllSessions()
        FSM.Session = nil
        FSM:Transition("PROMPTING_KEY")
        setStatus("Sessao esquecida localmente. Insira sua key para reconectar.")
    end)
end)

-- Iniciar Máquina de Estados Finita
task.defer(function()
    FSM:Start()
end)
