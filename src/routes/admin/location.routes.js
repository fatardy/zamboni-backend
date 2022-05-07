const express = require('express');

const api = express();

const ctrl = require('../../controllers/location.controller').adminCtrl;

api.get('/', ctrl.getAll);
api.put('/', ctrl.update);
api.post('/', ctrl.create);
api.delete('/:locId', ctrl.delete);

module.exports = api;
