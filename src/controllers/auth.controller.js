const { loggers } = require('winston');
const schemaHelper = require('../helpers/schema.helper').auth;
const responseHelper = require('../helpers/response.helper');
const tokenHelper = require('../helpers/jwt.helper');

const logger = loggers.get('logger');

const userCtrl = {

    authorize: async (req, res) => {
        const { error, value } = schemaHelper.authorize.validate(req.body);
        if (error) {
            return responseHelper.joiErrorResponse(res, error);
        }
        const {
            email,
            // deviceId,
        } = value;

        try {
            // check if user exists
            // if he doesnt, create,
            // create otp
            // save otp for user
            // send response
        } catch (err) {

        }
    },

};
const adminCtrl = {};

module.exports = {
    userCtrl,
    adminCtrl,
};
