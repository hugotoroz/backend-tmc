const { Router } = require("express");
const {
  getAllDoctors,
  getDoctorById,
  getAllSpecialities,
  createDoctor,
} = require("../controllers/doctors.controller.js");
const {
  authMiddleware,
  isAdminMiddleware,
} = require("../middleware/auth.middleware.js");
const { methodNotAllowed } = require("../middleware/errors.middleware.js");
const router = Router();

router
  .route("/specialities")
  .get(getAllSpecialities)
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
