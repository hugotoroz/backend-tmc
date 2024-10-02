const jwt = require("jsonwebtoken");
const { getAll, getOne, create } = require("../models/patients.models");

const secret = process.env.JWT_SECRET;

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
      exp: Date.now() + 60 * 1000,
    },
    secret
  );
  res.send({ token });
};

module.exports = { getAllPatients, getPatientById,createPatient };
