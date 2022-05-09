const express = require('express');

const api = express();

const ctrl = require('../../controllers/user.controller').adminCtrl;

api.get('/', ctrl.getAll);
api.put('/', ctrl.makeAdmin);

module.exports = api;
