require('dotenv').config();
const express = require('express');
const sql = require('mssql');

const app = express();
app.use(express.json());

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

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
