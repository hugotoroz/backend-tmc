const { Router } = require("express");
const {
  getAllPatients,
  getPatientById,
  createPatient,
} = require("../controllers/patients.controller.js");
const { authMiddleware } = require("../middleware/auth.middleware.js");

const router = Router();
// Routes
router.get("/patients",authMiddleware, getAllPatients);
router.get("/patients/:id", getPatientById);
router.post("/patients", createPatient);

module.exports = { patientsRouter: router };
