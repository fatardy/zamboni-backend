const express = require('express');

const api = express();

const auth = require('./auth.routes');
const { protectRoutes } = require('../../controllers/auth.controller');

api.use('/auth', auth);

api.use(protectRoutes);

api.get('/asdf', (req, res) => res.json({ sex: 'isme' }));

module.exports = api;
