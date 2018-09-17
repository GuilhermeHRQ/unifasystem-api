const repository = require('./professorRepository');

module.exports = {
    inserirProfessor
};

async function inserirProfessor(params) {
    const data = await repository.inserirProfessor(params);

    let error;

    switch (data.executionCode) {
        case 1:
        case 2:
            error = data.message;
            error.httCode = 401;
    }

    if (error) {
        throw error;
    }

    return data;
}