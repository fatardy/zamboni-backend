const express = require('express');

const api = express();

const userCtrl = require('../../controllers/coupon.controller').adminCtrl;

api.get('/', userCtrl.getAll);
api.put('/', userCtrl.update);
api.post('/', userCtrl.create);
api.delete('/:coupId', userCtrl.delete);

module.exports = api;
