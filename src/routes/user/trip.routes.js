const express = require('express');

const api = express();

const ctrl = require('../../controllers/trip.controller').userCtrl;

api.get('/', ctrl.getAllOfUser); // ?inProgress=1 returns live, 0 returns all;
api.post('/end', ctrl.endTrip);
api.post('/', ctrl.create);

module.exports = api;
