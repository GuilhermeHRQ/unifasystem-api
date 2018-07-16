'use strict';

module.exports = {
    autenticarPorEmail
}

const mongoose = require('mongoose');
const Usuario = mongoose.model('Usuario');

async function autenticarPorEmail(email) {
    const data = await Usuario.findOne({ email: email });
    return data;
}