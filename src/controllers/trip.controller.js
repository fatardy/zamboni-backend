const { differenceInDays, differenceInHours } = require('date-fns');
const { loggers } = require('winston');
const { db } = require('../config/initializers/database');
const { getMysqlDate, dateDiffInMins } = require('../helpers/date.helper');
const schemaHelper = require('../helpers/schema.helper').trip;
const responseHelper = require('../helpers/response.helper');

const logger = loggers.get('logger');

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
                odoEnd,
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
                odoEnd,
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
                ${odoEnd},
                '${res.locals.user.userId}',
                '${pickLocId}',
                '${dropLocId}',
                ${coupId ? `'${coupId}'` : null},
                '${vehId}',
                ${true}
            );
            select last_insert_id();
            `;
            // console.log(q);
            const [insertData] = await db.query(q);
            // console.log('insertData', insertData);
            const tripId = insertData[1][0]['last_insert_id()'];
            // console.log('TRIP ID', tripId);

            const [data] = await db.query(`
                select *
                from trips a
                join locations_vehicleTypes b
                    on a.vehId = b.vehId
                join vehicleTypes c
                    on b.vtId = c.vtId
                left join coupons d
                    on a.coupId = d.coupId
                where a.tripId = ${tripId};
            `);

            // MULTIPLE `name`s in that return obj;
            const tripData = data[0];
            console.log(tripData);

            let totalAmount = 0;

            // TODO: fine for extra days

            const numberOfDays = parseInt(differenceInHours(
                tripData.dropDate,
                tripData.pickDate,
            ), 10) / 24;
            console.log('DAYS', numberOfDays);
            totalAmount = parseInt(numberOfDays, 10) * parseInt(tripData.rate, 10);
            console.log('total amount till days', totalAmount);

            const discountPercent = parseInt(tripData.percent, 10);
            console.log('discount percent', discountPercent);
            if (!Number.isNaN(discountPercent)) {
                // apply the coupon
                totalAmount -= ((totalAmount * discountPercent) / 100);
                console.log('inside discount percent', totalAmount);
            }
            const discountFlatRate = parseInt(tripData.flatRate, 10);
            console.log('flat', discountFlatRate);
            if (!Number.isNaN(discountFlatRate)) {
                // apply the coupon
                totalAmount -= discountFlatRate;
                console.log('in flat', totalAmount);
            }

            // check odoMeter readings, add the extras;
            const odoDiff = parseInt(tripData.odoEnd || 100, 10) - parseInt(tripData.odoStart, 10);
            console.log('odo diff', odoDiff);
            const odoLimitV = parseInt(tripData.odoLimit, 10);
            console.log('odo limi', odoLimitV);
            if (odoDiff > odoLimit) {
                // charge for the extra miles;
                const odoExtraAmount = (odoDiff - odoLimitV) * parseInt(tripData.overFee, 10);
                totalAmount += odoExtraAmount;
                console.log('extra', odoExtraAmount);
            }

            console.log('final amount', totalAmount);
            const [invoice] = await db.query(
                `INSERT INTO invoices (
                    invDate,
                    amount,
                    tripId
                ) VALUES (
                    '${getMysqlDate()}',
                    ${totalAmount},
                    '${tripId}'
                );`,
            );
            console.log('invoice', invoice);

            return responseHelper.successResponse(res, {
                invoice,
                amount: totalAmount,
            });
        } catch (err) {
            logger.error(`trip create > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

    getAllOfUser: async (req, res) => {
        const { userId } = res.locals.user;

        // const q = `
        //     select a.tripId, a.pickDate, a.dropDate, a.odoStart, a.odoEnd, a.inProgress,
        //         b.invId, b.invDate, b.amount,
        //         c.locId as "pickLocId", c.name as "pickLocName",
        //         d.locId as "dropLocId", d.name as "dropLocName",
        //         e.payId, e.payDate, e.amount as 'paidAmount', e.method, e.cardNo,
        //         f.vehId, f.make, f.model
        //     from trips as a
        //     left join invoices as b
        //         on a.tripId = b.tripId
        //     join locations as c
        //         on a.pickLocId = c.locId
        //     join locations as d
        //         on a.pickLocId = d.locId
        //     left join payments as e
        //         on b.invId = e.invId
        //     join locations_vehicleTypes f
        //         on a.vehId = f.vehId
        //     where a.userId = ${userId}
        //     order by a.inProgress desc;
        // `;
        const q = `call getAllTripsOfUser('${userId}');`;

        try {
            const [[data]] = await db.query(q);
            console.log(data);
            return responseHelper.successResponse(res, data == null ? [] : data);
        } catch (err) {
            logger.error(`trip getAllOfUser > ${err}`);
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
            const data = await db.query(
                `UPDATE trips SET
                    inProgress = 0,
                    odoEnd = ${odoEnd},
                    finalDropDate = '${finalDropDate}'
                    WHERE tripId = ${tripId}`,
            );
            return responseHelper.successResponse(res, data);
        } catch (err) {
            logger.error(`trip endTrip > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

};

const adminCtrl = {

    getAll: async (req, res) => {
        try {
            // const q = `
            //     select a.tripId, a.pickDate, a.dropDate, a.pickLocId,
            //         a.dropLocId, a.odoStart, a.odoEnd, a.odoLimit,
            //         b.userId, b.firstName, b.lastName,
            //         c.vehId, c.make, c.model,
            //         e.invId, e.invDate, e.amount,
            //         f.payId, f.amount as 'paidAmount', f.method, f.cardNo
            //     from trips a
            //     join users b
            //         on a.userId = b.userId
            //     join locations_vehicleTypes c
            //         on a.vehId = c.vehId
            //     join vehicleTypes d
            //         on c.vtId = d.vtId
            //     left join invoices e
            //         on a.tripId = e.tripId
            //     left join payments f
            //         on e.invId = f.invId;
            // `;
            const q = 'call adminGetAllTrips();';
            const [[data]] = await db.query(q);
            console.log(data);

            return responseHelper.successResponse(res, data == null ? [] : data);
        } catch (err) {
            logger.error(`trip getAll > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

};

module.exports = {
    adminCtrl,
    userCtrl,
};
