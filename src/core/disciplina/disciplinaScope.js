const validate = require('../../helpers/validate');

async function inserir(params) {
    const validation = {
        cargaHoraria: {
            required: true,
            number: 'smallint',
            notNull: true
        },
        nome: {
            required: true,
            string: true,
            maxLength: 70
        },
        descricao: {
            required: true,
            string: true,
            maxLength: 200
        }
    };

    try {
        await validate(params, validation);
    } catch (error) {
        error.httpCode = 400;
        throw error;
    }
}