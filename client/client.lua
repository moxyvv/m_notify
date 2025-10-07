local config = {
    position = Config.Position,
    behavior = Config.Behavior,
    sound = Config.Sound
}

function ShowNotification(message, type, duration, title)
    SendNUIMessage({
        action = 'showNotification',
        data = {
            message = message,
            type = type or 'info',
            duration = duration or 5000,
            title = title,
            config = config
        }
    })
end

function ShowNotifications(notifications)
    SendNUIMessage({
        action = 'showNotifications',
        data = {
            notifications = notifications,
            config = config
        }
    })
end

function ClearNotifications()
    SendNUIMessage({
        action = 'clearNotifications'
    })
end

RegisterNUICallback('closeUI', function(_, cb)
    cb('ok')
end)

RegisterNUICallback('notificationClicked', function(data, cb)
    cb('ok')
end)

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    print("^2[m_notify]^7 ready")
end)

RegisterCommand('notify', function(source, args)
    local message = table.concat(args, ' ')
    if message and message ~= '' then
        ShowNotification(message, 'info', 5000, 'Info')
    else
        ShowNotification('Test notification!', 'success', 5000, 'Test')
    end
end, false)

local testNotifs = {
    {message = 'Success notification!', type = 'success', duration = 4000, title = 'Success'},
    {message = 'Error notification!', type = 'error', duration = 4000, title = 'Error'},
    {message = 'Warning notification!', type = 'warning', duration = 4000, title = 'Warning'},
    {message = 'Info notification!', type = 'info', duration = 4000, title = 'Info'}
}

RegisterCommand('notify_styles', function()
    for i, notif in ipairs(testNotifs) do
        Citizen.Wait((i-1) * 500)
        ShowNotification(notif.message, notif.type, notif.duration, notif.title)
    end
end, false)

exports('ShowNotification', ShowNotification)
exports('ShowNotifications', ShowNotifications)
exports('ClearNotifications', ClearNotifications)

RegisterNetEvent('notification:show')
AddEventHandler('notification:show', function(message, type, duration, title)
    ShowNotification(message, type, duration, title)
end)

RegisterNetEvent('notification:showMultiple')
AddEventHandler('notification:showMultiple', function(notifications)
    ShowNotifications(notifications)
end)

RegisterNetEvent('notification:clear')
AddEventHandler('notification:clear', function()
    ClearNotifications()
end)