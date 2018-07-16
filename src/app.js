'use strict';

const config = require('./config');
const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const app = express(); // Instancia o express em app;
const cors = require('./api/middleware/cors');
const response = require('./api/middleware/response');

// Conecta ao banco
mongoose.connect(config.mongoConnect) // Conexão com o banco através de connect string

// Carrega os models
const Usuario = require('./models/usuario');
const Menu = require('./models/menu');
const Disciplina = require('./models/disciplina');

// Carregar as rotas
const indexRoutes = require('./api/routes/indexRoutes');
const usuarioRoutes = require('./api/routes/usuarioRoutes');
const loginRoutes = require('./api/routes/loginRoutes');

app.use(bodyParser.json({
    limit: '5mb' // define um limite de dados na req
})); // Converte todo os body das req para json "middleware"
app.use(bodyParser.urlencoded({ extended: false })); // Faz urlencoded nas rotas

// Habilita o CORS e o RESPONSE
app.use(cors);
app.use(response);

// Cadastrando rotas
app.use('/', indexRoutes); // Adiciona um prefixo que deve ser colocado antes da rota ex: se o prefixo for /user a rota devera ser {{HOST}}:port/user/rota
app.use('/usuario', usuarioRoutes);
app.use('/login', loginRoutes);

module.exports = app;