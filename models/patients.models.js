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
const create = async (patient) => {
  // Encrypt the password
  const hashedPassword = await encryptPassword(patient.password);
  // Insert the patient into the database
  const insertPatient = await pool.query(
    "INSERT INTO usuarios (rut, email, clave, nom, ap_paterno, ap_materno, fec_nacimiento, telefono) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING id,rut, email, CONCAT(nom ,' ', ap_paterno,' ', ap_materno) AS full",
    [
      patient.rut,
      patient.email,
      hashedPassword,
      patient.name,
      patient.patSurName,
      patient.matSurName,
      patient.dateBirth,
      patient.cellphone,
    ]
  );
  // Return the patient data
  const { id, rut, email, full } = insertPatient.rows[0];
  // Insert the patient role
  await pool.query(
    "INSERT INTO usuario_rol (fk_usuario_id, fk_rol_id) VALUES ($1, $2)",
    [id, 3]
  );

  // Return the patient data
  return { id, rut, email, full, role: "paciente" };
};

module.exports = { getAll, getOne, create };
