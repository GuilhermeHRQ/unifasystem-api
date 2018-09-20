const db = global.db;

module.exports = {
    selecionarCidade
};

async function selecionarCidade(params) {
    return db.func('Administracao.SelecionarCidade', [
        params.uf
    ])
}