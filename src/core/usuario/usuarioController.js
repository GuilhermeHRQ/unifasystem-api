const
    scope = require('./usuarioScope'),
    service = require('./usuarioService');

module.exports = {
    inserir,
    selecionar,
    selecionarPorId,
    atualizar,
    remover
}

async function inserir(req, res) {
    const params = {
        nome: req.body.nome,
        email: req.body.email,
        senha: req.body.senha
    };

    try {
        await scope.inserir(params);

        const data = await service.inserir(params);

        let httpCode = 200;
        let error;
        let content = data.content;

        return res.finish({
            httpCode: httpCode,
            error: error,
            content: content
        });
    } catch (error) {
        switch (error.code) {
            case 11000:
                error.httpCode = 400;
                error.message = 'Email já cadastrado';
                break;
            default:
                httpCode = 500
        }

        return res.finish({
            httpCode: error.httpCode,
            error
        });
    }
}

async function selecionar(req, res) {
    try {
        const data = await service.selecionar();

        return res.finish({
            httpCode: 200,
            content: data.content || []
        });
    } catch (error) {
        return res.finish({
            httpCode: error.httpCode || 500,
            error
        });
    }
}


async function selecionarPorId(req, res) {
    const params = {
        id: req.params.id
    };

    try {
        await scope.selecionarPorId(params);

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

async function atualizar(req, res) {
    const params = {
        id: req.params.id,
        nome: req.body.nome,
        email: req.body.email
    }

    try {
        await scope.atualizar(params);

        await service.atualizar(params);

        return res.finish({
            httpCode: 200,
            content: 'Atualizado com sucesso'
        });
    } catch (error) {
        switch (error.code) {
            case 11000:
                error.httpCode = 400;
                error.message = 'Email já cadastrado';
                break;
            default:
                httpCode = 500
        }

        return res.finish({
            httpCode: error.httpCode,
            error
        });
    }
}

async function remover(req, res) {
    const params = {
        id: req.params.id
    }

    try {
        await scope.remover(params);

        const data = await service.remover(params);

        return res.finish({
            httpCode: 200,
            content: 'Removido com sucesso'
        });
    } catch (error) {
        if (error.name === 'CastError') {
            error.httpCode = 404;
            error.message = 'Usuário não encontrado';
        }

        return res.finish({
            httpCode: error.httpCode || 500,
            error
        });
    }
}