const repository = require('./cidadeRepository');

module.exports = {
    selecionarCidade
};

async function selecionarCidade(params) {
    return await repository.selecionarCidade(params);
}