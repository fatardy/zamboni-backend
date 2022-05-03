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
        const q = `INSERT INTO otps (otp, userId) VALUES ('${otp}', '${userId}')`;
        // const [data] = await db.query(q);
        return db.query(q);
    } catch (err) {
        logger.error(`auth updateOtpForUser > ${err}`);
    }
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

            return responseHelper.successResponse(res);
        } catch (err) {
            logger.error(`auth authorize > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

};
const adminCtrl = {};

module.exports = {
    userCtrl,
    adminCtrl,
};
