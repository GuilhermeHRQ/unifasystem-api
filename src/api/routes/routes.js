module.exports = {
    administracao: {
        professor: {
            inserir: {
                method: 'POST',
                url: `${global.config.host}/professor`
            },
            selecionar: {
                method: 'GET',
                url: `${global.config.host}/professor`
            },
            selecionarSimples: {
                method: 'GET',
                url: `${global.config.host}/professor-simples`
            },
            selecionarPorId: {
                method: 'GET',
                url: `${global.config.host}/professor/:id`
            },
            atualizar: {
                method: 'PUT',
                url: `${global.config.host}/professor/:id`
            },
            excluir: {
                method: 'DELETE',
                url: `${global.config.host}/professor/:id`
            }
        },
        curso: {
            inserir: {
                method: 'POST',
                url: `${global.config.host}/curso`
            },
            selecionar: {
                method: 'GET',
                url: `${global.config.host}/curso`
            },
            selecionarPorId: {
                method: 'GET',
                url: `${global.config.host}/curso/:id`
            },
            atualizar: {
                method: 'PUT',
                url: `${global.config.host}/curso/:id`
            },
            excluir: {
                method: 'DELETE',
                url: `${global.config.host}/curso/:id`
            }
        },
        disciplina: {
            inserir: {
                method: 'POST',
                url: `${global.config.host}/disciplina`
            },
            selecionar: {
                method: 'GET',
                url: `${global.config.host}/disciplina`
            },
            selecionarPorId: {
                method: 'GET',
                url: `${global.config.host}/disciplina/:id`
            },
            atualizar: {
                method: 'PUT',
                url: `${global.config.host}/disciplina/:id`
            },
            excluir: {
                method: 'DELETE',
                url: `${global.config.host}/disciplina/:id`
            }
        },
        estado: {
            selecionar: {
                method: 'GET',
                url: `${global.config.host}/estado`
            }
        },
        cidade: {
            selecionar: {
                method: 'GET',
                url: `${global.config.host}/cidade`
            }
        }
    },
    seguranca: {
        login: {
            refazer: {
                method: 'GET',
                url: `${global.config.host}/login/refazer`
            }
        }
    }
};