const service = require('./alunoPresencaService');

module.exports = {
    inserirPresenca
};

async function inserirPresenca(req, res) {
    try {
        const params = {
            idAluno: req.params.idAluno
        };

        const data = await service.inserirPresenca(params);

        return res.finish({
            content: data
        })
    } catch (error) {
        return res.finish({
            httpCode: error.httpCode || 500,
            error
        })
    }
}
