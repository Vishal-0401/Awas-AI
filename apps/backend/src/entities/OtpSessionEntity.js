const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const OtpSessionEntity = sequelize.define('OtpSession', {
  id: {
    type: DataTypes.STRING,
    primaryKey: true,
  },
  phone: DataTypes.STRING,
  email: DataTypes.STRING,
  otp: DataTypes.STRING,
  status: {
    type: DataTypes.STRING,
    defaultValue: 'PENDING',
  },
  attempts: {
    type: DataTypes.INTEGER,
    defaultValue: 0,
  },
  expiresAt: DataTypes.DATE,
  verifiedAt: DataTypes.DATE,
  createdAt: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW,
  },
}, {
  tableName: 'otp_sessions',
  timestamps: true,
  updatedAt: false,
});

module.exports = OtpSessionEntity;