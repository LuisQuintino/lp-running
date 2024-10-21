const bcrypt = require('bcrypt');
const { DataTypes } = require('sequelize');
const sequelize = require('../ApiConfig/db');

// Definição do modelo Coach
const Coach = sequelize.define('Coach', {
  name: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  email: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,  // Garantir que o email seja único
  },
  cpf: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,  // Garantir que o CPF seja único
  },
  dob: {
    type: DataTypes.DATEONLY,
    allowNull: true,  // Pode ser opcional
  },
  role: {
    type: DataTypes.ENUM,
    values: ['Admin', 'Coach', 'Master'],  // Limitar os valores aceitos
    allowNull: false,
  },
  password: {
    type: DataTypes.STRING,
    allowNull: false,  // Adiciona o campo de senha
  },
  active: {
    type: DataTypes.BOOLEAN,
    defaultValue: true,  // Por padrão, ativo
  },
});

// Funções de criptografia e validação de senha (usando bcrypt)
Coach.generateTemporaryPassword = function () {
  return Math.random().toString(36).slice(-8);  // Gerar uma senha de 8 caracteres
};

Coach.updatePassword = async function (id, newPassword) {
  const hashedPassword = await bcrypt.hash(newPassword, 10);  // Criptografar a nova senha
  return Coach.update({ password: hashedPassword }, { where: { id } });
};

Coach.validatePassword = async function (password, hashedPassword) {
  return bcrypt.compare(password, hashedPassword);  // Comparar a senha fornecida com a criptografada
};

// Serviço de Coach usando o modelo Coach
class CoachService {
  // Serviço para buscar todos os coaches
  async getAllCoaches() {
    return await Coach.findAll();
  }

  // Serviço para buscar um coach pelo ID
  async getCoachById(id) {
    return await Coach.findByPk(id);
  }

  // Serviço de criação de um novo coach (com criptografia de senha)
  async createCoach(coachData) {
    if (coachData.password) {
      const hashedPassword = await bcrypt.hash(coachData.password, 10); // Criptografar a senha
      coachData.password = hashedPassword;
    }
    return await Coach.create(coachData);
  }

  // Serviço para atualizar um coach (incluindo criptografia de senha, se fornecida)
  async updateCoach(id, coachData) {
    const coach = await Coach.findByPk(id);
    if (coach) {
      if (coachData.password) {
        const hashedPassword = await bcrypt.hash(coachData.password, 10); // Criptografar a senha
        coachData.password = hashedPassword;
      }
      await coach.update(coachData);
      return coach;
    }
    return null;
  }

  // Serviço para excluir um coach
  async deleteCoach(id) {
    const coach = await Coach.findByPk(id);
    if (coach) {
      await coach.destroy();
    }
  }

  // Serviço para arquivar (desativar) um coach
  async archiveCoach(id) {
    const coach = await Coach.findByPk(id);
    if (coach) {
      await coach.update({ active: false });
      return coach;
    }
    return null;
  }
}

module.exports = new CoachService();
