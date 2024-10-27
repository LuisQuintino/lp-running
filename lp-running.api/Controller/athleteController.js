const RegisterAthlete = require('../Models/RegisterAthlete');

exports.getAllAthletes = async (req, res) => {
  try {
    const athletes = await RegisterAthlete.findAll({
      attributes: ['name', 'active'],
    });
    res.status(200).json(athletes);
  } catch (error) {
    console.error("Erro ao buscar todos os atletas:", error);
    res.status(500).json({ error: 'Erro ao buscar atletas', details: error.message });
  }
};
