module.exports = {
    adminisracao: {},
    seguranca: {
        login: {
            refazer: {
                method: 'GET',
                url: `${global.config.host}:${global.config.port}/login/refazer`
            }
        }
    }
};