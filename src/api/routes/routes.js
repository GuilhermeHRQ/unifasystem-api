module.exports = {
    administracao: {
        professor: {
            inserir: {
                method: 'POST',
                url: `${global.config.host}:${global.config.port}/professor`
            },
            selecionar: {
                method: 'GET',
                url: `${global.config.host}:${global.config.port}/professor`
            },
            selecionarSimples: {
                method: 'GET',
                url: `${global.config.host}:${global.config.port}/professor-simples`
            },
            selecionarPorId: {
                method: 'GET',
                url: `${global.config.host}:${global.config.port}/professor/:id`
            },
            atualizar: {
                method: 'PUT',
                url: `${global.config.host}:${global.config.port}/professor/:id`
            },
            excluir: {
                method: 'DELETE',
                url: `${global.config.host}:${global.config.port}/professor/:id`
            }
        },
        curso: {
            inserir: {
                method: 'POST',
                url: `${global.config.host}:${global.config.port}/curso`
            },
            selecionar: {
                method: 'GET',
                url: `${global.config.host}:${global.config.port}/curso`
            },
            selecionarPorId: {
                method: 'GET',
                url: `${global.config.host}:${global.config.port}/curso/:id`
            },
            atualizar: {
                method: 'PUT',
                url: `${global.config.host}:${global.config.port}/curso/:id`
            },
            excluir: {
                method: 'DELETE',
                url: `${global.config.host}:${global.config.port}/curso/:id`
            }
        }
    },
    seguranca: {
        login: {
            refazer: {
                method: 'GET',
                url: `${global.config.host}:${global.config.port}/login/refazer`
            }
        }
    }
};