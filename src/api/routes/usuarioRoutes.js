'use strict';

const express = require('express');
const router = express.Router();
const api = require('../../core/usuario/usuarioController');

router.post('/', api.inserir);
router.get('/', api.selecionar);
router.get('/:id', api.selecionarPorId);
router.put('/:id', api.atualizar);
router.delete('/:id', api.remover);

module.exports = router;