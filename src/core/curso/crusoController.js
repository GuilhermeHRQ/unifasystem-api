const service = require('./cursoService');

module.exports = {
    inserirCurso,
    selecionarCurso,
    selecionarCursoPorId,
    atualizarCuros,
    excluirCurso
};

async function inserirCurso(req, res) {
    try {
        const params = {
            idCoordenador: req.body.idCoodenador,
            nome: req.body.nome,
            descricao: req.body.descricao,
            valor: req.body.valor
        };

        const data = await service.inserirCurso(params);

        res.finish({
            content: data
        });

    } catch (error) {
        return res.finish({
            httpCode: error.httpCode || 500,
            error
        });
    }
}

async function selecionarCurso(req, res) {
    try {
        const params = {
            filtro: req.query.filtro,
            linhas: req.query.linhas,
            pagina: req.query.pagina
        };

        const data = await service.selecionarCurso(params);

        return res.finish({
            content: data,
            totalLinhas: data.totalLinhas
        });

    } catch (error) {
        return res.finish({
            httpCode: error.httpCode || 500,
            error
        });
    }
}

async function selecionarCursoPorId(req, res) {
    try {
        const params = {
            id: req.params.id
        };

        const data = await service.selecionarCursoPorId(params);

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

async function atualizarCuros(req, res) {
    try {
        const params = {
            id: req.params.id,
            idCoordenador: req.body.idCoordenador,
            nome: req.body.nome,
            descricao: req.body.descricao,
            valor: req.body.valor,
            ativo: req.body.ativo
        };

        const data = await service.atualizarCurso(params);

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

async function excluirCurso(req, res) {
    try {
        const params = {
            id: req.params.id
        };

        const data = await service.excluirCurso(params);

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