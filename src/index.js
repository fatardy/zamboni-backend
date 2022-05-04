const dotenv = require('dotenv');
const winston = require('winston');

const initializeLogger = require('./config/initializers/logger');

initializeLogger();

const { initializeDatabase } = require('./config/initializers/database');
const initializeServer = require('./config/initializers/server');
const initializeCrons = require('./config/initializers/crons');

dotenv.config();

const logger = winston.loggers.get('logger');

logger.info(':.. Zamboni Rentals ');

process.on('unhandledRejection', (reason, p) => {
    logger.error(`Unhandled rejection at: Promise ${p}, reason ${reason}`);
});
process.on('uncaughtException', (error) => {
    logger.error(`Uncaught exception error: ${error.message}`);
});

async function start() {
    try {
        await initializeDatabase();
        await initializeServer();
        await initializeCrons();
    } catch (error) {
        logger.error(`Initialization failed: ${error}`);
    }
}

start();
