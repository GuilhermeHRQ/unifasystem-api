const db = global.db;

module.exports = {
    inserirDisciplina,
    selecionarDisciplina,
    selecionarDisciplinaPorId,
    atualizarDisciplina,
    excluirDisciplina
};

async function inserirDisciplina(params) {
    return db.json('Administracao.InserirDisciplina', [
        params.nome,
        params.cargaHoraria,
        params.descricao
    ])
}

async function selecionarDisciplina(params) {
    return db.func('Administracao.SelecionarDisciplina', [
        params.filtro,
        params.linhas,
        params.pagina
    ]);
}

async function selecionarDisciplinaPorId(params) {
    return db.func('Administracao.SelecionarDisciplinaPorId', [
        params.id
    ]);
}

async function atualizarDisciplina(params) {
    return db.json('Administracao.AtualizarDisciplina', [
        params.id,
        params.nome,
        params.cargaHoraria,
        params.descricao,
        params.ativo
    ]);
}

async function excluirDisciplina(params) {
    return db.json('Administracao.ExcluirDisciplina', [
        params.id
    ]);
}