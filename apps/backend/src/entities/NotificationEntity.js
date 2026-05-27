const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const NotificationEntity = sequelize.define('Notification', {
  id: {
    type: DataTypes.STRING,
    primaryKey: true,
  },
  userId: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  title: DataTypes.STRING,
  message: DataTypes.STRING,
  type: DataTypes.STRING,
  isRead: {
    type: DataTypes.BOOLEAN,
    defaultValue: false,
  },
  data: DataTypes.JSON,
  createdAt: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW,
  },
}, {
  tableName: 'notification',
  timestamps: true,
  updatedAt: false,
});

module.exports = NotificationEntity;