const { Router } = require("express");
const {
  getAppointmentsByDoctor,
  getAppointmentsByPatient,
  generateAppointments,
  getFilteredAppointmentsController,
  createPatientAppointment,
} = require("../controllers/appointments.controller.js");
const {
  authMiddleware,
  isDoctorMiddleware,
  isPatientMiddleware,
} = require("../middleware/auth.middleware.js");
const { methodNotAllowed } = require("../middleware/errors.middleware.js");
const router = Router();

router
  .route("/search")
  .get(authMiddleware, getFilteredAppointmentsController)
  .all(methodNotAllowed(["GET"]));

router
  .route("/patient")
  .get(authMiddleware, isPatientMiddleware, getAppointmentsByPatient)
  .all(methodNotAllowed(["GET"]));
router
  .route("/patient/create")
  .post(authMiddleware, isPatientMiddleware, createPatientAppointment)
  .all(methodNotAllowed(["POST"]));

router
  .route("/doctor")
  .get(authMiddleware, isDoctorMiddleware, getAppointmentsByDoctor)
  .all(methodNotAllowed(["GET"]));
router
  .route("/doctor/generate")
  .post(authMiddleware, isDoctorMiddleware, generateAppointments)
  .all(methodNotAllowed(["POST"]));

module.exports = { appointmentsRouter: router };
