const pg = require("pg");

const pool = new pg.Pool({
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  database: process.env.DB_DATABASE,
  // SSL connection for production environment only
  // ssl: true,
});
module.exports = { pool };
