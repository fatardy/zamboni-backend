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

const diff = differenceInMinutes(parseISO('2022-05-17T22:01:32.000Z'), parseISO('2022-05-08T02:02:07.000Z'));
console.log(diff / 60 / 24);
