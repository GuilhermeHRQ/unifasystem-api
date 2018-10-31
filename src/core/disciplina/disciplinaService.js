const request = require('request-promise');

module.exports = {
    selecionarDisciplinaSimples
};

async function selecionarDisciplinaSimples(params) {
    try {
        let data = [];

        let res =  await request({
            url: `http://dev2.unifacef.com.br:8000/api/disciplinaDocente/${params.codigoProfessor}`,
            method: 'GET',
            json: true
        });

        res.forEach(item => {
            data.push({
                id: item.id_disciplina,
                nome: item.nome_curso,
                turno: item.nome_turno
            })
        })
    } catch (error) {
        throw error;
    }
}