const jwt = require("jsonwebtoken");
const config = require("../config/auth.js");

const authMiddleware = (req, res, next) => {
  const authHeader = req.headers["authorization"];
  if (!authHeader) {
    return res.status(403).send({ message: "No token provided." });
  }

  const token = authHeader.split(" ")[1];
  if (!token) {
    return res.status(403).send({ message: "Malformed token!" });
  }

  jwt.verify(token, config.jwtSecret, (err, decoded) => {
    if (err) {
      console.error("JWT verification error:", err);
      return res.status(401).send({ message: "Unauthorized!" });
    }
    req.userId = decoded.id;
    next();
  });
};
const isAdminMiddleware = (req, res, next) => {};

module.exports = { authMiddleware, isAdminMiddleware };
