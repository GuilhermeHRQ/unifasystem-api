const db = global.db;

module.exports = {
    preLogin,
    login,
    refazLogin
};

async function preLogin(params) {
    const data = await db.func('Seguranca.Login', [
        params.login,
        params.senha
    ]);

    if(!data.content.id) {
        return {
            executionCode: 1,
            message: 'Usuário não encontrado'
        }
    }

    return data;
}

async function login(params) {
    let data = await db.func('Seguranca.Login', [
        params.login,
        params.senha
    ]);

    if(!data.content.id) {
        return {
            executionCode: 1,
            message: 'Usuário não encontrado'
        }
    } else if (!data.senhaCorreta) {
        return {
            executionCode: 2,
            message: 'Senha incorreta!'
        }
    }

    return data;
}

async function refazLogin(params) {
    return await db.func('Seguranca.RefazLogin', [
        params.id
    ]);
}