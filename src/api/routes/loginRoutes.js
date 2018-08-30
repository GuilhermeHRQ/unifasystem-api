const api = require('../../core/login/loginController');

module.exports = (app) => {
    app.route('/login/dados').post(api.preLogin);
};