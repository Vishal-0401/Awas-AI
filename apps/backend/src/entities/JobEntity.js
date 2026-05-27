const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const JobEntity = sequelize.define('Job', {
  id: {
    type: DataTypes.STRING,
    primaryKey: true,
  },
  bookingId: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  workerId: DataTypes.STRING,
  status: {
    type: DataTypes.ENUM(
      'REQUESTED',
      'ASSIGNED',
      'ARRIVING',
      'STARTED',
      'COMPLETED',
      'CANCELLED'
    ),
    defaultValue: 'REQUESTED',
  },
  startedAt: DataTypes.DATE,
  completedAt: DataTypes.DATE,
  createdAt: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW,
  },
  updatedAt: DataTypes.DATE,
}, {
  tableName: 'job',
  timestamps: true,
});

module.exports = JobEntity;