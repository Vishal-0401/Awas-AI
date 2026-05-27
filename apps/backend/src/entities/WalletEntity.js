const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const WalletEntity = sequelize.define('Wallet', {
  id: {
    type: DataTypes.STRING,
    primaryKey: true,
  },
  userId: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  balance: {
    type: DataTypes.DOUBLE,
    defaultValue: 0,
  },
  createdAt: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW,
  },
  updatedAt: DataTypes.DATE,
}, {
  tableName: 'wallet',
  timestamps: true,
});

module.exports = WalletEntity;