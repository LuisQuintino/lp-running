const Coach = require('../Models/Coach');

exports.getCoachesData = async () => {
  try {
    const coaches = await Coach.findAll({
      attributes: ['name', 'cpf', 'admin', 'active'] // Campos a serem buscados no banco
    });

    // Formata os dados para incluir `accountType` e `status`
    return coaches.map(coach => ({
      name: coach.name,
      cpf: coach.cpf,
      accountType: coach.admin ? 'Admin' : 'Coach', // Define 'Admin' se admin for true, caso contrário 'Coach'
      status: coach.active ? 'Ativo' : 'Desativado' // Define status com base no campo active
    }));
  } catch (error) {
    console.error("Erro ao buscar coaches no serviço:", error.message);
    throw new Error('Erro ao buscar coaches');
  }
};
