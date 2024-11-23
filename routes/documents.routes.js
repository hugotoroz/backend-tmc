const { Router } = require("express");
const { getDocumentsType } = require("../controllers/documents.controller");
const { authMiddleware } = require("../middleware/auth.middleware");
const { methodNotAllowed } = require("../middleware/errors.middleware");
const router = Router();

router
  .route("/types")
  .get(authMiddleware, getDocumentsType)
  .all(methodNotAllowed(["GET"]));

module.exports = { documentsRouter: router };
