const jwt = require("jsonwebtoken");
const config = require("../config/auth.js");
const { ROLES } = require("../constants/users.constant");
// function to verify the Bearer token
const authMiddleware = (req, res, next) => {
  const authHeader = req.headers["authorization"];
  if (!authHeader) {
    return res
      .status(403)
      .send({ status: "error", message: "No token provided." });
  }

  const token = authHeader.split(" ")[1];
  if (!token) {
    return res
      .status(403)
      .send({ status: "error", message: "Malformed token!" });
  }

  jwt.verify(token, config.jwtSecret, (err, decoded) => {
    // Error if the token is expired
    if (err && err.name === "TokenExpiredError") {
      return res.status(401).send({
        status: "error",
        message: "Token expired!",
      });
    }
    if (err) {
      console.error("JWT verification error:", err);
      return res
        .status(401)
        .send({ status: "error", message: "Unauthorized!" });
    }
    req.userId = decoded.id;
    req.userRole = decoded.roleId;
    if (decoded.specialityId) {
      req.specialityId = decoded.specialityId;
    }
    next();
  });
};
// function to verify if the user is an admin
const isAdminMiddleware = (req, res, next) => {
  if (parseInt(req.userRole) !== ROLES.ADMIN) {
    return res
      .status(403)
      .send({ status: "error", message: "Unauthorized!" });
  }
  next();
};
const isDoctorMiddleware = (req, res, next) => {
  if (parseInt(req.userRole) !== ROLES.DOCTOR) {
    return res
      .status(403)
      .send({ status: "error", message: "Unauthorized!" });
  }
  next();
};
const isPatientMiddleware = (req, res, next) => {
  if (req.userRole !== ROLES.PATIENT) {
    return res
      .status(403)
      .send({ status: "error", message: "Unauthorized!" });
  }
  next();
};

module.exports = { authMiddleware, isAdminMiddleware, isDoctorMiddleware, isPatientMiddleware };
