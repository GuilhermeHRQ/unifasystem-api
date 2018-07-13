'use strict';

const config = require('./config');
const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const app = express(); // Instancia o express em app;
const cors = require('./cors');

// Conecta ao banco
mongoose.connect(config.mongoConnect) // Conexão com o banco através de connect string

// Carrega os models
const Usuario = require('./models/usuario');

// Carregar as rotas
const indexRoutes = require('./routes/index-routes');

app.use(bodyParser.json({
    limit: '5mb' // define um limite de dados na req
})); // Converte todo os body das req para json "middleware"
app.use(bodyParser.urlencoded({ extended: false })); // Faz urlencoded nas rotas

// Habilita o CORS
app.use(cors);

// Cadastrando rotas
app.use('/', indexRoutes); // Adiciona um prefixo que deve ser colocado antes da rota ex: se o prefixo for /user a rota devera ser {{HOST}}:port/user/rota


module.exports = app;