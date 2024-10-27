const { Op } = require('sequelize'); 
const Athlete = require('../Models/RegisterAthlete');

exports.registerAthlete = async (req, res) => {
  try {
    const { name, email, cpf, dob, observations, imageUrl, gender, coach, active } = req.body;

    
    const existingAthlete = await Athlete.findOne({
      where: {
        [Op.or]: [{ email }, { cpf }],
      },
    });

    if (existingAthlete) {
      
      return res.status(400).json({
        error: 'Email ou CPF já cadastrado',
      });
    }

    
    const newAthlete = await Athlete.create({
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
