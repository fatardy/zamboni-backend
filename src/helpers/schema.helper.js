const { sanitize } = require('string-sanitizer');

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
        deviceId: trimStringRequired,
    }),

    sendOtp: Joi.object().keys({
        email: email.lowercase().required(),
    }),

    verifyOtp: Joi.object().keys({
        email: email.lowercase().required(),
        deviceId: trimStringRequired,
        otp: sanitize(trimStringRequired),
    }),

};

const user = {

    edit: Joi.object().keys({
        firstName: sanitize(trimStringAllowEmpty),
        lastName: sanitize(trimStringAllowEmpty),
        phoneNumber: numberAllowEmpty,
        street1: sanitize(trimStringAllowEmpty),
        street2: sanitize(trimStringAllowEmpty),
        city: sanitize(trimStringAllowEmpty),
        stateName: sanitize(trimStringAllowEmpty),
        zipCode: sanitize(trimStringAllowEmpty),
        country: sanitize(trimStringAllowEmpty),
        deviceId: sanitize(trimStringAllowEmpty),
        avatar: trimStringAllowEmpty,
    }),

    makeAdmin: Joi.object().keys({
        userId: trimStringRequired,
    }),

};

const location = {

    create: Joi.object().keys({
        name: trimStringAllowEmpty,
        phoneNumber: numberAllowEmpty,
        email: trimStringAllowEmpty,
        street1: trimStringAllowEmpty,
        street2: trimStringAllowEmpty,
        city: trimStringAllowEmpty,
        stateName: trimStringAllowEmpty,
        zipCode: trimStringAllowEmpty,
        country: trimStringAllowEmpty,
    }),

    update: Joi.object().keys({
        locId: trimStringRequired,

        name: trimStringAllowEmpty,
        phoneNumber: numberAllowEmpty,
        email: trimStringAllowEmpty,
        street1: trimStringAllowEmpty,
        street2: trimStringAllowEmpty,
        city: trimStringAllowEmpty,
        stateName: trimStringAllowEmpty,
        zipCode: trimStringAllowEmpty,
        country: trimStringAllowEmpty,
    }),

};

const vehicleType = {

    create: Joi.object().keys({
        name: trimStringAllowEmpty,
        rate: numberAllowEmpty,
        overFee: numberAllowEmpty,
    }),

    update: Joi.object().keys({
        vtId: trimStringRequired,

        name: trimStringAllowEmpty,
        rate: numberAllowEmpty,
        overFee: numberAllowEmpty,
    }),

};

const vehicle = {

    create: Joi.object().keys({
        vehId: trimStringRequired, // pk but no default value
        make: trimStringAllowEmpty,
        model: trimStringAllowEmpty,
        licensePlate: trimStringAllowEmpty,
        locId: trimStringRequired,
        vtId: trimStringRequired,
        avatar: trimStringAllowEmpty,
    }),

    update: Joi.object().keys({
        vehId: trimStringRequired,

        make: trimStringAllowEmpty,
        model: trimStringAllowEmpty,
        licensePlate: trimStringAllowEmpty,
        locId: trimStringRequired,
        vtId: trimStringRequired,
        avatar: trimStringAllowEmpty,
    }),

};

const coupon = {

    addToUser: Joi.object().keys({
        coupId: trimStringRequired,
        userId: trimStringRequired,
    }),

    create: Joi.object().keys({
        name: trimStringAllowEmpty,
        percent: numberAllowEmpty,
        flatRate: numberAllowEmpty,
        startDate: trimStringRequired,
        endDate: trimStringRequired,
    }),

    update: Joi.object().keys({
        coupId: trimStringRequired,

        name: trimStringAllowEmpty,
        percent: numberAllowEmpty,
        startDate: trimStringRequired,
        endDate: trimStringRequired,
    }),

};

const firm = {

    create: Joi.object().keys({
        name: trimStringAllowEmpty,
        regNo: trimStringRequired,
    }),

    update: Joi.object().keys({
        firmId: trimStringRequired,

        name: trimStringAllowEmpty,
        regNo: trimStringRequired,
    }),

};

const trip = {

    create: Joi.object().keys({
        pickDate: trimStringRequired,
        dropDate: trimStringRequired,
        odoStart: numberRequired,
        odoEnd: numberAllowEmpty,
        odoLimit: numberRequired,
        // userId: trimStringRequired,
        pickLocId: trimStringRequired,
        dropLocId: trimStringRequired,
        coupId: trimStringAllowEmpty,
        vehId: trimStringRequired,
    }),

    endTrip: Joi.object().keys({
        tripId: trimStringRequired,

        odoEnd: numberRequired,
        finalDropDate: trimStringRequired,
    }),

};

const payment = {

    create: Joi.object().keys({
        // payDate: trimStringRequired,
        amount: numberRequired,
        method: sanitize(trimStringRequired),
        cardNo: numberRequired,
        invId: trimStringRequired,
    }),

};

module.exports = {
    auth,
    user,
    location,
    vehicleType,
    vehicle,
    coupon,
    firm,
    trip,
    payment,
};
