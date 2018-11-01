const db = global.db;

module.exports = {
    inserir,
    selecionar,
    selecionarPorId,
    atualizar,
    cancelarControlePresenca,
    fecharControlesPresenca,
    verificarChamadaTurma
};

async function inserir(params) {
    return db.json('Administracao.InserirControlePresenca', [
        params.semestre,
        params.idDisciplina,
        params.idTurma,
        params.idProfessor,
        params.nomeTurma,
        params.nomeDisciplina,
        params.horaAbertura,
        params.horaFechamento,
        params.quantidadePresencas,
        params.conteudo
    ]);
}

async function selecionar(params) {
    return db.json('Administracao.SelecionarControlePresenca', [
        params.idProfessor,
        params.semestre,
        params.idDisciplina,
        params.idTurma,
        params.dataInicial,
        params.dataFinal,
        params.idStatus,
        params.linhas,
        params.pagina
    ]);
}

async function selecionarPorId(params) {
    return db.json('Administracao.SelecionarControlePresencaPorId', [
        params.id
    ]);
}

async function atualizar(params) {
    return db.json('Administracao.AtualizarControlePresenca', [
        params.id,
        params.conteudo,
        params.alunos,
        params.confirmarControle
    ]);
}

async function cancelarControlePresenca(params) {
    return db.json('Administracao.CancelarControlePresenca', [
        params.id
    ]);
}

async function fecharControlesPresenca() {
    return db.json('Administracao.FecharControlesPresenca', []);
}

async function verificarChamadaTurma(params) {
    return db.json('Administracao.VerificarChamadaTurma', [
        params.idTurma
    ]);
}