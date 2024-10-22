const Coach = require('../Models/Coach');

exports.getAllCoaches = async () => {
  return await Coach.findAll({ where: { archived: false } });
};

exports.createCoach = async (data) => {
  return await Coach.create(data);
};

exports.updateCoach = async (id, data) => {
  const coach = await Coach.findByPk(id);
  if (!coach) throw new Error('Coach não encontrado');
  
  Object.assign(coach, data);
  await coach.save();
  return coach;
};

exports.archiveCoach = async (id) => {
  const coach = await Coach.findByPk(id);
  if (!coach) throw new Error('Coach não encontrado');

  coach.active = false;
  coach.archived = true;
  await coach.save();
  return coach;
};

exports.unarchiveCoach = async (id) => {
  const coach = await Coach.findByPk(id);
  if (!coach) throw new Error('Coach não encontrado');

  coach.archived = false;
  await coach.save();
  return coach;
};
