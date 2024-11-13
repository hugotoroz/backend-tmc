const { getType } = require("../models/documents.models");
const { asyncHandler, AppError } = require("../middleware/errors.middleware");

const getDocumentsType = asyncHandler(async (req, res) => {
  const { type } = req.params;
  const result = await getType(type);

  if (!result.rows || result.rows.length === 0) {
    throw new AppError("No se encontraron documentos para este tipo", 404);
  }

  res.json({
    status: "success",
    data: result.rows,
  });
});

module.exports = {
  getDocumentsType,
};
