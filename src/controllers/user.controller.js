const { loggers } = require('winston');
const { db } = require('../config/initializers/database');
const schemaHelper = require('../helpers/schema.helper').user;
const responseHelper = require('../helpers/response.helper');

const logger = loggers.get('logger');

const adminCtrl = {

    getAll: async (req, res) => {
        try {
            const [data] = await db.query(
                `select * 
                from users`,
            );
            // console.log(data);

            return responseHelper.successResponse(res, data == null ? [] : data);
        } catch (err) {
            logger.error(`trip getAll > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

    makeAdmin: async (req, res) => {
        const { error, value } = schemaHelper.makeAdmin.validate(req.body);
        if (error) {
            return responseHelper.joiErrorResponse(res, error);
        }
        const {
            userId,
        } = value;

        try {
            const [data] = await db.query(
                `UPDATE users SET 
                    userType = 'A'
                    WHERE userId = ${userId};`,
            );
            await db.query(
                `insert into admins (
                    userId,
                    isAdmin
                ) values (
                    ${userId},
                    1
                );`,
            );

            // console.log(data);

            return responseHelper.successResponse(res, data.info);
        } catch (err) {
            logger.error(`auth makeAdmin > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

};

const userCtrl = {

    getUserData: (_, res) => responseHelper.successResponse(res, res.locals.user),

    editUser: async (req, res) => {
        const { error, value } = schemaHelper.edit.validate(req.body);
        if (error) {
            return responseHelper.joiErrorResponse(res, error);
        }
        const {
            firstName,
            lastName,
            phoneNumber,
            street1,
            street2,
            city,
            stateName,
            zipCode,
            country,
            deviceId,
            avatar,
        } = value;

        try {
            const [data] = await db.query(
                `UPDATE users SET 
                    firstName = '${firstName || ''}', 
                    lastName = '${lastName || ''}', 
                    phoneNumber = '${phoneNumber || 0}', 
                    street1 = '${street1 || ''}', 
                    street2 = '${street2 || ''}', 
                    city = '${city || ''}', 
                    stateName = '${stateName || ''}',
                    zipCode = '${zipCode || ''}',
                    country = '${country || ''}',
                    deviceId = '${deviceId || ''}',
                    avatar = '${avatar || ''}'
                    WHERE userId = ${res.locals.user.userId};`,
            );

            // console.log(data);

            return responseHelper.successResponse(res, data.info);
        } catch (err) {
            logger.error(`auth authorize > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

};

module.exports = {
    userCtrl,
    adminCtrl,
};
