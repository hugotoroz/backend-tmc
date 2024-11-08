const { Router } = require("express");
const {
  getAppointmentsByDoctor,
  getAppointmentsByPatient,
  generateAppointments,
} = require("../controllers/appointments.controller.js");
const { authMiddleware } = require("../middleware/auth.middleware.js");
const { methodNotAllowed } = require("../middleware/errors.middleware.js");
const router = Router();

router
  .route("/doctor")
  .get(authMiddleware, getAppointmentsByDoctor)
  .all(methodNotAllowed(["GET"]));

router
  .route("/patient")
  .get(authMiddleware, getAppointmentsByPatient)
  .all(methodNotAllowed(["GET"]));

router
  .route("/generate")
  .post(authMiddleware, generateAppointments)
  .all(methodNotAllowed(["POST"]));

module.exports = { appointmentsRouter: router };
