const api = require('../../core/controlePresenca/controlePresencaController');
const verify = global.verify;

module.exports = (app) => {
    app.route('/controle-presenca')
        .post(verify(api.inserir))
        .get(verify(api.selecionar));

    app.route('/controle-presenca/:id')
        .get(verify(api.selecionarPorId))
        .put(verify(api.atualizar));

    app.route('/controle-presenca/:id/cancelar')
        .put(verify(api.cancelarControlePresenca));
};