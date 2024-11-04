const { DataTypes } = require('sequelize');
const sequelize = require('../ApiConfig/db');
const Aluno = require('./Aluno'); 

const Avaliacao = sequelize.define('Avaliacao', {
    idAvaliacao: { 
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true, 
      },
  data: {
    type: DataTypes.DATE,
    allowNull: false, 
  },
  tempo: {
    type: DataTypes.FLOAT,
    allowNull: false, 
  },
  distancia: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  descricao: {
    type: DataTypes.TEXT,
    allowNull: true, 
  },
  alunoId: {
    type: DataTypes.INTEGER,
    references: {
      model: Aluno, 
      key: 'id', 
    },
    onDelete: 'CASCADE',
  }
}, {
  timestamps: true, 
});

Avaliacao.belongsTo(Aluno, { foreignKey: 'alunoId' });

module.exports = Avaliacao;
