const { Router } = require("express");
const {
  getAppointmentsByDoctor,
  getAppointmentsByPatient,
  generateAppointments,
  getFilteredAppointmentsController,
  createPatientAppointment,
  finishPatientAppointment,
} = require("../controllers/appointments.controller.js");
const {
  authMiddleware,
  isDoctorMiddleware,
  isPatientMiddleware,
} = require("../middleware/auth.middleware.js");
const { methodNotAllowed } = require("../middleware/errors.middleware.js");
const { upload } = require("../config/digitalOceanSpaces");
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
router
  .route("/finish")
  .post(
    authMiddleware,
    isDoctorMiddleware,
    upload.single("document"),
    finishPatientAppointment
  )
  .all(methodNotAllowed(["POST"]));

module.exports = { appointmentsRouter: router };
