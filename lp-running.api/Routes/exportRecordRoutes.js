const express = require('express');
const router = express.Router();
const ExportRecord = require('../Models/exportRecord'); // Ajuste o caminho conforme necessário
const Athlete = require('../Models/Athlete'); // Ajuste o caminho conforme necessário

// Rota para exportar registros
router.get('/export', async (req, res) => {
    try {
        const records = await ExportRecord.findAll({
            include: [{
                model: Athlete, // Verifique se é o modelo correto
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
