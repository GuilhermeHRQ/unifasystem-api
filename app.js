'use strict';

const consign = require('consign');
const express = require('express');
const app = express();
const body = require('body-parser');
const cors = require('./src/api/middleware/cors');
const response = require('./src/api/middleware/response');
require('./settings/db');
require('./src/helpers/auth');

global.config = {
    host: process.env.HOST || 'http://localhost',
    port: process.env.PORT || 4200
};

app.use(body.json({limit: '10mb'}));
app.use(body.urlencoded({extended: false}));

// Habilita o CORS e o RESPONSE
app.use(cors);
app.use(response);

consign()
        .include('./src/api/routes')
        .into(app);

app.listen(global.config.port, () => {
    console.log(`Server online on port ${global.config.port}`);
});

module.exports = app;