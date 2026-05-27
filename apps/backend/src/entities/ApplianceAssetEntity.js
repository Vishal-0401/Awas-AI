const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const ApplianceAssetEntity = sequelize.define('ApplianceAsset', {
  id: {
    type: DataTypes.STRING,
    primaryKey: true,
  },
  userId: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  type: DataTypes.STRING,
  brand: DataTypes.STRING,
  modelNumber: DataTypes.STRING,
  serialNumber: DataTypes.STRING,
  installDate: DataTypes.DATE,
  warrantyExpiry: DataTypes.DATE,
  createdAt: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW,
  },
  updatedAt: DataTypes.DATE,
}, {
  tableName: 'applianceasset',
  timestamps: true,
});

module.exports = ApplianceAssetEntity;