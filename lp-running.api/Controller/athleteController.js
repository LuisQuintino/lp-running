const Athlete = require('../Models/Athlete');

exports.getAthletes = async (req, res) => {
  try {
    const isActive = req.query.active;
    const whereCondition = isActive ? { active: true } : {};

    const athletes = await Athlete.findAll({
      attributes: ['id', 'name', 'active', 'archived'],
      where: whereCondition,
    });
    
    res.status(200).json(athletes);
  } catch (error) {
    console.error("Erro ao buscar atletas:", error);
    res.status(500).json({ error: 'Erro ao buscar atletas', details: error.message });
  }
};

exports.toggleActiveStatus = async (req, res) => {
  const { id } = req.params;
  const { active } = req.body;

  try {
    const athlete = await Athlete.findByPk(id);
    if (!athlete) {
      return res.status(404).json({ error: 'Atleta não encontrado' });
    }

    athlete.active = active;
    await athlete.save();

    res.status(200).json({ message: 'Status atualizado com sucesso', athlete });
  } catch (error) {
    console.error("Erro ao atualizar status do atleta:", error);
    res.status(500).json({ error: 'Erro ao atualizar status do atleta', details: error.message });
  }
};

exports.archiveAthlete = async (req, res) => {
  const { id } = req.params;

  try {
    const athlete = await Athlete.findByPk(id);
    if (!athlete) {
      return res.status(404).json({ error: 'Atleta não encontrado' });
    }

    athlete.archived = true;
    athlete.active = false;
    await athlete.save();

    res.status(200).json({ message: 'Atleta arquivado com sucesso', athlete });
  } catch (error) {
    console.error("Erro ao arquivar atleta:", error);
    res.status(500).json({ error: 'Erro ao arquivar atleta', details: error.message });
  }
};

exports.unarchiveAthlete = async (req, res) => {
  const { id } = req.params;

  try {
    const athlete = await Athlete.findByPk(id);
    if (!athlete) {
      return res.status(404).json({ error: 'Atleta não encontrado' });
    }

    athlete.archived = false;
    athlete.active = true;
    await athlete.save();

    res.status(200).json({ message: 'Atleta desarquivado com sucesso', athlete });
  } catch (error) {
    console.error("Erro ao desarquivar atleta:", error);
    res.status(500).json({ error: 'Erro ao desarquivar atleta', details: error.message });
  }
};
