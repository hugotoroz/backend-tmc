const { getAll, getOne, create } = require("../models/patients.models");
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

const createPatient = asyncHandler(async (req, res) => {
  const patient = req.body;
  try {
    const result = await create(patient);

    const token = generateToken({
      id: result.id,
      rut: result.rut,
      email: result.email,
      fullName: result.full,
      role: result.role,
    });
    res.json({ status: "success", data: { token: token } });
  } catch (error) {
    throw new AppError("Error crear el paciente:" + error, 500);
  }
});



module.exports = {
  getAllPatients,
  getPatientById,
  createPatient,
};
