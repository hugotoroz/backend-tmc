const { Router } = require("express");
const {
  getAllDoctors,
  getDoctorById,
  getAllSpecialities,
  getDoctorSpecialities,
  createDoctor,
  cancelDoctorAppointment,
} = require("../controllers/doctors.controller.js");
const {
  authMiddleware,
  isAdminMiddleware,
  isDoctorMiddleware,
} = require("../middleware/auth.middleware.js");
const { methodNotAllowed } = require("../middleware/errors.middleware.js");
const router = Router();
router
  .route("/cancelAppointment")
  .put(authMiddleware, isDoctorMiddleware, cancelDoctorAppointment)
  .all(methodNotAllowed(["PUT"]));
router
  .route("/specialities")
  .get(getAllSpecialities)
  .all(methodNotAllowed(["GET"]));
router
  .route("/Myspecialities/")
  .get(authMiddleware, getDoctorSpecialities)
  .all(methodNotAllowed(["GET"]));
router
  .route("/")
  .get(authMiddleware, getAllDoctors)
  .post(createDoctor)
  .all(methodNotAllowed(["GET"], ["POST"]));
router
  .route("/:id")
  .get(authMiddleware, isAdminMiddleware, getDoctorById)
  .all(methodNotAllowed(["GET"]));

module.exports = { doctorsRouter: router };
