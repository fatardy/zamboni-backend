const express = require('express');

const api = express();

const ctrl = require('../../controllers/invoice.controller').adminCtrl;

api.get('/', ctrl.getAll);

module.exports = api;
