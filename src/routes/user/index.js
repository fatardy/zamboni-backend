const express = require('express');

const api = express();

const auth = require('./auth.routes');

api.use('/auth', auth);

module.exports = api;
