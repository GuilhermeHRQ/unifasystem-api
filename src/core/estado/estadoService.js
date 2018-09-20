const repository = require('./estadoRepository');

module.exports = {
    selecionarEstado
};

async function selecionarEstado() {
    return await repository.selecionarEstado();
}