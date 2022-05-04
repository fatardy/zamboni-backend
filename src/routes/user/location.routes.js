const express = require('express');

const api = express();

const userCtrl = require('../../controllers/location.controller').adminCtrl;

api.get('/', userCtrl.getAll);
api.put('/', userCtrl.update);
api.post('/', userCtrl.create);
api.delete('/:locId', userCtrl.delete);

module.exports = api;
