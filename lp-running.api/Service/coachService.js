// Service/coachService.js

const Coach = require('../Model/coachModel');

class CoachService {
  async getAllCoaches() {
    return await Coach.getAll();
  }

  async getCoachById(id) {
    return await Coach.getById(id);
  }

  async createCoach(coachData) {
    return await Coach.create(coachData);
  }

  async updateCoach(id, coachData) {
    await Coach.update(id, coachData);
    return await Coach.getById(id);
  }

  async deleteCoach(id) {
    await Coach.delete(id);
  }
}

module.exports = new CoachService();
