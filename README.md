# Vyron Internal Discord Bot

A Discord bot for managing user registration, script key generation, and access control for Vyron Internal systems.

## Features

- **User Registration**: Users can register with username/password via DMs
- **Script Key Generation**: Owner can generate time-limited keys for specific users or roles
- **HWID Management**: Users can reset their hardware ID
- **Download Links**: Placeholder for future download functionality
- **Persistent Storage**: All data saved to SQLite database
- **Owner-Only Commands**: Secure key generation restricted to authorized user

## Commands

### User Commands (Available to all users in DMs)
- `/register <username> <password>` - Register a new account
- `/resethwid` - Reset your hardware ID
- `/download` - Get download link (placeholder)

### Owner Commands (Restricted to owner only)
- `/genscriptkey <duration> <maxusers> [users] [role]` - Generate script keys
- `/keyinfo` - View all active script keys
- `/deactivatekey <key>` - Deactivate a specific key

## Setup Instructions

### 1. Install Dependencies
```bash
cd discord-bot
npm install
```

### 2. Environment Configuration
Create a `.env` file based on `.env.example`:
```bash
cp .env.example .env
```

Edit `.env` with your values:
```
DISCORD_TOKEN=your_discord_bot_token_here
OWNER_USER_ID=1481473862775472190
OWNER_USERNAME=v9pv
```

### 3. Discord Bot Setup
1. Go to [Discord Developer Portal](https://discord.com/developers/applications)
2. Create a new application
3. Go to "Bot" section and create a bot
4. Copy the bot token to your `.env` file
5. Enable the following bot permissions:
   - Send Messages
   - Use Slash Commands
   - Read Message History
   - Embed Links

### 4. Bot Permissions & Intents
Required intents:
- Guilds
- Guild Messages
- Direct Messages
- Message Content

Required permissions:
- Send Messages
- Use Slash Commands
- Embed Links

### 5. Railway Deployment

#### Option 1: GitHub + Railway
1. Push this code to GitHub:
```bash
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/yourusername/vyron-internal-bot.git
git push -u origin main
```

2. Connect to Railway:
   - Go to [Railway](https://railway.app)
   - Create new project
   - Connect your GitHub repository
   - Set environment variables in Railway dashboard
   - Deploy automatically

#### Option 2: Railway CLI
```bash
# Install Railway CLI
npm install -g @railway/cli

# Login to Railway
railway login

# Initialize project
railway init

# Set environment variables
railway variables set DISCORD_TOKEN=your_token_here
railway variables set OWNER_USER_ID=1481473862775472190
railway variables set OWNER_USERNAME=v9pv

# Deploy
railway up
```

### 6. Database
The bot uses SQLite database (`vyron.db`) which will be created automatically on first run. The database includes:

- **users**: User registration data
- **script_keys**: Generated script keys with expiration and usage limits
- **key_usage**: Key usage tracking

## Owner Configuration

The bot recognizes the owner by either:
- Discord User ID: `1481473862775472190`
- Discord Username: `v9pv`

Only the owner can:
- Generate script keys
- View key information
- Deactivate keys

## Key Generation Features

- **Time-limited keys**: Set expiration in hours
- **Usage limits**: Limit number of users per key
- **User targeting**: Assign keys to specific Discord users
- **Role targeting**: Assign keys to all users with a specific role
- **Automatic distribution**: Keys are automatically sent via DM to assigned users

## Security Features

- Password hashing using SHA-256
- Hardware ID (HWID) tracking and reset capability
- Owner-only command restrictions
- Ephemeral responses for sensitive data
- Database persistence across restarts

## File Structure
```
discord-bot/
├── bot.js              # Main bot file
├── database.js         # Database management
├── package.json        # Dependencies
├── .env.example        # Environment template
├── .env               # Your environment variables (create this)
├── vyron.db           # SQLite database (auto-created)
└── README.md          # This file
```

## Usage Examples

### Register a new user:
```
/register username:john123 password:mypassword
```

### Generate a script key (owner only):
```
/genscriptkey duration:24 maxusers:5 role:@VIP
```

### Reset HWID:
```
/resethwid
```

## Support

For issues or questions, contact the bot owner or check the logs in Railway dashboard.