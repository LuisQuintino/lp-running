const { DataTypes } = require('sequelize');
const sequelize = require('../ApiConfig/db'); // Verifique se este caminho está correto
const Aluno = require('./Aluno'); // Importando o modelo Aluno

const Record = sequelize.define('Record', {
    best_time: {
        type: DataTypes.STRING, // Você pode mudar o tipo conforme necessário
        allowNull: false,
    },
    training_days: {
        type: DataTypes.STRING, // Pode ser uma lista ou um texto; ajuste conforme necessário
        allowNull: false,
    },
}, {
    tableName: 'Records', // Nome da tabela no banco de dados
    timestamps: false, // Se não houver colunas de timestamp (createdAt, updatedAt)
});

// Definindo a relação com o modelo Aluno
Record.belongsTo(Aluno, { foreignKey: 'athlete_id' }); // Mude 'athlete_id' se seu campo for diferente

module.exports = Record;
