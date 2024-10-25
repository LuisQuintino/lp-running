const express = require('express');
const app = express();
const sequelize = require('./ApiConfig/db');
const coachRoutes = require('./routes/coachRoutes');
const alunoRoutes = require('./routes/alunoRoutes');
const authRoutes = require('./routes/authRoutes');
const metricasRoutes = require('./routes/metricasRoutes');
const resetTokenRoutes = require('./routes/resetTokenRoutes');
const registerCoachRoutes = require('./routes/registerCoachRoutes'); // Importa a nova rota para registro de coaches

app.use(express.json());

// Define as rotas
app.use('/api/coaches', coachRoutes);                // Rota para operações de coaches
app.use('/api/register-coaches', registerCoachRoutes); // Nova rota para registro de coaches
app.use('/api/alunos', alunoRoutes);                 // Rota para operações de alunos
app.use('/api/auth', authRoutes);                    // Rota para autenticação
app.use('/api/metricas', metricasRoutes);            // Rota para métricas
app.use('/api/reset-token', resetTokenRoutes);       // Rota para reset de token

// Sincroniza o banco de dados e inicia o servidor
sequelize.sync({ force: false }).then(() => {
  app.listen(3000, () => {
    console.log('Servidor rodando na porta 3000');
  });
}).catch(err => {
  console.error('Erro ao conectar ao banco de dados:', err);
});
