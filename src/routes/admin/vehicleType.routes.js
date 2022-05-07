const express = require('express');

const api = express();

const ctrl = require('../../controllers/vehicleType.controller').adminCtrl;

api.get('/', ctrl.getAll);
api.put('/', ctrl.update);
api.post('/', ctrl.create);
api.delete('/:vtId', ctrl.delete);

module.exports = api;
