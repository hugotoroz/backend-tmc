const { pool } = require("../config/database.js");
const { encryptPassword } = require("../config/password");
const { APPOINTMENTS_STATUS } = require("../constants/users.constant");
const { AppError } = require("../middleware/errors.middleware");

const getAll = async (req, res, next) => {
  return await pool.query("SELECT * FROM public.doctores WHERE is_row = 1");
};
const getSpecialities = async (req, res, next) => {
  return await pool.query("SELECT * FROM especialidad");
};
const getAllDoctorSpecialities = async (specialities) => {
  return await pool.query(
    `SELECT * FROM especialidad WHERE id IN (${specialities.join(",")})`
  );
};
const getOne = async (req, res, next) => {
  return await pool.query("SELECT * FROM usuarios WHERE id = $1", [
    req.params.id,
  ]);
};

const create = async (doctor) => {
  try {
    // Encrypt the password
    const hashedPassword = await encryptPassword(doctor.password);
    // Look the RUT in the database
    const rutExist = await pool.query("SELECT * FROM usuarios WHERE rut = $1", [
      doctor.rut,
    ]);
    if (rutExist.rows.length > 0) {
      return { status: "error", message: "El RUT ya está registrado" };
    }
    // Look the email in the database
    const emailExist = await pool.query(
      "SELECT * FROM usuarios WHERE email = $1",
      [doctor.email]
    );
    if (emailExist.rows.length > 0) {
      return { status: "error", message: "El correo ya está registrado" };
    }
    // Insert the doctor into the database
    const insertDoctor = await pool.query(
      "INSERT INTO usuarios (rut, email, clave, nom, ap_paterno, ap_materno, fec_nacimiento, telefono, genero, is_active, is_row) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, 1, 1) RETURNING id,rut, email, CONCAT(nom ,' ', ap_paterno,' ', ap_materno) AS full",
      [
        doctor.rut,
        doctor.email,
        hashedPassword,
        doctor.name,
        doctor.patSurName,
        doctor.matSurName,
        doctor.dateBirth,
        doctor.cellphone,
        doctor.genre,
      ]
    );
    // Return the doctor data
    const { id, rut, email, full } = insertDoctor.rows[0];
    // Insert the doctor role
    await pool.query(
      "INSERT INTO usuario_rol (fk_usuario_id, fk_rol_id) VALUES ($1, $2)",
      [id, 2]
    );
    // Insert the doctor specialities
    const client = await pool.connect();
    await client.query("BEGIN");
    for (const specialityId of doctor.specialities) {
      await client.query(
        `INSERT INTO doctor_especialidad (fk_doctor_id, fk_especialidad_id) 
         VALUES ($1, $2)`,
        [id, specialityId]
      );
    }
    await client.query("COMMIT");

    // Return the doctor data
    return {
      status: "success",
      data: { id, rut, email, full, role: "doctor" },
    };
  } catch (error) {
    return error;
  }
};

const cancelAppointment = async (appointment) => {
  try {
    // Buscar la cita
    const appointmentExist = await pool.query(
      "SELECT * FROM citas WHERE id = $1",
      [appointment.appointmentId]
    );
    if (appointmentExist.rows.length === 0) {
      throw new AppError("La cita no existe", 404);
    }
    // Obtener fk_estado_cita_id
    const appointmentStatus = appointmentExist.rows[0].fk_estado_cita_id;
    // Validar que la cita no haya sido cancelada por el doctor o por el paciente
    if (appointmentStatus == APPOINTMENTS_STATUS.CANCELLED_BY_DOCTOR || appointmentStatus == APPOINTMENTS_STATUS.CANCELLED_BY_PATIENT) {
      throw new AppError("La cita ya fue cancelada", 400);
    }
    // Validar que una cita completada o en curso no pueda ser cancelada
    if (appointmentStatus == APPOINTMENTS_STATUS.COMPLETED || appointmentStatus == APPOINTMENTS_STATUS.IN_PROGRESS) {
      throw new AppError("La cita no puede ser cancelada porque está completada o en progreso", 400);
    }
    await pool.query("UPDATE citas SET fk_estado_cita_id = $1  WHERE id = $2", [
      APPOINTMENTS_STATUS.CANCELLED_BY_DOCTOR,
      appointment.appointmentId,
    ]);
    return { status: "success", message: "Cita cancelada exitosamente" };
  } catch (error) {
    throw new AppError(error.message, 500);
  }
};

module.exports = {
  getAll,
  getOne,
  getSpecialities,
  getAllDoctorSpecialities,
  create,
  cancelAppointment,
};
