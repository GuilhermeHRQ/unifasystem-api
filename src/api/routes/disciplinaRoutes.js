const api = require('../../core/disciplina/disciplinaController');
const verify = global.verify;

module.exports = (app) => {
    app.route('/disciplina').get(verify(api.selecionar));
};