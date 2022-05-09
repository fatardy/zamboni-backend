const express = require('express');

const api = express();

const ctrl = require('../../controllers/trip.controller').adminCtrl;

api.get('/', ctrl.getAll);

module.exports = api;
