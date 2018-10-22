const repository = require('./statusRepository');

module.exports = {
    selecionarStatusSimples
};

async function selecionarStatusSimples(req, res) {
    try {
        const data = await repository.selecionarStatusSimples();

        return res.finish(data);
    } catch (error) {
        return res.finish({
            httpCode: 500,
            error
        })
    }
}