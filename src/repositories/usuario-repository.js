'use strict';

module.exports = {
    inserir,
    selecionar,
    selecionarPorId,
    atualizar,
    remover
}

const mongoose = require('mongoose');
const Usuario = mongoose.model('Usuario');

async function inserir(data) {
    const usuario = new Usuario(data);
    await usuario.save();
    return usuario.id;
}

async function selecionar() {
    const data = await Usuario.find({}, 'nome, email');
    return data;
}

async function selecionarPorId(id) {
    const data = await Usuario.findById(id);
    return data;
}

async function atualizar(id, data) {
    await Usuario.findByIdAndUpdate(id, {
        $set: {
            nome: data.name,
            email: data.email
        }
    });
}

async function remover(id) {
    await Usuario.findByIdAndRemove(id);
}