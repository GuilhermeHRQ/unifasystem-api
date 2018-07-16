'use strict';

const express = require('express');
const router = express.Router();
const controller = require('../controllers/login-controller');

router.post('/dados', controller.getDadosUsuario);

module.exports = router;