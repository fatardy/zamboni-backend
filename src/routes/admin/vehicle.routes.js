const express = require('express');

const api = express();

const ctrl = require('../../controllers/vehicle.controller').adminCtrl;

api.get('/', ctrl.getAll);
api.put('/', ctrl.update);
api.post('/', ctrl.create);
api.delete('/:vehId', ctrl.delete);

module.exports = api;
