const validate = require('../../helpers/validate');

module.exports = {
    inserir
}

async function inserir(params) {
    const validation = {
        nome: {
            required: true,
            string: true,
            maxLength: 70
        },
        email: {
            required: true,
            string: true,
            maxLength: 252
        },
        senha: {
            required: true
        }
    };

    try {
        await validate(params, validation);
    } catch (error) {
        httpCode = error.httpCode;
        error
    }
}