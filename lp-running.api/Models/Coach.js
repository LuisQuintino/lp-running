const { DataTypes } = require('sequelize');
const sequelize = require('../ApiConfig/db');

const Coach = sequelize.define('Coach', {
  name: {
    type: DataTypes.STRING,
    allowNull: false, // Campo obrigatório
  },
  email: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true, // O email deve ser único
    validate: {
      isEmail: true, // Validação de formato de email
    }
  },
  phone: {
    type: DataTypes.STRING,
    allowNull: true, // Opcional
  },
  cpf: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true, // CPF deve ser único
  },
  admin: {
    type: DataTypes.BOOLEAN,
    allowNull: false,
    defaultValue: false, // O padrão é não ser admin
  },
  active: {
    type: DataTypes.BOOLEAN,
    allowNull: false,
    defaultValue: true, // O padrão é ser ativo
  }
}, {
  timestamps: true, // Inclui os campos createdAt e updatedAt
});

module.exports = Coach;
