const express = require('express');

const api = express();

const ctrl = require('../../controllers/coupon.controller').adminCtrl;

api.get('/', ctrl.getAll);
api.put('/', ctrl.update);
api.post('/', ctrl.create);
api.delete('/:coupId', ctrl.delete);

module.exports = api;
