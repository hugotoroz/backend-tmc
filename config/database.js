const pg = require("pg");

const pool = new pg.Pool({
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  database: process.env.DB_DATABASE,
  ssl: process.env.DB_SSL === 'true' ? true : false,
});
module.exports = { pool };
