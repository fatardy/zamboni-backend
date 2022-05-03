const express = require('express');

const api = express();

const authCtrl = require('../../controllers/auth.controller').userCtrl;

api.post('/', authCtrl.authorize);

module.exports = api;
