const express = require('express');

const api = express();

const ctrl = require('../../controllers/payment.controller').adminCtrl;

api.get('/', ctrl.getAll);

module.exports = api;
