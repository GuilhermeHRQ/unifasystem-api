const api = require('../../core/disciplina/disciplinaController');
const verify = global.verify;

module.exports = (app) => {
    app.route('/disciplina')
        .post(verify(api.inserirDisciplina))
        .get(verify(api.selecionarDisciplina));

    app.route('/disciplina/:id')
        .get(verify(api.selecionarDisciplinaPorId))
        .put(verify(api.atualizarDisciplina))
        .delete(verify(api.excluirDisciplina));
};