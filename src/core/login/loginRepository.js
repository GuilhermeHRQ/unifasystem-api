const db = global.db;

module.exports = {
    preLogin
};

async function preLogin(params) {
    let data = db.func('Seguranca.LoginUsuario', [
        parmas.login,
        params.senha
    ]);

    data = data[0];

    if(!data) {
        return {
            executionCode: 1,
            message: 'Usuário não encontrado'
        }
    } else if(!data.ativo) {
        return {
            executionCode: 2,
            message: 'Usuário bloqueado'
        }
    }

    return data;
}