const mongoose = require('mongoose');
const Disciplina = mongoose.model('Disciplina');

module.exports = {
    inserir,
    selecionar,
    selecionarPorId,
    atualizar,
    remover
}

async function inserir(params) {
    const disciplina = new Disciplina(params);
    await disciplina.save();
    return disciplina.id;
}

async function selecionar(params) {
    const regex = new RegExp(params.filtro, 'i');
    return await
        Disciplina
            .find({ nome: regex }, 'nome cargaHoraria')
            .sort({ nome: 1 })
            .limit(params.linhas)
            .skip((params.pagina - 1) * params.linhas);
}

async function selecionarPorId(params) {
    return await
        Disciplina
            .findById(params.id)
            .populate('usuarioCadastro', 'nome')
            .populate('usuarioAlteracao', 'nome');
}

async function atualizar(params) {
    await
        Disciplina
            .findByIdAndUpdate(params.id, {
                $set: {
                    cargaHoraria: params.cargaHoraria,
                    nome: params.nome,
                    descricao: params.descricao,
                    dataAlteracao: Date.now(),
                    usuarioAlteracao: params.user.id
                }
            });
}

async function remover(params) {
    await
        Disciplina
            .findByIdAndRemove(params.id);
}