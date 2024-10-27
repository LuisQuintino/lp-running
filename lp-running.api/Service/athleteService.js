const Aluno = require('../Models/Athlete');

exports.getBasicAthleteInfo = async () => {
  return await Aluno.findAll({
    attributes: ['name', 'active'],
    where: {
      active: true,
    }
  });
};
