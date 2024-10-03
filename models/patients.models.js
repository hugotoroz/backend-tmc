const bcryptjs = require("bcryptjs");
const { pool } = require("../config/database.js");


const getAll = async (req, res, next) => {
  return await pool.query("SELECT u.* FROM usuarios u JOIN usuario_rol ur ON u.id = ur.fk_usuario_id JOIN roles r ON ur.fk_rol_id = r.id WHERE r.id = 3");
};
const getOne = async (req, res, next) => {
  return await pool.query("SELECT * FROM usuarios WHERE id = $1", [
    req.params.id,
  ]);
};
const create = async (req, res, next) => {
  return null
}

module.exports = { getAll, getOne, create };
