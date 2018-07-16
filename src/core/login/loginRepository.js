'use strict';

module.exports = {
    autenticar,
    autenticarPorEmail,
    autenticarPorId,
    getMenu
}

const mongoose = require('mongoose');
const Usuario = mongoose.model('Usuario');
const Menu = mongoose.model('opcoesMenu');

async function autenticar(body) {
    const data = await Usuario.findOne({ email: body.email, senha: body.senha }, 'nome email cor');
    return data;
}

async function autenticarPorEmail(params) {
    const data = await Usuario.findOne({ email: params.login });
    return data;
}

async function autenticarPorId(id) {
    const data = await Usuario.findById(id, 'nome email cor');
    return data;
}

async function getMenu() {
    const data = await Menu.find({});
    return data;
}