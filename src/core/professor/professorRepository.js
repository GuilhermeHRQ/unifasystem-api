const db = global.db;

module.exports = {
    inserirProfessor
};

async function inserirProfessor(params) {
    return await db.json('Administracao.InserirProfessor', [
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