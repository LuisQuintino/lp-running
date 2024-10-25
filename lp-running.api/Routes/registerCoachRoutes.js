const express = require('express');
const router = express.Router();
const registerCoachController = require('../Controller/registerCoachController');

// Rota para registrar um novo coach
router.post('/register', registerCoachController.registerCoach);

module.exports = router;
