
const RegisterAthlete = require('../Models/RegisterAthlete');


exports.registerAthlete = async (data) => {
  return await RegisterAthlete.create(data);
};
