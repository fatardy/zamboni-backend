const { db } = require('../config/initializers/database');

module.exports = {
    doIt: async () => {
        try {
            // const [data] = await db.query('SELECT first_name from users;');
            const q = 'SHOW STATUS WHERE \'variable_name\' = \'Threads_connected\';';
            const [data] = await db.query(q);
            console.log('data,', data);
        } catch (err) {
            console.log(err);
        }
    },
};
