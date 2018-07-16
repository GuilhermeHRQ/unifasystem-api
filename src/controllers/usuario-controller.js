'use strict';

module.exports = {
    inserir
}

const repository = require('../repositories/usuario-repository');
const md5 = require('md5');

async function inserir(req, res) {
    try {
        const body = {
            nome: req.body.nome,
            email: req.body.email,
            senha: md5(req.body.senha, global.SALT_KEY)
        }

        const data = await repository.inserir(body);
        res.status(201).json({
            content: data,
            message: 'Usuário cadastrado com sucesso!'
        });
    } catch (e) {
        switch (e.code) {
            case 11000:
                res.status(403).json({
                    message: 'Email já cadastrado'
                });
                break;
            default:
                res.status(500).json({
                    message: 'Erro ao processar a requisição'
                });
        }
    }
}
