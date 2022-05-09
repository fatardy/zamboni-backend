const express = require('express');

const api = express();

const auth = require('./auth.routes');
const user = require('./user.routes');
const location = require('./location.routes');
const vehicleType = require('./vehicleType.routes');
const vehicle = require('./vehicle.routes');
const coupon = require('./coupon.routes');
const firm = require('./firm.routes');
const publicRoutes = require('./public.routes');
const trip = require('./trip.routes');
const payment = require('./payment.routes');
const { protectRoutes } = require('../../controllers/auth.controller');

api.use('/auth', auth);
api.use('/public', publicRoutes);

api.use(protectRoutes({ checkAdmin: false }));

api.use('/user', user);
api.use('/location', location);
api.use('/vehicleType', vehicleType);
api.use('/vehicle', vehicle);
api.use('/coupon', coupon);
api.use('/firm', firm);
api.use('/trip', trip);
api.use('/payment', payment);

module.exports = api;
