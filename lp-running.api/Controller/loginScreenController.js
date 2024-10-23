
const bcrypt = require('bcrypt');
const Coach = require('../Models/Coach'); 

const loginScreenController = {
 
  login: async (req, res) => {
    const { email, password } = req.body;
    
    try {
      const coach = await Coach.findOne({ where: { email } });
      
      if (!coach) {
        return res.status(404).json({ message: 'Usuário não encontrado' });
      }

   
      const isPasswordValid = await Coach.validatePassword(password, coach.password);
      if (!isPasswordValid) {
        return res.status(401).json({ message: 'Senha incorreta' });
      }

      return res.status(200).json({ message: 'Login bem-sucedido', coach });
      
    } catch (error) {
      return res.status(500).json({ message: 'Erro no login', error: error.message });
    }
  },

  forgotPassword: async (req, res) => {
    const { email } = req.body;

    try {
      const coach = await Coach.findOne({ where: { email } });
      
      if (!coach) {
        return res.status(404).json({ message: 'Usuário não encontrado' });
      }

      const newPassword = Coach.generateTemporaryPassword();
      await Coach.updatePassword(coach.id, newPassword);

     

      return res.status(200).json({ message: 'Nova senha enviada para o e-mail' });
      
    } catch (error) {
      return res.status(500).json({ message: 'Erro ao enviar nova senha', error: error.message });
    }
  }
};

module.exports = loginScreenController;
