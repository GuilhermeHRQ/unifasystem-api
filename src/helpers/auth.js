'use strict';
const pass = 'qwur213iu4i32btwebve4wy';

module.exports = {
    generateToken,
    verify
};

const jwt = require('jsonwebtoken');

/**
 * Gera um token com os dados passados no params, com base na SALT_KEY e com expiração de 1d
 * @param {Object} data Informações que serão colocadas no token 
 */
async function generateToken(data) {
    return jwt.sign(data, pass, { expiresIn: '365d' });
}

function verify(fn) {
    return async (req, res, next) => {
        if (req.method === 'OPTIONS') {
            return res.finish({
                httpCode: 204
            });
        }

        const auth = req.headers.authentication || null;

        if (!auth) {
            return res.finish({
                httpCode: 401,
                message: 'Acesso restrito'
            });
        }

        jwt.verify(auth, global.SALT_KEY, async (error, data) => {
            if (error) {
                return res.finish({
                    httpCode: 401,
                    message: 'Sessão inválida'
                });
            }

            req.token = data;

            fn(req, res, next).catch(next);
        });
    };
}