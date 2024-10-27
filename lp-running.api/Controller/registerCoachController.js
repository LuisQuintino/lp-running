// Controller/registerCoachController.js
const { Op } = require('sequelize');
const Coach = require('../Models/RegisterCoach');

// Função para registrar um novo coach
exports.registerCoach = async (req, res) => {
  try {
    const { name, email, phone, cpf, dob, role } = req.body;

    // Verifica se o email ou CPF já existem
    const existingCoach = await Coach.findOne({
      where: {
        [Op.or]: [{ email }, { cpf }],
      },
    });

    if (existingCoach) {
      return res.status(400).json({
        error: 'Email ou CPF já cadastrado',
      });
    }

    // Se não existir, cria um novo coach
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
