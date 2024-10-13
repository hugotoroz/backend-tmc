const { Router } = require("express");
const { validateNumDoc,getDataUser } = require("../controllers/users.controller.js");
const router = Router();

router.post("/user/validate", validateNumDoc);
router.post("/user/data", getDataUser);

module.exports = { usersRouter: router };
