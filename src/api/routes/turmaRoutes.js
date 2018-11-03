const api = require('../../core/turma/turmaController');
const verify = global.verify;

module.exports = (app) => {
    app.route('/turma').get(verify(api.selecionar));
};