'use strict';

module.exports = {
    inserir
}

const mongoose = require('mongoose');
const Disciplina = mongoose.model('Disciplina');

async function inserir(body) {
    const disciplina = new Disciplina(body);
    await disciplina.save();
    return disciplina.id;
}