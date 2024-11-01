const express = require('express');
const router = express.Router();
const coachController = require('../Controller/CoachController');


router.get('/', coachController.getAllCoaches);

module.exports = router;
