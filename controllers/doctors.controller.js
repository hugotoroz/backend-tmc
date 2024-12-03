const {
  getAll,
  getOne,
  getSpecialities,
  getAllDoctorSpecialities,
  create,
  cancelAppointment,
} = require("../models/doctors.models");
const { asyncHandler, AppError } = require("../middleware/errors.middleware");

const getAllDoctors = asyncHandler(async (req, res) => {
  try {
    const result = await getAll();
    res.json(result.rows);
  } catch (error) {
    throw new AppError("Error al obtener doctores", 500);
  }
});
const getAllSpecialities = asyncHandler(async (req, res) => {
  try {
    const result = await getSpecialities();
    res.json(result.rows);
  } catch (error) {
    throw new AppError("Error al obtener especialidades" + error, 500);
  }
});
const getDoctorSpecialities = asyncHandler(async (req, res) => {
  // ParseInt for each speciality
  const specialities = req.specialityId.map((speciality) =>
    parseInt(speciality)
  );
  try {
    const result = await getAllDoctorSpecialities(specialities);
    res.json(result.rows);
  } catch (error) {
    throw new AppError("Error al obtener especialidades" + error, 500);
  }
});
const getDoctorById = asyncHandler(async (req, res) => {
  try {
    const result = await getOne(req);
    res.json(result.rows);
  } catch (error) {
    throw new AppError("Error al obtener doctor", 500);
  }
});

const createDoctor = asyncHandler(async (req, res) => {
  const doctor = req.body;
  try {
    const result = await create(doctor);
    res.json(result);
  } catch (error) {
    throw new AppError("Error al crear doctor", 500);
  }
});

const cancelDoctorAppointment = asyncHandler(async (req, res) => {
  const appointment = req.body;
  try {
    const result = await cancelAppointment(appointment);
    res.json(result);
  } catch (error) {
    throw new AppError(error.message, error.statusCode);
  }
});

module.exports = {
  getAllDoctors,
  getDoctorById,
  getAllSpecialities,
  getDoctorSpecialities,
  createDoctor,
  cancelDoctorAppointment,
};
