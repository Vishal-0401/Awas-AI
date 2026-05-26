const db = require('../config/db');

const Customer = {
  createTable: async () => {
    const query = `
      CREATE TABLE IF NOT EXISTS customers (
        id INT AUTO_INCREMENT PRIMARY KEY,
        userId INT NOT NULL UNIQUE,
        fullName VARCHAR(255) NULL,
        panId VARCHAR(50) NULL,
        address TEXT NULL,
        kycStatus VARCHAR(50) NOT NULL DEFAULT 'PENDING_KYC',
        kycSubmittedAt TIMESTAMP NULL,
        kycApprovedAt TIMESTAMP NULL,
        createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        CONSTRAINT fk_customers_user
          FOREIGN KEY (userId) REFERENCES users(id)
          ON DELETE CASCADE
      )
    `;
    await db.query(query);
  },

  createForUser: async (userId) => {
    const [result] = await db.query(
      `INSERT INTO customers (userId, kycStatus) VALUES (?, 'PENDING_KYC')`,
      [userId]
    );
    return result.insertId;
  },

  findByUserId: async (userId) => {
    const [rows] = await db.query(`SELECT * FROM customers WHERE userId = ?`, [userId]);
    return rows[0];
  },

  upsertKyc: async (userId, kyc) => {
    const existing = await Customer.findByUserId(userId);

    const { fullName, panId, address } = kyc;

    if (!existing) {
      await Customer.createForUser(userId);
    }

    const now = new Date();

    await db.query(
      `UPDATE customers
       SET fullName = ?, panId = ?, address = ?,
           kycStatus = 'APPROVED',
           kycSubmittedAt = COALESCE(kycSubmittedAt, ?),
           kycApprovedAt = ?,
           updatedAt = CURRENT_TIMESTAMP
       WHERE userId = ?`,
      [fullName || null, panId || null, address || null, now, now, userId]
    );

    return Customer.findByUserId(userId);
  }
};

module.exports = Customer;

