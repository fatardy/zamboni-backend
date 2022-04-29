const winston = require('winston');
const { format } = require('date-fns');

const { combine, printf, colorize } = winston.format;

const theFormat = printf((info) => `[${format(new Date(), 'dd-MMM-yyyy h:mm:ssa')}] ${info.level} ${info.message}`);

function main() {
  winston.loggers.add('logger', {
    format: combine(colorize(), theFormat),
    transports: [
      new winston.transports.File({ filename: './logs/error.log', level: 'error' }),
      new winston.transports.File({ filename: './logs/combined.log' }),
      new winston.transports.Console(),
    ],
    exitOnError: false,
  });
  winston.loggers.add('morganLogger', {
    format: combine(theFormat),
    transports: [
      new winston.transports.File({ filename: './logs/morgan.log' }),
    ],
    exitOnError: false,
  });
}

module.exports = main;
