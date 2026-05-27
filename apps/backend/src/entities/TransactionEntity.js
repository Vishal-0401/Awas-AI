const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const TransactionEntity = sequelize.define('Transaction', {
  id: {
    type: DataTypes.STRING,
    primaryKey: true,
  },
  walletId: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  bookingId: DataTypes.STRING,
  amount: DataTypes.DOUBLE,
  type: {
    type: DataTypes.ENUM('CREDIT', 'DEBIT'),
    allowNull: false,
  },
  status: {
    type: DataTypes.ENUM('PENDING', 'SUCCESS', 'FAILED'),
    defaultValue: 'PENDING',
  },
  reference: DataTypes.STRING,
  createdAt: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW,
  },
}, {
  tableName: 'transaction',
  timestamps: true,
  updatedAt: false,
});

module.exports = TransactionEntity;