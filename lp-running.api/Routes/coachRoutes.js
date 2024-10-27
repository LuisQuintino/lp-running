const express = require('express');
const router = express.Router();
const coachController = require('../Controller/coachController');


router.get('/', coachController.getAllCoaches);

module.exports = router;
