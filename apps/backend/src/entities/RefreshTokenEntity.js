const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const RefreshTokenEntity = sequelize.define('RefreshToken', {
  id: {
    type: DataTypes.STRING,
    primaryKey: true,
  },
  token: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  userId: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  expiresAt: DataTypes.DATE,
  createdAt: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW,
  },
}, {
  tableName: 'refreshtoken',
  timestamps: true,
  updatedAt: false,
});

module.exports = RefreshTokenEntity;