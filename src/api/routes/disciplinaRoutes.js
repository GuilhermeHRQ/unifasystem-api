const express = require('express');
const router = express.Router();
const api = require('../../core/disciplina/disciplinaController');
const auth = require('../../helpers/auth');

router.post('/', auth.authorize, api.inserir);
router.get('/', auth.authorize, api.selecionar);

module.exports = router;