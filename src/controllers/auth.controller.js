const { loggers } = require('winston');
const { db } = require('../config/initializers/database');
const schemaHelper = require('../helpers/schema.helper').auth;
const responseHelper = require('../helpers/response.helper');
const jwtHelper = require('../helpers/jwt.helper');

const logger = loggers.get('logger');

function generateOtp() {
    return Math.floor(100000 + Math.random() * 900000).toString();
}

async function generateAccessToken(req, res) {
    const { user } = res.locals;
    if (!user) {
        logger.error('auth generateAccessToken error');
        return responseHelper.badRequestResponse(res, 'generateAccessToken error');
    }

    // TODO: add deviceId also, so you can only login from one place;
    const token = jwtHelper.createAccessToken({ userId: user.userId });

    let isNewUser = false;
    if (!user.firstName) {
        isNewUser = true;
    }

    return res.json({
        status: true,
        isNewUser,
        data: user,
        access_token: token,
    });
}

function protectRoutes({ checkAdmin = false }) {
    return async function cb(req, res, next) {
        const token = req.headers.access_token;
        if (!token) {
            return responseHelper.unAuthorizedResponse(res, 'Where is token, chinnaw?');
        }

        let decoded;
        try {
            decoded = jwtHelper.verifyAccessToken(token);
        } catch (err) {
            logger.error(`ERR auth protect verify > ${err}`);
            return responseHelper.unAuthorizedResponse(res, `Token verification failed - ${err}`);
        }

        try {
            const [[userData]] = await db.query(
                `SELECT * FROM users
                WHERE userId = ${decoded.userId}
                LIMIT 1;`,
            );
            // if userData is empty, it will be undefined;
            if (userData == null) {
                return responseHelper.unAuthorizedResponse(res, 'Invalid user. User is null, chinnaw?');
            }

            if (checkAdmin) {
                const [adminData] = await db.query(
                    `SELECT * FROM admins WHERE userId = ${decoded.userId}`,
                );

                console.log('adminData', adminData);

                const { isAdmin } = adminData[0];
                if (!isAdmin) {
                    return responseHelper.unAuthorizedResponse(res, 'Not admin, want to see :O');
                }
            }

            res.locals.decoded = decoded;
            res.locals.user = userData;

            return next();
        } catch (err) {
            logger.error(`ERR auth protect find > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    };
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

    generateAccessToken,

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

    verifyOtp: async (req, res, next) => {
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

            // eslint-disable-next-line prefer-destructuring
            res.locals.user = user[0];

            return next();
        } catch (err) {
            logger.error(`auth verifyOtp > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

    verifyAdminAccess: async (req, res, next) => {
        const { userId } = res.locals.user;

        try {
            const [data] = await db.query(
                `SELECT * FROM admins WHERE userId = ${userId}`,
            );
            // console.log(data);

            if (data.length === 0) {
                return responseHelper.badRequestResponse(res, 'Not Admin, cannot a see..');
            }

            return next();
        } catch (err) {
            logger.error(`auth verifyAdminAccess > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

};

const adminCtrl = {

    generateAccessToken,

};

module.exports = {
    userCtrl,
    adminCtrl,
    protectRoutes,
};
