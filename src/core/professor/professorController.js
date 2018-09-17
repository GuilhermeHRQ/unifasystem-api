const service = require('./professorService');
const scope = require('./professorScope');

module.exports = {
    inserirProfessor
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


        const data = service.inserirProfessor(params);

        return res.finish({
            content: data
        })
    } catch (error) {
        return res.finish({
            httpCode: error.httpCode || 500,
            error
        });
    }
}