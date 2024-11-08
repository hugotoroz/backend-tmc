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
  .all(methodNotAllowed(["GET"]));
router
  .route("/:id")
  .get(getPatientById)
  .all(methodNotAllowed(["GET"]));
router
  .route("/")
  .post(createPatient)
  .all(methodNotAllowed(["POST"]));
  
module.exports = { patientsRouter: router };
