const { Router } = require("express");
const {
  validateNumDoc,
  getDataUser,
  userLogin,
} = require("../controllers/users.controller.js");
const router = Router();

router.post("/user/validate", validateNumDoc);
router.post("/user/data", getDataUser);
router.post("/user/login", userLogin);

module.exports = { usersRouter: router };
