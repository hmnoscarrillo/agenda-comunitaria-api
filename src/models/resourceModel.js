const db = require('../config/dbConfig');

const resources = {
  personas: { table: 'persona', fields: ['nombre', 'apellido', 'cedula', 'email', 'celular'] },
  categorias: { table: 'categoria', fields: ['nombre', 'descripcion'] },
  lugares: { table: 'lugar', fields: ['nombre', 'ciudad', 'direccion', 'capacidad'] },
  eventos: { table: 'evento', fields: ['categoria_id', 'lugar_id', 'titulo', 'descripcion', 'fecha_inicio', 'fecha_fin', 'estado'] },
  inscripciones: { table: 'inscripcion', fields: ['persona_id', 'evento_id', 'fecha_inscripcion', 'estado'] }
};

const query = (sql, values, callback) => db.query(sql, values, callback);

module.exports = {
  resources,
  list(resource, callback) {
    const { table, fields } = resources[resource];
    if (resource === 'eventos') {
      return query(`SELECT e.id, e.categoria_id, c.nombre AS categoria, e.lugar_id, l.nombre AS lugar, e.titulo, e.descripcion, e.fecha_inicio, e.fecha_fin, e.estado FROM evento e JOIN categoria c ON c.id=e.categoria_id JOIN lugar l ON l.id=e.lugar_id ORDER BY e.fecha_inicio`, [], callback);
    }
    query(`SELECT id, ${fields.join(', ')} FROM ${table} ORDER BY id`, [], callback);
  },
  get(resource, id, callback) {
    const { table, fields } = resources[resource];
    if (resource === 'eventos') {
      return query(`SELECT e.id, e.categoria_id, c.nombre AS categoria, e.lugar_id, l.nombre AS lugar, e.titulo, e.descripcion, e.fecha_inicio, e.fecha_fin, e.estado FROM evento e JOIN categoria c ON c.id=e.categoria_id JOIN lugar l ON l.id=e.lugar_id WHERE e.id = ?`, [id], (err, rows) => callback(err, rows && rows[0]));
    }
    query(`SELECT id, ${fields.join(', ')} FROM ${table} WHERE id = ?`, [id], (err, rows) => callback(err, rows && rows[0]));
  },
  create(resource, values, callback) {
    const { table, fields } = resources[resource];
    query(`INSERT INTO ${table} (${fields.join(', ')}) VALUES (${fields.map(() => '?').join(', ')})`, fields.map((field) => values[field] ?? null), callback);
  },
  update(resource, id, values, callback) {
    const { table, fields } = resources[resource];
    const assignments = fields.map((field) => `${field} = ?`).join(', ');
    query(`UPDATE ${table} SET ${assignments} WHERE id = ?`, [...fields.map((field) => values[field] ?? null), id], callback);
  },
  remove(resource, id, callback) {
    const { table } = resources[resource];
    query(`DELETE FROM ${table} WHERE id = ?`, [id], callback);
  }
};
