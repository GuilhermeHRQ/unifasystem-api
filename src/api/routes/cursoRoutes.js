const api = require('../../core/curso/crusoController');
const verify = global.verify;

module.exports = (app) => {
    app.route('/curso')
        .post(verify(api.inserirCurso))
        .get(verify(api.selecionarCurso));

    app.route('/curso/:id')
        .get(verify(api.selecionarCursoPorId))
        .put(verify(api.atualizarCuros))
        .delete(verify(api.excluirCurso))
};