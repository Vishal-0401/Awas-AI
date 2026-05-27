const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const BookingEntity = sequelize.define('Booking', {
  id: {
    type: DataTypes.STRING,
    primaryKey: true,
  },
  customerId: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  serviceId: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  addressId: {
    type: DataTypes.STRING,
    allowNull: false,
  },
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
  scheduledFor: DataTypes.DATE,
  totalAmount: DataTypes.DOUBLE,
  paymentStatus: {
    type: DataTypes.ENUM('PENDING', 'PAID', 'FAILED'),
    defaultValue: 'PENDING',
  },
  createdAt: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW,
  },
  updatedAt: DataTypes.DATE,
}, {
  tableName: 'booking',
  timestamps: true,
});

module.exports = BookingEntity;