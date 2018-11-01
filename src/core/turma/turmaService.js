const request = require('request-promise');

module.exports = {
    
};

async function selecionar(params) {
    try {
        let data = [];

        let res =  await request({
            url: `http://dev2.unifacef.com.br:8000/api/disciplinaDocente/${params.codigoProfessor}`,
            method: 'GET',
            json: true
        });

        res.forEach(item => {

        })
    } catch(error) {
        throw error;
    }
}