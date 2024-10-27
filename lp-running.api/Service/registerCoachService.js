const RegisterCoach = require('../Models/RegisterCoach');

// Função para registrar um novo coach
exports.createCoach = async (data) => {
  return await RegisterCoach.create(data);
};

// Função para buscar todos os coaches
exports.getAllCoaches = async () => {
  return await RegisterCoach.findAll();
};

// Função para buscar um coach por ID
exports.getCoachById = async (id) => {
  return await RegisterCoach.findByPk(id);
};

// Função para atualizar um coach
exports.updateCoach = async (id, data) => {
  return await RegisterCoach.update(data, {
    where: { id },
    returning: true,
    plain: true
  });
};

// Função para deletar um coach
exports.deleteCoach = async (id) => {
  return await RegisterCoach.destroy({ where: { id } });
};
