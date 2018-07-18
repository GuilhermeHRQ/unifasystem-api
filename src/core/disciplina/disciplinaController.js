const scope = require('./disciplinaScope');
const service = require('./disciplinaService');

module.exports = {
    inserir
}

async function inserir(req, res) {
    const params = {
        cargaHoraria: req.body.cargaHoraria,
        nome: req.body.nome,
        descricao: req.body.descricao,
        token: req.headers.authorization
    }

    try {
        await scope.inserir(params);

        const data = await service.inserir(params);

        let httpCode = 200;
        let error;
        let content;

        switch (data.executionCode) {
            case 1:
                httpCode = 401;
                error = data;
                break;
            case 2:
                httpCode = 400;
                error = data;
                break;
            default:
                content = data.content;
        }

        return res.finish({
            httpCode: 200,
            error: error,
            content: data
        });
    } catch (error) {
        res.finish({
            httpCode: error.httpCode || 500,
            error
        });
    }
}