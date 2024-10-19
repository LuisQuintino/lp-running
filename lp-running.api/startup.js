require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { connectDB } = require('./ApiConfig/db');
const coachController = require('./Controller/coachController');
const alunoController = require('./Controller/alunoController');

const app = express();
connectDB(); // Conectar ao banco de dados
app.use(cors());
app.use(express.json());

// Definir rotas
app.get('/api/coaches', coachController.getAllCoaches);
app.get('/api/coaches/:id', coachController.getCoachById);
app.post('/api/coaches', coachController.createCoach);
app.put('/api/coaches/:id', coachController.updateCoach);
app.delete('/api/coaches/:id', coachController.deleteCoach);
// Rotas de Alunos
app.get('/api/alunos', alunoController.getAllAlunos); 
app.get('/api/alunos/:id', alunoController.getAlunoById); 
app.post('/api/alunos', alunoController.createAluno); 
app.put('/api/alunos/:id', alunoController.updateAluno); 
app.delete('/api/alunos/:id', alunoController.deleteAluno); 

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

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
