const {
  getDoctorAppointments,
  getPatientsAppointments,
  generateDoctorAppointments,
} = require("../models/appointments.models");
const { asyncHandler, AppError } = require("../middleware/errors.middleware");

const getAppointmentsByDoctor = asyncHandler(async (req, res) => {
  const userId = req.userId;
  const result = await getDoctorAppointments(userId);

  if (!result.rows || result.rows.length === 0) {
    throw new AppError("No se encontraron citas para este doctor", 404);
  }

  res.json({
    status: "success",
    data: result.rows,
  });
});

const getAppointmentsByPatient = asyncHandler(async (req, res) => {
  const userId = req.userId;
  const result = await getPatientsAppointments(userId);

  if (!result.rows || result.rows.length === 0) {
    throw new AppError("No se encontraron citas para este paciente", 404);
  }

  res.json({
    status: "success",
    data: result.rows,
  });
});

const generateAppointments = asyncHandler(async (req, res) => {
  const { startTime, endTime, speciality, weekdays, saturdays, sundays } =
    req.body;

  // Validaciones
  if (!startTime || !endTime || !speciality) {
    throw new AppError(
      "Faltan campos requeridos: startTime, endTime, speciality",
      400
    );
  }

  if (weekdays === false && saturdays === false && sundays === false) {
    throw new AppError(
      "Al menos un día debe ser seleccionado (weekdays, saturdays, o sundays)",
      400
    );
  }

  const result = await generateDoctorAppointments(req, res);

  res.json({
    status: "success",
    data: result.rows,
  });
});

module.exports = {
  getAppointmentsByDoctor,
  getAppointmentsByPatient,
  generateAppointments,
};
