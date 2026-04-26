const { Client, GatewayIntentBits, SlashCommandBuilder, EmbedBuilder, PermissionFlagsBits } = require('discord.js');
const Database = require('./database');
const crypto = require('crypto');
require('dotenv').config();

const client = new Client({
    intents: [
        GatewayIntentBits.Guilds,
        GatewayIntentBits.GuildMessages,
        GatewayIntentBits.DirectMessages,
        GatewayIntentBits.MessageContent
    ]
});

const db = new Database();

// Owner configuration
const OWNER_USER_ID = process.env.OWNER_USER_ID || '1481473862775472190';
const OWNER_USERNAME = process.env.OWNER_USERNAME || 'v9pv';

// Utility functions
function generateScriptKey() {
    return 'VYR-' + crypto.randomBytes(16).toString('hex').toUpperCase();
}

function hashPassword(password) {
    return crypto.createHash('sha256').update(password).digest('hex');
}

function isOwner(user) {
    return user.id === OWNER_USER_ID || user.username === OWNER_USERNAME;
}

function createEmbed(title, description, color = 0x8A2BE2) {
    return new EmbedBuilder()
        .setTitle(title)
        .setDescription(description)
        .setColor(color)
        .setTimestamp()
        .setFooter({ text: 'Vyron Internal System' });
}

// Slash commands
const commands = [
    new SlashCommandBuilder()
        .setName('register')
        .setDescription('Register a new account for Vyron Internal')
        .addStringOption(option =>
            option.setName('username')
                .setDescription('Your desired username')
                .setRequired(true))
        .addStringOption(option =>
            option.setName('password')
                .setDescription('Your desired password')
                .setRequired(true)),

    new SlashCommandBuilder()
        .setName('genscriptkey')
        .setDescription('Generate a new script key (Owner only)')
        .addIntegerOption(option =>
            option.setName('duration')
                .setDescription('Duration in hours')
                .setRequired(true))
        .addIntegerOption(option =>
            option.setName('maxusers')
                .setDescription('Maximum number of users')
                .setRequired(true))
        .addStringOption(option =>
            option.setName('users')
                .setDescription('Specific user IDs (comma separated)')
                .setRequired(false))
        .addRoleOption(option =>
            option.setName('role')
                .setDescription('Role to assign keys to')
                .setRequired(false)),

    new SlashCommandBuilder()
        .setName('resethwid')
        .setDescription('Reset your hardware ID'),

    new SlashCommandBuilder()
        .setName('download')
        .setDescription('Get download link for Vyron Internal'),

    new SlashCommandBuilder()
        .setName('keyinfo')
        .setDescription('Get information about your script keys (Owner only)'),

    new SlashCommandBuilder()
        .setName('deactivatekey')
        .setDescription('Deactivate a script key (Owner only)')
        .addStringOption(option =>
            option.setName('key')
                .setDescription('The key to deactivate')
                .setRequired(true))
];

client.once('ready', async () => {
    console.log(`✅ ${client.user.tag} is online!`);
    console.log(`🔧 Serving ${client.guilds.cache.size} guilds`);
    
    // Register slash commands
    try {
        console.log('🔄 Refreshing slash commands...');
        await client.application.commands.set(commands);
        console.log('✅ Slash commands registered successfully!');
    } catch (error) {
        console.error('❌ Error registering slash commands:', error);
    }
});

client.on('interactionCreate', async interaction => {
    if (!interaction.isChatInputCommand()) return;

    const { commandName, user, options } = interaction;

    try {
        switch (commandName) {
            case 'register':
                await handleRegister(interaction);
                break;
            case 'genscriptkey':
                await handleGenScriptKey(interaction);
                break;
            case 'resethwid':
                await handleResetHwid(interaction);
                break;
            case 'download':
                await handleDownload(interaction);
                break;
            case 'keyinfo':
                await handleKeyInfo(interaction);
                break;
            case 'deactivatekey':
                await handleDeactivateKey(interaction);
                break;
        }
    } catch (error) {
        console.error(`Error handling ${commandName}:`, error);
        
        const errorEmbed = createEmbed(
            '❌ Error',
            'An error occurred while processing your request. Please try again later.',
            0xFF0000
        );

        if (interaction.replied || interaction.deferred) {
            await interaction.followUp({ embeds: [errorEmbed], ephemeral: true });
        } else {
            await interaction.reply({ embeds: [errorEmbed], ephemeral: true });
        }
    }
});

