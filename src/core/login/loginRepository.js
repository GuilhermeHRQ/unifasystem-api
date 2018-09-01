const db = global.db;

module.exports = {
    preLogin,
    login,
    refazLogin
};

async function preLogin(params) {
    let data = await db.func('Seguranca.LoginUsuario', [
        params.login,
        params.senha
    ]);

    data = data[0];

    if (!data) {
        return {
            executionCode: 1,
            message: 'Usuário não encontrado'
        }
    } else if (!data.ativo) {
        return {
            executionCode: 2,
            message: 'Usuário bloqueado'
        }
    }

    return data;
}

async function login(params) {
    let data = await db.func('Seguranca.LoginUsuario', [
        params.login,
        params.senha
    ]);

    data = data[0];

    if (!data) {
        return {
            executionCode: 1,
            message: 'Usuário não encontrado'
        }
    } else if (!data.senhaCorreta) {
        return {
            executionCode: 2,
            message: 'Senha incorreta!'
        }
    } else if (!data.ativo) {
        return {
            executionCode: 3,
            message: 'Usuário bloqueado'
        }
    }

    return data;
}

async function refazLogin(params) {
    let data = await db.func('Seguranca.RefazLogin', [
        params.id
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