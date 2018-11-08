const databaseConfig = {
    'host': '18.188.151.183',
    'port': 5432,
    'database': 'unifasystem',
    'user': 'postgres',
    'password': '123321'
};

//const connectionString = 'postgres://jfyucfiyvfztpy:4523bdfc3acea28e579ecd2d10492be08bb8e4992f1d048e007c0fe1d992ea47@ec2-54-197-230-161.compute-1.amazonaws.com:5432/df6vhct6ogge09?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory';

const db = require('pg-promise')()(databaseConfig);

global.db = {
    json: async function (query, params) {
        let result = await db.proc(query, params);

        return result ? result[Object.keys(result)[0]] : null;
    },
    query: db.query,
    proc: db.proc,
    func: db.func
};