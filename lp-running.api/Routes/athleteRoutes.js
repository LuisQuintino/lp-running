// athleteRoutes.js
const express = require('express');
const router = express.Router();
const athleteController = require('../Controller/athleteController'); // Verifique o caminho exato do arquivo

// Rota para buscar todos os atletas, com opção de filtro por ativos
router.get('/', athleteController.getAthletes);

module.exports = router;
