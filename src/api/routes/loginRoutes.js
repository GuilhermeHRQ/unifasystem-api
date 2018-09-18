const verify = global.verify;

module.exports = (app) => {
    const api = require('../../core/login/loginController');

    app.route('/login/dados').post(api.preLogin);
    app.route('/login').post(api.login);
    app.route('/login/refazer').get(verify(api.refazLogin));
};