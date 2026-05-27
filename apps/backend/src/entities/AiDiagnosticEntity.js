const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const AiDiagnosticEntity = sequelize.define('AiDiagnostic', {
  id: {
    type: DataTypes.STRING,
    primaryKey: true,
  },
  userId: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  applianceAssetId: DataTypes.STRING,
  imageUrl: DataTypes.STRING,
  ocrRawText: DataTypes.TEXT,
  analysisResult: DataTypes.JSON,
  healthScore: DataTypes.INTEGER,
  recommendation: DataTypes.TEXT,
  createdAt: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW,
  },
}, {
  tableName: 'aidiagnostic',
  timestamps: true,
  updatedAt: false,
});

module.exports = AiDiagnosticEntity;