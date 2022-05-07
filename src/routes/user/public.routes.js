const express = require('express');

const api = express();

const locationCtrl = require('../../controllers/location.controller').userCtrl;
const vehicleCtrl = require('../../controllers/vehicle.controller').userCtrl;

api.get('/location/', locationCtrl.getAll);
api.get('/vehicle/', vehicleCtrl.getAvailable);

module.exports = api;
