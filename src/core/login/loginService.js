const repository = require('./loginRepository');
const md5 = require('md5');
const auth = require('../../helpers/auth');
const routes = require('../../api/routes/routes');

module.exports = {
    getDadosUsuario,
    logar,
    refazLogin
}

async function getDadosUsuario(params) {
    const data = await repository.autenticarPorEmail(params);

    if (!data) {
        return {
            executionCode: 1,
            message: 'Usuário não encontrado'
        }
    }

    return {
        content: {
            user: data
        }
    }
}

async function logar(params) {
    const data = await repository.autenticarPorEmail(params);
    const senhaCorreta = data.senha === md5(params.senha, global.SALT_KEY);

    if (!data) {
        return {
            executionCode: 1,
            message: 'Usuário não encontrado'
        }
    } else if (!senhaCorreta) {
        return {
            executionCode: 2,
            message: 'Senha incorreta'
        }
    }

    const menu = await repository.getMenu();

    const token = await auth.generateToken({
        id: data._id,
        email: data.email,
        nome: data.nome
    });


    return {
        content: {
            user: data,
            opcoes: menu,
            token: token,
            api: routes || {}
        }
    }
}

async function refazLogin(params) {
    const user = await auth.decodeToken(params.token);
    const data = await repository.autenticarPorId(user.id);

    if (!data) {
        return {
            executionCode: 1,
            message: 'Usuário não encontrado'
        }
    }

    const menu = await repository.getMenu();
    const token = await auth.generateToken({
        id: data._id,
        email: data.email,
        nome: data.nome
    });

    return {
        content: {
            user: data,
            opcoes: menu,
            token: token,
            api: routes || {}
        }
    }
}