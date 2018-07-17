const validate = require('../../helpers/validate');

module.exports = {
    inserir,
    selecionarPorId,
    atualizar,
    remover
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
        error.httpCode = 400;
        throw error;
    }
}

async function selecionarPorId(params) {
    const validation = {
        id: {
            required: true,
            string: true,
            notNull: true
        }
    };

    try {
        await validate(params, validation);
    } catch (error) {
        error.httpCode = 400;
        throw error;
    }
}

async function atualizar(params) {
    const validation = {
        id: {
            required: true,
            string: true,
            notNull: true
        },
        nome: {
            required: true,
            string: true,
            maxLength: 70
        },
        email: {
            required: true,
            string: true,
            maxLength: 252
        }
    }

    try {
        await validate(params, validation);
    } catch (error) {
        error.httpCode = 400;
        throw error;
    }
}

async function remover(params) {
    const validation = {
        id: {
            required: true,
            string: true,
            notNull: true
        }
    };

    try {
        await validate(params, validation);
    } catch (error) {
        error.httpCode = 400;
        throw error;
    }
}