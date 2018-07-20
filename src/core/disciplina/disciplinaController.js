const scope = require('./disciplinaScope');
const service = require('./disciplinaService');

module.exports = {
    inserir,
    selecionar,
    selecionarPorId,
    atualizar,
    remover
}

async function inserir(req, res) {
    try {
        const params = {
            cargaHoraria: req.body.cargaHoraria,
            nome: req.body.nome,
            descricao: req.body.descricao,
            user: req.token
        }

        await scope.inserir(params);

        const data = await service.inserir(params);

        let httpCode = 200;
        let error;
        let content;

        switch (data.executionCode) {
            case 1:
                httpCode = 400;
                error = data;
                break;
            default:
                content = data.content;
        }

        return res.finish({
            httpCode: httpCode,
            error: error,
            content: content
        });

    } catch (error) {
        res.finish({
            httpCode: error.httpCode || 500,
            error
        });
    }
}

async function selecionar(req, res) {
    try {
        const params = {
            filtro: req.query.filtro || null,
            pagina: req.query.pagina || 1,
            linhas: req.query.linhas || 10
        }

        await scope.selecionar(params);

        const data = await service.selecionar(params);

        const totalLinhas = data && data.content ? data.content.length : 0;

        return res.finish({
            httpCode: 200,
            content: data.content,
            totalLinhas: totalLinhas
        });

    } catch (error) {
        return res.finish({
            httpCode: error.httpCode || 500,
            error
        });
    }
}

async function selecionarPorId(req, res) {
    try {
        const params = {
            id: req.params.id
        }

        const data = await service.selecionarPorId(params);

        let httpCode = 200;
        let error;
        let content;

        switch (data.executionCode) {
            case 1:
                httpCode = 404;
                error = data;
                break;
            default:
                content = data.content;
        };

        return res.finish({
            httpCode: httpCode,
            error: error,
            content: content
        });

    } catch (error) {
        return res.finish({
            httpCode: error.httpCode || 500,
            error
        });
    }
}

async function atualizar(req, res) {
    try {
        const params = {
            id: req.params.id,
            user: req.token,
            cargaHoraria: req.body.cargaHoraria,
            nome: req.body.nome,
            descricao: req.body.descricao
        }

        await scope.atualizar(params);

        const data = service.atualizar(params);

        let httpCode = 200;
        let error;
        let content;

        switch (data.executionCode) {
            case 1:
                httpCode = 404;
                error = data;
                break;
            default:
                content = data.content;
        }

        return res.finish({
            httpCode: httpCode,
            error: error,
            content: content
        });

    } catch (error) {
        return res.finish({
            httpCode: error.httpCode || 500,
            error
        });
    }
}


async function remover(req, res) {
    try {
        const params = {
            id: req.params.id
        }

        const data = await service.remover(params);

        let httpCode = 200;
        let error;
        let content;

        switch (data.executionCode) {
            case 1:
                httpCode = 404;
                error = data;
                break;
            default:
                content = data.content;
        }

        return res.finish({
            httpCode: httpCode,
            error: error,
            content: content
        });

    } catch (error) {
        return res.finish({
            httpCode: error.httpCode || 500,
            error
        });
    }
}