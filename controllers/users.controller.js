const axios = require("axios");
const { login } = require("../models/users.models");
const { generateToken } = require("../config/auth");


const validateNumDoc = async (req, res, next) => {
  // JSON example format:
  // {
  //   "rut": "12345678-k",
  //   "numDoc": "123456789",
  // }
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
};

const getDataUser = async (req, res, next) => {
  // JSON example format:
  // {
  //   "rut": "12345678-k",
  // }
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
};
const userLogin = async (req, res, next) => {
  // JSON example format:
  // {
  //   "RUT": "12345678-k",
  //   "password": "123",
  // }
  const user = req.body;
  try {
    const result = await login(user);
    const token = generateToken({
      id: result.data.id,
      rut: result.data.rut,
      email: result.data.email,
      fullName: result.data.fullName,
      role: result.data.role,
    });
    res.json({ status: "success", data: { token: token } });
    // res.json({ status: "success", data: result });
  } catch (error) {
    next(error);
  }
};

module.exports = { validateNumDoc, getDataUser, userLogin };
