const { pool } = require("../config/database.js");
const { comparePassword } = require("../config/password.js");
const { AppError } = require("../middleware/errors.middleware");

const login = async (user) => {
  try {
    // Obtain the user data from the database
    const response = await pool.query(
      "SELECT u.*,CONCAT(u.nom,' ',u.ap_paterno,' ',u.ap_materno) AS full,r.rol FROM usuarios u JOIN usuario_rol ur ON u.id = ur.fk_usuario_id JOIN roles r ON ur.fk_rol_id = r.id WHERE u.rut = $1",
      [user.rut]
    );
    // Check if the user exists
    if (response.rowCount === 0) {
      throw new AppError("User not found", 404);
    }
    // Check if the password is correct
    const match = await comparePassword(user.password, response.rows[0].clave);
    if (!match) {
      throw new AppError("Invalid password", 401);
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
    throw AppError(error, 500);
  }
};

const update = async (userId, updateData, userRole) => {
  // Check that only email and cellphone are being updated
  const allowedUpdates = ["email", "cellphone"];
  const updates = Object.keys(updateData).filter((key) =>
    allowedUpdates.includes(key)
  );

  if (updates.length === 0) {
    throw new Error("No se proporcionaron campos válidos para actualizar");
  }

  // Build the UPDATE query dynamically
  let updateQuery = "UPDATE usuarios SET ";
  const values = [];
  let paramCount = 1;

  if (updateData.email) {
    updateQuery += `email = $${paramCount}, `;
    values.push(updateData.email);
    paramCount++;
  }

  if (updateData.cellphone) {
    updateQuery += `telefono = $${paramCount}, `;
    values.push(updateData.cellphone);
    paramCount++;
  }

  // Remove the final comma and space
  updateQuery = updateQuery.slice(0, -2);

  // Add WHERE and RETURNING
  updateQuery += ` WHERE id = $${paramCount} 
    RETURNING id, rut, email, CONCAT(nom, ' ', ap_paterno, ' ', ap_materno) AS full`;
  values.push(userId);

  // Execute the query
  const result = await pool.query(updateQuery, values);

  if (result.rows.length === 0) {
    throw new Error("Usuario no encontrado");
  }

  const { id, rut, email, full } = result.rows[0];

  return {
    id,
    rut,
    email,
    full,
  };
};

module.exports = { login, update };
