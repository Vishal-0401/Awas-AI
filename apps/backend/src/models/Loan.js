const db = require('../config/db');

const Loan = {
  createTable: async () => {
    const query = `
      CREATE TABLE IF NOT EXISTS loans (
        id INT AUTO_INCREMENT PRIMARY KEY,
        customerId INT NOT NULL,
        amount DECIMAL(18,2) NOT NULL,
        tenureMonths INT NOT NULL,
        interestRate DECIMAL(10,4) NOT NULL,
        monthlyEmi DECIMAL(18,2) NOT NULL,
        status VARCHAR(50) NOT NULL DEFAULT 'PENDING',
        outstandingAmount DECIMAL(18,2) NOT NULL,
        createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        CONSTRAINT fk_loans_customer
          FOREIGN KEY (customerId) REFERENCES customers(id)
          ON DELETE CASCADE
      )
    `;
    await db.query(query);
  },

  create: async ({ customerId, amount, tenureMonths, interestRate, monthlyEmi }) => {
    const [result] = await db.query(
      `INSERT INTO loans (customerId, amount, tenureMonths, interestRate, monthlyEmi, status, outstandingAmount)
       VALUES (?, ?, ?, ?, ?, 'ACTIVE', ?)` ,
      [customerId, amount, tenureMonths, interestRate, monthlyEmi, amount]
    );
    return result.insertId;
  },

  findByCustomerId: async (customerId) => {
    const [rows] = await db.query(
      `SELECT * FROM loans WHERE customerId = ? ORDER BY createdAt DESC`,
      [customerId]
    );
    return rows;
  },

  findByIdAndCustomerId: async (loanId, customerId) => {
    const [rows] = await db.query(
      `SELECT * FROM loans WHERE id = ? AND customerId = ?`,
      [loanId, customerId]
    );
    return rows[0];
  },

  applyRepayment: async (loanId, customerId, repaymentAmount) => {
    const loan = await Loan.findByIdAndCustomerId(loanId, customerId);
    if (!loan) return null;

    const newOutstanding = Number(loan.outstandingAmount) - Number(repaymentAmount);
    const outstandingAmount = newOutstanding > 0 ? newOutstanding : 0;
    const status = outstandingAmount === 0 ? 'CLOSED' : loan.status;

    await db.query(
      `UPDATE loans
       SET outstandingAmount = ?, status = ?, updatedAt = CURRENT_TIMESTAMP
       WHERE id = ? AND customerId = ?`,
      [outstandingAmount, status, loanId, customerId]
    );

    return Loan.findByIdAndCustomerId(loanId, customerId);
  }
};

module.exports = Loan;

