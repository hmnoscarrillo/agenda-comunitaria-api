const express = require('express');
const controller = require('../controllers/resourceController');
const router = express.Router();
const resources = ['personas', 'categorias', 'lugares', 'eventos', 'inscripciones'];

router.get('/', (_req, res) => res.json({ success: true, data: { resources } }));
router.get('/:resource', (req, res, next) => resources.includes(req.params.resource) ? controller.list(req, res, next) : next());
router.get('/:resource/:id', (req, res, next) => resources.includes(req.params.resource) && /^\d+$/.test(req.params.id) ? controller.get(req, res, next) : next());
router.post('/:resource', (req, res, next) => resources.includes(req.params.resource) ? controller.create(req, res, next) : next());
router.put('/:resource/:id', (req, res, next) => resources.includes(req.params.resource) && /^\d+$/.test(req.params.id) ? controller.update(req, res, next) : next());
router.delete('/:resource/:id', (req, res, next) => resources.includes(req.params.resource) && /^\d+$/.test(req.params.id) ? controller.remove(req, res, next) : next());

module.exports = router;
