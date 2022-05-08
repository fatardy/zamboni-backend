const { format, differenceInMinutes, parseISO } = require('date-fns');

/**
 * Gives you a mysql standard formatted datetime
 * e.g., 2018-08-08 23:00:00
 */
function getMysqlDate(date = new Date()) {
    return format(date, 'yyyy-MM-dd HH-mm-ss');
}

function addDays(days, date = new Date()) {
    const result = new Date(date);
    result.setDate(result.getDate() + days);
    return result;
}

function dateDiffInMins(start, end) {
    return differenceInMinutes(parseISO(end), parseISO(start));
}

module.exports = {
    getMysqlDate,
    addDays,
    dateDiffInMins,
};

// const d = getStandardFormattedDateTime();
// console.log(d);
// const twoDaysLater = addDays(10);
// console.log(getStandardFormattedDateTime(twoDaysLater));
