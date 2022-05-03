const express = require('express');

const api = express();

const auth = require('./auth.routes');
const user = require('./user.routes');
const { protectRoutes } = require('../../controllers/auth.controller');

api.use('/auth', auth);

api.use(protectRoutes);

api.use('/user', user);
// api.get('/asdf', (req, res) => res.json({ sex: 'isme' }));

module.exports = api;
