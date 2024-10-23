// Controller/resetTokenController.js
const resetTokenService = require('../Service/resetTokenService');
const Coach = require('../Models/Coach'); 

const resetTokenController = {
  
  requestResetToken: async (req, res) => {
    const { email } = req.body;

    try {
      const coach = await Coach.findOne({ where: { email } });

      if (!coach) {
        return res.status(404).json({ message: 'Coach não encontrado' });
      }

     
      const resetToken = await resetTokenService.generateResetToken(coach.id);

      

      return res.status(200).json({ message: 'Token de recuperação enviado para o e-mail' });
    } catch (error) {
      return res.status(500).json({ message: 'Erro ao gerar token de recuperação', error: error.message });
    }
  },


  resetPassword: async (req, res) => {
    const { token, newPassword } = req.body;

    try {
  
      const coachId = await resetTokenService.validateResetToken(token);


      const hashedPassword = await bcrypt.hash(newPassword, 10);
      await Coach.update({ password: hashedPassword }, { where: { id: coachId } });

      
      await resetTokenService.deleteResetToken(token);

      return res.status(200).json({ message: 'Senha redefinida com sucesso' });
    } catch (error) {
      return res.status(400).json({ message: error.message });
    }
  },
};

module.exports = resetTokenController;
