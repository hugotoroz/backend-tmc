const { getAll, getOne,getSpecialities, create } = require("../models/doctors.models");

const getAllDoctors = async (req, res, next) => {
  try {
    const result = await getAll();
    res.json(result.rows);
  } catch (error) {
    next(error);
  }
};
const getDoctorById = async (req, res, next) => {
  try {
    const result = await getOne(req);
    res.json(result.rows);
  } catch (error) {
    next(error);
  }
};
const getAllSpecialities = async (req, res, next) => {
  try {
    const result = await getSpecialities(req);
    res.json(result.rows);
  } catch (error) {
    next(error);
  }
};

const createDoctor = async (req, res, next) => {
  // Obtain the doctor data from the request
  // JSON example format:
  // {
  //     "rut": "12345678-k",
  //     "email": "hugotoro@gmail.com",
  //     "password": "123",
  //     "name": "Hugo",
  //     "patSurName": "Toro",
  //     "matSurName": "Zúñiga",
  //     "dateBirth": "2024-01-09",
  //     "cellphone": "912345678",
  //     "speciality": "1"
  //   }
  const doctor = req.body;
  try {
    const result = await create(doctor);
    res.json(result);
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getAllDoctors,
  getDoctorById,
  getAllSpecialities,
  createDoctor,
};
