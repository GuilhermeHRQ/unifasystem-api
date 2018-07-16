'use strict';

const express = require('express');
const router = express.Router();
const api = require('../../core/login/loginController');
const auth = require('../../helpers/auth');

router.post('/', api.logar);
router.post('/dados', api.getDadosUsuario);
router.get('/refazer', auth.authorize, api.refazLogin);

module.exports = router;