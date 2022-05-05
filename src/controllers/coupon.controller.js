const { loggers } = require('winston');
const { db } = require('../config/initializers/database');
const schemaHelper = require('../helpers/schema.helper').coupon;
const responseHelper = require('../helpers/response.helper');

const logger = loggers.get('logger');

const adminCtrl = {

    create: async (req, res) => {
        const { error, value } = schemaHelper.create.validate(req.body);
        if (error) {
            return responseHelper.joiErrorResponse(res, error);
        }
        const {
            name,
            percent,
            startDate,
            endDate,
        } = value;

        try {
            const q = `INSERT INTO coupons (
                name,
                percent,
                startDate,
                endDate
            ) VALUES (
                '${name || ''}',
                ${percent || 0},
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
};
