const repository = require('./disciplinaRepository');
const auth = require('../../helpers/auth');

module.exports = {
    inserir,
    selecionar
}

async function inserir(params) {
    const user = await auth.decodeToken(params.token);

    if (!user) {
        return {
            executionCode: 1,
            message: 'Sessão inválida, usuário logado não encontrado'
        }
    }

    const body = {
        cargaHoraria: params.cargaHoraria,
        nome: params.nome,
        descricao: params.descricao,
        usuarioCadastro: user.id
    };

    const data = await repository.inserir(body);

    if (!data) {
        return {
            executionCode: 2,
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
}