const { pool } = require("../config/database.js");
const { AppError } = require("../middleware/errors.middleware");

const getType = async (patientId) => {
  return await pool.query(`select * from tipos_documento`);
};

const SetDocument = async (req, res) => {
  const { appointmentId, documentTypeId, url } = req.body;
};

module.exports = {
  getType,
};
