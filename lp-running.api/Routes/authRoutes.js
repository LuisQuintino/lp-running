
const express = require('express');
const router = express.Router();
const loginScreenController = require('../Controller/loginScreenController'); 


router.post('/login', loginScreenController.login);


router.post('/forgot-password', loginScreenController.forgotPassword);

module.exports = router;
