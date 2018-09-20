const repository = require('./professorRepository');

module.exports = {
    inserirProfessor,
    selecionarProfessor,
    selecionarProfessorSimples,
    selecionarProfessorPorId,
    atualizarProfessor,
    excluirProfessor
};

async function inserirProfessor(params) {
    const data = await repository.inserirProfessor(params);

    let error;

    switch (data.executionCode) {
        case 1:
        case 2:
        case 3:
            error = data;
            error.httpCode = 401;
    }

    if (error) {
        throw error;
    }

    return data;
}

async function selecionarProfessor(params) {
    const data = await repository.selecionarProfessor(params);

    data.totalLinhas = data.length ? data[0].totalLinhas : 0;

    data.forEach(item => {
        delete item.totalLinhas;
    });

    return data;
}

async function selecionarProfessorSimples() {
    return await repository.selecionarProfessorSimples();
}

async function selecionarProfessorPorId(params) {
    let data = await repository.selecionarProfessorPorId(params);

    if (!data.length) {
        throw {
            executionCode: 1,
            httpCode: 404,
            message: 'Professor não encontrado'
        }
    }

    data = data[0];

    return data;
}

async function atualizarProfessor(params) {
    const data = await repository.atualizarProfessor(params);

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

async function excluirProfessor(params) {
    const data = await repository.excluirProfessor(params);

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