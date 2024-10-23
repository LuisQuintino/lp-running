const Metrica = require('../Models/Metrica');

exports.createMetrica = async (data) => {
  const novaMetrica = await Metrica.create(data);
  return novaMetrica;
};

exports.updateMetrica = async (id, descricao) => {
  const metrica = await Metrica.findByPk(id);
  if (!metrica) {
    throw new Error('Métrica não encontrada');
  }
  metrica.descricao = descricao;
  await metrica.save();
  return metrica;
};

exports.deleteMetrica = async (id) => {
  const metrica = await Metrica.findByPk(id);
  if (!metrica) {
    throw new Error('Métrica não encontrada');
  }
  await metrica.destroy();
};

exports.getMetricas = async () => {
  const metricas = await Metrica.findAll();
  return metricas;
};
