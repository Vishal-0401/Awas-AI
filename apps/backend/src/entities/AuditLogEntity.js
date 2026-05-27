const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const AuditLogEntity = sequelize.define('AuditLog', {
  id: {
    type: DataTypes.STRING,
    primaryKey: true,
  },
  userId: DataTypes.STRING,
  action: DataTypes.STRING,
  resource: DataTypes.STRING,
  details: DataTypes.JSON,
  ipAddress: DataTypes.STRING,
  createdAt: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW,
  },
}, {
  tableName: 'auditlog',
  timestamps: true,
  updatedAt: false,
});

module.exports = AuditLogEntity;