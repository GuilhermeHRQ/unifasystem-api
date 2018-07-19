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

async function selecionarPorId(params) {
    const data = await Usuario.findById(params.id);
    return data;
}

async function atualizar(params) {
    await Usuario.findByIdAndUpdate(params.id, {
        $set: {
            nome: params.nome,
            email: params.email,
        }
    });
}

async function remover(params) {
    await Usuario.findByIdAndRemove(params.id);
}