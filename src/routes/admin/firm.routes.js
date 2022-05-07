const express = require('express');

const api = express();

const ctrl = require('../../controllers/firm.controller').adminCtrl;

api.get('/', ctrl.getAll);
api.put('/', ctrl.update);
api.post('/', ctrl.create);
api.delete('/:firmId', ctrl.delete);

module.exports = api;
