'use strict';

const repository = require('./disciplinaRepository');

async function inserir(req, res) {
    const data = await repository.inserir()
}