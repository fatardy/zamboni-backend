const express = require('express');

const api = express();

const ctrl = require('../../controllers/trip.controller').userCtrl;

api.post('/', ctrl.create);

module.exports = api;
