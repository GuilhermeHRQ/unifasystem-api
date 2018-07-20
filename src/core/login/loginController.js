'use strict';

module.exports = {
    getDadosUsuario,
    logar,
    refazLogin
}

const service = require('./loginService');
const scope = require('./loginScope');
const md5 = require('md5');

async function getDadosUsuario(req, res) {
    const params = {
        login: req.body.login
    }

    try {
        await scope.getDadosUsuario(params);

        const data = await service.getDadosUsuario(params);

        let httpCode = 200;
        let error;
        let content;

        switch (data.executionCode) {
            case 1:
                httpCode = 404;
                error = data;
                break;
            default:
                content = data.content;
        }

        return res.finish({
            httpCode: httpCode,
            error: error,
            content: content
        });
    } catch (error) {
        return res.finish({
            httpCode: error.httpCode || 500,
            error
        });
    }
}

async function logar(req, res) {
    const params = {
        login: req.body.login,
        senha: req.body.senha
    }

    try {
        await scope.logar(params);

        const data = await service.logar(params);

        let httpCode = 200;
        let error;
        let content;

        switch (data.executionCode) {
            case 1:
                httpCode = 404;
                error = data;
                break;
            case 2:
                httpCode = 401;
                error = data;
                break;
            default:
                content = data.content;
        }

        return res.finish({
            httpCode: httpCode,
            error: error,
            content: content
        });

    } catch (error) {
        return res.finish({
            httpCode: error.httpCode || 500,
            error
        });
    }
}

async function refazLogin(req, res) {
    const params = {
        user: req.token
    };

    try {
        await scope.refazLogin(params);
        const data = await service.refazLogin(params);

        let httpCode = 200;
        let error;
        let content;

        switch (data.executionCode) {
            case 1:
                httpCode = 404;
                error = data;
                break;
            default:
                content = data.content;
        }

        return res.finish({
            httpCode: httpCode,
            error: error,
            content: content
        });

    } catch (error) {
        return res.finish({
            httpCode: error.httpCode || 500,
            error
        });
    }
}