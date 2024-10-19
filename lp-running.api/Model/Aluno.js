const mongoose = require('mongoose');

const AlunoSchema = new mongoose.Schema({
    nome: {
        type: String,
        required: true
    },
    email: {
        type: String,
        required: true,
        unique: true
    },
    professor: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Professor', // Refere-se a um outro modelo, Professor
        required: true
    },
    status: {
        type: String,
        default: 'ativo'
    }
}, {
    timestamps: true // Cria campos automáticos para createdAt e updatedAt
});

module.exports = mongoose.model('Aluno', AlunoSchema);
