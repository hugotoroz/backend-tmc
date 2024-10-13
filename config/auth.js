module.exports = {
  // Secret key from .env
  jwtSecret: process.env.JWT_SECRET,
  // Expire time for the token (optional)
  jwtExpiration: "1h",
  // Expire time for the refresh token (optional)
  jwtRefreshExpiration: "7d",
  // Encryption rounds for the password
  saltRounds: 10,
};
