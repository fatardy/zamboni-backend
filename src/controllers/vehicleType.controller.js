const { loggers } = require('winston');
const { db } = require('../config/initializers/database');
const schemaHelper = require('../helpers/schema.helper').vehicleType;
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
            rate,
            overFee,
        } = value;

        try {
            const q = `INSERT INTO vehicleTypes (
                name, 
                rate,
                overFee
            ) VALUES (
                '${name || ''}',
                ${rate || 0},
                ${overFee || 0}
            );`;
            console.log(q);
            const [data] = await db.query(q);

            return responseHelper.successResponse(res, data);
        } catch (err) {
            logger.error(`vehicleTypes create > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

    update: async (req, res) => {
        const { error, value } = schemaHelper.update.validate(req.body);
        if (error) {
            return responseHelper.joiErrorResponse(res, error);
        }
        const {
            vtId,
            name,
            rate,
            overFee,
        } = value;

        try {
            const q = `UPDATE vehicleTypes SET
                name = '${name || ''}', 
                rate = ${rate || 0}, 
                overFee = ${overFee || 0}
                WHERE vtId = ${vtId};`;

            console.log(q);
            const [data] = await db.query(q);

            // console.log(data);

            return responseHelper.successResponse(res, data);
        } catch (err) {
            logger.error(`vehicleTypes update > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

    getAll: async (req, res) => {
        try {
            const [data] = await db.query(
                'SELECT * FROM vehicleTypes;',
            );
            // console.log(data);

            return responseHelper.successResponse(res, data == null ? [] : data);
        } catch (err) {
            logger.error(`vehicleTypes getAll > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

    delete: async (req, res) => {
        const { vtId } = req.params;
        try {
            const [data] = await db.query(
                `DELETE FROM vehicleTypes WHERE vtId = ${vtId};`,
            );
            return responseHelper.successResponse(res, data);
        } catch (err) {
            logger.error(`vehicleTypes delete > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

};

module.exports = {
    adminCtrl,
};
