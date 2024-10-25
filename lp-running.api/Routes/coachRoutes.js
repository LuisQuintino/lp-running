const express = require('express');
const router = express.Router();
const CoachListScreenController = require('../Controller/CoachListScreenController');

// Endpoint para buscar todos os coaches com os dados formatados
router.get('/', CoachListScreenController.getAllCoaches);

module.exports = router;
