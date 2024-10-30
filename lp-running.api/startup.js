// app.js
const express = require('express');
const cors = require('cors'); // Middleware para permitir CORS
const app = express();
const sequelize = require('./ApiConfig/db'); // Conexão com o banco de dados

// Importação das rotas
const coachRoutes = require('./routes/coachRoutes'); // Rota padrão de Coach
const registerAthleteRoutes = require('./routes/registerAthleteRoutes'); // Rota de registro de atletas
const athleteRoutes = require('./routes/athleteRoutes'); // Todas as rotas de atletas
const registerCoachRoutes = require('./routes/registerCoachRoutes'); 
const authRoutes = require('./routes/authRoutes');
const metricasRoutes = require('./routes/metricasRoutes');
const resetTokenRoutes = require('./routes/resetTokenRoutes');

// Importação do controller de Coach para rotas específicas adicionais
const coachController = require('./Controller/CoachController');


// Middleware
app.use(cors()); // Permite acesso CORS para todas as rotas
app.use(express.json()); // Middleware para parsing de JSON
app.use((req, res, next) => {
  console.log(`Rota acessada: ${req.method} ${req.url}`); // Log de cada requisição com método HTTP
  next();
});

// Define as rotas adicionais de Coach diretamente com o controller
app.get('/api/coaches', coachRoutes);
app.get('/api/coaches/data', coachController.getCoachesData);
app.put('/api/coaches/:id/status', coachController.toggleCoachStatus);
app.put('/api/coaches/:id/archive', coachController.archiveCoach);
app.use('/api/coaches', coachRoutes);

// Define as rotas principais para o restante das funcionalidades
app.use('/api/register-coaches', registerCoachRoutes);   
app.use('/api/athletes', athleteRoutes);                 // Todas as rotas de atletas centralizadas em athleteRoutes
app.use('/api/athletes/register', registerAthleteRoutes); // Rota para registrar atletas
app.use('/api/auth', authRoutes);                        
app.use('/api/metricas', metricasRoutes);                
app.use('/api/reset-token', resetTokenRoutes);           

// Sincronização e inicialização do servidor
sequelize.sync({ force: false })
  .then(() => {
    console.log('Conexão bem-sucedida com o banco de dados SQL Server');
    app.listen(3000, () => {
      console.log('Servidor rodando na porta 3000');
    });
  })
  .catch(err => {
    console.error('Erro ao conectar ao banco de dados:', err);
  });
