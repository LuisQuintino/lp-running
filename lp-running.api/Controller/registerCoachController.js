const { Op } = require('sequelize');
const Coach = require('../Models/RegisterCoach');


exports.registerCoach = async (req, res) => {
  try {
    const { name, email, phone, cpf, dob, role } = req.body;

    
    const existingCoach = await Coach.findOne({
      where: {
        [Op.or]: [{ email }, { cpf }],
      },
    });

    if (existingCoach) {
      return res.status(400).json({ error: 'Email ou CPF já cadastrado' });
    }

    
    const newCoach = await Coach.create({
      name,
      email,
      phone,
      cpf,
      dob,
      role,
    });

    res.status(201).json(newCoach);
  } catch (error) {
    console.error("Erro ao registrar coach:", error);
    res.status(500).json({ error: 'Erro ao registrar coach', details: error.message });
  }
};


exports.getAllCoaches = async (req, res) => {
  try {
    const coaches = await Coach.findAll({
      attributes: ['id', 'name', 'email', 'phone', 'cpf', 'dob', 'role', 'active']
    });
    res.status(200).json(coaches);
  } catch (error) {
    console.error("Erro ao buscar coaches:", error);
    res.status(500).json({ error: 'Erro ao buscar coaches', details: error.message });
  }
};


exports.getCoachById = async (req, res) => {
  const { id } = req.params;
  try {
    const coach = await Coach.findByPk(id);
    if (!coach) {
      return res.status(404).json({ error: 'Coach não encontrado' });
    }
    res.status(200).json(coach);
  } catch (error) {
    console.error("Erro ao buscar coach:", error);
    res.status(500).json({ error: 'Erro ao buscar coach', details: error.message });
  }
};


exports.updateCoach = async (req, res) => {
  const { id } = req.params;
  const data = req.body;

  try {
    const [updated] = await Coach.update(data, {
      where: { id },
      returning: true,
    });

    if (!updated) {
      return res.status(404).json({ error: 'Coach não encontrado' });
    }

    const updatedCoach = await Coach.findByPk(id);
    res.status(200).json(updatedCoach);
  } catch (error) {
    console.error("Erro ao atualizar coach:", error);
    res.status(500).json({ error: 'Erro ao atualizar coach', details: error.message });
  }
};


exports.toggleCoachStatus = async (req, res) => {
  const { id } = req.params;
  const { active } = req.body;

  try {
    const [updated] = await Coach.update({ active }, {
      where: { id },
      returning: true,
    });

    if (!updated) {
      return res.status(404).json({ error: 'Coach não encontrado' });
    }

    const updatedCoach = await Coach.findByPk(id);
    res.status(200).json(updatedCoach);
  } catch (error) {
    console.error("Erro ao ativar/desativar coach:", error);
    res.status(500).json({ error: 'Erro ao ativar/desativar coach', details: error.message });
  }
};

exports.archiveCoach = async (req, res) => {
  const { id } = req.params;

  try {
    const [updated] = await Coach.update({ active: false }, {
      where: { id },
      returning: true,
    });

    if (!updated) {
      return res.status(404).json({ error: 'Coach não encontrado' });
    }

    const archivedCoach = await Coach.findByPk(id);
    res.status(200).json({ message: 'Coach arquivado com sucesso', coach: archivedCoach });
  } catch (error) {
    console.error("Erro ao arquivar coach:", error);
    res.status(500).json({ error: 'Erro ao arquivar coach', details: error.message });
  }
};

