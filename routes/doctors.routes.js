const { Router } = require("express");
const {
  getAllDoctors,
  getDoctorById,
  getAllSpecialities,
  createDoctor,
  getAppointmentsByDoctor,
} = require("../controllers/doctors.controller.js");
const { authMiddleware } = require("../middleware/auth.middleware.js");
const router = Router();
// Routes]
router.get("/doctors/appointments", authMiddleware, getAppointmentsByDoctor);
router.get("/doctors/specialities", authMiddleware, getAllSpecialities);
router.get("/doctors", authMiddleware, getAllDoctors);
router.get("/doctors/:id", getDoctorById);
router.post("/doctors", createDoctor);

module.exports = { doctorsRouter: router };
