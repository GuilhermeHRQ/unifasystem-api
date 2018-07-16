const repository = require('./usuarioRepository');
const md5 = require('md5');

module.exports = {
    inserir
}

async function inserir(params) {
    const data = await repository.inserir(params);

    if (!data) {
        return {
            executionCode: 1,
            message: 'Email já cadastrado'
        }
    }

    return {
        executionCode: 0,
        content: data
    }
}