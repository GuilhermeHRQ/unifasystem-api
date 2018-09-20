const repository = require('./cursoRepository');

module.exports = {
    inserirCurso,
    selecionarCurso,
    selecionarCursoPorId,
    atualizarCurso,
    excluirCurso
};

async function inserirCurso(params) {
    return await repository.inserirCurso(params);
}

async function selecionarCurso(params) {
    let data = await repository.selecionarCurso(params);

    data.totalLinhas = data.length ? data[0].totalLinhas : 0;

    data.forEach(item => {
        delete item.totalLinhas
    });
    return data;
}

async function selecionarCursoPorId(params) {
    let data = await repository.selecionarCursoPorId(params);

    if (!data.length) {
        throw {
            executionCode: 1,
            message: 'Curso não encontrado'
        }
    }

    data = data[0];

    return data;
}

async function atualizarCurso(params) {
    const data = await repository.atualizarCurso(params);

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

async function excluirCurso(params) {
    const data = await repository.excluirCurso(params);

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






