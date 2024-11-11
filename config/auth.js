const jwt = require("jsonwebtoken");

module.exports = {
  // Secret key from .env
  jwtSecret: process.env.JWT_SECRET,
  // Expire time for the token (optional)
  jwtExpiration: "72h",
  // Expire time for the refresh token (optional)
  jwtRefreshExpiration: "7d",
  // Encryption rounds for the password
  saltRounds: 10,
  // Function to generate a token
  generateToken: (payload) => {
    return jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: module.exports.jwtExpiration });
  }
};
