const { DataTypes } = require('sequelize');
const sequelize = require('../ApiConfig/db');

const RegisterCoach = sequelize.define('RegisterCoach', {
  name: {
    type: DataTypes.STRING,
    allowNull: false
  },
  email: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
    validate: {
      isEmail: true
    }
  },
  phone: {
    type: DataTypes.STRING,
    allowNull: true
  },
  cpf: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true
  },
  dob: {
    type: DataTypes.DATEONLY,
    allowNull: true
  },
  role: {
    type: DataTypes.ENUM('admin', 'master', 'coach'), // Certifique-se de que isso está definido corretamente
    allowNull: true,
  }
}, {
  timestamps: true
});

module.exports = RegisterCoach;
