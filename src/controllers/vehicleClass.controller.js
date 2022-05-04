const { loggers } = require('winston');
const { db } = require('../config/initializers/database');
const schemaHelper = require('../helpers/schema.helper').vehicleClass;
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
            const q = `INSERT INTO vehicleClass (
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
            logger.error(`vehicleClass create > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

    update: async (req, res) => {
        const { error, value } = schemaHelper.update.validate(req.body);
        if (error) {
            return responseHelper.joiErrorResponse(res, error);
        }
        const {
            vcId,
            name,
            rate,
            overFee,
        } = value;

        try {
            const q = `UPDATE vehicleClass SET
                name = '${name || ''}', 
                rate = ${rate || 0}, 
                overFee = ${overFee || 0}
                WHERE vcId = ${vcId};`;

            console.log(q);
            const [data] = await db.query(q);

            // console.log(data);

            return responseHelper.successResponse(res, data);
        } catch (err) {
            logger.error(`vehicleClass update > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

    getAll: async (req, res) => {
        try {
            const [data] = await db.query(
                'SELECT * FROM vehicleClass;',
            );
            // console.log(data);

            return responseHelper.successResponse(res, data == null ? [] : data);
        } catch (err) {
            logger.error(`vehicleClass getAll > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

    delete: async (req, res) => {
        const { vcId } = req.params;
        try {
            const [data] = await db.query(
                `DELETE FROM vehicleClass WHERE vcId = ${vcId};`,
            );
            return responseHelper.successResponse(res, data);
        } catch (err) {
            logger.error(`vehicleClass delete > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

};

module.exports = {
    adminCtrl,
};
