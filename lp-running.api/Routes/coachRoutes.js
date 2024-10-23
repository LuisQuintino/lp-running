
const express = require('express');
const router = express.Router();
const CoachListScreenController = require('../Controller/CoachListScreenController'); 
const RegisterCoachController = require('../Controller/RegisterCoachController'); 

router.use('/register', RegisterCoachController);
router.use('/update', RegisterCoachController);
router.use('/', CoachListScreenController);

module.exports = router;
