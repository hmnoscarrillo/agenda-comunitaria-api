require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const routes = require('./src/routes');
const db = require('./src/config/dbConfig');

const app = express();
const port = Number(process.env.PORT || 3000);

app.use(bodyParser.json({ limit: '1mb' }));
app.use('/api', routes);
app.get('/health', (_req, res) => {
  db.ping((err) => {
    if (err) return res.status(503).json({ success: false, error: { code: 'DB_UNAVAILABLE', message: 'Base de datos no disponible' } });
    res.status(200).json({ success: true, data: { api: 'ok', database: 'ok' } });
  });
});
app.use((_req, res) => res.status(404).json({ success: false, error: { code: 'ROUTE_NOT_FOUND', message: 'Ruta no encontrada' } }));
app.use((err, _req, res, _next) => {
  if (err instanceof SyntaxError && err.status === 400 && 'body' in err) {
    return res.status(400).json({ success: false, error: { code: 'INVALID_JSON', message: 'El cuerpo debe contener JSON válido' } });
  }
  console.error(err);
  res.status(500).json({ success: false, error: { code: 'INTERNAL_ERROR', message: 'Error interno del servidor' } });
});

const server = app.listen(port, () => console.log(`API Agenda Comunitaria en http://localhost:${port}`));
const shutdown = () => db.end(() => server.close(() => process.exit(0)));
process.on('SIGINT', shutdown);
process.on('SIGTERM', shutdown);
module.exports = app;
