const { pool } = require("../config/database.js");
const { comparePassword } = require("../config/password.js");
const { AppError } = require("../middleware/errors.middleware");
const { ROLES } = require("../constants/users.constant");

const login = async (user) => {
  try {
    // Obtain the user data from the database
    const response = await pool.query(
      "SELECT u.*,CONCAT(u.nom,' ',u.ap_paterno,' ',u.ap_materno) AS full,ur.fk_rol_id as id_rol, u.telefono, u.fec_nacimiento FROM usuarios u JOIN usuario_rol ur ON u.id = ur.fk_usuario_id WHERE u.rut = $1",
      [user.rut.toLowerCase()]
    );
    // Check if the user exists
    if (response.rowCount === 0) {
      throw new AppError("Usuario no encontrado", 404);
    }
    // Check if the password is correct
    const match = await comparePassword(user.password, response.rows[0].clave);
    if (!match) {
      throw new AppError("Contraseña inválida", 401);
    }
    let specialities = [];
    // check if the rol is doctor
    if (parseInt(response.rows[0].id_rol) === ROLES.DOCTOR) {
      const doctorSpecialities = await pool.query(
        "select * from doctor_especialidad de where fk_doctor_id = $1",
        [response.rows[0].id]
      );
      // Save all the specialities
      specialities = doctorSpecialities.rows.map(
        (speciality) => speciality.fk_especialidad_id
      );
    }

    return {
      status: "success",
      data: {
        id: response.rows[0].id,
        rut: response.rows[0].rut.toLowerCase(),
        email: response.rows[0].email.toLowerCase(),
        fullName: response.rows[0].full,
        roleId: parseInt(response.rows[0].id_rol),
        cellphone: response.rows[0].telefono,
        dateBirth: response.rows[0].fec_nacimiento,
        ...(specialities.length > 0 && {
          specialityId: specialities,
        }),
      },
    };
  } catch (error) {
    throw new AppError(error, error.statusCode);
  }
};

const update = async (userId, updateData) => {
  // Check that only email and cellphone are being updated
  const allowedUpdates = ["email", "cellphone"];
  const updates = Object.keys(updateData).filter((key) =>
    allowedUpdates.includes(key)
  );

  if (updates.length === 0) {
    throw new Error("No se proporcionaron campos válidos para actualizar");
  }
  // Si viene el correo, validar que sea un correo unico
  if (updateData.email) {
    const emailExist = await pool.query(
      "SELECT * FROM usuarios WHERE email = $1 AND id != $2",
      [updateData.email.toLowerCase(), userId]
    );
    if (emailExist.rows.length > 0) {
      throw new AppError("El email ya está registrado", 400);
    }
  }

  // Build the UPDATE query dynamically
  let updateQuery = "UPDATE usuarios SET ";
  const values = [];
  let paramCount = 1;

  if (updateData.email) {
    updateQuery += `email = $${paramCount}, `;
    values.push(updateData.email.toLowerCase());
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
    RETURNING id, rut, email, CONCAT(nom, ' ', ap_paterno, ' ', ap_materno) AS full, telefono, fec_nacimiento`;
  values.push(userId);

  // Execute the query
  const result = await pool.query(updateQuery, values);

  if (result.rows.length === 0) {
    throw new Error("Usuario no encontrado");
  }

  const { id, rut, email, full, telefono, fec_nacimiento } = result.rows[0];
  // Validar si es un usuario de rol DOCTOR
  const isDoctor = await pool.query(
    "SELECT ur.fk_rol_id FROM usuarios u JOIN usuario_rol ur ON u.id = ur.fk_usuario_id WHERE u.id = $1",
    [userId]
  );
  
  let specialities = [];
  if (parseInt(isDoctor.rows[0].fk_rol_id) === ROLES.DOCTOR) {
    const doctorSpecialities = await pool.query(
      "SELECT * FROM doctor_especialidad WHERE fk_doctor_id = $1",
      [userId]
    );

    specialities = doctorSpecialities.rows.map(
      (speciality) => speciality.fk_especialidad_id
    );
  }

  return {
    id,
    rut,
    email,
    full,
    telefono,
    fec_nacimiento,
    ...(specialities.length > 0 && {
      specialityId: specialities,
    }),
  };
};

const toggleStatus = async (rut) => {
  // isActive = isActive === true ? 1 : 0;

  // Search the user in the database
  const user = await pool.query("SELECT * FROM usuarios WHERE rut = $1", [rut]);
  // Check if the user exists
  if (user.rowCount === 0) {
    throw new AppError("Usuario no encontrado", 404);
  }

  // Update the user status (if its 0, it will be 1 and vice versa)
  const isActive = user.rows[0].is_active == 1 ? 0 : 1;

  const result = await pool.query(
    "UPDATE usuarios SET is_active = $1 WHERE rut = $2 RETURNING rut, email, is_active",
    [isActive, rut]
  );
  return {
    status: "success",
    data: result.rows[0],
  };
};

const deleteU = async (rut) => {
  const result = await pool.query(
    "UPDATE usuarios SET is_row = 0 WHERE rut = $1 RETURNING rut, email, is_row",
    [rut]
  );
  if (result.rows.length === 0) {
    throw new Error("Usuario no encontrado");
  }
  return {
    status: "success",
    data: result.rows[0],
  };
};

module.exports = { login, update, toggleStatus, deleteU };
