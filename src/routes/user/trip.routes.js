const express = require('express');

const api = express();

const ctrl = require('../../controllers/trip.controller').userCtrl;

api.get('/', ctrl.getAllOfUser);
api.post('/end', ctrl.endTrip);
api.post('/', ctrl.create);

module.exports = api;
