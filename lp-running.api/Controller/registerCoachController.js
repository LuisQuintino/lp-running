const coachService = require('../Service/coachService');

const coachController = {
  registerCoach: async (req, res) => {
    try {
      // Verificar se o CPF foi enviado
      if (!req.body.cpf) {
        return res.status(400).json({ message: 'CPF é obrigatório.' });
      }

      const coach = await coachService.createCoach(req.body);
      res.status(201).json(coach);
    } catch (error) {
      res.status(400).json({ message: error.message });
    }
  },
  getAllCoaches: async (req, res) => {
    try {
      const coaches = await coachService.getAllCoaches();
      res.status(200).json(coaches);
    } catch (error) {
      res.status(400).json({ message: error.message });
    }
  },
  updateCoach: async (req, res) => {
    try {
      // Evitar alteração do CPF
      if (req.body.cpf) {
        return res.status(400).json({ message: 'Não é permitido alterar o CPF.' });
      }

      const coach = await coachService.updateCoach(req.params.id, req.body);
      if (!coach) return res.status(404).json({ message: 'Coach não encontrado.' });
      res.status(200).json(coach);
    } catch (error) {
      res.status(400).json({ message: error.message });
    }
  },
  archiveCoach: async (req, res) => {
    try {
      const coach = await coachService.archiveCoach(req.params.id);
      if (!coach) return res.status(404).json({ message: 'Coach não encontrado.' });
      res.status(200).json(coach);
    } catch (error) {
      res.status(400).json({ message: error.message });
    }
  },
};

module.exports = coachController;
