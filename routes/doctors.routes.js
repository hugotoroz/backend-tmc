const { Router } = require("express");
const{
    getAllDoctors,
    getDoctorById,
    getAllSpecialities,
    createDoctor
} = require("../controllers/doctors.controller.js");
const { authMiddleware } = require("../middleware/auth.middleware.js");
const router = Router();
// Routes]
router.get("/doctors",authMiddleware, getAllDoctors);
router.get("/doctors/specialities",authMiddleware, getAllSpecialities);
router.get("/doctors/:id", getDoctorById);
router.post("/doctors", createDoctor);

module.exports = { doctorsRouter: router };