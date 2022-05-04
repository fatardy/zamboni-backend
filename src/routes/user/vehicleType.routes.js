const express = require('express');

const api = express();

const userCtrl = require('../../controllers/vehicleType.controller').adminCtrl;

api.get('/', userCtrl.getAll);
api.put('/', userCtrl.update);
api.post('/', userCtrl.create);
api.delete('/:vcId', userCtrl.delete);

module.exports = api;
