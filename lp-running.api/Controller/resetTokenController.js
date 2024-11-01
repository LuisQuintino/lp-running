
const Coach = require('../Models/Coach');
const ResetToken = require('../Models/ResetToken');
const { Op } = require('sequelize');
const crypto = require('crypto');
const bcrypt = require('bcryptjs');

const resetTokenController = {
  
  
  requestResetToken: async (req, res) => {
    const { email } = req.body;

    try {
      const coach = await Coach.findOne({ where: { email } });

      if (!coach) {
        return res.status(404).json({ message: 'Coach não encontrado' });
      }

      const resetToken = await resetTokenController.generateResetToken(coach.id);

      return res.status(200).json({ message: 'Token de recuperação enviado para o e-mail', token: resetToken.token });
    } catch (error) {
      return res.status(500).json({ message: 'Erro ao gerar token de recuperação', error: error.message });
    }
  },

  
  resetPassword: async (req, res) => {
    const { token, newPassword } = req.body;

    try {
      const coachId = await resetTokenController.validateResetToken(token);

      const hashedPassword = await bcrypt.hash(newPassword, 10);
      await Coach.update({ password: hashedPassword }, { where: { id: coachId } });

      await resetTokenController.deleteResetToken(token);

      return res.status(200).json({ message: 'Senha redefinida com sucesso' });
    } catch (error) {
      return res.status(400).json({ message: error.message });
    }
  },

  
  generateResetToken: async (coachId) => {
    const token = crypto.randomBytes(32).toString('hex');
    const expiresAt = new Date();
    expiresAt.setHours(expiresAt.getHours() + 1);

    const resetToken = await ResetToken.create({
      token,
      coachId,
      expiresAt,
    });

    return resetToken;
  },

  
  validateResetToken: async (token) => {
    const resetToken = await ResetToken.findOne({
      where: {
        token,
        expiresAt: {
          [Op.gt]: new Date(),
        },
      },
    });

    if (!resetToken) {
      throw new Error('Token inválido ou expirado');
    }

    return resetToken.coachId;
  },

 
  deleteResetToken: async (token) => {
    await ResetToken.destroy({ where: { token } });
  },
};

module.exports = resetTokenController;
