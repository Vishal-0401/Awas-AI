const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const UserEntity = sequelize.define('User', {
  id: {
    type: DataTypes.STRING,
    primaryKey: true,
  },
  fullName: DataTypes.STRING,
  email: {
    type: DataTypes.STRING,
    unique: true,
  },
  phone: {
    type: DataTypes.STRING,
    unique: true,
  },
  avatar: DataTypes.STRING,
  googleId: DataTypes.STRING,
  authProvider: {
    type: DataTypes.ENUM('LOCAL', 'GOOGLE', 'APPLE'),
    defaultValue: 'LOCAL',
  },
  role: {
    type: DataTypes.ENUM('CUSTOMER', 'WORKER', 'ADMIN'),
    defaultValue: 'CUSTOMER',
  },
  isVerified: {
    type: DataTypes.BOOLEAN,
    defaultValue: false,
  },
  createdAt: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW,
  },
  updatedAt: DataTypes.DATE,
}, {
  tableName: 'user',
  timestamps: true,
});

module.exports = UserEntity;