const conn = require('../config/initializers/database');

const db = conn();

async function dbTest() {
  try {
    const q = `
        create table if not exists test_table;
        select * from table;
    `;
    const c = await db.con;
    const data = await db.query(q);
    console.log(data);
  } catch (err) {
    console.log(err);
  }
}

module.exports = {
  dbTest,
};
