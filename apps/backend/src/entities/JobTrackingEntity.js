const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const JobTrackingEntity = sequelize.define('JobTracking', {
  id: {
    type: DataTypes.STRING,
    primaryKey: true,
  },
  jobId: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  latitude: DataTypes.DOUBLE,
  longitude: DataTypes.DOUBLE,
  heading: DataTypes.DOUBLE,
  speed: DataTypes.DOUBLE,
  updatedAt: DataTypes.DATE,
}, {
  tableName: 'jobtracking',
  timestamps: true,
  createdAt: false,
});

module.exports = JobTrackingEntity;