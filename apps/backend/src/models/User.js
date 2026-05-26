const db = require('../config/db');

const User = {
    createTable: async () => {
        const query = `
            CREATE TABLE IF NOT EXISTS users (
                id INT AUTO_INCREMENT PRIMARY KEY,
                email VARCHAR(255) NOT NULL UNIQUE,
                password VARCHAR(255) NOT NULL,
                name VARCHAR(255) NOT NULL,
                mobile VARCHAR(20) NULL,
                isActive BOOLEAN DEFAULT TRUE,
                defaultRole VARCHAR(50) NULL,
                createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
            )
        `;
        await db.query(query);
    },

    findByEmail: async (email) => {
        const [rows] = await db.query('SELECT * FROM users WHERE email = ?', [email]);
        return rows[0];
    },

    create: async (userData) => {
        const { name, email, password, mobile, defaultRole, isActive } = userData;
        const [result] = await db.query(
            `INSERT INTO users (name, email, password, mobile, isActive, defaultRole)
             VALUES (?, ?, ?, ?, ?, ?)`,
            [
                name,
                email,
                password,
                mobile || null,
                isActive === undefined ? true : isActive,
                defaultRole || null
            ]
        );
        return result.insertId;
    },

    findById: async (id) => {
        const [rows] = await db.query(
            'SELECT id, name, email, mobile, isActive, defaultRole, createdAt, updatedAt FROM users WHERE id = ?',
            [id]
        );
        return rows[0];
    }
};


module.exports = User;
