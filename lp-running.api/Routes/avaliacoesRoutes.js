const express = require('express');
const router = express.Router();
const avaliacoesController = require('../Controller/avaliacoesController'); 

router.get('/', avaliacoesController.getAvaliacoes);
router.post('/', avaliacoesController.createAvaliacao);
router.put('/:idAvaliacao', avaliacoesController.updateAvaliacao);
router.delete('/:idAvaliacao', avaliacoesController.deleteAvaliacao);
router.get('/:idAvaliacao', avaliacoesController.findAvaliacaoById);

module.exports = router;
