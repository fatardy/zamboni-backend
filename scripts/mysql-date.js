// import { format } from 'date-fns';

const { format, differenceInMinutes, parseISO } = require('date-fns');

/**
 * Gives you a mysql standard formatted datetime
 * e.g., 2018-08-08 23:00:00
 */
function getStandardFormattedDateTime(date = new Date()) {
    return format(date, 'yyyy-MM-dd HH-mm-ss');
}

function addDays(days, date = new Date()) {
    const result = new Date(date);
    result.setDate(result.getDate() + days);
    return result;
}

const now = getStandardFormattedDateTime();
console.log(now);
const twoDaysLater = addDays(10);
const later = getStandardFormattedDateTime(twoDaysLater);
console.log(later);

// const diff = differenceInMinutes(parseISO(later), parseISO(now));
// console.log(diff / 60 / 24);
