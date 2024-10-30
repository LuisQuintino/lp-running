const { Sequelize } = require('sequelize'); 

const sequelize = new Sequelize('lprunning', 'lprunningadmin', '12345678', {
  host: 'lprunning-instance.cd2w0wswy8xz.sa-east-1.rds.amazonaws.com',
  port: 1433,
  logging: console.log, // Ativa o log detalhado para cada consulta
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
