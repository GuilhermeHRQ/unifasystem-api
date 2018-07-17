const repository = require('./usuarioRepository');
const md5 = require('md5');

module.exports = {
    inserir,
    selecionar,
    selecionarPorId,
    atualizar,
    remover
}

async function inserir(params) {
    const data = await repository.inserir(params);

    if (!data) {
        return {
            executionCode: 1,
            message: 'Email já cadastrado'
        }
    }

    return {
        executionCode: 0,
        content: data
    }
}

async function selecionar() {
    const data = await repository.selecionar();

    return {
        executionCode: 0,
        content: data
    }
}

async function selecionarPorId(params) {
    const data = await repository.selecionarPorId(params);

    if (!data) {
        return {
            executionCode: 1,
            message: 'Usuário não encontrado'
        }
    }

    return {
        executionCode: 0,
        content: data
    }
}

async function atualizar(params) {
    await repository.atualizar(params);
}

async function remover(params) {
    const data = await repository.remover(params);

    return {
        executionCode: 0,
        content: data
    }
}
