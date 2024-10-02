module.exports = {
  // Clave secreta que proviene de .env
  jwtSecret: process.env.JWT_SECRET || "your_secret_key",
  // Tiempo de expiración para el token
  jwtExpiration: "1h",
  // Tiempo de expiración para el token de refresco (opcional)
  jwtRefreshExpiration: "7d",
  // Parámetro para encriptar contraseñas (bcryptjs)
  saltRounds: 10,
};