async function handleRegister(interaction) {
    const username = options.getString('username');
    const password = options.getString('password');
    const discordId = interaction.user.id;

    // Check if user already exists
    const existingUser = await db.getUser(discordId);
    if (existingUser) {
        const embed = createEmbed(
            '⚠️ Already Registered',
            'You already have an account registered!',
            0xFFAA00
        );
        return interaction.reply({ embeds: [embed], ephemeral: true });
    }

    // Validate input
    if (username.length < 3 || username.length > 20) {
        const embed = createEmbed(
            '❌ Invalid Username',
            'Username must be between 3 and 20 characters.',
            0xFF0000
        );
        return interaction.reply({ embeds: [embed], ephemeral: true });
    }

    if (password.length < 6) {
        const embed = createEmbed(
            '❌ Invalid Password',
            'Password must be at least 6 characters long.',
            0xFF0000
        );
        return interaction.reply({ embeds: [embed], ephemeral: true });
    }

    // Create user
    const hashedPassword = hashPassword(password);
    await db.createUser(discordId, username, hashedPassword);

    const embed = createEmbed(
        '✅ Registration Successful',
        `Welcome to Vyron Internal, **${username}**!\n\nYour account has been created successfully. You can now use your credentials to access our internal systems.\n\n**Username:** ${username}\n**Discord ID:** ${discordId}`,
        0x00FF00
    );

    await interaction.reply({ embeds: [embed], ephemeral: true });
}

async function handleGenScriptKey(interaction) {
    if (!isOwner(interaction.user)) {
        const embed = createEmbed(
            '❌ Access Denied',
            'Only the owner can generate script keys.',
            0xFF0000
        );
        return interaction.reply({ embeds: [embed], ephemeral: true });
    }

    const duration = interaction.options.getInteger('duration');
    const maxUsers = interaction.options.getInteger('maxusers');
    const usersString = interaction.options.getString('users');
    const role = interaction.options.getRole('role');

    let assignedUsers = [];
    let assignedRoles = [];

    if (usersString) {
        assignedUsers = usersString.split(',').map(id => id.trim());
    }

    if (role) {
        assignedRoles = [role.id];
        
        // Get members with the role
        const guild = interaction.guild;
        if (guild) {
            const members = await guild.members.fetch();
            const roleMembers = members.filter(member => member.roles.cache.has(role.id));
            assignedUsers = [...assignedUsers, ...roleMembers.map(member => member.id)];
        }
    }

    const scriptKey = generateScriptKey();
    
    await db.createScriptKey(
        scriptKey,
        interaction.user.id,
        duration,
        maxUsers,
        assignedUsers,
        assignedRoles
    );

    const embed = createEmbed(
        '🔑 Script Key Generated',
        `**Key:** \`${scriptKey}\`\n**Duration:** ${duration} hours\n**Max Users:** ${maxUsers}\n**Assigned Users:** ${assignedUsers.length}\n**Expires:** <t:${Math.floor((Date.now() + duration * 60 * 60 * 1000) / 1000)}:F>`,
        0x00FF00
    );

    await interaction.reply({ embeds: [embed], ephemeral: true });

    // Send keys to assigned users
    if (assignedUsers.length > 0) {
        for (const userId of assignedUsers) {
            try {
                const user = await client.users.fetch(userId);
                const userEmbed = createEmbed(
                    '🎉 Script Key Assigned',
                    `You have been assigned a Vyron Internal script key!\n\n**Key:** \`${scriptKey}\`\n**Duration:** ${duration} hours\n**Expires:** <t:${Math.floor((Date.now() + duration * 60 * 60 * 1000) / 1000)}:F>\n\nUse this key to access Vyron Internal systems.`,
                    0x8A2BE2
                );
                await user.send({ embeds: [userEmbed] });
            } catch (error) {
                console.error(`Failed to send key to user ${userId}:`, error);
            }
        }
    }
}

