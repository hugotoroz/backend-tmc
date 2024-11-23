const { pool } = require("../config/database.js");
const { APPOINTMENTS_STATUS } = require("../constants/users.constant");
const emailService = require("../config/email/email.config.js");
const { AppError } = require("../middleware/errors.middleware");

const { formatearFecha } = require("../utils/dates.js");

const getDoctorAppointments = async (doctorId) => {
  return await pool.query(`select * from citas_medicas where id_doctor = $1`, [
    doctorId,
  ]);
};
const getPatientsAppointments = async (patientId) => {
  return await pool.query(
    `select * from citas_medicas where id_paciente = $1`,
    [patientId]
  );
};

const getFilteredAppointments = async (filters) => {
  let queryConditions = [];
  let queryParams = [];
  let paramCounter = 1;

  // Construir condiciones de búsqueda dinámicamente
  if (filters.specialityId) {
    queryConditions.push(`id_especialidad = $${paramCounter}`);
    queryParams.push(filters.specialityId);
    paramCounter++;
  }

  if (filters.date) {
    queryConditions.push(`fecha = $${paramCounter}`);
    queryParams.push(filters.date);
    paramCounter++;
  }

  if (filters.doctorId) {
    queryConditions.push(`id_doctor = $${paramCounter}`);
    queryParams.push(filters.doctorId);
    paramCounter++;
  }

  // Build the base query
  let query = "SELECT * FROM citas_medicas";

  // Add WHERE conditions if filters exist
  if (queryConditions.length > 0) {
    query += ` WHERE ${queryConditions.join(" AND ")}`;
  }

  // Add patient is null to filter only available appointments
  // Add ORDER BY fecha to sort the results
  query += " AND id_paciente IS NULL ORDER BY fecha";

  return await pool.query(query, queryParams);
};
// Create an appointment
const createAppointment = async (appointment) => {
  try {
    const { patientId, availabilityId } = appointment;

    // 1. Verificar que la disponibilidad existe
    const getData = await pool.query(
      `SELECT fk_doctor_id, fk_especialidad_id FROM disponibilidad WHERE id = $1`,
      [availabilityId]
    );

    // Validación de disponibilidad
    if (!getData.rows || getData.rows.length === 0) {
      throw new AppError("La disponibilidad especificada no existe", 404);
    }

    const specialityId = getData.rows[0].fk_especialidad_id;
    const doctorId = getData.rows[0].fk_doctor_id;

    // 2. Verificar cita existente
    const appointmentExists = await pool.query(
      `SELECT * FROM citas WHERE fk_doctor_id = $1 AND fk_disponibilidad_id = $2`,
      [doctorId, availabilityId]
    );

    if (appointmentExists.rows.length > 0) {
      throw new AppError("Ya existe una cita para esta disponibilidad", 400);
    }

    // 3. Insertar la nueva cita
    const insert = await pool.query(
      `INSERT INTO citas (
        fk_doctor_id, 
        fk_paciente_id, 
        fk_disponibilidad_id, 
        fk_especialidad_id, 
        fk_estado_cita_id
      ) VALUES ($1, $2, $3, $4, $5) 
      RETURNING id`,
      [
        doctorId,
        patientId,
        availabilityId,
        specialityId,
        APPOINTMENTS_STATUS.CONFIRMED,
      ]
    );

    // Validación de inserción
    if (!insert.rows || insert.rows.length === 0) {
      throw new AppError("Error al insertar la cita", 500);
    }

    const appointmentId = insert.rows[0].id;

    // 4. Obtener datos de la cita
    const getAppointmentData = await pool.query(
      `SELECT * FROM citas_medicas WHERE id_cita = $1`,
      [appointmentId]
    );

    // Validación de datos de la cita
    if (!getAppointmentData.rows || getAppointmentData.rows.length === 0) {
      throw new AppError("No se encontraron los datos de la cita creada", 404);
    }

    const appointmentData = getAppointmentData.rows[0];

    // 5. Preparar respuesta
    const fecha = formatearFecha(appointmentData.fecha);

    const json = {
      patientName: appointmentData.nombre_paciente,
      patientEmail: appointmentData.email_paciente,
      date: fecha,
      time: appointmentData.hora_inicio,
      doctorName: "Dr. " + appointmentData.nombre_doctor,
      specialty: appointmentData.nombre_especialidad,
    };

    // 6. Enviar email
    emailService.sendAppointmentConfirmation(json);

    return json;
  } catch (error) {
    throw new AppError(error.message, 500);
  }
};
const finishAppointment = async (appointment, url) => {
  try {
    // 1. Verificar que la cita existe
    const getAppointment = await pool.query(
      `SELECT * FROM citas WHERE id = $1`,
      [appointment.appointmentId]
    );

    if (!getAppointment.rows || getAppointment.rows.length === 0) {
      throw new AppError("La cita especificada no existe", 404);
    }

    // 2. Actualizar el estado de la cita
    const update = await pool.query(
      `UPDATE citas SET fk_estado_cita_id = $1 WHERE id = $2 RETURNING id`,
      [APPOINTMENTS_STATUS.COMPLETED, appointment.appointmentId]
    );

    // Validación de actualización
    if (!update.rows || update.rows.length === 0) {
      throw new AppError("Error al finalizar la cita", 500);
    }

    // Añadir las observaciones de la cita
    const addObservations = await pool.query(
      `INSERT INTO observaciones (observacion, fk_cita_id) VALUES ($1, $2) RETURNING id, fk_cita_id, observacion`,
      [url, appointment.appointmentId]
    );

    // Validación de inserción de observaciones
    if (!addObservations.rows || addObservations.rows.length === 0) {
      throw new AppError("Error al añadir las observaciones de la cita", 500);
    }
    return addObservations.rows[0];
  } catch (error) {
    throw new AppError(error.message, 500);
  }
};


const generateDoctorAppointments = async (req, res) => {
  const { startTime, endTime, speciality, weekdays, saturdays, sundays } =
    req.body;
  if (weekdays == false && saturdays == false && sundays == false) {
    return res
      .status(400)
      .json({ message: "Al menos 1 parámetro debe ser true." });
  }
  return await pool.query(
    "SELECT * FROM generar_horario_mensual( $1, $2, $3, $4, $5, $6)",
    [startTime, endTime, speciality, weekdays, saturdays, sundays]
  );
};

module.exports = {
  getDoctorAppointments,
  getPatientsAppointments,
  generateDoctorAppointments,
  getFilteredAppointments,
  createAppointment,
  finishAppointment,
};
