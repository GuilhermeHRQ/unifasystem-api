'use strict';

const repository = require('./disciplinaRepository');

async function inserir(req, res) {
    const params = {
        cargaHoraria: req.body.cargaHoraria,
        nome: req.body.nome,
        descricao: req.body.descricao
    }
}