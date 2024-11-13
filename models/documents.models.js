const { pool } = require("../config/database.js");
const { AppError } = require("../middleware/errors.middleware");

const getType = async (patientId) => {
  return await pool.query(`select * from tipos_documento`);
};

module.exports = {
    getType,
};
