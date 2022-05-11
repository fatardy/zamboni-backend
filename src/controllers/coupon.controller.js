const { loggers } = require('winston');
const { db } = require('../config/initializers/database');
const schemaHelper = require('../helpers/schema.helper').coupon;
const responseHelper = require('../helpers/response.helper');

const logger = loggers.get('logger');

const userCtrl = {

    getAll: async (req, res) => {
        try {
            const [data] = await db.query(
                `select *
                from users_coupons a
                join coupons b
                    on a.coupId = b.coupId
                where userId = ${res.locals.user.userId}`,
            );
            // console.log(data);

            return responseHelper.successResponse(res, data == null ? [] : data);
        } catch (err) {
            logger.error(`coupon getAll > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

};

const adminCtrl = {

    addToUser: async (req, res) => {
        const { error, value } = schemaHelper.addToUser.validate(req.body);
        if (error) {
            return responseHelper.joiErrorResponse(res, error);
        }
        const {
            coupId,
            userId,
        } = value;

        try {
            const q = `INSERT INTO users_coupons (
                coupId,
                userId
            ) VALUES (
                '${coupId}',
                '${userId}'
            );`;
            console.log(q);
            const [data] = await db.query(q);

            return responseHelper.successResponse(res, data);
        } catch (err) {
            logger.error(`coupon create > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

    create: async (req, res) => {
        const { error, value } = schemaHelper.create.validate(req.body);
        if (error) {
            return responseHelper.joiErrorResponse(res, error);
        }
        const {
            name,
            percent,
            flatRate,
            startDate,
            endDate,
        } = value;

        try {
            const q = `INSERT INTO coupons (
                name,
                percent,
                flatRate,
                startDate,
                endDate
            ) VALUES (
                '${name || ''}',
                ${percent || 0},
                ${flatRate || 0},
                '${startDate}',
                '${endDate}'
            );`;
            console.log(q);
            const [data] = await db.query(q);

            return responseHelper.successResponse(res, data);
        } catch (err) {
            logger.error(`coupon create > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

    update: async (req, res) => {
        const { error, value } = schemaHelper.update.validate(req.body);
        if (error) {
            return responseHelper.joiErrorResponse(res, error);
        }
        const {
            coupId,
            name,
            percent,
            startDate,
            endDate,
        } = value;

        try {
            const q = `UPDATE coupons SET
                name = '${name || ''}', 
                percent = ${percent || 0}, 
                startDate = '${startDate}', 
                endDate = '${endDate}'
                WHERE coupId = ${coupId};`;

            console.log(q);
            const [data] = await db.query(q);

            // console.log(data);

            return responseHelper.successResponse(res, data);
        } catch (err) {
            logger.error(`coupon update > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

    getAll: async (req, res) => {
        try {
            const [data] = await db.query(
                'SELECT * FROM coupons;',
            );
            // console.log(data);

            return responseHelper.successResponse(res, data == null ? [] : data);
        } catch (err) {
            logger.error(`coupon getAll > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

    getCouponsOfUsers: async (req, res) => {
        try {
            const [data] = await db.query(
                `select *
                from users_coupons a
                join users b
                    on a.userId = b.userId
                join coupons c
                    on a.coupId = c.coupId`,
            );
            // console.log(data);

            return responseHelper.successResponse(res, data == null ? [] : data);
        } catch (err) {
            logger.error(`coupon getAll > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

    delete: async (req, res) => {
        const { coupId } = req.params;
        try {
            const [data] = await db.query(
                `DELETE FROM coupons WHERE coupId = ${coupId};`,
            );
            return responseHelper.successResponse(res, data);
        } catch (err) {
            logger.error(`coupon delete > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

};

module.exports = {
    adminCtrl,
    userCtrl,
};
