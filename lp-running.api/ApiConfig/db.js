const { Sequelize } = require('sequelize'); 

const sequelize = new Sequelize('lprunning', 'lprunningadmin', '12345678', {
  host: 'lp-running-staging.c5m6ccag8zzp.sa-east-1.rds.amazonaws.com',
  port: 1433,
  logging: console.log, 
  dialect: 'mssql',
  dialectOptions: {
    options: {
      encrypt: true,
      trustServerCertificate: true,
    },
  },
  logging: false,
});
sequelize.authenticate()
  .then(() => {
    console.log('Conexão bem-sucedida com o banco de dados SQL Server');
  })
  .catch(err => {
    console.error('Erro ao conectar ao banco de dados:', err);
  });


module.exports = sequelize;
