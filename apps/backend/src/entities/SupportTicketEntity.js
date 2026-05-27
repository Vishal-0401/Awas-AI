const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const SupportTicketEntity = sequelize.define('SupportTicket', {
  id: {
    type: DataTypes.STRING,
    primaryKey: true,
  },
  userId: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  subject: DataTypes.STRING,
  message: DataTypes.TEXT,
  status: {
    type: DataTypes.STRING,
    defaultValue: 'OPEN',
  },
  createdAt: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW,
  },
  updatedAt: DataTypes.DATE,
}, {
  tableName: 'supportticket',
  timestamps: true,
});

module.exports = SupportTicketEntity;