const axios = require("axios");

const validateNumDoc = async (req, res, next) => {
  // JSON example format:
  // {
  //   "RUT": "12345678-k",
  //   "numDoc": "123456789",
  // }
  const user = req.body;
  const options = {
    method: "POST",
    url: "https://api.floid.app/cl/registrocivil/valida_cedula",
    headers: {
      accept: "application/json",
      "content-type": "application/json",
      authorization: "Bearer " + process.env.FLOID_API_KEY,
    },
    data: { id: user.RUT, numero_documento: user.numDoc },
  };
  const response = await axios.request(options);
  res.send({ response: response.data });
};

const getDataUser = async (req, res, next) => {
  // JSON example format:
  // {
  //   "RUT": "12345678-k",
  // }
  // const user = req.body;
  // const options = {
  //   method: "POST",
  //   url: "https://api.floid.app/cl/registrocivil/datos_persona",
  //   headers: {
  //     accept: "application/json",
  //     "content-type": "application/json",
  //     authorization: "Bearer " + process.env.FLOID_API_KEY,
  //   },
  //   data: { id: user.RUT },
  // };
  // const response = await axios.request(options);
  // res.send({ response: response.data });

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
      data: { id: user.RUT },
    };
    const response = await axios.request(options);

    res.send({ status: "success", data: response.data.data });
  } catch (error) {
    res
      .status(error.response.status)
      .send({ status: "error", data: error.response.data });
  }
};

module.exports = { validateNumDoc, getDataUser };
