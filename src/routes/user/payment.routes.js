const express = require('express');

const api = express();

const ctrl = require('../../controllers/payment.controller').userCtrl;

api.post('/', ctrl.create);

module.exports = api;
