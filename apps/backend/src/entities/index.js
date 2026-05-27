const UserEntity = require('./UserEntity');
const AddressEntity = require('./AddressEntity');
const CategoryEntity = require('./CategoryEntity');
const ServiceEntity = require('./ServiceEntity');
const BookingEntity = require('./BookingEntity');
const JobEntity = require('./JobEntity');
const JobTrackingEntity = require('./JobTrackingEntity');
const WalletEntity = require('./WalletEntity');
const TransactionEntity = require('./TransactionEntity');
const NotificationEntity = require('./NotificationEntity');
const ReviewEntity = require('./ReviewEntity');
const ApplianceAssetEntity = require('./ApplianceAssetEntity');
const AiDiagnosticEntity = require('./AiDiagnosticEntity');
const PredictiveScoreEntity = require('./PredictiveScoreEntity');
const SupportTicketEntity = require('./SupportTicketEntity');
const RefreshTokenEntity = require('./RefreshTokenEntity');
const AuditLogEntity = require('./AuditLogEntity');

// USER RELATIONS
UserEntity.hasMany(AddressEntity, { foreignKey: 'userId' });
AddressEntity.belongsTo(UserEntity, { foreignKey: 'userId' });

UserEntity.hasMany(BookingEntity, { foreignKey: 'customerId' });
BookingEntity.belongsTo(UserEntity, { foreignKey: 'customerId' });

UserEntity.hasOne(WalletEntity, { foreignKey: 'userId' });
WalletEntity.belongsTo(UserEntity, { foreignKey: 'userId' });

UserEntity.hasMany(NotificationEntity, { foreignKey: 'userId' });
NotificationEntity.belongsTo(UserEntity, { foreignKey: 'userId' });

UserEntity.hasMany(ReviewEntity, { foreignKey: 'userId' });
ReviewEntity.belongsTo(UserEntity, { foreignKey: 'userId' });

UserEntity.hasMany(ApplianceAssetEntity, { foreignKey: 'userId' });
ApplianceAssetEntity.belongsTo(UserEntity, { foreignKey: 'userId' });

UserEntity.hasMany(SupportTicketEntity, { foreignKey: 'userId' });
SupportTicketEntity.belongsTo(UserEntity, { foreignKey: 'userId' });

// CATEGORY & SERVICE
CategoryEntity.hasMany(ServiceEntity, { foreignKey: 'categoryId' });
ServiceEntity.belongsTo(CategoryEntity, { foreignKey: 'categoryId' });

// BOOKING
ServiceEntity.hasMany(BookingEntity, { foreignKey: 'serviceId' });
BookingEntity.belongsTo(ServiceEntity, { foreignKey: 'serviceId' });

AddressEntity.hasMany(BookingEntity, { foreignKey: 'addressId' });
BookingEntity.belongsTo(AddressEntity, { foreignKey: 'addressId' });

// JOB
BookingEntity.hasOne(JobEntity, { foreignKey: 'bookingId' });
JobEntity.belongsTo(BookingEntity, { foreignKey: 'bookingId' });

JobEntity.hasMany(JobTrackingEntity, { foreignKey: 'jobId' });
JobTrackingEntity.belongsTo(JobEntity, { foreignKey: 'jobId' });

// TRANSACTION
WalletEntity.hasMany(TransactionEntity, { foreignKey: 'walletId' });
TransactionEntity.belongsTo(WalletEntity, { foreignKey: 'walletId' });

BookingEntity.hasMany(TransactionEntity, { foreignKey: 'bookingId' });
TransactionEntity.belongsTo(BookingEntity, { foreignKey: 'bookingId' });

// AI
ApplianceAssetEntity.hasMany(AiDiagnosticEntity, {
  foreignKey: 'applianceAssetId',
});
AiDiagnosticEntity.belongsTo(ApplianceAssetEntity, {
  foreignKey: 'applianceAssetId',
});

ApplianceAssetEntity.hasMany(PredictiveScoreEntity, {
  foreignKey: 'applianceAssetId',
});
PredictiveScoreEntity.belongsTo(ApplianceAssetEntity, {
  foreignKey: 'applianceAssetId',
});

module.exports = {
  UserEntity,
  AddressEntity,
  CategoryEntity,
  ServiceEntity,
  BookingEntity,
  JobEntity,
  JobTrackingEntity,
  WalletEntity,
  TransactionEntity,
  NotificationEntity,
  ReviewEntity,
  ApplianceAssetEntity,
  AiDiagnosticEntity,
  PredictiveScoreEntity,
  SupportTicketEntity,
  RefreshTokenEntity,
  AuditLogEntity,
};