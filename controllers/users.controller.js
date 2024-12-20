const axios = require("axios");
const {
  login,
  update,
  toggleStatus,
  deleteU,
} = require("../models/users.models");
const { generateToken } = require("../config/auth");
const { asyncHandler, AppError } = require("../middleware/errors.middleware");

const validateNumDoc = asyncHandler(async (req, res) => {
  try {
    const user = req.body;
    const options = {
      method: "POST",
      url: "https://api.floid.app/cl/registrocivil/valida_cedula",
      headers: {
        accept: "application/json",
        "content-type": "application/json",
        authorization: "Bearer " + process.env.FLOID_API_KEY,
      },
      data: { id: user.rut, numero_documento: user.numDoc },
    };
    const response = await axios.request(options);
    res.send({ status: "success", data: response.data });
  } catch (error) {
    res
      .status(error.response.status)
      .send({ status: "error", data: error.response.data });
  }
});

const getDataUser = asyncHandler(async (req, res) => {
  try {
    const user = req.body;
    const options = {
      method: "POST",
      url: "https://api.floid.app/cl/registrocivil/datos_persona",
      headers: {
        accept: "application/json",
        "content-type": "application/json",
        authorization: "Bearer " + process.env.FLOID_API_KEY,
      },
      data: { id: user.rut },
    };
    const response = await axios.request(options);

    res.send({ status: "success", data: response.data.data });
  } catch (error) {
    res
      .status(error.response.status)
      .send({ status: "error", data: error.response.data });
  }
});
const userLogin = asyncHandler(async (req, res) => {
  const user = req.body;
  try {
    const result = await login(user);
    const specialityExists = result.data.specialityId !== null;
    const token = generateToken({
      id: result.data.id,
      rut: result.data.rut,
      email: result.data.email,
      fullName: result.data.fullName,
      roleId: result.data.roleId,
      cellphone: result.data.cellphone,
      dateBirth: result.data.dateBirth,
      ...(specialityExists && {
        specialityId: result.data.specialityId,
      }),
    });

    res.json({ status: "success", data: { token: token } });
  } catch (error) {
    throw new AppError(error, error.statusCode);
  }
});

const updateUser = asyncHandler(async (req, res) => {
  // The user ID and the Role now comes from the JWT token through the middleware
  const userId = req.userId;
  const userRole = parseInt(req.userRole);

  // Obtain the role in the JWT
  const updateData = req.body;

  try {
    const result = await update(userId, updateData);
    const specialityExists = result.specialityId !== null;


    // Generate new token with updated information
    const token = generateToken({
      id: result.id,
      rut: result.rut,
      email: result.email,
      fullName: result.full,
      roleId: userRole,
      cellphone: result.telefono,
      dateBirth: result.fec_nacimiento,
      ...(specialityExists && {
        specialityId: result.specialityId,
      }),

    });

    res.json({
      status: "success",
      message: "Usuario actualizado exitosamente",
      data: { token: token },
    });
  } catch (error) {
    throw new AppError(error, error.statusCode);
  }
});

const toggleStatusUser = asyncHandler(async (req, res) => {
  const user = req.body;
  try {
    const result = await toggleStatus(user.rut);
    res.json(result);
  } catch (error) {
    throw new AppError("Error:" + error, 500);
  }
});

const deleteUser = asyncHandler(async (req, res) => {
  const rut = req.body.rut;
  try {
    const result = await deleteU(rut);
    res.json(result);
  } catch (error) {
    throw new AppError(error, 500);
  }
});

module.exports = {
  validateNumDoc,
  getDataUser,
  userLogin,
  updateUser,
  toggleStatusUser,
  deleteUser,
};
