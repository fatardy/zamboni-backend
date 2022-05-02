const { db } = require('../config/initializers/database');

// const db = getDB();

async function dbTest() {
//   console.log(db);
    try {
        const q = `
      SELECT * FROM users;
    `;
        // console.log(db);
        // console.log(db());
        const [data, fields] = await db.query(q);
        console.log(data);
    } catch (err) {
        console.log(err);
    }
}

module.exports = {
    dbTest,
};
