'use strict';

const express = require('express');
const router = express.Router();
const controller = require('../controllers/usuario-controller');

router.post('/inserir', controller.inserir);

module.exports = router;