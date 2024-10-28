const express = require('express');
const router = express.Router();
const Record = require('../Models/Record'); // Ajuste o caminho conforme necessário
const Athlete = require('../Models/Aluno'); // Ajuste o caminho conforme a estrutura do seu projeto


// Rota para exportar registros
router.get('/export', async (req, res) => {
    try {
        const records = await Record.findAll({
            include: [{
                model: Aluno, // Inclua o modelo que você deseja
                attributes: ['email', 'age', 'weight', 'height'], // Os atributos que você quer retornar
            }]
        });
        res.json(records);
    } catch (error) {
        console.error('Erro ao exportar registros:', error);
        res.status(500).json({ error: 'Erro ao exportar registros' });
    }
});

module.exports = router;
