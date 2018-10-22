const db = global.db;

module.exports = {
    selecionarStatusSimples
};

async function selecionarStatusSimples() {
    return db.json('Administracao.SelecionarStatusSimples',[]);
}