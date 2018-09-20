const api = require('../../core/cidade/cidadeController');
const verify = global.verify;

module.exports = (app) => {
    app.route('/cidade').get(verify(api.selecionarCidade));
};