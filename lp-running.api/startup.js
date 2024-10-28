const express = require('express');
const bodyParser = require('body-parser');
const sequelize = require('./ApiConfig/db'); // Ajuste o caminho conforme necessário
const recordRoutes = require('./Routes/recordRoutes'); // Ajuste o caminho conforme necessário
const coachRoutes = require('./Routes/coachRoutes');
const alunoRoutes = require('./routes/alunoRoutes');
const authRoutes = require('./routes/authRoutes');
const metricasRoutes = require('./routes/metricasRoutes');
const resetTokenRoutes = require('./routes/resetTokenRoutes');

const app = express();
const PORT = 3000;

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
app.use('/api/alunos', alunoRoutes);
app.use('/api/auth', authRoutes);
app.use('/api/metricas', metricasRoutes);
app.use('/api/reset-token', resetTokenRoutes);

// Rota de teste
app.get('/', (req, res) => {
    res.send('Servidor rodando!');
});

// Sincronizando e iniciando o servidor
sequelize.sync({ force: false }).then(() => {
    app.listen(PORT, () => {
        console.log(`Servidor rodando na porta ${PORT}`);
    });
}).catch(err => {
    console.error('Erro ao conectar ao banco de dados:', err);
});
