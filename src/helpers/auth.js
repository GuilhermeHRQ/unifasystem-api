'use strict';

module.exports = {
    generateToken,
    decodeToken,
    authorize,
    isAdmin
}

const jwt = require('jsonwebtoken');

/**
 * Gera um token com os dados passados no params, com base na SALT_KEY e com expiração de 1d
 * @param {Object} data Informações que serão colocadas no token 
 */
async function generateToken(data) {
    return jwt.sign(data, global.SALT_KEY, { expiresIn: '1d' });
}

/**
 * Decodifica o token para obter os dados que estavam encriptados
 * @param {String} token Token para decodificação
 */
async function decodeToken(token) {
    const data = await jwt.verify(token, global.SALT_KEY);
    return data;
}


/**
 * Middlewere que verifica nas requisições se existe um token e se ele é válido
 * @param {Object} req Dados da requisição 
 * @param {Object} res Dados da resposta 
 * @param {Function} next Prossegue para a próxima chamada 
 */
function authorize(req, res, next) {
    const token = req.body.token || req.query.token || req.headers['x-access-token'] || req.headers['authorization']; // Verifica o token nesses pontos

    if (!token) {
        res.status(401).json({
            message: 'Acesso Restrito'
        });
    } else {
        jwt.verify(token, global.SALT_KEY, (error, decoded) => {
            if (error) {
                res.status(401).json({
                    message: 'Token inválido'
                });
            } else {
                next(); // Caso possua um token e ele seja válido, prossegue para as próximas requisições
            }
        });
    }
}

// Verifica se o user é um admin para ter acesso a alguns métodos expecíficos
function isAdmin(req, res, next) {
    const token = req.body.token || req.query.token || req.headers['x-access-token'] || req.headers['authorization']; // Verifica o token nesses pontos

    if (!token) {
        res.status(401).json({
            message: 'Acesso Restrito'
        });
    } else {
        jwt.verify(token, global.SALT_KEY, (error, decoded) => {
            if (error) {
                res.status(401).json({
                    message: 'Token inválido'
                });
            } else {
                if (decoded.roles.includes('admin')) {
                    next();
                } else {
                    res.status(403).json({
                        message: 'Esta funcionalidade é restrita para administradores'
                    })
                }
            }
        });
    }
}