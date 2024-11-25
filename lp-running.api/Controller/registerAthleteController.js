const { Op } = require('sequelize');
const RegisterAthlete = require('../Models/RegisterAthlete');

exports.registerAthlete = async (req, res) => {
  try {
    const { name, email, cpf, dob, observations, imageUrl, gender, coach, active } = req.body;

    const existingAthlete = await RegisterAthlete.findOne({
      where: {
        [Op.or]: [{ email }, { cpf }],
      },
    });

    if (existingAthlete) {
      return res.status(400).json({ error: 'Email ou CPF já cadastrado' });
    }

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

    res.status(201).json({ message: 'Atleta registrado com sucesso!', athlete: newAthlete });
  } catch (error) {
    console.error("Erro ao registrar atleta:", error);
    res.status(500).json({ error: 'Erro ao registrar atleta', details: error.message });
  }
};


exports.getAthleteById = async (req, res) => {
  try {
    const { id } = req.params;
    const athlete = await RegisterAthlete.findByPk(id);

    if (!athlete) {
      return res.status(404).json({ error: 'Atleta não encontrado' });
    }

    res.status(200).json({ athlete });
  } catch (error) {
    console.error("Erro ao buscar atleta:", error);
    res.status(500).json({ error: 'Erro ao buscar atleta', details: error.message });
  }
};

