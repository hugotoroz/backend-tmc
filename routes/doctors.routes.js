const { Router } = require("express");
const {
  getAllDoctors,
  getDoctorById,
  getAllSpecialities,
  createDoctor,
} = require("../controllers/doctors.controller.js");
const { authMiddleware } = require("../middleware/auth.middleware.js");
const { methodNotAllowed } = require("../middleware/errors.middleware.js");
const router = Router();

router
  .route("/specialities")
  .get(authMiddleware, getAllSpecialities)
  .all(methodNotAllowed(["GET"]));
router
  .route("/")
  .get(authMiddleware, getAllDoctors)
  .all(methodNotAllowed(["GET"]));
router
  .route("/:id")
  .get(getDoctorById)
  .all(methodNotAllowed(["GET"]));
router
  .route("/")
  .post(createDoctor)
  .all(methodNotAllowed(["POST"]));

module.exports = { doctorsRouter: router };
