const express = require('express');
const cors = require('cors');
const app = express();
const sequelize = require('./ApiConfig/db');
const bcrypt = require('bcryptjs');


const coachRoutes = require('./routes/coachRoutes');
const registerAthleteRoutes = require('./routes/registerAthleteRoutes');
const athleteRoutes = require('./routes/athleteRoutes');
const registerCoachRoutes = require('./routes/registerCoachRoutes');
const authRoutes = require('./routes/authRoutes');
const metricasRoutes = require('./routes/metricasRoutes');
const resetTokenRoutes = require('./routes/resetTokenRoutes');
const coachController = require('./Controller/CoachController');

app.use(cors());
app.use(express.json());
app.use((req, res, next) => {
  console.log(`Rota acessada: ${req.method} ${req.url}`);
  next();
});

// Middleware para analisar o corpo da requisição como JSON
app.use(bodyParser.json());

// Teste de conexão com o banco de dados
sequelize.authenticate()
    .then(() => {
        console.log('Conexão bem-sucedida com o banco de dados SQL Server');
    })
    .catch(err => {
        console.error('Erro ao conectar ao banco de dados:', err);
    });

// Usando as rotas
app.use('/api/record', recordRoutes);
app.use('/api/coaches', coachRoutes);
app.get('/api/coaches/data', coachController.getCoachesData);
app.put('/api/coaches/:id/status', coachController.toggleCoachStatus);
app.put('/api/coaches/:id/archive', coachController.archiveCoach);

app.use('/api/athletes', athleteRoutes);
app.use('/api/register-athletes', registerAthleteRoutes); 
app.use('/api/register-coaches', registerCoachRoutes);
app.use('/api/auth', authRoutes);
app.use('/api/metricas', metricasRoutes);
app.use('/api/athletes/register', registerAthleteRoutes);
app.use('/api/reset-token', resetTokenRoutes);

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