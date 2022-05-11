const { loggers } = require('winston');
const { db } = require('../config/initializers/database');
const schemaHelper = require('../helpers/schema.helper').location;
const responseHelper = require('../helpers/response.helper');

const logger = loggers.get('logger');

const userCtrl = {

    // TODO: CANT DO THIS BECAUSE YOU NEED TRIP ID TO GET TO INVOICE

    // getUsersInvoices: async (req, res) => {
    //     try {
    //         const data = await db.query(
    //             `SELECT * FROM invoices WHERE `
    //         )

    //         return responseHelper.successResponse(res, data);
    //     } catch (err) {
    //         logger.error(`location create > ${err}`);
    //         return responseHelper.serverErrorResponse(res, err);
    //     }
    // },

};

// TODO: JUST COPY PASTE DELET
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

    getAll: async (req, res) => {
        try {
            const [data] = await db.query(
                `select *
                from invoices a
                join trips b
                    on a.tripId = b.tripId`,
            );
            // console.log(data);

            return responseHelper.successResponse(res, data == null ? [] : data);
        } catch (err) {
            logger.error(`invoice getAll > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

};

module.exports = {
    adminCtrl,
    userCtrl,
};
