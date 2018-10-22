const verify = global.verify;
const api = require('../../core/status/statusController');

module.exports = (app) => {
    app.route('/selecionar-status-simples').get(verify(api.selecionarStatusSimples));
};