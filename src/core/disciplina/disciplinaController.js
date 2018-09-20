const service = require('./disciplinaService');

module.exports = {
    inserirDisciplina,
    selecionarDisciplina,
    selecionarDisciplinaPorId,
    atualizarDisciplina,
    excluirDisciplina
};

async function inserirDisciplina(req, res) {
    try {
        const params = {
            nome: req.body.nome,
            cargaHoraria: req.body.cargaHoraria,
            descricao: req.body.descricao
        };

        const data = await service.inserirDisciplina(params);

        return res.finish({
            content: data
        });

    } catch (error) {
        return res.finish({
            httpCode: error.httpCode || 500,
            error
        });
    }
}

async function selecionarDisciplina(req, res) {
    try {
        const params = {
            filtro: req.query.filtro || null,
            linhas: req.query.linhas || 10,
            pagina: req.query.pagina || 1
        };

        const data = await service.selecionarDisciplina(params);

        return res.finish({
            totalLinhas: data.totalLinhas,
            content: data
        });

    } catch (error) {
        return res.finish({
            httpCode: error.httpCode || 500,
            error
        });
    }
}

async function selecionarDisciplinaPorId(req, res) {
    try {
        const params = {
            id: req.params.id
        };

        const data = await service.selecionarDisciplinaPorId(params);

        return res.finish({
            content: data
        });

    } catch (error) {
        return res.finish({
            httpCode: error.httpCode || 500,
            error
        });
    }
}

async function atualizarDisciplina(req, res) {
    try {
        const params = {
            id: req.params.id,
            nome: req.body.nome,
            cargaHoraria: req.body.cargaHoraria,
            descricao: req.body.descricao,
            ativo: req.body.ativo
        };

        const data = await service.atualizarDisciplina(params);

        return res.finish({
            content: data
        });

    } catch (error) {
        return res.finish({
            httpCode: error.httpCode || 500,
            error
        });
    }
}

async function excluirDisciplina(req, res) {
    try {
        const params = {
            id: req.params.id,
        };

        const data = await service.excluirDisciplina(params);

        return res.finish({
            content: data
        });

    } catch (error) {
        return res.finish({
            httpCode: error.httpCode || 500,
            error
        });
    }
}