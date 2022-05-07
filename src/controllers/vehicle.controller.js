const { loggers } = require('winston');
const { db } = require('../config/initializers/database');
const schemaHelper = require('../helpers/schema.helper').vehicle;
const responseHelper = require('../helpers/response.helper');

const logger = loggers.get('logger');

const userCtrl = {

    getAvailable: async (req, res) => {
        try {
            const [data] = await db.query(
                `select b.locId as 'locId', b.name as 'locName', 
                    c.vtId as 'vtId', c.name as 'vehName', c.rate, c.overFee, 
                    a.vehId, a.make, a.model, a.licensePlate
                from locations_vehicleTypes as a
                join locations as b
                    on a.locId = b.locId
                join vehicleTypes as c
                    on a.vtId = c.vtId
                where a.vehId not in (
                    select vehId
                    from trips a
                    where a.inProgress = true    
                );`,
            );
            // console.log(data);

            return responseHelper.successResponse(res, data);
        } catch (err) {
            logger.error(`vehicle create > ${err}`);
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
            vehId,
            make,
            model,
            licensePlate,
            locId,
            vtId,
        } = value;

        try {
            const q = `INSERT INTO locations_vehicleTypes (
                vehId,
                make,
                model,
                licensePlate,
                locId,
                vtId
            ) VALUES (
                '${vehId}',
                '${make || ''}',
                '${model || ''}',
                '${licensePlate || ''}',
                ${locId},
                ${vtId}
            );`;
            console.log(q);
            const [data] = await db.query(q);

            return responseHelper.successResponse(res, data);
        } catch (err) {
            logger.error(`vehicle create > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

    update: async (req, res) => {
        const { error, value } = schemaHelper.update.validate(req.body);
        if (error) {
            return responseHelper.joiErrorResponse(res, error);
        }
        const {
            vehId,
            make,
            model,
            licensePlate,
            locId,
            vtId,
        } = value;

        try {
            const q = `UPDATE locations_vehicleTypes SET
                make = '${make || ''}', 
                model = '${model || ''}', 
                licensePlate = '${licensePlate || ''}', 
                locId = ${locId}, 
                vtId = ${vtId}
                WHERE vehId = '${vehId}';`;

            console.log(q);
            const [data] = await db.query(q);

            // console.log(data);

            return responseHelper.successResponse(res, data);
        } catch (err) {
            logger.error(`vehicle update > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

    getAll: async (req, res) => {
        try {
            const [data] = await db.query(
                'SELECT * FROM locations_vehicleTypes;',
            );
            // console.log(data);

            return responseHelper.successResponse(res, data == null ? [] : data);
        } catch (err) {
            logger.error(`vehicle getAll > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

    delete: async (req, res) => {
        const { vehId } = req.params;
        try {
            const [data] = await db.query(
                `DELETE FROM locations_vehicleTypes WHERE vehId = '${vehId}';`,
            );
            return responseHelper.successResponse(res, data);
        } catch (err) {
            logger.error(`vehicle delete > ${err}`);
            return responseHelper.serverErrorResponse(res, err);
        }
    },

};

module.exports = {
    adminCtrl,
    userCtrl,
};
