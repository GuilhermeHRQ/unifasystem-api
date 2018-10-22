const repository = require('./loginRepository');
const routes = require('../../api/routes/routes');

module.exports = {
    preLogin,
    login,
    refazLogin
};

async function preLogin(params) {
    const data = await repository.preLogin(params);

    let error;

    switch (data.executionCode) {
        case 1:
            error = data;
            error.httpCode = 404;
    }

    if (error) {
        throw error;
    }

    delete data.senhaCorreta;

    return data;
}

async function login(params) {
    const data = await repository.login(params);

    let error;

    switch (data.executionCode) {
        case 1:
            error = data;
            error.httpCode = 404;
            break;
        case 2:
            error = data;
            error.httpCode = 401
    }

    if (error) {
        throw error;
    }

    delete data.senhaCorreta;

    const token = await global.generateToken({
        idUsuario: data.id,
        codigoProfessor: data.codigo
    });

    return {
        user: data,
        api: routes,
        token: token
    }
}

async function refazLogin(params) {
    const data = await repository.refazLogin(params);

    let error;

    switch (data.executionCode) {
        case 1:
            error = data;
            error.httpCode = 404;
    }

    if (error) {
        throw error;
    }

    const token = await global.generateToken({
        idUsuario: data.id,
        codigoProfessor: data.codigo
    });

    return {
        user: data,
        api: routes,
        token: token
    }
}