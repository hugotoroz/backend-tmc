const { Router } = require("express");
const {
  getAllPatients,
  getPatientById,
  createPatient,
} = require("../controllers/patients.controller.js");
const { authMiddleware } = require("../middleware/auth.middleware.js");
const { methodNotAllowed } = require("../middleware/errors.middleware.js");
const router = Router();

router
  .route("/")
  .get(authMiddleware, getAllPatients)
  .post(createPatient)
  .all(methodNotAllowed(["GET", "POST"]));
router
  .route("/:id")
  .get(authMiddleware, getPatientById)
  .all(methodNotAllowed(["GET"]));
  
module.exports = { patientsRouter: router };
