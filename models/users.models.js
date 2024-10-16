const { pool } = require("../config/database.js");
const { comparePassword } = require("../config/password.js");

const login = async (user) => {
  try {
    // Obtain the user data from the database
    const response = await pool.query("SELECT u.*,CONCAT(u.nom,' ',u.ap_paterno,' ',u.ap_materno) AS full,r.rol FROM usuarios u JOIN usuario_rol ur ON u.id = ur.fk_usuario_id JOIN roles r ON ur.fk_rol_id = r.id WHERE u.rut = $1", [
      user.rut,
    ]);
    // Check if the user exists
    if (response.rowCount === 0) {
      throw new Error("User not found");
    }
    // Check if the password is correct
    const match = await comparePassword(user.password, response.rows[0].clave);
    if (!match) {
      throw new Error("Invalid password");
    }
    // Return the user data
    return {
      status: "success",
      data: {
        id: response.rows[0].id,
        rut: response.rows[0].rut,
        email: response.rows[0].email,
        fullName: response.rows[0].full,
        role: response.rows[0].rol,
      },
    };
  } catch (error) {
    throw error;
  }
};

module.exports = { login };
