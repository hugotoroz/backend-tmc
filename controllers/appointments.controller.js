const {
  getStatus,
  getDoctorAppointments,
  getPatientsAppointments,
  getFilteredAppointments,
  generateDoctorAppointments,
  createAppointment,
  finishAppointment,
  createDoctorAppointments,
} = require("../models/appointments.models");
const { asyncHandler, AppError } = require("../middleware/errors.middleware");
const { uploadFiles } = require("./documents.controller");

const getAppointmentStatus = asyncHandler(async (req, res) => {

  const result = await getStatus();
  if (!result.rows || result.rows.length === 0) {
    throw new AppError("No se encontraron estados de cita.", 404);
  }

  res.json({
    status: "success",
    data: result.rows,
  });
});

const getAppointmentsByDoctor = asyncHandler(async (req, res) => {
  const userId = req.userId;
  const filters = {};

  // Extract filters from query parameters
  if (req.query.specialityId) filters.specialityId = req.query.specialityId;
  if (req.query.date) filters.date = req.query.date;
  if (req.query.time) filters.time = req.query.time;
  if (req.query.statusId) filters.statusId = req.query.statusId;

  const result = await getDoctorAppointments(userId, filters);

  if (!result.rows || result.rows.length === 0) {
    throw new AppError("No se encontraron citas.", 404);
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
const finishPatientAppointment = asyncHandler(async (req, res) => {
  const appointment = req.body;
  try {
    const fileUrl = await uploadFiles(req.file);

    const result = await finishAppointment(appointment, fileUrl);

    res.json({
      status: "success",
      data: result,
    });
  } catch (error) {
    throw new AppError(error, error.statusCode);
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
// Generate doctor's hours
const createAppointments = asyncHandler(async (req, res) => {
  try {
    const { appointments, speciality } = req.body;
    const userId = req.userId;

    const result = await createDoctorAppointments(
      appointments,
      speciality,
      userId
    );

    res.json({
      status: "success",
      data: result,
    });
  } catch (error) {
    throw new AppError(error, error.statusCode);
  }
});

module.exports = {
  getAppointmentStatus,
  getAppointmentsByDoctor,
  getAppointmentsByPatient,
  generateAppointments,
  getFilteredAppointmentsController,
  createPatientAppointment,
  finishPatientAppointment,
  createAppointments,
};
