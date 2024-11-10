const { pool } = require("../config/database.js");

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

// const getSpecialityAppointmentsP = async (specialityId) => {
//   return await pool.query(
//     `select * from citas_medicas where id_paciente is null and id_especialidad = $1`,
//     [specialityId]
//   );
// };
// const getDateAppointmentsP = async (date) => {
//   return await pool.query(`select * from citas_medicas cm where id_paciente is null and fecha = $1`, [
//     date,
//   ]);
// };
// const getDoctorAppointmentsP = async (doctorId) => {
//   return await pool.query(`select * from citas_medicas where id_paciente is null and id_doctor = $1`, [
//     doctorId,
//   ]);
// };
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
  
  // Construir la consulta base
  let query = 'SELECT * FROM citas_medicas';
  
  // Agregar condiciones WHERE si existen filtros
  if (queryConditions.length > 0) {
    query += ` WHERE ${queryConditions.join(' AND ')}`;
  }
  
  // Agregar ORDER BY fecha para ordenar los resultados
  query += ' AND id_paciente IS NULL ORDER BY fecha';
  
  return await pool.query(query, queryParams);
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
  // getSpecialityAppointmentsP,
  // getDateAppointmentsP,
  // getDoctorAppointmentsP,
};
