const repository = require('./controlePresencaRepository');

module.exports = {
    inserir,
    selecionar,
    selecionarPorId,
    atualizar,
    cancelarControlePresenca
};

async function inserir(params) {
    const chamadaAberta = await repository.verificaChamadasProfessor(params);

    if(chamadaAberta) {
        throw {
            message: 'Você possui uma chamada em aberto que deve ser fechada para poder adicionar outra',
            httpCode: 401
        }
    }

    return await repository.inserir(params);
}

async function selecionar(params) {
    return await repository.selecionar(params);
}

async function selecionarPorId(params) {
    const data = await repository.selecionarPorId(params);

    let error;

    switch (data.executionCode) {
        case 1:
            error = data;
            error.httpCode = 404;
            throw error;
    }

    return data;
}

async function atualizar(params) {
    const data = await repository.atualizar(params);

    let error;
    switch (data.executionCode) {
        case 1:
            error = data;
            error.httpCode = 404;
            break;
        case 2:
            error = data;
            error.httpCode = 400;
            break
    }

    if(error) {
        throw error;
    }

    return data;
}

async function cancelarControlePresenca(params) {
    const data = repository.cancelarControlePresenca(params);

    let error;
    switch (data) {
        case 1:
            error = data;
            error.httpCode = 404;
    }

    if(error) {
        throw error;
    }

    return data;
}

