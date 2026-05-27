const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const PredictiveScoreEntity = sequelize.define('PredictiveScore', {
  id: {
    type: DataTypes.STRING,
    primaryKey: true,
  },
  applianceAssetId: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  overallScore: DataTypes.INTEGER,
  failureRisk: DataTypes.STRING,
  estimatedDaysLeft: DataTypes.INTEGER,
  createdAt: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW,
  },
}, {
  tableName: 'predictivescore',
  timestamps: true,
  updatedAt: false,
});

module.exports = PredictiveScoreEntity;