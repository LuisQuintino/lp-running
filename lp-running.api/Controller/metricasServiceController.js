
const metricasService = require('../Service/metricasService');

const metricasServiceController = {
  
  createMetrica: async (req, res) => {
    const { tempo, codigoAluno, descricao } = req.body;

    if (!tempo || !codigoAluno || !descricao) {
      return res.status(400).json({ error: 'Todos os campos são obrigatórios.' });
    }

    try {
      const novaMetrica = await metricasService.createMetrica({ tempo, codigoAluno, descricao });
      return res.status(201).json({ message: 'Métrica cadastrada com sucesso!', metrica: novaMetrica });
    } catch (error) {
      return res.status(500).json({ message: 'Erro ao criar métrica', error: error.message });
    }
  },

  updateMetrica: async (req, res) => {
    const metricaId = req.params.id;
    const { descricao } = req.body;

    if (!descricao) {
      return res.status(400).json({ error: 'A descrição é obrigatória.' });
    }

    try {
      const metricaAtualizada = await metricasService.updateMetrica(metricaId, descricao);
      return res.status(200).json({ message: 'Descrição atualizada com sucesso!', metrica: metricaAtualizada });
    } catch (error) {
      return res.status(500).json({ message: 'Erro ao atualizar métrica', error: error.message });
    }
  },

  deleteMetrica: async (req, res) => {
    const metricaId = req.params.id;

    try {
      await metricasService.deleteMetrica(metricaId);
      return res.status(200).json({ message: 'Métrica deletada com sucesso!' });
    } catch (error) {
      return res.status(500).json({ message: 'Erro ao deletar métrica', error: error.message });
    }
  },

  getMetricas: async (req, res) => {
    try {
      const metricas = await metricasService.getMetricas();
      return res.status(200).json(metricas);
    } catch (error) {
      return res.status(500).json({ message: 'Erro ao buscar métricas', error: error.message });
    }
  },
};

module.exports = metricasServiceController;
