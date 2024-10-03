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
  const { id: sub, name } = { id: 1, name: "John Doe" };
  const token = jwt.sign(
    {
      sub,
      name,
      // Token expires in 5 minutes
      exp: Math.floor(Date.now() / 1000) + 60 * 5,
    },
    secret
  );
  res.send({ token });
};

module.exports = { getAllPatients, getPatientById,createPatient };
