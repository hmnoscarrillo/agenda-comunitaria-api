const mysql = require('mysql');

const required = ['DB_HOST', 'DB_USER', 'DB_NAME'];
const missing = required.filter((key) => !process.env[key]);
if (missing.length) throw new Error(`Faltan variables de entorno: ${missing.join(', ')}`);

const db = mysql.createConnection({
  host: process.env.DB_HOST,
  port: Number(process.env.DB_PORT || 3306),
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME,
  ssl: process.env.DB_SSL === 'true' ? { rejectUnauthorized: true } : undefined,
  multipleStatements: false,
  connectTimeout: 10000
});

db.connect((err) => {
  if (err) {
    console.error(`No fue posible conectar con MySQL: ${err.code || err.message}`);
    process.exit(1);
  }
  console.log(`Conexión MySQL establecida (${process.env.DB_NAME})`);
});

module.exports = db;
