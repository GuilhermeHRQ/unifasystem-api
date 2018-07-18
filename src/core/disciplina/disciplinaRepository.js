const mongoose = require('mongoose');
const Disciplina = mongoose.model('Disciplina');

module.exports = {
    inserir
}

async function inserir(params) {
    const disciplina = new Disciplina(params);
    await disciplina.save();
    return disciplina.id;
}