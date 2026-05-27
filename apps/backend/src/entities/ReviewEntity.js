const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const ReviewEntity = sequelize.define('Review', {
  id: {
    type: DataTypes.STRING,
    primaryKey: true,
  },
  userId: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  bookingId: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  rating: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
  comment: DataTypes.TEXT,
  createdAt: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW,
  },
}, {
  tableName: 'review',
  timestamps: true,
  updatedAt: false,
});

module.exports = ReviewEntity;