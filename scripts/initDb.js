const fs = require('fs-extra');
const path = require('path');
const mysql = require('mysql2');

require('dotenv').config();

const pool = mysql
    .createPool({
        host: process.env.DB_HOST,
        user: process.env.DB_USER,
        password: process.env.DB_PASSWORD,
        connectionLimit: process.env.DB_CONN_LIMIT,
        database: process.env.DB_NAME,
        debug: false, // process.env.DEBUG,
        multipleStatements: true,
    });

const fileWithPath = path.join(__dirname, 'create-database.sql');
// console.log(fileWithPath);
const fileBuffer = fs.readFileSync(fileWithPath);
const fileContent = fileBuffer.toString().replace(/\n/g, '');
console.log(fileContent);

pool.query(fileContent, null, (err, res, fields) => {
    if (err) {
        console.log('err', err);
    }

    console.log(res);
});
