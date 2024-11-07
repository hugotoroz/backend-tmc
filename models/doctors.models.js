const { pool } = require("../config/database.js");
const { encryptPassword } = require("../config/password");

const getAll = async (req, res, next) => {
  return await pool.query(
    "SELECT * FROM public.doctores WHERE is_active = 1"
  );
};
const getSpecialities = async (req, res, next) => {
  return await pool.query("SELECT * FROM especialidad");
};
const getOne = async (req, res, next) => {
  return await pool.query("SELECT * FROM usuarios WHERE id = $1", [
    req.params.id,
  ]);
};
const getAppointments = async (doctorId) => {
  return await pool.query("select d.fecha,d.hora_inicio,d.hora_fin,c.fecha_agendada,c.fk_especialidad_id as id_especialidad, e.nom as nombre_especialidad,ec.nombre as estado,p.id as id_paciente, p.rut as rut_paciente, CONCAT(p.nom,' ',p.ap_paterno,' ',p.ap_materno) AS nombre_paciente from disponibilidad d left join citas c on d.id = c.fk_disponibilidad_id left join estados_cita ec on c.fk_estado_cita_id = ec.id left join especialidad e on c.fk_especialidad_id = e.id left join public.pacientes p on c.fk_paciente_id = p.id where d.fk_doctor_id = $1", [
    doctorId,
  ]);
};


const create = async (doctor) => {
  // Encrypt the password
  const hashedPassword = await encryptPassword("123");
  // Insert the doctor into the database
  const insertDoctor = await pool.query(
    "INSERT INTO usuarios (rut, email, clave, nom, ap_paterno, ap_materno, fec_nacimiento, telefono, is_active) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, 0) RETURNING id,rut, email, CONCAT(nom ,' ', ap_paterno,' ', ap_materno) AS full",
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
  const { id, rut, email, full } = insertDoctor.rows[0];
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
    data: { id, rut, email, full, role: "doctor" },
  };
};

module.exports = { getAll, getOne, getSpecialities, create, getAppointments };
