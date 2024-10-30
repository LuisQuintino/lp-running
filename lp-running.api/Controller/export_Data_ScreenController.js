// controllers/exportDataScreenController.js
const Record = require('../Models/Record'); // Importa o modelo Record

const exportDataScreenController = {
  exportData: async (req, res) => {
    const { email } = req.body;

    try {
      // Recupera todos os registros
      const records = await Record.findAll();
      console.log(records); // Para verificar se os registros estão sendo retornados

      // Aqui você pode implementar a lógica para enviar os dados por e-mail

      res.status(200).json({ message: 'Dados exportados e enviados para o e-mail com sucesso!', records });
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: error.message });
    }
  },
};

module.exports = exportDataScreenController;
