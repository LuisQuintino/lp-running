// controllers/export_DataController.js
const ExportRecord = require('../Models/exportRecord'); // Importa o modelo exportRecord

const exportDataController = {
  exportData: async (req, res) => {
    const { email } = req.body;

    try {
      // Recupera todos os registros
      const records = await ExportRecord.findAll();
      console.log(records); // Para verificar se os registros estão sendo retornados

      // Aqui você pode implementar a lógica para enviar os dados por e-mail

      res.status(200).json({ message: 'Dados exportados e enviados para o e-mail com sucesso!', records });
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: error.message });
    }
  },
  // Outras funções (se necessário)
  getCoachesData: async (req, res) => {
    // Lógica para obter dados dos treinadores
  },
  toggleCoachStatus: async (req, res) => {
    // Lógica para alternar status do treinador
  },
  archiveCoach: async (req, res) => {
    // Lógica para arquivar treinador
  },
};

module.exports = exportDataController;
