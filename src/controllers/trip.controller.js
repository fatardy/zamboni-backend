const { loggers } = require('winston');
const { db } = require('../config/initializers/database');
const { getMysqlDate, dateDiffInMins } = require('../helpers/date.helper');
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

    // ONLY TAKES inProgress = 1; 0 returns all the trips!
    getAllOfUser: async (req, res) => {
        const { inProgress } = req.query;
        const { userId } = res.locals.user;

        // let q = `
        //     SELECT *
        //     FROM trips as a
        //     left join invoices as b
        //         on a.tripId = b.tripId
        //     WHERE userId = ${userId};`;

        // // pointedly using a == over ===
        // // eslint-disable-next-line eqeqeq
        // if (inProgress == 1) {
        //     q = `
        //         select *
        //         from trips as a
        //         left join invoices as b
        //             on a.tripId = b.tripId
        //         where a.userId = ${userId} and inProgress = ${inProgress};
        //     `;
        // }
        const q = `
        select a.tripId, a.pickDate, a.dropDate, a.odoStart, a.odoEnd, a.inProgress,
            b.invId, b.invDate, b.amount,
            c.locId as "pickLocId", c.name as "pickLocName",
            d.locId as "dropLocId", d.name as "dropLocName"
        from trips as a
        left join invoices as b
            on a.tripId = b.tripId
        join locations as c
            on a.pickLocId = c.locId
        join locations as d
            on a.pickLocId = d.locId
        where a.userId = 2
        order by a.inProgress desc;
        `;

        try {
            const [data] = await db.query(q);
            // console.log(data);

            return responseHelper.successResponse(res, data == null ? [] : data);
        } catch (err) {
            logger.error(`location getAll > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

    endTrip: async (req, res) => {
        const { error, value } = schemaHelper.endTrip.validate(req.body);
        if (error) {
            return responseHelper.joiErrorResponse(res, error);
        }
        const {
            tripId,
            odoEnd,
            finalDropDate,
        } = value;

        try {
            await db.query(
                `UPDATE trips SET
                    inProgress = 0,
                    odoEnd = ${odoEnd},
                    finalDropDate = '${finalDropDate}'
                    WHERE tripId = ${tripId}`,
            );
            const [data] = await db.query(`SELECT * FROM trips WHERE tripId = ${tripId}`);
            console.log(data);

            const totalAmount = 0;
            // put the start date in first param;
            const diff = dateDiffInMins(new Date(), finalDropDate);
            if (diff < 0) {
                // user has crossed the booking;
            } else {
                // charge full amount
            }

            // add coupon discount;

            // check odoMeter readings, add the extras;

            const [invoice] = await db.query(
                `INSERT INTO invoices (
                    invDate,
                    amount,
                    tripId
                    ${totalAmount},
                ) VALUES (
                    ${getMysqlDate()},
                    '${tripId}'
                );`,
            );
            console.log('invoice', invoice);

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
