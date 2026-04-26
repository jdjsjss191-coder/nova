const sqlite3 = require('sqlite3').verbose();
const path = require('path');

class Database {
    constructor() {
        this.db = new sqlite3.Database(path.join(__dirname, 'vyron.db'));
        this.initTables();
    }

    initTables() {
        // Users table
        this.db.run(`
            CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                discord_id TEXT UNIQUE NOT NULL,
                username TEXT NOT NULL,
                password TEXT NOT NULL,
                hwid TEXT,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
            )
        `);

        // Script keys table
        this.db.run(`
            CREATE TABLE IF NOT EXISTS script_keys (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                key_value TEXT UNIQUE NOT NULL,
                created_by TEXT NOT NULL,
                duration_hours INTEGER NOT NULL,
                max_users INTEGER NOT NULL,
                used_count INTEGER DEFAULT 0,
                assigned_users TEXT DEFAULT '[]',
                assigned_roles TEXT DEFAULT '[]',
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                expires_at DATETIME NOT NULL,
                is_active BOOLEAN DEFAULT 1
            )
        `);

        // Key usage table
        this.db.run(`
            CREATE TABLE IF NOT EXISTS key_usage (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                key_id INTEGER,
                user_id TEXT,
                used_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (key_id) REFERENCES script_keys (id)
            )
        `);

        console.log('Database tables initialized successfully');
    }

    // User management
    async createUser(discordId, username, password) {
        return new Promise((resolve, reject) => {
            const stmt = this.db.prepare(`
                INSERT INTO users (discord_id, username, password) 
                VALUES (?, ?, ?)
            `);
            
            stmt.run([discordId, username, password], function(err) {
                if (err) {
                    reject(err);
                } else {
                    resolve(this.lastID);
                }
            });
            stmt.finalize();
        });
    }

    async getUser(discordId) {
        return new Promise((resolve, reject) => {
            this.db.get(
                'SELECT * FROM users WHERE discord_id = ?',
                [discordId],
                (err, row) => {
                    if (err) reject(err);
                    else resolve(row);
                }
            );
        });
    }

    async updateUserHwid(discordId, hwid = null) {
        return new Promise((resolve, reject) => {
            this.db.run(
                'UPDATE users SET hwid = ?, updated_at = CURRENT_TIMESTAMP WHERE discord_id = ?',
                [hwid, discordId],
                function(err) {
                    if (err) reject(err);
                    else resolve(this.changes);
                }
            );
        });
    }

    // Script key management
    async createScriptKey(keyValue, createdBy, durationHours, maxUsers, assignedUsers = [], assignedRoles = []) {
        return new Promise((resolve, reject) => {
            const expiresAt = new Date(Date.now() + (durationHours * 60 * 60 * 1000)).toISOString();
            
            const stmt = this.db.prepare(`
                INSERT INTO script_keys (key_value, created_by, duration_hours, max_users, assigned_users, assigned_roles, expires_at) 
                VALUES (?, ?, ?, ?, ?, ?, ?)
            `);
            
            stmt.run([
                keyValue, 
                createdBy, 
                durationHours, 
                maxUsers, 
                JSON.stringify(assignedUsers),
                JSON.stringify(assignedRoles),
                expiresAt
            ], function(err) {
                if (err) {
                    reject(err);
                } else {
                    resolve(this.lastID);
                }
            });
            stmt.finalize();
        });
    }

    async getScriptKey(keyValue) {
        return new Promise((resolve, reject) => {
            this.db.get(
                'SELECT * FROM script_keys WHERE key_value = ? AND is_active = 1',
                [keyValue],
                (err, row) => {
                    if (err) reject(err);
                    else resolve(row);
                }
            );
        });
    }

    async getAllActiveKeys() {
        return new Promise((resolve, reject) => {
            this.db.all(
                'SELECT * FROM script_keys WHERE is_active = 1 AND expires_at > datetime("now")',
                [],
                (err, rows) => {
                    if (err) reject(err);
                    else resolve(rows);
                }
            );
        });
    }

    async useScriptKey(keyId, userId) {
        return new Promise((resolve, reject) => {
            this.db.serialize(() => {
                this.db.run('BEGIN TRANSACTION');
                
                // Update key usage count
                this.db.run(
                    'UPDATE script_keys SET used_count = used_count + 1 WHERE id = ?',
                    [keyId],
                    (err) => {
                        if (err) {
                            this.db.run('ROLLBACK');
                            reject(err);
                            return;
                        }
                    }
                );

                // Log key usage
                this.db.run(
                    'INSERT INTO key_usage (key_id, user_id) VALUES (?, ?)',
                    [keyId, userId],
                    (err) => {
                        if (err) {
                            this.db.run('ROLLBACK');
                            reject(err);
                        } else {
                            this.db.run('COMMIT');
                            resolve(true);
                        }
                    }
                );
            });
        });
    }

    async deactivateKey(keyValue) {
        return new Promise((resolve, reject) => {
            this.db.run(
                'UPDATE script_keys SET is_active = 0 WHERE key_value = ?',
                [keyValue],
                function(err) {
                    if (err) reject(err);
                    else resolve(this.changes);
                }
            );
        });
    }

    close() {
        this.db.close();
    }
}

module.exports = Database;