const { getType } = require("../models/documents.models");
const { asyncHandler, AppError } = require("../middleware/errors.middleware");
const { spacesClient } = require("../config/digitalOceanSpaces");
const { PutObjectCommand } = require("@aws-sdk/client-s3");
const { v4: uuidv4 } = require("uuid");
const {
  bucket,
  url,
} = require("../constants/digitalOceanSpaces.constant.js");
const path = require("path"); // Corregido: no uses destructuring para path

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
const uploadFiles = async (file) => {
  if (!file) {
    throw new AppError("No se ha proporcionado ningún archivo", 400);
  }

  const fileExtension = path.extname(file.originalname);
  const fileName = `${uuidv4()}${fileExtension}`;

  const uploadParams = {
    Bucket: bucket,
    Key: `documents/${fileName}`,
    Body: file.buffer,
    ACL: "public-read",
    ContentType: file.mimetype,
    Metadata: {
      "original-name": file.originalname,
    },
  };

  try {
    await spacesClient.send(new PutObjectCommand(uploadParams));
    const fileURL = `${url}/documents/${fileName}`;
    console.log("Archivo subido a DigitalOcean:", fileURL);
    return fileURL; // Retornamos directamente la URL
  } catch (error) {
    console.error("Error al subir archivo:", error);
    throw new AppError("Error al subir el archivo", 500);
  }
};

module.exports = {
  getDocumentsType,
  uploadFiles,
};
