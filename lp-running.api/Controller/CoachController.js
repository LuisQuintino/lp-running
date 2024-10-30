// Controller/coachController.js
const Coach = require('../Models/Coach');

// Função para buscar todos os coaches (com campos específicos)
exports.getAllCoaches = async (req, res) => {
  try {
    const coaches = await Coach.findAll({
      attributes: ['id', 'name', 'email', 'phone', 'role', 'active'] // Campos retornados
    });
    res.status(200).json(coaches);
  } catch (error) {
    console.error("Erro ao buscar coaches:", error.message);
    res.status(500).json({ error: 'Erro ao buscar coaches.' });
  }
};

// Função para buscar dados específicos dos coaches (dados mais detalhados)
exports.getCoachesData = async (req, res) => {
  try {
    const coaches = await Coach.findAll({
      attributes: ['name', 'cpf', 'role', 'active']
    });

    const coachesData = coaches.map(coach => ({
      name: coach.name,
      cpf: coach.cpf,
      accountType: coach.role === 'Admin' ? 'Admin' : coach.role, // Define tipo de conta
      status: coach.active ? 'Ativo' : 'Desativado'
    }));

    res.status(200).json(coachesData);
  } catch (error) {
    console.error("Erro ao buscar coaches no serviço:", error.message);
    res.status(500).json({ error: 'Erro ao buscar dados dos coaches' });
  }
};

// Função para atualizar o status (ativar/desativar) de um coach
exports.toggleCoachStatus = async (req, res) => {
  const { id } = req.params;
  const { active } = req.body;

  try {
    const updated = await Coach.update({ active }, {
      where: { id },
      returning: true
    });

    if (!updated[0]) {
      return res.status(404).json({ error: 'Coach não encontrado' });
    }

    const updatedCoach = await Coach.findByPk(id);
    res.status(200).json(updatedCoach);
  } catch (error) {
    console.error("Erro ao atualizar o status do coach:", error.message);
    res.status(500).json({ error: 'Erro ao atualizar status do coach' });
  }
};

// Função para arquivar/desarquivar coach
exports.archiveCoach = async (req, res) => {
  const { id } = req.params;
  try {
    const coach = await Coach.findByPk(id);
    if (!coach) {
      return res.status(404).json({ error: 'Coach não encontrado' });
    }

    // Alterna o estado de arquivamento
    coach.active = !coach.active;
    await coach.save();

    res.status(200).json({ message: 'Coach arquivado/desarquivado com sucesso', coach });
  } catch (error) {
    console.error("Erro ao arquivar/desarquivar coach:", error.message);
    res.status(500).json({ error: 'Erro ao arquivar/desarquivar coach' });
  }
};
