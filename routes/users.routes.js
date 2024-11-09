const { Router } = require("express");
const {
  validateNumDoc,
  getDataUser,
  userLogin,
  updateUser,
  toggleStatusUser,
  deleteUser,
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
router
  .route("/status")
  .put(authMiddleware, toggleStatusUser)
  .all(methodNotAllowed(["PUT"]));
router
  .route("/delete")
  .delete(authMiddleware, deleteUser)
  .all(methodNotAllowed(["DELETE"]));

module.exports = { usersRouter: router };
