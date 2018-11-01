const service = require('./controlePresencaService');
const scope = require('./controlePresencaScope');

module.exports = {
    inserir,
    selecionar,
    selecionarPorId,
    atualizar,
    cancelarControlePresenca
};

async function inserir(req, res) {
    try {
        const params = {
            semestre: req.body.semestre,
            idProfessor: req.token.idUsuario,
            nomeTurma: req.body.nomeTurma,
            idDisciplina: req.body.idDisciplina,
            idTurma: req.body.idTurma,
            nomeDisciplina: req.body.nomeDisciplina,
            horaAbertura: req.body.horaAbertura,
            horaFechamento: req.body.horaFechamento,
            quantidadePresencas: req.body.quantidadePresencas,
            conteudo: req.body.conteudo
        };

        await scope.inserir(params);

        const data = await service.inserir(params);

        return res.finish(data);
    } catch (error) {
        return res.finish({
            httpCode: error.httpCode || 500,
            error
        });
    }
}

async function selecionar(req, res) {
    try {
        const params = {
            idProfessor: req.token.idUsuario,
            semestre: req.query.semestre || null,
            idDisciplina: req.query.idDisciplina || null,
            idTurma: req.query.idTurma || null,
            dataInicial: req.query.dataInicial || null,
            dataFinal: req.query.dataFinal || null,
            idStatus: req.query.idStatus || null,
            linhas: req.query.linhas || 10,
            pagina: req.query.pagina || 1
        };

        const data = await service.selecionar(params);

        return res.finish(data);
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
        };

        const data = await service.selecionarPorId(params);

        return res.finish(data);
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
            conteudo: req.body.conteudo || null,
            alunos: JSON.stringify(req.body.alunos),
            confirmarControle: req.body.confirmarControle || false
        };

        await scope.atualizar(params);

        const data = await service.atualizar(params);

        return res.finish(data);
    } catch (error) {
        return res.finish({
            httpCode: error.httpCode || 500,
            error
        });
    }
}

async function cancelarControlePresenca(req, res) {
    try {
        const params = {
            id: req.params.id
        };

        const data = await service.cancelarControlePresenca(params);

        return res.finish(data);
    } catch (error) {
        return res.finish({
            httpCode: error.httpCode || 500,
            error
        });
    }
}