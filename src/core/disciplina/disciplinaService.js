const repository = require('./disciplinaRepository');

module.exports = {
    inserirDisciplina,
    selecionarDisciplina,
    selecionarDisciplinaPorId,
    atualizarDisciplina,
    excluirDisciplina
};

async function inserirDisciplina(params) {
    return await repository.inserirDisciplina(params);
}

async function selecionarDisciplina(params) {
    const data = await repository.selecionarDisciplina(params);

    data.totalLinhas = data.length ? data[0].totalLinhas : 0;

    data.forEach(item => {
        delete item.totalLinhas;
    });

    return data;
}

async function selecionarDisciplinaPorId(params) {
    let data = await repository.selecionarDisciplinaPorId(params);

    if(!data.length) {
        throw {
            executionCode: 1,
            message: 'Disciplina não encontrada'
        }
    }

    data = data[0];

    return data;
}

async function atualizarDisciplina(params) {
    const data = await repository.atualizarDisciplina(params);

    let error;

    switch (data.executionCode) {
        case 1:
            error = data;
            error.httpCode = 404;
    }

    if (error) {
        throw error;
    }

    return data;
}

async function excluirDisciplina(params) {
    const data = await repository.excluirDisciplina(params);

    let error;

    switch (data.executionCode) {
        case 1:
            error = data;
            error.httpCode = 404;
    }

    if (error) {
        throw error;
    }

    return data;
}