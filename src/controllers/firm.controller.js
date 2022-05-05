const { loggers } = require('winston');
const { db } = require('../config/initializers/database');
const schemaHelper = require('../helpers/schema.helper').firm;
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
            regNo,
        } = value;

        try {
            const q = `INSERT INTO firms (
                name,
                regNo
            ) VALUES (
                '${name || ''}',
                '${regNo}'
            );`;
            console.log(q);
            const [data] = await db.query(q);

            return responseHelper.successResponse(res, data);
        } catch (err) {
            logger.error(`firm create > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

    update: async (req, res) => {
        const { error, value } = schemaHelper.update.validate(req.body);
        if (error) {
            return responseHelper.joiErrorResponse(res, error);
        }
        const {
            firmId,
            name,
            regNo,
        } = value;

        try {
            const q = `UPDATE firms SET
                name = '${name || ''}', 
                regNo = '${regNo}'
                WHERE firmId = ${firmId};`;

            console.log(q);
            const [data] = await db.query(q);

            // console.log(data);

            return responseHelper.successResponse(res, data);
        } catch (err) {
            logger.error(`firm update > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

    getAll: async (req, res) => {
        try {
            const [data] = await db.query(
                'SELECT * FROM firms;',
            );
            // console.log(data);

            return responseHelper.successResponse(res, data == null ? [] : data);
        } catch (err) {
            logger.error(`firm getAll > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

    delete: async (req, res) => {
        const { firmId } = req.params;
        try {
            const [data] = await db.query(
                `DELETE FROM firms WHERE firmId = ${firmId};`,
            );
            return responseHelper.successResponse(res, data);
        } catch (err) {
            logger.error(`firm delete > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

};

module.exports = {
    adminCtrl,
};
