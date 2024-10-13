const { pool } = require("../config/database.js");
const { encryptPassword } = require("../config/password");

const getAll = async (req, res, next) => {
  return await pool.query(
    "SELECT u.* FROM usuarios u JOIN usuario_rol ur ON u.id = ur.fk_usuario_id JOIN roles r ON ur.fk_rol_id = r.id WHERE r.id = 3"
  );
};
const getOne = async (req, res, next) => {
  return await pool.query("SELECT * FROM usuarios WHERE id = $1", [
    req.params.id,
  ]);
};
const create = async (req, res, next) => {
  return await pool.query(
    "INSERT INTO usuarios (rut, email, password, nombre, ap_paterno, ap_materno, fec_nacimiento, telefono) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *",
    [
      req.body.rut,
      req.body.email,
      encryptPassword(req.body.password),
      req.body.name,
      req.body.patSurName,
      req.body.matSurName,
      req.body.dateBirth,
      req.body.cellphone,
    ]
  );
};

module.exports = { getAll, getOne, create };
