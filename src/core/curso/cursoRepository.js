const db = global.db;

module.exports = {
    inserirCurso,
    selecionarCurso,
    selecionarCursoPorId,
    atualizarCurso,
    excluirCurso
};

async function inserirCurso(params) {
    return db.json('Administracao.InserirCurso', [
        params.idCoordenador,
        params.nome,
        params.descricao,
        params.valor
    ]);
}

async function selecionarCurso(params) {
    return db.func('Administracao.SelecionarCurso', [
        params.filtro,
        params.linhas,
        params.pagina
    ]);
}

async function selecionarCursoPorId(params) {
    return db.func('Administracao.SelecionarCursoPorId', [
        params.id
    ]);
}

async function atualizarCurso(params) {
    return db.json('Administracao.AtualizarCurso', [
        params.id,
        params.idCoordenador,
        params.nome,
        params.descricao,
        params.valor,
        params.ativo
    ]);
}

async function excluirCurso(params) {
    return db.json('Administracao.ExcluirCurso', [
        params.id
    ]);
}