const mysql = require('mysql2');

require('dotenv').config();
// TODO: error, dotenv shouldn't be required here.

async function init() {
  const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    connectionLimit: process.env.DB_CONN_LIMIT,
    database: process.env.DB_NAME,
    debug: process.env.DEBUG,
  });
  // const promisePool = pool.promise();
  // return promisePool;
  // return pool;

  // console.log(pool);

  // pool.query('SELECT * FROM users;', (err, rows, fields) => {
  //   if (err) {
  //     console.log(err);
  //   }

  //   console.log('rows', rows);
  // });

  try {
    const p = pool.promise();
    const data = await p.query('SELECT * FROM users');
    console.log('data', data[0]);
  } catch (err) {
    console.log('err', err);
  }

  Promise.resolve('yay');
}

module.exports = init;
