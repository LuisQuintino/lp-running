
const { DataTypes } = require('sequelize');
const sequelize = require('../ApiConfig/db'); 
const Coach = require('./Coach'); 

const Aluno = sequelize.define('Aluno', {
  nome: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  email: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
  },
  status: {
    type: DataTypes.ENUM('ativo', 'inativo'),
    defaultValue: 'ativo',
  },
  coachId: {
    type: DataTypes.INTEGER,
    references: {
      model: Coach, 
      key: 'id',
    },
  },
}, {
  timestamps: true,
});

Aluno.belongsTo(Coach, { foreignKey: 'coachId' });

module.exports = Aluno;
