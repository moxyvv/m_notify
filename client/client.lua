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
