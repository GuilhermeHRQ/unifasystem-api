const routes = {
    administracao: {
        disciplina: {
            inserir: {
                method: 'POST',
                url: `${global.config.host}:${global.config.port}/disciplina/inserir`
            },
            selecionar: {
                method: 'GET',
                url: `${global.config.host}:${global.config.port}/disciplina/selecionar`
            }
        }
    }
}

module.exports = routes;
