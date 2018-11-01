const validate = require('../../helpers/validate');

module.exports = {
    inserir,
    atualizar
};

async function inserir(params) {
    const validation = {
        semestre: {
            required: true,
            notNull: true,
            number: 'smallint'
        },
        idDisciplina: {
            required: true,
            notNull: true
        },
        idTurma: {
            required: true,
            notNull: true
        },
        idProfessor: {
            required: true,
            notNull: true,
            number: 'integer'
        },
        nomeTurma: {
            required: true,
            notNull: true,
            string: true,
            maxLength: 100
        },
        nomeDisciplina: {
            required: true,
            notNull: true,
            string: true,
            maxLength: 100
        },
        horaAbertura: {
            required: true,
            notNull: true
        },
        horaFechamento: {
            required: true,
            notNull: true
        },
        quantidadePresencas: {
            required: true,
            notNull: true,
            number: 'smallint'
        },
        conteudo: {
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

async function atualizar(params) {
    const validation = {
        id: {
            notNull: true,
            required: true,
            number: 'smallint'
        },
        conteudo: {
            string: true
        },
        confirmarControle: {
            required: true,
            notNull: true,
            boolean: true
        }
    };

    try {
        await validate(params, validation);
    } catch (error) {
        error.httpCode = 400;
        throw error;
    }
}