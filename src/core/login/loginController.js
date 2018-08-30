const scope = require('./loginScope');
const service = require('./loginService');

module.exports = {
    preLogin
};

async function preLogin(req, res) {
    try {
        const params = {
            login: req.body.login,
            senha: null
        };

        await scope.preLogin(params);

        const data = await service.preLogin(params);

        return res.finish({
            content: {
                user: data
            }
        })
    } catch (error) {
        return res.finish({
            httpCode: error.httpCode || 500,
            error
        });
    }
}