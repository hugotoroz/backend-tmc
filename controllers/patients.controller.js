const { getAll, getOne, create } = require("../models/patients.models");
const { generateToken } = require("../config/auth");

const getAllPatients = async (req, res, next) => {
  try {
    const result = await getAll();
    res.json(result.rows);
  } catch (error) {
    next(error);
  }
};
const getPatientById = async (req, res, next) => {
  try {
    const result = await getOne(req);
    res.json(result.rows);
  } catch (error) {
    next(error);
  }
};

const createPatient = async (req, res, next) => {
  // Obtain the patient data from the request
  // JSON example format:
  // {
  //   "RUT": "12345678-k",
  //   "email": "hugotoro@gmail.com",
  //   "password": "123",
  //   "name": "Hugo",
  //   "patSurName": "Toro",
  //   "matSurName": "Zúñiga",
  //   "dateBirth": "2024-01-09",
  //   "cellphone": "912345678",
  // }
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
    next(error);
  }
};



module.exports = {
  getAllPatients,
  getPatientById,
  createPatient,
};
