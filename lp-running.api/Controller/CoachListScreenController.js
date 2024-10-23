
const express = require('express');
const router = express.Router();
const coachService = require('../Service/coachService'); 


module.exports = router;
router.get('/', async (req, res) => {
  try {
    const coaches = await coachService.getAllCoaches();
    res.status(200).json(coaches);
  } catch (error) {
    res.status(500).json({ error: 'Erro ao buscar coaches.' });
  }
});


router.patch('/:id/archive', async (req, res) => {
  try {
    const coach = await coachService.archiveCoach(req.params.id);
    res.status(200).json({ message: 'Coach arquivado com sucesso.', coach });
  } catch (error) {
    res.status(500).json({ error: 'Erro ao arquivar coach.' });
  }
});


router.patch('/:id/unarchive', async (req, res) => {
  try {
    const coach = await coachService.unarchiveCoach(req.params.id);
    res.status(200).json({ message: 'Coach desarquivado com sucesso.', coach });
  } catch (error) {
    res.status(500).json({ error: 'Erro ao desarquivar coach.' });
  }
});

module.exports = router;
