// athleteController.js
const Athlete = require('../Models/Athlete');


// Função para buscar atletas, com opção de filtrar apenas os ativos
exports.getAthletes = async (req, res) => {
  try {
    const isActive = req.query.active; // Verifica se há um filtro de ativos
    const whereCondition = isActive ? { active: true } : {}; // Condição para buscar apenas ativos, se necessário

    const athletes = await Athlete.findAll({
      attributes: ['name', 'active'],
      where: whereCondition,
    });
    
    res.status(200).json(athletes);
  } catch (error) {
    console.error("Erro ao buscar atletas:", error);
    res.status(500).json({ error: 'Erro ao buscar atletas', details: error.message });
  }
};
