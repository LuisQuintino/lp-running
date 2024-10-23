
const express = require('express');
const router = express.Router();
const resetTokenController = require('../Controller/resetTokenController');


router.post('/request-token', resetTokenController.requestResetToken);


router.post('/reset-password', resetTokenController.resetPassword);

module.exports = router;
