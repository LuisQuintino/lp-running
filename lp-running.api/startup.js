const express = require('express');
const app = express();
const sequelize = require('./ApiConfig/db'); 


// Importação das rotas
const coachRoutes = require('./routes/coachRoutes');
const athleteRoutes = require('./routes/athleteRoutes'); 
const registerCoachRoutes = require('./routes/registerCoachRoutes'); 
const registerAthleteRoutes = require('./routes/registerAthleteRoutes'); 
const authRoutes = require('./routes/authRoutes');
const metricasRoutes = require('./routes/metricasRoutes');
const resetTokenRoutes = require('./routes/resetTokenRoutes');

app.use(express.json());

// Define as rotas
app.use('/api/coaches', coachRoutes);                    
app.use('/api/register-coaches', registerCoachRoutes);   
app.use('/api/athletes', athleteRoutes);                
app.use('/api/register-athletes', registerAthleteRoutes); 
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
