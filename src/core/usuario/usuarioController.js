const
    scope = require('./usuarioScope'),
    service = require('./usuarioService');

module.exports = {
    inserir
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
