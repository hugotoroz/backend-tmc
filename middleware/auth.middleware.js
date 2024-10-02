const jwt = require("jsonwebtoken");
const config = require("../config/auth.js");

const authMiddleware = (req, res, next) => {
  const token = req.headers["authorization"];

  if (!token) {
    return res.status(403).send({ message: "No token provided!" });
  }

  jwt.verify(token, config.jwtSecret, (err, decoded) => {
    if (err) {
      return res.status(401).send({ message: "Unauthorized!" });
    }
    req.userId = decoded.id;
    next();
  });
};
const isAdminMiddleware = (req, res, next) => {

};



module.exports = { authMiddleware, isAdminMiddleware };
  