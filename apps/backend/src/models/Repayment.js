const db = require('../config/db');

const Repayment = {
  createTable: async () => {
    const query = `
      CREATE TABLE IF NOT EXISTS repayments (
        id INT AUTO_INCREMENT PRIMARY KEY,
        loanId INT NOT NULL,
        customerId INT NOT NULL,
        amount DECIMAL(18,2) NOT NULL,
        repaymentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        CONSTRAINT fk_repayments_loan
          FOREIGN KEY (loanId) REFERENCES loans(id)
          ON DELETE CASCADE
      )
    `;
    await db.query(query);
  },

  create: async ({ loanId, customerId, amount }) => {
    const [result] = await db.query(
      `INSERT INTO repayments (loanId, customerId, amount)
       VALUES (?, ?, ?)`,
      [loanId, customerId, amount]
    );
    return result.insertId;
  },

  findByCustomerId: async (customerId) => {
    const [rows] = await db.query(
      `SELECT r.*, l.amount as loanAmount, l.tenureMonths, l.interestRate
       FROM repayments r
       JOIN loans l ON l.id = r.loanId
       WHERE r.customerId = ?
       ORDER BY r.repaymentDate DESC`,
      [customerId]
    );
    return rows;
  }
};

module.exports = Repayment;

