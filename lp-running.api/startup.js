// startup.js

const express = require('express');
const cors = require('cors');
const { connectDB } = require('./ApiConfig/db');
const coachController = require('./Controller/coachController');

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

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
