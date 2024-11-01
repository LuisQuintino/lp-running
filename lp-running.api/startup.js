const express = require('express');
const cors = require('cors');
const app = express();
const sequelize = require('./ApiConfig/db');
const bcrypt = require('bcryptjs');
const bodyParser = require('body-parser')


const coachRoutes = require('./Routes/coachRoutes');
const registerAthleteRoutes = require('./Routes/registerAthleteRoutes');
const athleteRoutes = require('./Routes/athleteRoutes');
const registerCoachRoutes = require('./Routes/registerCoachRoutes');
const authRoutes = require('./Routes/authRoutes');
const metricasRoutes = require('./Routes/metricasRoutes');
const resetTokenRoutes = require('./Routes/resetTokenRoutes');
const coachController = require('./Controller/CoachController');
const recordRoutes = require('./Routes/recordRoutes')

app.use(cors());
app.use(express.json());
app.use(bodyParser.json());

app.use((req, res, next) => {
  console.log(`Rota acessada: ${req.method} ${req.url}`);
  next();
});

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

app.use('/api/athletes/register', registerAthleteRoutes);
app.use('/api/athletes', athleteRoutes);
app.use('/api/register-coaches', registerCoachRoutes);
app.use('/api/auth', authRoutes);
app.use('/api/metricas', metricasRoutes);
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
