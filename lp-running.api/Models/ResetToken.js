
const { DataTypes } = require('sequelize');
const sequelize = require('../ApiConfig/db');
const Coach = require('./Coach'); 

const ResetToken = sequelize.define('ResetToken', {
  token: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  coachId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: {
      model: Coach, 
      key: 'id',
    },
  },
  expiresAt: {
    type: DataTypes.DATE,
    allowNull: false,
  },
}, {
  timestamps: true,
});

module.exports = ResetToken;
