const scope = require('./loginScope');
const service = require('./loginService');

module.exports = {
    preLogin,
    login,
    refazLogin
};

async function preLogin(req, res) {
    try {
        const params = {
            login: req.body.login,
            senha: null
        };

        await scope.preLogin(params);

        const data = await service.preLogin(params);

        return res.finish({
            content: {
                user: data
            }
        });
    } catch (error) {
        return res.finish({
            httpCode: error.httpCode || 500,
            error
        });
    }
}

async function login(req, res) {
    try {
        const params = {
            login: req.body.login,
            senha: req.body.senha
        };

        await scope.login(params);

        const data = await service.login(params);

        return res.finish({
            content: data
        });

    } catch (error) {
        return res.finish({
            httpCode: error.httpCode || 500,
            error
        });
    }
}

async function refazLogin(req, res) {
    try {
        const params = {
            id: req.token.idUsuario
        };

        await scope.rafazLogin(params);

        const data = await service.refazLogin(params);

        return res.finish({
            content: data
        });

    } catch (error) {
        return res.finish({
            httpCode: error.httpCode || 500,
            error
        });
    }
}