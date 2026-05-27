const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const CategoryEntity = sequelize.define('Category', {
  id: {
    type: DataTypes.STRING,
    primaryKey: true,
  },
  name: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  description: DataTypes.STRING,
  icon: DataTypes.STRING,
  createdAt: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW,
  },
  updatedAt: DataTypes.DATE,
}, {
  tableName: 'category',
  timestamps: true,
});

module.exports = CategoryEntity;