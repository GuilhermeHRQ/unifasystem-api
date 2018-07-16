'use strict';

module.exports = {
    getDadosUsuario
}

const repository = require('../repositories/login-repository');

async function getDadosUsuario(req, res) {
    try {
        const data = await repository.autenticarPorEmail(req.body.usuario);

        if (!data) {
            res.status(404).json({
                message: 'Email não cadastrado'
            });
            return;
        }

        res.status(200).json({
            content: data,
            message: 'OK'
        });
    } catch (e) {
        res.status(500).json({
            message: 'Erro ao processar a requisição'
        });
    }
}