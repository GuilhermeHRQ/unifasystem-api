const db = global.db;

module.exports = {
    inserirProfessor,
    selecionarProfessor,
    selecionarProfessorPorId,
    atualizarProfessor,
    excluirProfessor
};

async function inserirProfessor(params) {
    return db.json('Administracao.InserirProfessor', [
        params.cpf,
        params.nome,
        params.sobrenome,
        params.dataNascimento,
        params.salario,
        params.email,
        params.telefone,
        params.logon,
        params.senha,
        params.endereco
    ]);
}

async function selecionarProfessor(params) {
    return db.func('Administracao.SelecionarProfessor', [
        params.filtro,
        params.linhas,
        params.pagina
    ]);
}

async function selecionarProfessorPorId(params) {
    return db.func('Administracao.SelecionarProfessorPorId', [
        params.id
    ]);
}

async function atualizarProfessor(params) {
    return db.json('Administracao.AtualizarProfessor', [
        params.id,
        params.cpf,
        params.nome,
        params.sobrenome,
        params.dataNascimento,
        params.salario,
        params.email,
        params.telefone,
        params.logon,
        params.ativo,
        params.endereco
    ]);
}

async function excluirProfessor(params) {
    return db.json('Administracao.ExcluirProfessor', [
        params.id
    ]);
}