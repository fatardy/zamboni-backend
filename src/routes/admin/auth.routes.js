const express = require('express');

const api = express();

const authCtrl = require('../../controllers/auth.controller').userCtrl;

api.post('/', authCtrl.authorize);
api.post('/send-otp', authCtrl.sendOtp);
api.post(
    '/verify-otp',
    authCtrl.verifyOtp,
    authCtrl.verifyAdminAccess,
    authCtrl.generateAccessToken,
);

module.exports = api;
