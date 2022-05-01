const mysql = require('mysql2/promise');

require('dotenv').config();
// TODO: error, dotenv shouldn't be required here.

function init() {
  return mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    connectionLimit: process.env.DB_CONN_LIMIT,
    database: process.env.DB_NAME,
    debug: process.env.DEBUG,
  });
}

module.exports = init;
