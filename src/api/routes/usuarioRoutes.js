'use strict';

const express = require('express');
const router = express.Router();
const api = require('../../core/usuario/usuarioController');

router.post('/inserir', api.inserir);

module.exports = router;