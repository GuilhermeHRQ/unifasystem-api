'use strict';

const express = require('express');
const router = express.Router();
const api = require('../../core/usuario/usuarioController');

router.post('/inserir', api.inserir);
router.get('/selecionar', api.selecionar);
router.get('/selecionar/:id', api.selecionarPorId);
router.put('/atualizar/:id', api.atualizar);
router.delete('/remover/:id', api.remover);

module.exports = router;