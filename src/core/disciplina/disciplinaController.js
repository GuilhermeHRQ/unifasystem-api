const service = require('./disciplinaService');

module.exports = {
    selecionar
};

async function selecionar(req, res) {
    try {
        const params = {
            codigoProfessor: req.token.codigoProfessor,
            idTurma: req.query.idTurma || null
        };

        const data = await service.selecionar(params);

        return res.finish({
            content: data
        });
    } catch (error) {
        return res.finish({
            httpCode: error.httpCode || 400,
        })
    }
}