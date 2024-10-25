const RegisterCoach = require('../Models/RegisterCoach');

exports.registerCoach = async (data) => {
  try {
    // Certifique-se de que o campo dob está em formato YYYY-MM-DD
    if (data.dob) {
      const date = new Date(data.dob);
      data.dob = date.toISOString().split('T')[0]; // Converte para YYYY-MM-DD
    }

    const newCoach = await RegisterCoach.create(data);
    return newCoach;
  } catch (error) {
    console.error("Erro no serviço ao registrar coach:", error.message);
    console.log(error.stack);
    throw error;
  }
};
