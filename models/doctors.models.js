const { pool } = require("../config/database.js");

const getAll = async (req, res, next) => {
  return await pool.query(
    "SELECT u.* FROM usuarios u JOIN usuario_rol ur ON u.id = ur.fk_usuario_id JOIN roles r ON ur.fk_rol_id = r.id WHERE r.id = 2"
  );
};
const getOne = async (req, res, next) => {
  return await pool.query("SELECT * FROM usuarios WHERE id = $1", [
    req.params.id,
  ]);
};
const create = async (doctor) => {
  // Encrypt the password
  const hashedPassword = await encryptPassword("123");
  // Insert the doctor into the database
  const insertDoctor = await pool.query(
    "INSERT INTO usuarios (rut, email, clave, nom, ap_paterno, ap_materno, fec_nacimiento, telefono, is_active) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, 0) RETURNING id,rut, email, CONCAT(nom ,' ', ap_paterno,' ', ap_materno) AS fullName",
    [
      doctor.rut,
      doctor.email,
      hashedPassword,
      doctor.name,
      doctor.patSurName,
      doctor.matSurName,
      doctor.dateBirth,
      doctor.cellphone,
    ]
  );
  // Return the doctor data
  const { id, rut, email, fullName } = insertDoctor.rows[0];
  // Insert the doctor role
  await pool.query(
    "INSERT INTO usuario_rol (fk_usuario_id, fk_rol_id) VALUES ($1, $2)",
    [id, 2]
  );
  // Insert the doctor speciality
  await pool.query(
    "INSERT INTO doctor_especialidad (fk_doctor_id, fk_especialidad_id) VALUES ($1, $2)",
    [id, doctor.speciality]
  );

  // Return the doctor data
  return {
    status: "success",
    data: { id, rut, email, fullName, role: "doctor" },
  };
};

module.exports = { getAll, getOne, create };
