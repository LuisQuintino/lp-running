
const { DataTypes } = require('sequelize');
const sequelize = require('../ApiConfig/db');
const bcrypt = require('bcrypt');

const Coach = sequelize.define('Coach', {
  nome: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  email: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
  },
  password: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  role: {
    type: DataTypes.ENUM('Admin', 'Coach', 'Master'),
    allowNull: false,
  },
}, {
  timestamps: true,
});

Coach.validatePassword = async function (password, hash) {
  return await bcrypt.compare(password, hash);
};


Coach.generateTemporaryPassword = function () {
  const tempPassword = Math.random().toString(36).slice(-8); 
  return tempPassword;
};


Coach.updatePassword = async function (coachId, newPassword) {
  const hashedPassword = await bcrypt.hash(newPassword, 10); 
  await Coach.update({ password: hashedPassword }, { where: { id: coachId } });
};

module.exports = Coach;
