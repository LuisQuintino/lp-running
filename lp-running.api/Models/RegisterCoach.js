const { DataTypes } = require('sequelize');
const sequelize = require('../ApiConfig/db');

const RegisterCoach = sequelize.define('RegisterCoach', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  name: {
    type: DataTypes.STRING,
    allowNull: false
  },
  email: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true
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
  admin: {
    type: DataTypes.BOOLEAN,
    allowNull: false,
    defaultValue: false
  },
  active: {
    type: DataTypes.BOOLEAN,
    allowNull: false,
    defaultValue: true
  }
}, {
  timestamps: true, // timestamps vão mapear para os campos created_at e updated_at
  createdAt: 'created_at',
  updatedAt: 'updated_at',
  tableName: 'coaches' // Especifica a tabela correta no banco de dados
});

module.exports = RegisterCoach;
