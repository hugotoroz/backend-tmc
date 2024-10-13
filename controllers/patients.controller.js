const jwt = require("jsonwebtoken");

const { getAll, getOne, create } = require("../models/patients.models");
const config = require("../config/auth.js");

const secret = config.jwtSecret;

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
    res.json(result.rows);
  } catch (error) {
    next(error);
  }
};

module.exports = { getAllPatients, getPatientById, createPatient };

// const { id: sub, name } = { id: 1, name: "John Doe" };
// const token = jwt.sign(
//   {
//     sub,
//     name,
//     // Token expires in 5 minutes
//     exp: Math.floor(Date.now() / 1000) + 60 * 5,
//   },
//   secret
// );
// res.send({ token });
