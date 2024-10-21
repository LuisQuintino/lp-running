require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { connectDB } = require('./ApiConfig/db');
const sequelize = require('./ApiConfig/db'); // Adicionando o sequelize do segundo código
const coachController = require('./Controller/coachController');
const alunoController = require('./Controller/alunoController');
const coachScreenController = require('./Controller/coachScreenController');
const loginScreenController = require('./Controller/loginScreenController'); // Novo controlador de login

const app = express();
app.use(cors());
app.use(express.json());

// Conectar ao banco de dados
connectDB(); // Conexão ao MongoDB
sequelize.sync() // Sincronização com o banco de dados SQL
  .then(() => {
    console.log('Banco de dados sincronizado');
  })
  .catch((error) => {
    console.error('Erro ao sincronizar o banco de dados:', error);
  });

// Rotas de Coaches utilizando o coachController
app.get('/api/coaches', coachController.getAllCoaches);
app.get('/api/coaches/:id', coachController.getCoachById);
app.post('/api/coaches', coachController.createCoach);
app.put('/api/coaches/:id', coachController.updateCoach);
app.delete('/api/coaches/:id', coachController.deleteCoach);

// Rotas de Alunos utilizando o alunoController
app.get('/api/alunos', alunoController.getAllAlunos);
app.get('/api/alunos/:id', alunoController.getAlunoById);
app.post('/api/alunos', alunoController.createAluno);
app.put('/api/alunos/:id', alunoController.updateAluno);
app.delete('/api/alunos/:id', alunoController.deleteAluno);

// Rotas de Coaches utilizando o coachScreenController
app.post('/coaches', coachScreenController.registerCoach);
app.get('/coaches', coachScreenController.getAllCoaches);
app.put('/coaches/:id', coachScreenController.updateCoach);
app.patch('/coaches/:id/archive', coachScreenController.archiveCoach);

// Rotas para login e recuperação de senha utilizando loginScreenController
app.post('/login', loginScreenController.login); // Rota de login
app.post('/forgot-password', loginScreenController.forgotPassword); // Rota para recuperar senha

// Verificação das variáveis de ambiente para SQL Server
/*
const sql = require('mssql');
if (!process.env.DB_USER || !process.env.DB_PASSWORD || !process.env.DB_NAME || !process.env.DB_SERVER) {
  console.warn('AVISO: As variáveis de conexão com o banco de dados não estão configuradas.');
} else {
  const sqlConfig = {
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    server: process.env.DB_SERVER,
    options: {
      encrypt: true,
      trustServerCertificate: true,
    },
  };
  
  sql.connect(sqlConfig)
    .then(() => console.log('Conectado ao SQL Server'))
    .catch((err) => console.error('Erro ao conectar no SQL Server:', err));
}
*/

// Inicialização do servidor
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
