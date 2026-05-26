class UserEntity {
  constructor({ id, email, password, name, mobile, isActive, defaultRole, createdAt, updatedAt }) {
    this.id = id;
    this.email = email;
    this.password = password;
    this.name = name;
    this.mobile = mobile;
    this.isActive = isActive;
    this.defaultRole = defaultRole;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
  }
}

module.exports = { UserEntity };

