const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const ServiceEntity = sequelize.define('Service', {
  id: {
    type: DataTypes.STRING,
    primaryKey: true,
  },
  categoryId: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  name: DataTypes.STRING,
  description: DataTypes.STRING,
  basePrice: DataTypes.DOUBLE,
  icon: DataTypes.STRING,
  createdAt: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW,
  },
  updatedAt: DataTypes.DATE,
}, {
  tableName: 'service',
  timestamps: true,
});

module.exports = ServiceEntity;