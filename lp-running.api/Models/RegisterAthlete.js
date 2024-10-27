const { DataTypes } = require('sequelize');
const sequelize = require('../ApiConfig/db');

const RegisterAthlete = sequelize.define('RegisterAthlete', {
  name: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  email: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
    validate: {
      isEmail: true,
    },
  },
  cpf: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
  },
  dob: {
    type: DataTypes.DATEONLY,
    allowNull: true,
  },
  observations: {
    type: DataTypes.TEXT,
    allowNull: true,
  },
  imageUrl: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  gender: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  coach: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  active: {
    type: DataTypes.BOOLEAN,
    defaultValue: true,
  },
}, {
  tableName: 'RegisterAthletes',
  timestamps: true,
});

module.exports = RegisterAthlete;