async function handleResetHwid(interaction) {
    const discordId = interaction.user.id;
    
    const user = await db.getUser(discordId);
    if (!user) {
        const embed = createEmbed(
            '❌ Not Registered',
            'You need to register first using `/register`.',
            0xFF0000
        );
        return interaction.reply({ embeds: [embed], ephemeral: true });
    }

    await db.updateUserHwid(discordId, null);

    const embed = createEmbed(
        '✅ HWID Reset',
        'Your hardware ID has been reset successfully. You can now use Vyron Internal on a different device.',
        0x00FF00
    );

    await interaction.reply({ embeds: [embed], ephemeral: true });
}

async function handleDownload(interaction) {
    const embed = createEmbed(
        '📥 Download Link',
        '❌ **No link provided yet, please wait!**\n\nThe download link will be available soon. Please check back later or contact an administrator.',
        0xFFAA00
    );

    await interaction.reply({ embeds: [embed], ephemeral: true });
}

async function handleKeyInfo(interaction) {
    if (!isOwner(interaction.user)) {
        const embed = createEmbed(
            '❌ Access Denied',
            'Only the owner can view key information.',
            0xFF0000
        );
        return interaction.reply({ embeds: [embed], ephemeral: true });
    }

    const keys = await db.getAllActiveKeys();
    
    if (keys.length === 0) {
        const embed = createEmbed(
            '📊 Key Information',
            'No active keys found.',
            0xFFAA00
        );
        return interaction.reply({ embeds: [embed], ephemeral: true });
    }

    let description = '';
    keys.forEach((key, index) => {
        const expiresAt = Math.floor(new Date(key.expires_at).getTime() / 1000);
        description += `**${index + 1}.** \`${key.key_value}\`\n`;
        description += `   • Used: ${key.used_count}/${key.max_users}\n`;
        description += `   • Expires: <t:${expiresAt}:R>\n\n`;
    });

    const embed = createEmbed(
        '📊 Active Script Keys',
        description,
        0x8A2BE2
    );

    await interaction.reply({ embeds: [embed], ephemeral: true });
}

async function handleDeactivateKey(interaction) {
    if (!isOwner(interaction.user)) {
        const embed = createEmbed(
            '❌ Access Denied',
            'Only the owner can deactivate keys.',
            0xFF0000
        );
        return interaction.reply({ embeds: [embed], ephemeral: true });
    }

    const keyValue = interaction.options.getString('key');
    
    const key = await db.getScriptKey(keyValue);
    if (!key) {
        const embed = createEmbed(
            '❌ Key Not Found',
            'The specified key was not found or is already inactive.',
            0xFF0000
        );
        return interaction.reply({ embeds: [embed], ephemeral: true });
    }

    await db.deactivateKey(keyValue);

    const embed = createEmbed(
        '✅ Key Deactivated',
        `Script key \`${keyValue}\` has been deactivated successfully.`,
        0x00FF00
    );

    await interaction.reply({ embeds: [embed], ephemeral: true });
}

// Error handling
process.on('unhandledRejection', error => {
    console.error('Unhandled promise rejection:', error);
});

process.on('uncaughtException', error => {
    console.error('Uncaught exception:', error);
    process.exit(1);
});

// Graceful shutdown
process.on('SIGINT', () => {
    console.log('🔄 Shutting down gracefully...');
    db.close();
    client.destroy();
    process.exit(0);
});

client.login(process.env.DISCORD_TOKEN);