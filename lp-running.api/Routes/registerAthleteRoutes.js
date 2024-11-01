const express = require('express');
const router = express.Router();
const registerAthleteController = require('../Controller/registerAthleteController');

// Define a rota POST para registrar um atleta
router.post('/', registerAthleteController.registerAthlete);


module.exports = router;
