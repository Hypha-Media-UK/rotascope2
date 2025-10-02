"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.dbConfig = void 0;
exports.dbConfig = {
    host: process.env.DB_HOST || 'localhost',
    port: parseInt(process.env.DB_PORT || '3307'),
    user: process.env.DB_USER || 'rotascope_user',
    password: process.env.DB_PASSWORD || 'rotascope_password',
    database: process.env.DB_NAME || 'rotascope',
    charset: 'utf8mb4',
    timezone: '+00:00'
};
//# sourceMappingURL=database.js.map