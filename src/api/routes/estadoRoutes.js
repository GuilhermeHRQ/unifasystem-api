const api = require('../../core/estado/estadoController');
const verify = global.verify;

module.exports = (app) => {
    app.route('/estado').get(verify(api.selecionarEstado));
};