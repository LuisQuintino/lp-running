const Coach = require('../Models/Coach');

exports.getCoachesData = async () => {
  try {
    const coaches = await Coach.findAll({
      attributes: ['name', 'cpf', 'admin', 'active'], // Campos a serem buscados no banco
    });

    return coaches.map(coach => ({
      name: coach.name,
      cpf: coach.cpf,
      accountType: coach.admin ? 'Admin' : 'Coach', // Define o tipo de conta
      status: coach.active ? 'Ativo' : 'Desativado', // Define o status com base no campo active
    }));
  } catch (error) {
    console.error("Erro ao buscar coaches no serviço:", error.message);
    throw new Error('Erro ao buscar coaches');
  }
};
