const routes = {
    administracao: {
        disciplina: {
            inserir: {
                method: 'POST',
                url: `${global.config.host}:${global.config.port}/disciplina`
            },
            selecionar: {
                method: 'GET',
                url: `${global.config.host}:${global.config.port}/disciplina`
            }
        }
    }
}

module.exports = routes;
