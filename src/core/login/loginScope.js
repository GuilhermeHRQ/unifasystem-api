const validate = require('../../helpers/validate');

module.exports = {
    getDadosUsuario,
    logar,
    refazLogin
}

async function getDadosUsuario(params) {
    const validation = {
        login: {
            required: true
        }
    };

    try {
        await validate(params, validation);
    } catch (error) {
        error.httpCode = 400;
        throw error;
    }
}

async function logar(params) {
    const validation = {
        login: {
            require: true,
        },
        senha: {
            required: true
        }
    };

    try {
        await validate(params, validation);
    } catch (error) {
        error.httpCode = 400;
        throw error;
    }
}

async function refazLogin(params) {
    const validation = {
        token: {
            required: true,
            string: true
        }
    };

    try {
        await validate(params, validation);
    } catch (error) {
        error.httpCode = 400;
        throw error;
    }
}