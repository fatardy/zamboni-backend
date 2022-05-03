const Joi = require('@hapi/joi');
const { trim } = require('lodash');
Joi.objectId = require('joi-objectid')(Joi);

const trimString = Joi.string().trim();
const trimStringAllowEmpty = trimString.allow('');
const trimStringRequired = trimString.required();
const email = Joi.string().email();
const number = Joi.number();
const numberRequired = number.required();
const numberAllowEmpty = number.allow('');
const any = Joi.any();
const arrayOfStringsAllowEmpty = Joi.array().items(trimStringAllowEmpty);
const booleanRequired = Joi.boolean();
// TODO:
// const phone = Joi.string().regex(/^[0-9]*$/).min(6).max(20);

const auth = {

    authorize: Joi.object().keys({
        email: email.lowercase().required(),
        // deviceId: trimStringRequired,
    }),

    sendOtp: Joi.object().keys({
        email: email.lowercase().required(),
    }),

    verifyOtp: Joi.object().keys({
        email: email.lowercase().required(),
        deviceId: trimStringRequired,
        otp: trimStringRequired,
    }),

};

// const auth = {

// };

// const user = {

//     edit: Joi.object().keys({
//         username: trimStringAllowEmpty,
//         fullname: trimStringAllowEmpty,
//         avatar: trimStringAllowEmpty,
//         about: trimStringAllowEmpty,
//         gender: trimStringAllowEmpty,
//         deviceId: trimStringAllowEmpty,
//         extraInfo: any,
//     }),

// };

// const group = {

//     create: Joi.object().keys({
//         name: trimStringRequired,
//         description: trimStringAllowEmpty,
//         avatar: trimStringAllowEmpty,
//         username: trimStringRequired,
//         password: trimStringRequired,
//         members: arrayOfStringsAllowEmpty,
//     }),

//     edit: Joi.object().keys({
//         groupId: trimStringRequired,

//         name: trimStringAllowEmpty,
//         description: trimStringAllowEmpty,
//         avatar: trimStringAllowEmpty,
//         username: trimStringAllowEmpty,
//         password: trimStringAllowEmpty,
//         members: arrayOfStringsAllowEmpty,
//     }),

//     join: Joi.object().keys({
//         username: trimStringRequired,
//         password: trimStringRequired,
//     }),

// };

// const habit = {

//     create: Joi.object().keys({
//         groupId: trimStringRequired,
//         name: trimStringRequired,
//         categories: arrayOfStringsAllowEmpty,
//         // days: Joi.array().items(trimString.valid(...DAYS)),
//         days: Joi.array().items(numberAllowEmpty),
//         startTime: numberRequired,
//         endTime: numberAllowEmpty,
//         members: arrayOfStringsAllowEmpty,
//         points: numberAllowEmpty,
//     // notify
//     }),

//     edit: Joi.object().keys({
//         habitId: trimStringRequired,
//         name: trimStringAllowEmpty,
//         categories: arrayOfStringsAllowEmpty,
//         // days: Joi.array().items(trimString.valid(...DAYS)),
//         days: Joi.array().items(numberAllowEmpty),
//         startTime: numberAllowEmpty,
//         endTime: numberAllowEmpty,
//         members: arrayOfStringsAllowEmpty,
//         points: numberAllowEmpty,
//     }),

// };

// const task = {
//     markDone: Joi.object().keys({
//         habitId: trimStringRequired,
//     }),
// };

module.exports = {
    auth,

};