const request = require('request-promise');
const apiFacef = global.apiFacef;

module.exports = {
    selecionar
};

async function selecionar(params) {
    try {
        let data = [];

        let res =  await request({
            url: `${apiFacef.disciplinasDocente}${params.codigoProfessor}`,
            method: 'GET',
            json: true
        });

        let filtrar = params.idTurma === null;

        res.forEach(item => {
            if(filtrar || item.id_serie == params.idTurma) {
                data.push({
                    id: item.id_disciplina,
                    nome: item.nome_disciplina,
                    semestre: item.nome_serie
                });
            }
        });

        return data;
    } catch (error) {
        throw error;
    }
}