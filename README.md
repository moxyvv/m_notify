# m_notify - Clean Notification System for FiveM

A modern, lightweight notification system built with React and TypeScript for FiveM servers. Features beautiful animations, customizable positioning, sound effects, and a clean API.

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![FiveM](https://img.shields.io/badge/FiveM-Ready-orange.svg)

## ✨ Features

- **Modern UI** - Clean, glass-morphism design with smooth animations
- **Multiple Positions** - 8 different positioning options (top-right, bottom-left, center, etc.)
- **Sound System** - Customizable audio feedback with different tones for each notification type
- **Rate Limiting** - Built-in protection against spam and abuse
- **Lightweight** - Optimized build with minimal resource usage
- **Easy Integration** - Simple exports and events for seamless server integration

## 🚀 Installation

1. Download the resource and place it in your `resources` folder
2. Add `ensure m_notify` to your `server.cfg`
3. Restart your server or start the resource

```bash
# In your server.cfg
ensure m_notify
```

## 📖 Usage

### Server-Side Exports

#### Send to Specific Player
```lua
-- Basic notification
exports['m_notify']:SendNotificationToPlayer(playerId, "Welcome to the server!", "success", 5000, "Welcome")

-- With all parameters
exports['m_notify']:SendNotificationToPlayer(playerId, message, type, duration, title)
```

#### Send to All Players
```lua
-- Server restart notification
exports['m_notify']:SendNotificationToAll("Server restarting in 5 minutes!", "warning", 10000, "Server Notice")
```

#### Send in Range
```lua
-- Local area notification
local coords = GetEntityCoords(GetPlayerPed(playerId))
exports['m_notify']:SendNotificationInRange(coords, 50.0, "Someone is nearby!", "info", 3000, "Proximity Alert")
```

#### Send Multiple Notifications
```lua
-- Batch notifications
local notifications = {
    {message = "Task 1 completed!", type = "success", duration = 3000, title = "Progress"},
    {message = "Task 2 in progress...", type = "info", duration = 4000, title = "Progress"},
    {message = "Task 3 failed!", type = "error", duration = 5000, title = "Progress"}
}

exports['m_notify']:SendNotificationsToPlayer(playerId, notifications)
```

#### Clear Player Notifications
```lua
-- Clear all notifications for a player
exports['m_notify']:ClearPlayerNotifications(playerId)
```

### Client-Side Usage

#### Direct Client Function
```lua
-- Show notification directly on client
exports['m_notify']:ShowNotification("You found a weapon!", "success", 4000, "Loot Found")
```

#### Multiple Notifications
```lua
-- Show multiple notifications at once
local notifications = {
    {message = "Health restored", type = "success", duration = 2000, title = "Medical"},
    {message = "Armor restored", type = "info", duration = 2000, title = "Medical"}
}

exports['m_notify']:ShowNotifications(notifications)
```

### Event-Based Usage

#### Server Events
```lua
-- Trigger from server
TriggerClientEvent('notification:show', playerId, "Custom message", "warning", 5000, "Custom Title")

-- Multiple notifications
TriggerClientEvent('notification:showMultiple', playerId, {
    {message = "First notification", type = "info", duration = 3000, title = "Batch 1"},
    {message = "Second notification", type = "success", duration = 3000, title = "Batch 2"}
})

-- Clear notifications
TriggerClientEvent('notification:clear', playerId)
```

## 🎨 Configuration

Edit `config.lua` to customize the notification system:

```lua
Config = {}

-- Positioning
Config.Position = {
    location = 'right-center', -- 8 position options available
    spacing = 12,              -- Space between notifications
    maxNotifications = 5,      -- Maximum notifications shown
    slideInDistance = 100,     -- Animation distance
    animationDuration = 400    -- Animation speed
}

-- Sound Settings
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

-- Behavior
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
```

### Position Options
- `top-right` - Top right corner
- `top-left` - Top left corner  
- `bottom-right` - Bottom right corner
- `bottom-left` - Bottom left corner
- `top-center` - Top center
- `bottom-center` - Bottom center
- `left-center` - Left center
- `right-center` - Right center

### Notification Types
- `success` - Green notification with checkmark
- `error` - Red notification with X icon
- `warning` - Orange notification with warning triangle
- `info` - Blue notification with info icon

## 🛠️ Development

### Building from Source

```bash
# Navigate to web directory
cd web

# Install dependencies
npm install

# Build for production
npm run build
```

### Testing Commands

The resource includes built-in test commands:

```bash
# Basic test notification
/notify

# Test with custom message
/notify Hello World!

# Test all notification types
/notify_styles
```

## 🔧 API Reference

### Server Exports

| Export | Parameters | Description |
|--------|------------|-------------|
| `SendNotificationToPlayer` | `playerId, message, type, duration, title` | Send notification to specific player |
| `SendNotificationToAll` | `message, type, duration, title` | Send notification to all players |
| `SendNotificationInRange` | `coords, range, message, type, duration, title` | Send notification to players in range |
| `SendNotificationsToPlayer` | `playerId, notifications` | Send multiple notifications to player |
| `ClearPlayerNotifications` | `playerId` | Clear all notifications for player |

### Client Exports

| Export | Parameters | Description |
|--------|------------|-------------|
| `ShowNotification` | `message, type, duration, title` | Show notification on client |
| `ShowNotifications` | `notifications` | Show multiple notifications |
| `ClearNotifications` | - | Clear all notifications |

### Events

| Event | Direction | Description |
|-------|-----------|-------------|
| `notification:show` | Server → Client | Show single notification |
| `notification:showMultiple` | Server → Client | Show multiple notifications |
| `notification:clear` | Server → Client | Clear notifications |
| `notification:requestShow` | Client → Server | Request notification from server |

## 🎯 Examples

### Banking System
```lua
-- Money deposited
exports['m_notify']:SendNotificationToPlayer(playerId, 
    "You deposited $5,000", "success", 3000, "Bank")

-- Insufficient funds
exports['m_notify']:SendNotificationToPlayer(playerId, 
    "Insufficient funds", "error", 4000, "Bank")
```

### Job System
```lua
-- Job completed
exports['m_notify']:SendNotificationToPlayer(playerId, 
    "Delivery completed! +$250", "success", 5000, "Delivery Job")

-- Job failed
exports['m_notify']:SendNotificationToPlayer(playerId, 
    "Delivery failed - package damaged", "error", 6000, "Delivery Job")
```

### Admin System
```lua
-- Admin warning
exports['m_notify']:SendNotificationToAll(
    "Server maintenance in 10 minutes", "warning", 10000, "Admin Notice")
```

## 🐛 Troubleshooting

### Common Issues

**Notifications not showing?**
- Check if the resource is started: `ensure m_notify`
- Verify the web build files exist in `web/build/`
- Check F8 console for any errors

**Sound not working?**
- Ensure `Config.Sound.enabled = true`
- Check browser audio permissions
- Verify audio context is supported

**Performance issues?**
- Reduce `maxNotifications` in config
- Lower `animationDuration` for faster animations
- Check rate limiting settings

## 📝 Changelog

### v1.0.0
- Initial release
- Modern React-based UI
- Sound system with customizable frequencies
- Multiple positioning options
- Rate limiting and spam protection
- TypeScript support
- Comprehensive API

## 🤝 Contributing

Feel free to submit issues, feature requests, or pull requests. This resource is actively maintained and we welcome community contributions.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👨‍💻 Author

**Moxy**
- Discord: [Join Server](https://discord.gg/tJ8y4rXjcd)
- Website: [moxydev.xyz](https://moxydev.xyz/)

---

*Made with ❤️ for the FiveM community*
