// ApiConfig/db.js

const sql = require('mssql');
const dotenv = require('dotenv');

dotenv.config();

const config = {
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  server: process.env.DB_SERVER, 
  database: process.env.DB_DATABASE,
  port: parseInt(process.env.DB_PORT, 10),
  options: {
    encrypt: true,
    trustServerCertificate: true,
  },
};

const connectDB = async () => {
  try {
    await sql.connect(config);
    console.log('Conectado ao SQL Server.');
  } catch (err) {
    console.error('Erro ao conectar ao SQL Server:', err);
    process.exit(1);
  }
};

module.exports = { sql, connectDB };
