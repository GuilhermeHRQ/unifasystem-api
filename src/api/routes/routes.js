module.exports = {
    administracao: {
        controlePresenca: {
            inserir: {
                method: 'POST',
                url: `${global.config.host}${global.config.isProduction ? '' : `:${global.config.port}`}/controle-presenca`
            },
            selecionar: {
                method: 'GET',
                url: `${global.config.host}${global.config.isProduction ? '' : `:${global.config.port}`}/controle-presenca`
            },
            selecionarPorId: {
                method: 'GET',
                url: `${global.config.host}${global.config.isProduction ? '' : `:${global.config.port}`}/controle-presenca/:id`
            },
            atualizar: {
                method: 'PUT',
                url: `${global.config.host}${global.config.isProduction ? '' : `:${global.config.port}`}/controle-presenca/:id`
            },
            cancelar: {
                method: 'PUT',
                url: `${global.config.host}${global.config.isProduction ? '' : `:${global.config.port}`}/controle-presenca/:id/cancelar`
            }
        },
        status: {
            selecionarSimples: {
                method: 'GET',
                url: `${global.config.host}${global.config.isProduction ? '' : `:${global.config.port}`}/selecionar-status-simples`
            }
        },
        disciplina: {
            selecionar: {
                method: 'GET',
                url: `${global.config.host}${global.config.isProduction ? '' : `:${global.config.port}`}/disciplina`
            }
        }
    },
    seguranca: {
        login: {
            refazer: {
                method: 'GET',
                url: `${global.config.host}${global.config.isProduction ? '' : `:${global.config.port}`}/login/refazer`
            }
        }
    }
};