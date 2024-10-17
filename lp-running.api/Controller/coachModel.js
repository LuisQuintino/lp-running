// Controller/coachController.js

const CoachService = require('../Service/coachService');

exports.getAllCoaches = async (req, res) => {
  try {
    const coaches = await CoachService.getAllCoaches();
    res.status(200).json(coaches);
  } catch (error) {
    console.error('Erro ao buscar coaches:', error);
    res.status(500).json({ message: 'Erro ao buscar coaches.' });
  }
};

exports.getCoachById = async (req, res) => {
  const { id } = req.params;
  try {
    const coach = await CoachService.getCoachById(id);
    if (!coach) {
      return res.status(404).json({ message: 'Coach não encontrado.' });
    }
    res.status(200).json(coach);
  } catch (error) {
    console.error('Erro ao buscar coach:', error);
    res.status(500).json({ message: 'Erro ao buscar coach.' });
  }
};

exports.createCoach = async (req, res) => {
  try {
    const newCoach = await CoachService.createCoach(req.body);
    res.status(201).json(newCoach);
  } catch (error) {
    console.error('Erro ao criar coach:', error);
    res.status(500).json({ message: 'Erro ao criar coach.' });
  }
};

exports.updateCoach = async (req, res) => {
  const { id } = req.params;
  try {
    const updatedCoach = await CoachService.updateCoach(id, req.body);
    res.status(200).json(updatedCoach);
  } catch (error) {
    console.error('Erro ao atualizar coach:', error);
    res.status(500).json({ message: 'Erro ao atualizar coach.' });
  }
};

exports.deleteCoach = async (req, res) => {
  const { id } = req.params;
  try {
    await CoachService.deleteCoach(id);
    res.status(200).json({ message: 'Coach deletado com sucesso.' });
  } catch (error) {
    console.error('Erro ao deletar coach:', error);
    res.status(500).json({ message: 'Erro ao deletar coach.' });
  }
};
