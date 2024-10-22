
const { DataTypes } = require('sequelize');
const sequelize = require('../ApiConfig/db');
const Aluno = require('./Aluno'); 

const Metrica = sequelize.define('Metrica', {
  tempo: {
    type: DataTypes.FLOAT, 
    allowNull: false,
  },
  codigoAluno: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: {
      model: Aluno, 
      key: 'id',
    },
  },
  descricao: {
    type: DataTypes.STRING,
    allowNull: false,
  },
}, {
  timestamps: true,
});

module.exports = Metrica;
