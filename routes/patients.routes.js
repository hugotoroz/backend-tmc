const { Router } = require("express");
const {
  getAllPatients,
  getPatientById,
  getPatientObservations,
  getAllPatientsDocuments,
  createPatient,
  savePatientDocument,
  cancelPatientAppointment,
} = require("../controllers/patients.controller.js");
const {
  authMiddleware,
  isAdminMiddleware,
  isDoctorMiddleware,
  isPatientMiddleware,
} = require("../middleware/auth.middleware.js");
const { methodNotAllowed } = require("../middleware/errors.middleware.js");
const { upload } = require("../config/digitalOceanSpaces");
const router = Router();

router
  .route("/cancelAppointment")
  .put(authMiddleware, isPatientMiddleware, cancelPatientAppointment)
  .all(methodNotAllowed(["PUT"]));
router
  .route("/myDocuments/search")
  .get(authMiddleware, isPatientMiddleware, getAllPatientsDocuments)
  .all(methodNotAllowed(["GET"]));
router
  .route("/document/save")
  .post(
    authMiddleware,
    isDoctorMiddleware,
    upload.single("document"), // Añadir el middleware de multer aquí
    savePatientDocument
  )
  .all(methodNotAllowed(["POST"]));
router
  .route("/")
  .get(authMiddleware, isAdminMiddleware, getAllPatients)
  .post(createPatient)
  .all(methodNotAllowed(["GET", "POST"]));
router
  .route("/:id")
  .get(authMiddleware, isAdminMiddleware, getPatientById)
  .all(methodNotAllowed(["GET"]));
router
  .route("/:id/observations")
  .get(authMiddleware, isDoctorMiddleware, getPatientObservations)
  .all(methodNotAllowed(["GET"]));

module.exports = { patientsRouter: router };
