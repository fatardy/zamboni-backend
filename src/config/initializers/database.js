const dotenv = require('dotenv').config();
// TODO: error, dotenv shouldn't be required here.

// const a = require('../../models');
// const Sequelize = require('sequelize');

const dbName = process.env.DB_NAME;
const user = process.env.DB_USER;
const password = process.env.DB_PASSWORD;
const host = 'localhost';
const dialect = 'postgres';
const max = 5;
const min = 0;
const acquire = 30000;
const idle = 10000;

// const database = new Sequelize(dbName, user, password, {
//   host,
//   dialect,
//   debug: false,
//   logging: false,
//   pool: {
//     max,
//     min,
//     idle,
//     acquire,
//   },
// });

async function main() {
  return new Promise((resolve) => {
    resolve();
  });
}

module.exports = {
  // database,
  main,
};
