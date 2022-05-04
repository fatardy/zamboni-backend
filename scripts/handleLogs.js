const fs = require('fs-extra');

const logFiles = [
    './logs/combined.log',
    './logs/error.log',
    './logs/morgan.log',
];

logFiles.forEach((file) => {
    fs.writeFileSync(file, '', () => {});
});
