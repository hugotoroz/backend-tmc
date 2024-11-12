const {
  getDoctorAppointments,
  getPatientsAppointments,
  getFilteredAppointments,
  generateDoctorAppointments,
  createAppointment,
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
  try {
    const userId = req.userId;
    const result = await getPatientsAppointments(userId);

    if (!result.rows || result.rows.length === 0) {
      throw new AppError("No se encontraron citas para este paciente", 404);
    }

    res.json({
      status: "success",
      data: result.rows,
    });
  } catch (error) {
    throw new AppError(error, 500);
  }
});
const getFilteredAppointmentsController = asyncHandler(async (req, res) => {
  // Obtener filtros de query params
  const filters = {
    specialityId: req.query.speciality,
    date: req.query.date,
    doctorId: req.query.doctor,
  };

  // Verificar si hay al menos un filtro
  const hasFilters = Object.values(filters).some(
    (value) => value !== undefined
  );

  if (!hasFilters) {
    throw new AppError(
      "Debe proporcionar al menos un parámetro de búsqueda",
      400
    );
  }

  const result = await getFilteredAppointments(filters);

  if (!result.rows || result.rows.length === 0) {
    throw new AppError(
      "No se encontraron citas con los filtros especificados",
      404
    );
  }

  res.json({
    status: "success",
    data: result.rows,
    filters: filters, // Incluir los filtros utilizados en la respuesta
  });
});
const createPatientAppointment = asyncHandler(async (req, res) => {
  try {
    const { availabilityId } = req.body;
    const patientId = req.userId;

    const appointment = {
      patientId,
      availabilityId,
    };

    const result = await createAppointment(appointment);

    res.json({
      status: "success",
      data: result,
    });
  } catch (error) {
    throw new AppError(error, 500);
  }
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
  getFilteredAppointmentsController,
  createPatientAppointment,
};
