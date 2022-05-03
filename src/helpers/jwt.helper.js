const jsonwebtoken = require('jsonwebtoken');
const CONSTANTS = require('../config/constants');

module.exports = {
    createAccessToken: (data) => jsonwebtoken.sign(data, CONSTANTS.KEYS.SECRET, {
        expiresIn: '30 days',
    }),

    verifyAccessToken: (tkn) => jsonwebtoken.verify(tkn, CONSTANTS.KEYS.SECRET),
};
