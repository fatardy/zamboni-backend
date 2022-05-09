const express = require('express');

const api = express();

const ctrl = require('../../controllers/coupon.controller').userCtrl;

api.get('/', ctrl.getAll);

module.exports = api;
