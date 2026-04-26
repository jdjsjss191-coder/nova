# Vyron Internal

A complete internal system with animated website and Discord bot for user management and key distribution.

## 🌐 Website Features

- **Stunning Animated Design**: Realistic rotating planets, floating particles, and dynamic effects
- **Login System**: Beautiful modal with username, password, and script key authentication
- **Responsive Design**: Works perfectly on all devices
- **Space Theme**: Immersive cosmic background with interactive elements

## 🤖 Discord Bot Features

- **User Registration**: Secure account creation with encrypted passwords
- **Script Key Generation**: Time-limited keys with usage restrictions
- **Role-Based Distribution**: Automatically assign keys to Discord roles
- **HWID Management**: Hardware ID tracking and reset functionality
- **Persistent Database**: SQLite storage that survives restarts

## 🚀 Quick Start

### Website
1. Open `index.html` in your browser
2. Click "Load Internal" to see the login modal
3. Enter credentials to access the system

### Discord Bot
1. Navigate to `discord-bot/` folder
2. Follow the setup instructions in `discord-bot/README.md`
3. Deploy to Railway for 24/7 uptime

## 📋 Commands

### User Commands (DMs only)
- `/register <username> <password>` - Create account
- `/resethwid` - Reset hardware ID
- `/download` - Get download link

### Owner Commands (v9pv only)
- `/genscriptkey <hours> <maxusers> [users] [role]` - Generate keys
- `/keyinfo` - View active keys
- `/deactivatekey <key>` - Deactivate key

## 🔐 Security

- Owner verification by Discord ID: `1481473862775472190`
- Password hashing with SHA-256
- Time-limited script keys
- Usage tracking and limits
- Secure environment variables

## 🛠️ Tech Stack

- **Frontend**: HTML5, CSS3, JavaScript (Vanilla)
- **Backend**: Node.js, Discord.js v14
- **Database**: SQLite3
- **Deployment**: Railway
- **Version Control**: Git/GitHub

## 📦 Deployment

1. **GitHub**: Push all files to repository
2. **Railway**: Connect GitHub repo for auto-deployment
3. **Environment**: Set Discord token and owner ID
4. **Database**: Automatic SQLite creation

## 🎨 Visual Features

- Animated gradient backgrounds
- 3D rotating planets with realistic textures
- Mouse-following particle effects
- Glowing UI elements
- Smooth transitions and hover effects
- Glass morphism design elements

## 📞 Support

Contact the owner (v9pv) for access or technical support.

---

**Vyron Internal** - Advanced systems for advanced users.