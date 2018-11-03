const db = global.db;

module.exports = {
    inserirPresenca
};

async function inserirPresenca(params) {
    return db.json('Administracao.InserirPresencaAluno', [
        params.idTurma,
        params.idAluno,
        params.nome
    ]);
}