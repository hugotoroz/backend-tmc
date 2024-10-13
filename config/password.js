const bcrypt = require("bcryptjs");
// Encrypt a password
const encryptPassword = async (password) => {
  // Generate a salt with cost factor 10
  const salt = await bcrypt.genSalt(10);
  // Return the hashed password
  return await bcrypt.hash(password, salt);
};

// Compare a password with a hashed password
const comparePassword = async (password, hashedPassword) => {
  // Return true if the password matches the hashed password
  return await bcrypt.compare(password, hashedPassword);
};

module.exports = { encryptPassword, comparePassword };
