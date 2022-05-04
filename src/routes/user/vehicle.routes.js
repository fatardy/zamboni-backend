const express = require('express');

const api = express();

const userCtrl = require('../../controllers/vehicle.controller').adminCtrl;

api.get('/', userCtrl.getAll);
api.put('/', userCtrl.update);
api.post('/', userCtrl.create);
api.delete('/:vehId', userCtrl.delete);

module.exports = api;
