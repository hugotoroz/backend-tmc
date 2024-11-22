const {
  getAll,
  getOne,
  getAllObservations,
  getAllDocuments,
  create,
} = require("../models/patients.models");
const { generateToken } = require("../config/auth");
const { asyncHandler, AppError } = require("../middleware/errors.middleware");

const getAllPatients = asyncHandler(async (req, res) => {
  try {
    const result = await getAll();
    res.json(result.rows);
  } catch (error) {
    throw new AppError("Error al obtener pacientes", 500);
  }
});
const getPatientById = asyncHandler(async (req, res) => {
  try {
    const result = await getOne(req);
    res.json(result.rows);
  } catch (error) {
    throw new AppError("Error al obtener paciente", 500);
  }
});

const getPatientObservations = asyncHandler(async (req, res) => {
  try {
    const result = await getAllObservations(req);
    res.json(result.rows);
  } catch (error) {
    throw new AppError(error, error.statusCode);
  }
});

const getAllPatientsDocuments = asyncHandler(async (req, res) => {
  const userId = req.userId;

  const filters = {
    fecha: req.query.date,
    id_tipo_documento: req.query.documentTypeId,
    id_especialidad: req.query.specialityId,
  };

  try {
    const result = await getAllDocuments(userId, filters);
    res.json(result.rows);
  } catch (error) {
    throw new AppError(error, error.statusCode);
  }
});

const createPatient = asyncHandler(async (req, res) => {
  const patient = req.body;
  try {
    const result = await create(patient);

    const token = generateToken({
      id: result.id,
      rut: result.rut,
      email: result.email,
      fullName: result.full,
      roleId: result.roleId,
      cellphone: result.telefono,
      dateBirth: result.fec_nacimiento,
    });
    res.json({ status: "success", data: { token: token } });
  } catch (error) {
    throw new AppError(error, error.statusCode);
  }
});

module.exports = {
  getAllPatients,
  getPatientById,
  getPatientObservations,
  getAllPatientsDocuments,
  createPatient,
};
