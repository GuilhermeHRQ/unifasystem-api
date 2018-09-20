const db = global.db;

module.exports = {
     selecionarEstado
};

async function  selecionarEstado() {
    return db.func('Administracao.SelecionarEstados', []);
}