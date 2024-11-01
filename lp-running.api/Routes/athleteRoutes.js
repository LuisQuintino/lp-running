const express = require('express');
const router = express.Router();
const athleteController = require('../Controller/athleteController');
router.get('/', athleteController.getAthletes);
router.put('/:id/toggle-active', athleteController.toggleActiveStatus);
router.put('/:id/archive', athleteController.archiveAthlete);
router.put('/:id/unarchive', athleteController.unarchiveAthlete);

module.exports = router;
