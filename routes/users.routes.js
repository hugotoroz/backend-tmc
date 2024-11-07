const { Router } = require("express");
const {
  validateNumDoc,
  getDataUser,
  userLogin,
  updateUser,
} = require("../controllers/users.controller.js");
const { authMiddleware } = require("../middleware/auth.middleware.js");

const router = Router();

router.post("/user/validate", validateNumDoc);
router.post("/user/data", getDataUser);
router.post("/user/login", userLogin);
router.put("/user/update", authMiddleware, updateUser);

module.exports = { usersRouter: router };
