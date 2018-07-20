const repository = require('./disciplinaRepository');

module.exports = {
    inserir,
    selecionar,
    selecionarPorId,
    atualizar
}

async function inserir(params) {
    const body = {
        cargaHoraria: params.cargaHoraria,
        nome: params.nome,
        descricao: params.descricao,
        usuarioCadastro: params.user.id
    };

    const data = await repository.inserir(body);

    if (!data) {
        return {
            executionCode: 1,
            message: 'Erro ao cadastrar disciplina'
        }
    }

    return {
        content: {
            id: data
        }
    }
}

async function selecionar(params) {
    params.filtro = params.filtro || '.';

    const data = await repository.selecionar(params);

    return {
        content: data || []
    }
}

async function selecionarPorId(params) {
    const data = await repository.selecionarPorId(params);

    if (!data) {
        return {
            executionCode: 1,
            message: 'Disciplina não encontrada'
        }
    }

    return {
        content: data
    }
}

async function atualizar(params) {
    const data = repository.selecionarPorId(params.id);

    if (!data) {
        return {
            executionCode: 1,
            message: 'Disciplina não encontrada'
        }
    }

    await repository.atualizar(params);

    return {
        content: {
            message: 'Disciplina alterada com sucesso!'
        }
    }
}

async function remover(params) {
    const data = repository.selecionarPorId(params.id);

    if (!data) {
        return {
            executionCode: 1,
            message: 'Disciplina não encontrada'
        }
    }

    await repository.remover(params);

    return {
        content: {
            message: 'Disciplina removida com sucesso!'
        }
    }
}