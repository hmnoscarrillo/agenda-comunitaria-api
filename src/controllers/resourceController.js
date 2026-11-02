const model = require('../models/resourceModel');
const enums = { eventos: ['programado', 'cancelado', 'finalizado'], inscripciones: ['confirmada', 'cancelada', 'asistio'] };
const integerFields = new Set(['capacidad', 'categoria_id', 'lugar_id', 'persona_id', 'evento_id']);
const requiredByResource = {
  personas: ['nombre', 'apellido', 'cedula', 'email', 'celular'],
  categorias: ['nombre', 'descripcion'],
  lugares: ['nombre', 'ciudad', 'direccion', 'capacidad'],
  eventos: ['categoria_id', 'lugar_id', 'titulo', 'descripcion', 'fecha_inicio', 'fecha_fin', 'estado'],
  inscripciones: ['persona_id', 'evento_id', 'fecha_inscripcion', 'estado']
};
const constraints = {
  nombre: 60, apellido: 60, cedula: 20, email: 150, celular: 20,
  descripcion: 1000, ciudad: 80, direccion: 180, titulo: 160
};

function validate(resource, body) {
  if (!body || typeof body !== 'object' || Array.isArray(body)) return 'El cuerpo debe ser un objeto JSON';
  const fields = model.resources[resource].fields;
  const extra = Object.keys(body).filter((key) => !fields.includes(key));
  if (extra.length) return `Campos no permitidos: ${extra.join(', ')}`;
  for (const field of requiredByResource[resource]) {
    if (body[field] === undefined || body[field] === null || body[field] === '') return `El campo ${field} es obligatorio`;
    if (integerFields.has(field) && (!Number.isInteger(Number(body[field])) || Number(body[field]) < 1)) return `El campo ${field} debe ser un entero positivo`;
    if (constraints[field] && (typeof body[field] !== 'string' || body[field].length > constraints[field])) return `El campo ${field} debe ser texto de máximo ${constraints[field]} caracteres`;
  }
  if (resource === 'personas' && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(body.email)) return 'El correo electrónico no tiene un formato válido';
  if (resource === 'lugares' && Number(body.capacidad) < 1) return 'La capacidad debe ser mayor que cero';
  if (enums[resource] && !enums[resource].includes(body.estado)) return `estado debe ser uno de: ${enums[resource].join(', ')}`;
  if (resource === 'eventos') {
    const start = new Date(body.fecha_inicio); const end = new Date(body.fecha_fin);
    if (Number.isNaN(start.valueOf()) || Number.isNaN(end.valueOf())) return 'Las fechas deben ser válidas';
    if (end <= start) return 'fecha_fin debe ser posterior a fecha_inicio';
  }
  if (resource === 'inscripciones' && Number.isNaN(new Date(body.fecha_inscripcion).valueOf())) return 'fecha_inscripcion debe ser una fecha válida';
  return null;
}

function dbError(err, res) {
  if (err.code === 'ER_DUP_ENTRY') return res.status(409).json({ success: false, error: { code: 'DUPLICATE_VALUE', message: 'El registro viola una restricción UNIQUE' } });
  if (err.code === 'ER_NO_REFERENCED_ROW_2' || err.code === 'ER_ROW_IS_REFERENCED_2') return res.status(409).json({ success: false, error: { code: 'REFERENCE_CONFLICT', message: 'La operación viola una relación entre registros' } });
  if (err.code === 'ER_CHECK_CONSTRAINT_VIOLATED' || err.code === 'ER_TRUNCATED_WRONG_VALUE') return res.status(400).json({ success: false, error: { code: 'INVALID_VALUE', message: 'Uno o más valores no son válidos' } });
  console.error(`Error MySQL ${err.code || ''}`);
  return res.status(500).json({ success: false, error: { code: 'DATABASE_ERROR', message: 'No fue posible completar la operación' } });
}

const notFound = (res, resource) => res.status(404).json({ success: false, error: { code: 'NOT_FOUND', message: `${resource} no encontrado` } });
const controller = {
  list(req, res) { model.list(req.params.resource, (err, rows) => err ? dbError(err, res) : res.json({ success: true, data: rows })); },
  get(req, res) { model.get(req.params.resource, req.params.id, (err, row) => err ? dbError(err, res) : row ? res.json({ success: true, data: row }) : notFound(res, req.params.resource)); },
  create(req, res) {
    const resource = req.params.resource; const invalid = validate(resource, req.body);
    if (invalid) return res.status(400).json({ success: false, error: { code: 'VALIDATION_ERROR', message: invalid } });
    model.create(resource, req.body, (err, result) => err ? dbError(err, res) : res.status(201).json({ success: true, data: { id: result.insertId }, message: 'Registro creado' }));
  },
  update(req, res) {
    const resource = req.params.resource; const invalid = validate(resource, req.body);
    if (invalid) return res.status(400).json({ success: false, error: { code: 'VALIDATION_ERROR', message: invalid } });
    model.update(resource, req.params.id, req.body, (err, result) => err ? dbError(err, res) : result.affectedRows ? res.json({ success: true, message: 'Registro actualizado' }) : notFound(res, resource));
  },
  remove(req, res) { model.remove(req.params.resource, req.params.id, (err, result) => err ? dbError(err, res) : result.affectedRows ? res.json({ success: true, message: 'Registro eliminado' }) : notFound(res, req.params.resource)); }
};

module.exports = controller;
