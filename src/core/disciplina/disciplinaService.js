const repository = require('./disciplinaRepository');
const auth = require('../../helpers/auth');

module.exports = {
    inserir
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