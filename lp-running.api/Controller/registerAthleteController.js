// registerAthleteController.js
const { Op } = require('sequelize');
const RegisterAthlete = require('../models/RegisterAthlete'); // Confirme que o caminho está correto

// Função para registrar um novo atleta
exports.registerAthlete = async (req, res) => {
  try {
    const { name, email, cpf, dob, observations, imageUrl, gender, coach, active } = req.body;

    // Verificar se o atleta já existe
    const existingAthlete = await RegisterAthlete.findOne({
      where: {
        [Op.or]: [{ email }, { cpf }],
      },
    });

    if (existingAthlete) {
      return res.status(400).json({ error: 'Email ou CPF já cadastrado' });
    }

    // Criar novo atleta
    const newAthlete = await RegisterAthlete.create({
      name,
      email,
      cpf,
      dob,
      observations,
      imageUrl,
      gender,
      coach,
      active,
    });

    res.status(201).json(newAthlete);
  } catch (error) {
    console.error("Erro ao registrar atleta:", error);
    res.status(500).json({ error: 'Erro ao registrar atleta', details: error.message });
  }
};
