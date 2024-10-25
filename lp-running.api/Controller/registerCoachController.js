const registerCoachService = require('../Service/registerCoachService');

exports.registerCoach = async (req, res) => {
  try {
    const newCoach = await registerCoachService.registerCoach(req.body);
    res.status(201).json({ message: 'Coach registrado com sucesso.', coach: newCoach });
  } catch (error) {
    console.error("Erro ao registrar coach:", error.message);
    res.status(500).json({ error: 'Erro ao registrar coach.', details: error.message });
  }
};
