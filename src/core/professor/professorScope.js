const validate = require('../../helpers/validate');

module.exports = {
    inserirProfessor
};

async function inserirProfessor(params) {
    const validation = {
        cpf: {
            required: true,
            string: true,
            notNull: true,
            maxLength: 11
        },
        nome: {
            required: true,
            string: true,
            notNull: true,
            maxLength: 30
        },
        sobrenome: {
            required: true,
            string: true,
            notNull: true,
            maxLength: 30
        },
        dataNascimento: {
            required: true,
            date: true,
            notNull: true
        },
        salario: {
            required: true,
            notNull: true,
            number: true
        }
    };

    try {
        await validate(params, validation);
    } catch (error) {
        error.httpCode = 400;
        throw error;
    }
}