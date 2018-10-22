const validate = require('../../helpers/validate');

module.exports = {
    preLogin,
    login,
    rafazLogin
};

async function preLogin(params) {
    const validation = {
        login: {
            required: true,
            notNull: true,
            string: true
        }
    };

    await validate(params, validation);
}

async function login(params) {
    const validation = {
        login: {
            required: true,
            notNull: true,
            string: true,
            maxLength: 30
        },
        senha: {
            required: true,
            notNull: true,
            string: true,
        }
    };

    await validate(params, validation);
}

async function rafazLogin(params) {
    const validation = {
        id: {
            required: true,
            notNull: true
        }
    };

    await validate(params, validation);
}