const bcryptjs = require("bcryptjs");
const { pool } = require("../config/database.js");


const getAll = async (req, res, next) => {
  return await pool.query("SELECT * FROM pacientes");
};
const getOne = async (req, res, next) => {
  return await pool.query("SELECT * FROM pacientes WHERE id = $1", [
    req.params.id,
  ]);
};
const create = async (req, res, next) => {
  return null
}

module.exports = { getAll, getOne, create };
