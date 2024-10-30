// registerAthleteRoutes.js
const express = require('express');
const router = express.Router();
const registerAthleteController = require('../Controller/registerAthleteController'); // Verifique o caminho correto

// Rota para registrar um novo atleta
router.post('/register', registerAthleteController.registerAthlete);

module.exports = router;
