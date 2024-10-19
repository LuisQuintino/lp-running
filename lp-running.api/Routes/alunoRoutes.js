const express = require('express');
const router = express.Router();
const alunoController = require('../controllers/AlunoController');

// Rotas CRUD para Aluno
router.get('/alunos', alunoController.getAlunos);
router.post('/alunos', alunoController.createAluno);
router.put('/alunos/:id', alunoController.updateAluno);
router.delete('/alunos/:id', alunoController.inativarAluno);

module.exports = router;
