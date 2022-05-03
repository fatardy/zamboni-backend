/* eslint-disable max-len */

const CONSTANTS = require('../config/constants');

function getErrorResponseObject(opts) {
    let respObj = {
        error: {},
    };
    if (opts && opts.message) {
        respObj.error.message = opts.message;
    } else if (typeof opts === 'object') {
        respObj = opts;
    } else {
        respObj.error.message = opts;
    }
    respObj.status = false;
    return respObj;
}

const obj = {

    successResponse: (resp, data = {}) => resp.status(CONSTANTS.STATUS.SUCCESS).json({ status: true, data }),
    badRequestResponse: (resp, opts) => resp.status(CONSTANTS.STATUS.BAD_REQUEST).json(getErrorResponseObject(opts)),
    unAuthorizedResponse: (resp, opts) => resp.status(CONSTANTS.STATUS.UN_AUTHORIZED).json(getErrorResponseObject(opts)),
    serverErrorResponse: (resp, opts) => resp.status(CONSTANTS.STATUS.SERVER_ERROR).json(getErrorResponseObject(opts)),
    joiErrorResponse: (resp, error) => obj.badRequestResponse(resp, error),

};

module.exports = obj;
