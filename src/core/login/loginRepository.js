const db = global.db;

console.log(db);

module.exports = {
    preLogin
};

async function preLogin(params) {
    let data = await db.func('seguranca.LoginUsuario', [
        params.login,
        params.senha
    ]);

    console.log(data);

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