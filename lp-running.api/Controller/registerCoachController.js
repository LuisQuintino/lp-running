
const express = require('express');
const router = express.Router();
const coachService = require('../Service/coachService');


module.exports = router;
router.post('/register', async (req, res) => {
  const { name, email, phone, cpf, dob, role, active } = req.body;

  if (!name || !email || !phone || !cpf || !dob || !role) {
    return res.status(400).json({ error: 'Preencha todos os campos.' });
  }

  try {
    const newCoach = await coachService.createCoach({
      name, email, phone, cpf, dob, role, active: active || true
    });
    res.status(201).json({ message: 'Coach cadastrado com sucesso.', coach: newCoach });
  } catch (error) {
    res.status(500).json({ error: 'Erro ao registrar coach.' });
  }
});

router.put('/update/:id', async (req, res) => {
  const { id } = req.params;
  const { name, email, phone, cpf, dob, role, active } = req.body;

  try {
    const updatedCoach = await coachService.updateCoach(id, {
      name, email, phone, cpf, dob, role, active
    });
    res.status(200).json({ message: 'Coach atualizado com sucesso.', coach: updatedCoach });
  } catch (error) {
    res.status(500).json({ error: 'Erro ao atualizar coach.' });
  }
});

module.exports = router;
