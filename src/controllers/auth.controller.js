const { loggers } = require('winston');
const { db } = require('../config/initializers/database');
const schemaHelper = require('../helpers/schema.helper').auth;
const responseHelper = require('../helpers/response.helper');
const tokenHelper = require('../helpers/jwt.helper');

const logger = loggers.get('logger');

function generateOtp() {
    return Math.floor(100000 + Math.random() * 900000).toString();
}

async function updateOtpForUser(email, userId) {
    const otp = generateOtp();
    logger.info(`email > ${email}, OTP > ${otp}`);

    try {
        const q = `REPLACE INTO otps (otp, userId) VALUES ('${otp}', '${userId}')`;
        // const [data] = await db.query(q);
        return db.query(q);
    } catch (err) {
        logger.error(`auth updateOtpForUser > ${err}`);
    }

    return false;
}

const userCtrl = {

    authorize: async (req, res) => {
        const { error, value } = schemaHelper.authorize.validate(req.body);
        if (error) {
            return responseHelper.joiErrorResponse(res, error);
        }
        const {
            email,
            deviceId,
        } = value;

        try {
            let userId;
            const [user] = await db.query(
                `SELECT * FROM users WHERE email='${email}' LIMIT 1;`,
            );

            if (user.length === 0) {
                const [newUser] = await db.query(
                    `INSERT INTO users (email, deviceId) VALUES ('${email}', '${deviceId}')`,
                );
                userId = newUser.insertId;
            } else {
                userId = user[0].userId;
            }

            await updateOtpForUser(email, userId);
            // TODO: send email aws

            return responseHelper.successResponse(res);
        } catch (err) {
            logger.error(`auth authorize > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

    sendOtp: async (req, res) => {
        const { error, value } = schemaHelper.sendOtp.validate(req.body);
        if (error) {
            return responseHelper.joiErrorResponse(res, error);
        }
        const { email } = value;

        try {
            const [user] = await db.query(
                `SELECT * FROM users WHERE email='${email}' LIMIT 1;`,
            );

            if (user.length === 0) {
                return responseHelper.badRequestResponse(res, 'Please authorize your email first..');
            }
            const { userId } = user[0];

            await updateOtpForUser(email, userId);
            // TODO: send email aws

            return responseHelper.successResponse(res);
        } catch (err) {
            logger.error(`auth sendOtp > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

    verifyOtp: async (req, res) => {
        const { error, value } = schemaHelper.verifyOtp.validate(req.body);
        if (error) {
            return responseHelper.joiErrorResponse(res, error);
        }
        const {
            email,
            deviceId,
            otp,
        } = value;

        try {
            const [user] = await db.query(
                `SELECT u.userId, u.email, o.otp FROM users as u
                LEFT JOIN otps as o
                ON u.userId = o.userId
                WHERE u.email = '${email}';`,
            );

            if (user.length === 0) {
                return responseHelper.badRequestResponse(res, 'Email not found.. Please authorize first.');
            }

            const { userId, otp: dbOtp } = user[0];

            if (dbOtp == null) {
                return responseHelper.badRequestResponse(res, 'OTP has expired.. Please click on resend OTP');
            }

            // storing in the db as a number for some reason;
            if (dbOtp !== parseInt(otp, 10)) {
                return responseHelper.badRequestResponse(res, 'Ooops! Wrong OTP, please try again..');
            }

            // TODO: update deviceID

            await db.query(
                `DELETE FROM otps WHERE userId = ${userId};`,
            );

            return responseHelper.successResponse(res, user[0]);
        } catch (err) {
            logger.error(`auth verifyOtp > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

};
const adminCtrl = {};

module.exports = {
    userCtrl,
    adminCtrl,
};
