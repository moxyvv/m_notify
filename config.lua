Config = {}

-- Positioning
Config.Position = {
    -- Options: 'top-right', 'top-left', 'bottom-right', 'bottom-left', 'top-center', 'bottom-center', 'left-center', 'right-center'
    location = 'right-center',
    spacing = 12,
    maxNotifications = 5,
    slideInDistance = 100,
    animationDuration = 400
}


-- Sound
Config.Sound = {
    enabled = true,
    volume = 0.3,
    duration = 200,
    frequencies = {
        success = { 800, 1000 },
        error = { 400, 300 },
        warning = { 600, 500 },
        info = { 500, 600 }
    },
    waveType = 'sine'
}

Config.Behavior = {
    defaultDuration = 5000,
    autoRemove = true,
    clickable = false,
    queue = {
        delay = 100,
        maxSize = 10,
        staggeredPositions = true,
        staggerOffset = 8
    }
}