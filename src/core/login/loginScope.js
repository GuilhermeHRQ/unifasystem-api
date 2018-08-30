const validate = require('../../helpers/validate');

module.exports = {
    preLogin
};

async function preLogin(params) {
    const validation = {
        login: {
            required: true,
            notNull: true,
            string: true,
            maxLength: 30
        }
    };

    await validate(params, validation);
}

