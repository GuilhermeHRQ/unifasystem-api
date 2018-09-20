const api = require('../../core/professor/professorController');
const verify = global.verify;

module.exports = (app) => {
    app.route('/professor')
        .post(verify(api.inserirProfessor))
        .get(verify(api.selecionarProfessor));

    app.route('/professor-simples').get(verify(api.selecionarProfessorSimples));

    app.route('/professor/:id')
        .get(verify(api.selecionarProfessorPorId))
        .put(verify(api.atualizarProfessor))
        .delete(verify(api.excluirProfessor));
};