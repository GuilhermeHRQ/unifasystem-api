const service = require('./disciplinaService');

module.exports = {
    selecionarDisciplinaSimples
};

async function selecionarDisciplinaSimples(req, res) {
    try {
        const params = {
            codigoProfessor: req.token.codigoProfessor,
            idCurso: req.query.idCurso
        };

        const data = await service.selecionarDisciplinaSimples(params.codigoProfessor);

        return res.finish({
            content: data
        });
    } catch (error) {
        return res.finish({
            httpCode: error.httpCode || 500,
            error
        })
    }
}