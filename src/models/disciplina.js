'use strict';

const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const schema = new Schema({
    cargaHoraria: {
        type: Number,
        required: true
    },
    nome: {
        type: String,
        required: true,
        maxlength: 70
    },
    descricao: {
        type: String,
        required: true,
        maxlength: 250
    },
    dataCadastro: {
        type: Date,
        required: true,
        default: Date.now()
    },
    dataAlteracao: {
        type: Date,
        required: false,
        default: null
    },
    usuarioCadastro: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Usuario',
        required: true
    },
    usuarioAlteracao: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Usuario'
    }
});

module.exports = mongoose.model('Disciplina', schema);