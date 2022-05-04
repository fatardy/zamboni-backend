const express = require('express');

const api = express();

const auth = require('./auth.routes');
const user = require('./user.routes');
const location = require('./location.routes');
const vehicleType = require('./vehicleType.routes');
const { protectRoutes } = require('../../controllers/auth.controller');

api.use('/auth', auth);

api.use(protectRoutes);

api.use('/user', user);
api.use('/location', location);
api.use('/vehicleType', vehicleType);

module.exports = api;
