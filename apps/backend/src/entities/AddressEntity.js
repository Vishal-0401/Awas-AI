const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const AddressEntity = sequelize.define('Address', {
  id: {
    type: DataTypes.STRING,
    primaryKey: true,
  },
  userId: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  title: DataTypes.STRING,
  address: DataTypes.STRING,
  city: DataTypes.STRING,
  state: DataTypes.STRING,
  zipCode: DataTypes.STRING,
  latitude: DataTypes.DOUBLE,
  longitude: DataTypes.DOUBLE,
  createdAt: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW,
  },
  updatedAt: DataTypes.DATE,
}, {
  tableName: 'address',
  timestamps: true,
});

module.exports = AddressEntity;