const service = require('./professorService');

module.exports = {
    inserirProfessor,
    selecionarProfessor,
    selecionarProfessorSimples,
    selecionarProfessorPorId,
    atualizarProfessor,
    excluirProfessor
};


async function inserirProfessor(req, res) {
    try {
        const params = {
            cpf: req.body.cpf,
            nome: req.body.nome,
            sobrenome: req.body.sobrenome,
            dataNascimento: req.body.dataNascimento,
            salario: req.body.salario,
            email: req.body.email,
            telefone: req.body.telefone,
            logon: req.body.logon,
            senha: req.body.senha,
            endereco: req.body.endereco ? JSON.stringify(req.body.endereco) : null
        };

        const data = await service.inserirProfessor(params);

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

async function selecionarProfessor(req, res) {
    try {
        const params = {
            filtro: req.query.filtro,
            linhas: req.query.linhas || 10,
            pagina: req.query.pagina || 1
        };

        const data = await service.selecionarProfessor(params);
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

async function selecionarProfessorSimples(req, res) {
    try {
        const data = await service.selecionarProfessorSimples();

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

async function selecionarProfessorPorId(req, res) {
    try {
        const params = {
            id: req.params.id
        };

        const data = await service.selecionarProfessorPorId(params);

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

async function atualizarProfessor(req, res) {
    try {
        const params = {
            id: req.params.id,
            cpf: req.body.cpf,
            nome: req.body.nome,
            sobrenome: req.body.sobrenome,
            dataNascimento: req.body.dataNascimento,
            salario: req.body.salario,
            email: req.body.email,
            telefone: req.body.telefone,
            logon: req.body.logon,
            ativo: req.body.ativo,
            endereco: req.body.endereco ? JSON.stringify(req.body.endereco) : null
        };

        const data = await service.atualizarProfessor(params);

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

async function excluirProfessor(req, res) {
    try {
        const params = {
            id: req.params.id
        };

        const data = await service.excluirProfessor(params);

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