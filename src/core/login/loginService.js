const repository = require('./loginRepository');

module.exports = {
    preLogin
};

async function preLogin(params) {
    const data = await repository.preLogin(params);

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

    return data;
}