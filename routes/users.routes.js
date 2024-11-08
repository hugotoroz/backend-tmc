const { Router } = require("express");
const {
  validateNumDoc,
  getDataUser,
  userLogin,
  updateUser,
} = require("../controllers/users.controller.js");
const { authMiddleware } = require("../middleware/auth.middleware.js");
const { methodNotAllowed } = require("../middleware/errors.middleware.js");
const router = Router();

router
  .route("/validate")
  .post(validateNumDoc)
  .all(methodNotAllowed(["POST"]));
router
  .route("/data")
  .post(getDataUser)
  .all(methodNotAllowed(["POST"]));
router
  .route("/login")
  .post(userLogin)
  .all(methodNotAllowed(["POST"]));
router
  .route("/update")
  .put(authMiddleware, updateUser)
  .all(methodNotAllowed(["PUT"]));

module.exports = { usersRouter: router };
