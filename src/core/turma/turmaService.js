const request = require('request-promise');
const apiFacef = global.apiFacef;

module.exports = {
    selecionar
};

async function selecionar(params) {
    try {
        let data = [];

        let res = await request({
            url: `${apiFacef.disciplinasDocente}${params.codigoProfessor}`,
            method: 'GET',
            json: true
        });

        res.forEach(r => {
            let inserir = true;
            for(let i = 0; i < data.length; i++) {
                let itemAtual = data[i];
                if (r.id_serie === itemAtual.id) {
                    inserir = false;
                    break;
                }
            }

            if(inserir) {
                data.push({
                    id: r.id_serie,
                    nome: `${r.nome_serie} ${r.nome_curso}`
                });
            }
        });

        return data;
    } catch(error) {
        throw error;
    }
}