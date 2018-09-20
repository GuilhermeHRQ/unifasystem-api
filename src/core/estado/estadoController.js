const service = require('./estadoService');

module.exports = {
    selecionarEstado
};

async function selecionarEstado(req, res) {
    try {
        const data = await service.selecionarEstado();

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