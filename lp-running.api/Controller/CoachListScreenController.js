const coachService = require('../Service/coachService');

exports.getAllCoaches = async (req, res) => {
  try {
    // Chama o serviço para obter os coaches com os campos necessários
    const coaches = await coachService.getCoachesData();
    res.status(200).json(coaches);
  } catch (error) {
    console.error("Erro ao buscar coaches:", error.message);
    res.status(500).json({ error: 'Erro ao buscar coaches.' });
  }
};
