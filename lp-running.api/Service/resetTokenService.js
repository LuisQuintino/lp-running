const ResetToken = require('../Models/ResetToken');
const { Op } = require('sequelize');
const crypto = require('crypto');

exports.generateResetToken = async (coachId) => {
  const token = crypto.randomBytes(32).toString('hex');
  const expiresAt = new Date();
  expiresAt.setHours(expiresAt.getHours() + 1);

  const resetToken = await ResetToken.create({
    token,
    coachId,
    expiresAt,
  });

  return resetToken;
};

exports.validateResetToken = async (token) => {
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
};

exports.deleteResetToken = async (token) => {
  await ResetToken.destroy({ where: { token } });
};
