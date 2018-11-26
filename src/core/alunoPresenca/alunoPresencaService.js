const repository = require('./alunoPresencaRepository');
const request = require('request-promise');
const apiFacef = global.apiFacef;

module.exports = {
    inserirPresenca
};

async function inserirPresenca(params) {
    try {
        let dataAluno = await request({
            url: `${apiFacef.dadosAluno}${params.idAluno}`,
            method: 'GET',
            json: true
        });

        if(!dataAluno.length) {
            throw {
                message: 'Código de aluno incorreto ou inválido',
                httpCode: 404
            };
        }

        dataAluno = dataAluno[0];

        params = {
            idTurma: dataAluno.id_serie,
            idAluno: dataAluno.id_aluno,
            nome: dataAluno.sobrenome_aluno
        };

        const data = await repository.inserirPresenca(params);

        return data;
    } catch(error) {
        throw error;
    }
}