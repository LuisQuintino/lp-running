const express = require('express');
const router = express.Router();
const athleteController = require('../Controller/athleteController');


router.get('/', athleteController.getAllAthletes);

module.exports = router;
