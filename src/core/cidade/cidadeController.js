const service = require('./cidadeService');

module.exports = {
    selecionarCidade
};

async function selecionarCidade(req, res) {
    try {
        const params = {
            uf: req.query.uf.length ? req.query.uf : null
        };

        const data = await service.selecionarCidade(params);

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