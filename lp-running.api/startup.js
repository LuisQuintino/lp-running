const express = require('express');
const sequelize = require('./ApiConfig/db');
const coachRoutes = require('./routes/coachRoutes');
const alunoRoutes = require('./routes/alunoRoutes');
const authRoutes = require('./routes/authRoutes');
const metricasRoutes = require('./routes/metricasRoutes');
const resetTokenRoutes = require('./routes/resetTokenRoutes');

const app = express();
app.use(express.json());

app.use('/api/coaches', coachRoutes);
app.use('/api/alunos', alunoRoutes);
app.use('/api/auth', authRoutes);
app.use('/api/metricas', metricasRoutes);
app.use('/api/reset-token', resetTokenRoutes);

sequelize.sync({ force: false }).then(() => {
  app.listen(3000, () => {
    console.log('Servidor rodando na porta 3000');
  });
}).catch(err => {
  console.error('Erro ao conectar ao banco de dados:', err);
});
