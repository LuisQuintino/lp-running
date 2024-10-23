
const express = require('express');
const router = express.Router();
const AlunoController = require('../Controller/AlunoController'); 

router.get('/', AlunoController.getAlunos);
router.post('/', AlunoController.createAluno);
router.put('/:id', AlunoController.updateAluno);
router.delete('/:id', AlunoController.inativarAluno);

module.exports = router;
