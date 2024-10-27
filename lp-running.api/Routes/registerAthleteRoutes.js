const express = require('express');
const router = express.Router();
const registerAthleteController = require('../Controller/registerAthleteController');


router.post('/register', registerAthleteController.registerAthlete);

module.exports = router;
