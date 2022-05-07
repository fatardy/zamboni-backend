const { loggers } = require('winston');
const { db } = require('../config/initializers/database');
const schemaHelper = require('../helpers/schema.helper').trip;
const responseHelper = require('../helpers/response.helper');

const logger = loggers.get('logger');

const getAll = async (req, res) => {
    try {
        const [data] = await db.query(
            'SELECT * FROM locations;',
        );
        // console.log(data);

        return responseHelper.successResponse(res, data == null ? [] : data);
    } catch (err) {
        logger.error(`location getAll > ${err}`);
        return responseHelper.serverErrorResponse(res, err);
    }
};

const userCtrl = {

    create: async (req, res) => {
        try {
            const { error, value } = schemaHelper.create.validate(req.body);
            if (error) {
                return responseHelper.joiErrorResponse(res, error);
            }
            const {
                pickDate,
                dropDate,
                odoStart,
                odoLimit,
                userId,
                pickLocId,
                dropLocId,
                coupId,
                vehId,
            } = value;

            const q = `INSERT INTO trips (
                pickDate,
                dropDate,
                odoStart,
                odoLimit,
                userId,
                pickLocId,
                dropLocId,
                coupId,
                vehId,
                inProgress
            ) VALUES (
                '${pickDate}',
                '${dropDate}',
                ${odoStart},
                ${odoLimit},
                '${userId}',
                '${pickLocId}',
                '${dropLocId}',
                ${coupId ? `'${coupId}'` : null},
                '${vehId}',
                ${true}
            );`;

            console.log(q);
            const [data] = await db.query(q);

            return responseHelper.successResponse(res, data);
        } catch (err) {
            logger.error(`location getAll > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

};

const adminCtrl = {

    create: async (req, res) => {
        const { error, value } = schemaHelper.create.validate(req.body);
        if (error) {
            return responseHelper.joiErrorResponse(res, error);
        }
        const {
            name,
            phoneNumber,
            email,
            street1,
            street2,
            city,
            stateName,
            zipCode,
            country,
        } = value;

        try {
            const q = `INSERT INTO locations (
                name, 
                phoneNumber, 
                email, 
                street1, 
                street2, 
                city, 
                stateName, 
                zipCode, 
                country
            ) VALUES (
                '${name || ''}',
                ${phoneNumber || 0},
                '${email || ''}',
                '${street1 || ''}',
                '${street2 || ''}',
                '${city || ''}',
                '${stateName || ''}',
                '${zipCode || ''}',
                '${country || ''}'
            );`;
            console.log(q);
            const [data] = await db.query(q);

            return responseHelper.successResponse(res, data);
        } catch (err) {
            logger.error(`location create > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

    update: async (req, res) => {
        const { error, value } = schemaHelper.update.validate(req.body);
        if (error) {
            return responseHelper.joiErrorResponse(res, error);
        }
        const {
            locId,
            name,
            phoneNumber,
            email,
            street1,
            street2,
            city,
            stateName,
            zipCode,
            country,
        } = value;

        try {
            const q = `UPDATE locations SET
                name = '${name || ''}', 
                phoneNumber = ${phoneNumber || 0}, 
                email = '${email || ''}', 
                street1 = '${street1 || ''}', 
                street2 = '${street2 || ''}', 
                city = '${city || ''}', 
                stateName = '${stateName || ''}',
                zipCode = '${zipCode || ''}',
                country = '${country || ''}'
                WHERE locId = ${locId};`;

            console.log(q);
            const [data] = await db.query(q);

            // console.log(data);

            return responseHelper.successResponse(res, data);
        } catch (err) {
            logger.error(`location update > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

    getAll,

    delete: async (req, res) => {
        const { locId } = req.params;
        try {
            const [data] = await db.query(
                `DELETE FROM locations WHERE locId = ${locId};`,
            );
            return responseHelper.successResponse(res, data);
        } catch (err) {
            logger.error(`location delete > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

};

module.exports = {
    adminCtrl,
    userCtrl,
};
