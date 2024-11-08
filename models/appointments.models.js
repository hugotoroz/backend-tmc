const { pool } = require("../config/database.js");

const getDoctorAppointments = async (doctorId) => {
  return await pool.query(
    "select d.fecha,d.hora_inicio,d.hora_fin,c.fecha_agendada,c.fk_especialidad_id as id_especialidad, e.nom as nombre_especialidad,ec.nombre as estado,p.id as id_paciente, p.rut as rut_paciente, CONCAT(p.nom,' ',p.ap_paterno,' ',p.ap_materno) AS nombre_paciente from disponibilidad d left join citas c on d.id = c.fk_disponibilidad_id left join estados_cita ec on c.fk_estado_cita_id = ec.id left join especialidad e on c.fk_especialidad_id = e.id left join public.pacientes p on c.fk_paciente_id = p.id where d.fk_doctor_id = $1",
    [doctorId]
  );
};

const getPatientsAppointments = async (patientId) => {
  return await pool.query(
    "select d.fecha,d.hora_inicio,d.hora_fin,c.fecha_agendada,c.fk_especialidad_id as id_especialidad, e.nom as nombre_especialidad,ec.nombre as estado,p.id as id_paciente, p.rut as rut_paciente, CONCAT(p.nom,' ',p.ap_paterno,' ',p.ap_materno) AS nombre_paciente from disponibilidad d left join citas c on d.id = c.fk_disponibilidad_id left join estados_cita ec on c.fk_estado_cita_id = ec.id left join especialidad e on c.fk_especialidad_id = e.id left join public.pacientes p on c.fk_paciente_id = p.id where c.fk_paciente_id = $1",
    [patientId]
  );
};

const generateDoctorAppointments = async (req, res, next) => {
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
};
