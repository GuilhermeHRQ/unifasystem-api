'use strict';

const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const schema = new Schema({
    nome: {
        type: String,
        required: [true, 'Nome é obrigatório']
    },
    email: {
        type: String,
        required: [true, 'Email é obrigatório'],
        unique: [true, 'Email já cadastrado'],
        index: true,
        trim: true
    },
    senha: {
        type: String,
        required: [true, 'Senha é obrigatória']
    }
})

module.exports = mongoose.model('Usuario', schema);