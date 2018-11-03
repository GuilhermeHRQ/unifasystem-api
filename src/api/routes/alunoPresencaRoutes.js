const api = require('../../core/alunoPresenca/alunoPresencaController');
const verify = global.verify;

module.exports = (app) => {
    app.route('/aluno-presenca/:idAluno').post(verify(api.inserirPresenca));
};