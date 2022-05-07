const express = require('express');

const api = express();

const ctrl = require('../../controllers/invoice.controller').userCtrl;

// api.get('/', ctrl.getUsersInvoices);

module.exports = api;
