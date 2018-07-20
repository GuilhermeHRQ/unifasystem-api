const express = require('express');
const router = express.Router();
const api = require('../../core/disciplina/disciplinaController');
const auth = require('../../helpers/auth');

router.post('/', auth.verify(api.inserir));
router.get('/', auth.verify(api.selecionar));
router.get('/:id', auth.verify(api.selecionarPorId));
router.put('/:id', auth.verify(api.atualizar));

module.exports = router;