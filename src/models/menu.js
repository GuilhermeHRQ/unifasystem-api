'use strict';

const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const schema = new Schema({
    parentId: {
        type: String,
        default: null
    },
    url: {
        type: String,
        required: true,
        trim: true,
        unique: true
    },
    name: {
        type: String,
        required: true,
        trim: true
    }
});

module.exports = mongoose.model('opcoesMenu', schema);