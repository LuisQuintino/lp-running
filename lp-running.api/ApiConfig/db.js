const { Sequelize } = require('sequelize'); 

const sequelize = new Sequelize('lprunning', 'lprunningadmin', '12345678', {
  host: 'lprunning-instance.cd2w0wswy8xz.sa-east-1.rds.amazonaws.com',
  port: 1433,
  dialect: 'mssql',
  dialectOptions: {
    options: {
      encrypt: true,
      trustServerCertificate: true,
    },
  },
  logging: false,
});

module.exports = sequelize;
