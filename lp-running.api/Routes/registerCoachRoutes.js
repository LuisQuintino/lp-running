// routes/registerCoachRoutes.js
const express = require('express');
const router = express.Router();
const registerCoachController = require('../Controller/registerCoachController'); // Verifique este caminho

// Rota para registrar um novo coach
router.post('/register', registerCoachController.registerCoach); // Certifique-se de que a função está sendo importada corretamente

module.exports = router;
