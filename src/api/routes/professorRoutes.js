const api = require('../../core/professor/professorController');
const verify = require('../../helpers/auth').verify;

module.exports = (app) => {
    app.route('/professor').get(verify(api.inserirProfessor))
};