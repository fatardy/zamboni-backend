const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const http = require('http');
const morgan = require('morgan');
const winston = require('winston');
const sanitize = require('sanitize');

const constants = require('../constants');
const userApi = require('../../routes/user');
const adminApi = require('../../routes/admin');

const morganLogger = winston.loggers.get('morganLogger');
const logger = winston.loggers.get('logger');

function bodyParserErrorChecker(err, req, res, next) {
    if (err instanceof SyntaxError) {
        return res
            .status(constants.STATUS.BAD_REQUEST)
            .json({
                status: false,
                error: {
                    message: 'Syntax error in the request',
                },
            });
    }
    return next();
}

function apiNotFound(req, res) {
    return res
        .status(constants.STATUS.NOT_FOUND)
        .json({
            status: false,
            error: {
                message: 'No dragons in this mire',
            },
        });
}

function main() {
    return new Promise((resolve, reject) => {
        const app = express();

        app.use(cors({
            origin: [
                'http://localhost:3000',
                'http://localhost:4200',
            ],
            credentials: true,
        }));
        app.options('*', cors());
        app.disable('etag');
        app.set('etag', false);

        app.use(express.urlencoded({ extended: true }));
        app.use(express.json());
        app.use(express.raw());
        app.use(bodyParserErrorChecker);

        app.use(helmet());

        app.use(sanitize.middleware);

        app.use(morgan('combined', {
            stream: { write: (msg) => morganLogger.info(msg.trim()) },
        }));
        app.use(morgan('dev', {
            stream: { write: (msg) => logger.info(msg.trim()) },
        }));

        app.use('/api/admin', adminApi);
        app.use('/api/user', userApi);
        app.use('/', apiNotFound);

        const server = http.createServer(app);
        server.listen(process.env.PORT, (err) => {
            if (err) {
                return reject(new Error(`Error on server.listen - ${err}`));
            }

            logger.info(`:.. Dragons on ..: ${process.env.PORT}`);
            return resolve();
        });
    });
}

module.exports = main;
