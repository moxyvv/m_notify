local limits = {
    messageMax = 200,
    titleMax = 50,
    durationMax = 30000,
    durationMin = 1000,
    types = {'success', 'error', 'warning', 'info'},
    rateLimit = {
        global = 10,
        player = 5
    }
}

local globalLimits = {}
local playerLimits = {}

-- check if input is valid
local function checkInput(msg, notifType, dur, title)
    if not msg or type(msg) ~= 'string' or msg == '' then
        return false, 'bad message'
    end
    
    if #msg > limits.messageMax then
        return false, 'message too long'
    end
    
    if not notifType or not table.contains(limits.types, notifType) then
        return false, 'bad type'
    end
    
    if dur then
        dur = tonumber(dur)
        if not dur or dur < limits.durationMin or dur > limits.durationMax then
            return false, 'bad duration'
        end
    end
    
    if title then
        if type(title) ~= 'string' or #title > limits.titleMax then
            return false, 'bad title'
        end
    end
    
    -- remove any potential script stuff
    msg = string.gsub(msg, '[<>]', '')
    
    return true, msg, notifType, dur, title
end

-- check rate limits
local function checkRateLimit(source)
    local time = os.time()
    local minute = math.floor(time / 60)
    
    -- global limit
    if not globalLimits[minute] then
        globalLimits[minute] = 0
    end
    globalLimits[minute] = globalLimits[minute] + 1
    
    if globalLimits[minute] > limits.rateLimit.global then
        return false, 'too many notifications'
    end
    
    -- player limit
    if source and source > 0 then
        if not playerLimits[source] then
            playerLimits[source] = {}
        end
        
        if not playerLimits[source][minute] then
            playerLimits[source][minute] = 0
        end
        playerLimits[source][minute] = playerLimits[source][minute] + 1
        
        if playerLimits[source][minute] > limits.rateLimit.player then
            return false, 'player rate limit hit'
        end
    end
    
    return true
end

-- cleanup old rate limit data
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        local time = os.time()
        local currentMinute = math.floor(time / 60)
        
        -- clean global limits
        for minute, _ in pairs(globalLimits) do
            if minute < currentMinute - 1 then
                globalLimits[minute] = nil
            end
        end
        
        -- clean player limits
        for playerId, data in pairs(playerLimits) do
            for minute, _ in pairs(data) do
                if minute < currentMinute - 1 then
                    data[minute] = nil
                end
            end
        end
    end
end)

function SendNotificationToPlayer(playerId, message, type, duration, title, source)
    local valid, msg, notifType, dur, titleText = checkInput(message, type, duration, title)
    if not valid then
        print('^1[m_notify]^7 ' .. msg)
        return false
    end
    
    local rateOk, rateMsg = checkRateLimit(source)
    if not rateOk then
        print('^1[m_notify]^7 ' .. rateMsg)
        return false
    end
    
    if not GetPlayerName(playerId) then
        print('^1[m_notify]^7 bad player id: ' .. playerId)
        return false
    end
    
    TriggerClientEvent('notification:show', playerId, msg, notifType, dur, titleText)
    return true
end

function SendNotificationToAll(message, type, duration, title, source)
    local valid, msg, notifType, dur, titleText = checkInput(message, type, duration, title)
    if not valid then
        print('^1[m_notify]^7 ' .. msg)
        return false
    end
    
    local rateOk, rateMsg = checkRateLimit(source)
    if not rateOk then
        print('^1[m_notify]^7 ' .. rateMsg)
        return false
    end
    
    TriggerClientEvent('notification:show', -1, msg, notifType, dur, titleText)
    return true
end

function SendNotificationInRange(coords, range, message, type, duration, title, source)
    local valid, msg, notifType, dur, titleText = checkInput(message, type, duration, title)
    if not valid then
        print('^1[m_notify]^7 ' .. msg)
        return false
    end
    
    local rateOk, rateMsg = checkRateLimit(source)
    if not rateOk then
        print('^1[m_notify]^7 ' .. rateMsg)
        return false
    end
    
    if not range or range < 1 or range > 1000 then
        print('^1[m_notify]^7 bad range')
        return false
    end
    
    local players = GetPlayers()
    local rangeSquared = range * range
    local sent = 0
    
    for _, playerId in ipairs(players) do
        local ped = GetPlayerPed(playerId)
        if ped and ped ~= 0 then
            local playerCoords = GetEntityCoords(ped)
            local dist = (coords.x - playerCoords.x)^2 + (coords.y - playerCoords.y)^2 + (coords.z - playerCoords.z)^2
            
            if dist <= rangeSquared then
                TriggerClientEvent('notification:show', playerId, msg, notifType, dur, titleText)
                sent = sent + 1
            end
        end
    end
    
    return sent
end

function SendNotificationsToPlayer(playerId, notifications, source)
    if not GetPlayerName(playerId) then
        print('^1[m_notify]^7 bad player id: ' .. playerId)
        return false
    end
    
    if not notifications or type(notifications) ~= 'table' or #notifications == 0 then
        print('^1[m_notify]^7 bad notifications array')
        return false
    end
    
    if #notifications > 10 then
        print('^1[m_notify]^7 too many notifications')
        return false
    end
    
    local validNotifs = {}
    for i, notif in ipairs(notifications) do
        local valid, msg, notifType, dur, titleText = checkInput(notif.message, notif.type, notif.duration, notif.title)
        if valid then
            table.insert(validNotifs, {
                message = msg,
                type = notifType,
                duration = dur,
                title = titleText
            })
        else
            print('^1[m_notify]^7 bad notification ' .. i .. ': ' .. msg)
        end
    end
    
    if #validNotifs == 0 then
        print('^1[m_notify]^7 no valid notifications')
        return false
    end
    
    TriggerClientEvent('notification:showMultiple', playerId, validNotifs)
    return true
end

function ClearPlayerNotifications(playerId)
    if not GetPlayerName(playerId) then
        print('^1[m_notify]^7 bad player id: ' .. playerId)
        return false
    end
    
    TriggerClientEvent('notification:clear', playerId)
    return true
end

exports('SendNotificationToPlayer', function(playerId, message, type, duration, title)
    return SendNotificationToPlayer(playerId, message, type, duration, title, source)
end)

exports('SendNotificationToAll', function(message, type, duration, title)
    return SendNotificationToAll(message, type, duration, title, source)
end)

exports('SendNotificationInRange', function(coords, range, message, type, duration, title)
    return SendNotificationInRange(coords, range, message, type, duration, title, source)
end)

exports('SendNotificationsToPlayer', function(playerId, notifications)
    return SendNotificationsToPlayer(playerId, notifications, source)
end)

exports('ClearPlayerNotifications', ClearPlayerNotifications)

RegisterNetEvent('notification:requestShow')
AddEventHandler('notification:requestShow', function(message, type, duration)
    local source = source
    SendNotificationToPlayer(source, message, type, duration)
end)