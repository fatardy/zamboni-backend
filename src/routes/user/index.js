const express = require('express');

const api = express();

const auth = require('./auth.routes');
const user = require('./user.routes');
const location = require('./location.routes');
const vehicleClass = require('./vehicleClass.routes');
const { protectRoutes } = require('../../controllers/auth.controller');

api.use('/auth', auth);

api.use(protectRoutes);

api.use('/user', user);
api.use('/location', location);
api.use('/vehicleClass', vehicleClass);

module.exports = api;
