const mysql = require('mysql2');

require('dotenv').config();
// TODO: error, dotenv shouldn't be required here.

const pool = mysql
    .createPool({
        host: process.env.DB_HOST,
        user: process.env.DB_USER,
        password: process.env.DB_PASSWORD,
        connectionLimit: process.env.DB_CONN_LIMIT,
        database: process.env.DB_NAME,
        debug: false, // process.env.DEBUG,
        multipleStatements: true,
    })
    .promise();

async function initializeDatabase() {
    Promise.resolve();
}

module.exports = {
    initializeDatabase,
    db: pool,
};

// https://github.com/sidorares/node-mysql2/issues/840
