const service = require('./turmaService');

module.exports = {
    selecionar
};

async function selecionar(req, res) {
    try {
        const params = {
            codigoProfessor: req.token.codigoProfessor
        };

        const data = await service.selecionar(params);

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