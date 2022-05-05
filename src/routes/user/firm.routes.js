const express = require('express');

const api = express();

const userCtrl = require('../../controllers/firm.controller').adminCtrl;

api.get('/', userCtrl.getAll);
api.put('/', userCtrl.update);
api.post('/', userCtrl.create);
api.delete('/:firmId', userCtrl.delete);

module.exports = api;
